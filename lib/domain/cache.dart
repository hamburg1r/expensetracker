import 'package:expensetracker/domain/model/base_entity.dart';

class Cache {
  final Map<Type, Map<int, CacheItem<BaseEntity>>> _caches = {};
  final Map<Type, void Function(BaseEntity, Cache)> _garbageCollectors = {};

  void registerGarbageCollector<T extends BaseEntity>(
    void Function(T, Cache) collector,
  ) {
    _garbageCollectors[T] = (BaseEntity item, Cache cache) =>
        collector(item as T, cache);
  }

  Map<int, CacheItem<T>> _getCacheFor<T extends BaseEntity>() {
    return _caches.putIfAbsent(T, () => <int, CacheItem<BaseEntity>>{})
        as Map<int, CacheItem<T>>;
  }

  void addStrong<T extends BaseEntity>(T item) {
    final cache = _getCacheFor<T>();
    final int id = item.id;

    if (cache.containsKey(id)) {
      cache[id]!.increment();
    } else {
      cache[id] = CacheItem(value: item);
    }
  }

  void addWeak<T extends BaseEntity>(T item) {
    final cache = _getCacheFor<T>();
    final int id = item.id;

    if (!cache.containsKey(id)) {
      cache[id] = CacheItem(
        value: item,
        references: 0,
      );
    }
  }

  int references<T extends BaseEntity>(T item) {
    final cache = _getCacheFor<T>();
    final int id = item.id;
    return cache[id]?.references ?? -1;
  }

  void update<T extends BaseEntity>(T item) {
    final cache = _getCacheFor<T>();
    final int id = item.id;

    if (cache.containsKey(id)) {
      cache[id]!.value = item;
    }
  }

  void remove<T extends BaseEntity>(int id) {
    final cache = _getCacheFor<T>();
    if (cache.containsKey(id)) {
      final removedItem = cache.remove(id);
      final collector = _garbageCollectors[T];
      if (collector != null && removedItem != null) {
        collector(removedItem.value, this);
      }
    }
  }

  void releaseStrong<T extends BaseEntity>(T item) {
    final cache = _getCacheFor<T>();
    final int id = item.id;

    if (!cache.containsKey(id)) return;

    cache[id]!.decrement();

    if (cache[id]!.references == 0) {
      final removedItem = cache.remove(id);
      final collector = _garbageCollectors[T];
      if (collector != null && removedItem != null) {
        collector(removedItem.value, this);
      }
    }
  }

  T? get<T extends BaseEntity>(int id) {
    final cache = _getCacheFor<T>();
    return cache[id]?.value;
  }

  Map<int, T> getAll<T extends BaseEntity>() {
    return _getCacheFor<T>().map((key, value) => MapEntry(key, value.value));
  }

  void clear<T extends BaseEntity>() {
    final cache = _getCacheFor<T>();
    cache.clear();
  }

  void clearAll() {
    _caches.clear();
  }
}

class CacheItem<T extends BaseEntity> {
  T value;
  int references;

  CacheItem({
    required this.value,
    this.references = 1,
  });

  void increment() => references++;
  void decrement() {
    if (references == 0) return;
    references--;
  }
}
