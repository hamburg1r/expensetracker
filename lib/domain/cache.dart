class Cache {
  final Map<Type, Map<int, CacheItem<dynamic>>> _caches = {};
  final Map<Type, void Function(dynamic, Cache)> _garbageCollectors = {};

  void registerGarbageCollector<T>(void Function(T, Cache) collector) {
    _garbageCollectors[T] = (dynamic item, Cache cache) =>
        collector(item as T, cache);
  }

  Map<int, CacheItem<T>> _getCacheFor<T>() {
    return _caches.putIfAbsent(T, () => <int, CacheItem<T>>{})
        as Map<int, CacheItem<T>>;
  }

  void addStrong<T>(T item) {
    final cache = _getCacheFor<T>();
    final int id = (item as dynamic).id;

    if (cache.containsKey(id)) {
      cache[id]!.increment();
    } else {
      cache[id] = CacheItem(value: item);
    }
  }

  void addWeak<T>(T item) {
    final cache = _getCacheFor<T>();
    final int id = (item as dynamic).id;

    if (!cache.containsKey(id)) {
      cache[id] = CacheItem(
        value: item,
        references: 0,
      );
    }
  }

  void releaseStrong<T>(T item) {
    final cache = _getCacheFor<T>();
    final int id = (item as dynamic).id;

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

  T? get<T>(int id) {
    final cache = _getCacheFor<T>();
    return cache[id]?.value;
  }

  Map<int, T> getAll<T>() {
    return _getCacheFor<T>().map((key, value) => MapEntry(key, value.value));
  }

  void clear<T>() {
    final cache = _getCacheFor<T>();
    cache.clear();
  }

  void clearAll() {
    _caches.clear();
  }
}

class CacheItem<T> {
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
