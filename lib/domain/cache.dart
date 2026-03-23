import 'package:expensetracker/domain/model/base_entity.dart';

/// A generic in-memory cache for [BaseEntity] objects, managing strong and weak
/// references.
///
/// This cache allows storing and retrieving objects of different types that extend
/// [BaseEntity]. It supports two types of references:
/// - Strong references: Objects are retained in the cache as long as there is at
///   least one strong reference. When the last strong reference is released, the
///   object is removed, and an optional garbage collector is invoked.
/// - Weak references: Objects are added without incrementing a reference count.
///   They remain in the cache until explicitly removed or a strong reference
///   count drops to zero.
///
/// The cache also supports registering garbage collectors for specific types,
/// which are invoked when an item is removed from the cache due to its
/// strong reference count dropping to zero.
class Cache {
  /// A map where keys are [Type]s (subtypes of [BaseEntity]) and values are
  /// maps containing cached [CacheItem]s for that type, keyed by their integer ID.
  final Map<Type, Map<int, CacheItem<BaseEntity>>> _caches = {};
  /// A map where keys are [Type]s (subtypes of [BaseEntity]) and values are
  /// functions that serve as garbage collectors for that specific type.
  /// These functions are invoked when an item is removed from the cache
  /// due to its strong reference count reaching zero.
  final Map<Type, void Function(BaseEntity, Cache)> _garbageCollectors = {};

  /// Registers a garbage collector function for a specific type [T].
  ///
  /// The [collector] function will be invoked when an item of type [T] is
  /// removed from the cache, typically when its strong reference count drops to
  /// zero. This allows for custom cleanup logic for associated entities.
  ///
  /// - Parameters:
  ///   - [collector]: The function to be called. It receives the removed item
  ///     and the [Cache] instance itself as arguments.
  void registerGarbageCollector<T extends BaseEntity>(
    void Function(T, Cache) collector,
  ) {
    _garbageCollectors[T] = (BaseEntity item, Cache cache) =>
        collector(item as T, cache);
  }

  /// Retrieves or creates the type-specific cache map for [T].
  ///
  /// This internal helper ensures that there is a dedicated map within [_caches]
  /// for each unique subtype of [BaseEntity].
  ///
  /// - Returns: A [Map] from item ID to [CacheItem] for the specified type [T].
  Map<int, CacheItem<T>> _getCacheFor<T extends BaseEntity>() {
    return _caches.putIfAbsent(T, () => <int, CacheItem<BaseEntity>>{})
        as Map<int, CacheItem<T>>;
  }

  /// Adds an item to the cache with a strong reference.
  ///
  /// If the item (identified by its ID) is already in the cache, its strong
  /// reference count is incremented. Otherwise, the item is added with an
  /// initial strong reference count of 1.
  ///
  /// - Parameters:
  ///   - [item]: The [BaseEntity] item to add.
  void addStrong<T extends BaseEntity>(T item) {
    final cache = _getCacheFor<T>();
    final int id = item.id;

    if (cache.containsKey(id)) {
      cache[id]!.increment();
    } else {
      cache[id] = CacheItem(value: item);
    }
  }

  /// Adds an item to the cache with a weak reference.
  ///
  /// If the item (identified by its ID) is not already in the cache, it is
  /// added with a reference count of 0. If it already exists (either strong
  /// or weak), this method does nothing, preserving its existing reference count.
  ///
  /// - Parameters:
  ///   - [item]: The [BaseEntity] item to add weakly.
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

  /// Returns the current strong reference count for a given item.
  ///
  /// - Parameters:
  ///   - [item]: The [BaseEntity] item whose reference count is to be queried.
  ///
  /// - Returns: The number of strong references for the item. Returns -1 if
  ///   the item is not found in the cache.
  int references<T extends BaseEntity>(T item) {
    final cache = _getCacheFor<T>();
    final int id = item.id;
    return cache[id]?.references ?? -1;
  }

  /// Updates an existing item in the cache with a new instance.
  ///
  /// If the item (identified by its ID) exists in the cache, its stored value
  /// is replaced with the new [item]. The reference count remains unchanged.
  ///
  /// - Parameters:
  ///   - [item]: The new [BaseEntity] instance to update. It must have the
  ///     same ID as an item already in the cache.
  void update<T extends BaseEntity>(T item) {
    final cache = _getCacheFor<T>();
    final int id = item.id;

    if (cache.containsKey(id)) {
      cache[id]!.value = item;
    }
  }

  /// Explicitly removes an item of type [T] with the given [id] from the cache.
  ///
  /// If an item is removed and a garbage collector is registered for type [T],
  /// the collector function is invoked with the removed item's value. This
  /// method removes the item regardless of its reference count.
  ///
  /// - Parameters:
  ///   - [id]: The integer ID of the item to remove.
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

  /// Decrements the strong reference count for a given [item].
  ///
  /// If the reference count drops to zero after decrementing, the item is
  /// removed from the cache, and any registered garbage collector for its type
  /// [T] is invoked.
  ///
  /// - Parameters:
  ///   - [item]: The [BaseEntity] item for which to release a strong reference.
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

  /// Retrieves an item of type [T] from the cache by its ID.
  ///
  /// - Parameters:
  ///   - [id]: The integer ID of the item to retrieve.
  ///
  /// - Returns: The [BaseEntity] item if found, otherwise `null`.
  T? get<T extends BaseEntity>(int id) {
    final cache = _getCacheFor<T>();
    return cache[id]?.value;
  }

  /// Retrieves all items of a specific type [T] from the cache.
  ///
  /// - Returns: A [Map] containing all cached [BaseEntity] items of type [T],
  ///   keyed by their integer ID.
  Map<int, T> getAll<T extends BaseEntity>() {
    return _getCacheFor<T>().map((key, value) => MapEntry(key, value.value));
  }

  /// Clears all items of a specific type [T] from the cache.
  void clear<T extends BaseEntity>() {
    final cache = _getCacheFor<T>();
    cache.clear();
  }

  /// Clears all items from all type-specific caches.
  void clearAll() {
    _caches.clear();
  }
}

/// A wrapper class for a [BaseEntity] stored in the [Cache].
///
/// It holds the actual [value] of the entity and a [references] count
/// to manage strong references.
class CacheItem<T extends BaseEntity> {
  /// The actual [BaseEntity] instance being cached.
  T value;
  /// The number of strong references currently held for this cached item.
  /// When this count drops to 0, the item may be removed from the cache.
  int references;

  /// Creates a new [CacheItem] instance.
  ///
  /// - Parameters:
  ///   - [value]: The [BaseEntity] instance to wrap.
  ///   - [references]: The initial strong reference count for the item.
  ///     Defaults to 1.
  CacheItem({
    required this.value,
    this.references = 1,
  });

  /// Increments the strong reference count by 1.
  void increment() => references++;
  /// Decrements the strong reference count by 1, ensuring it does not go below zero.
  void decrement() {
    if (references == 0) return;
    references--;
  }
}
