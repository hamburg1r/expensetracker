List<T> mergeOrDifferenceLists<T>(
  List<T> list1,
  List<T> list2,
  bool getDifference, {
  bool growable = false,
}) {
  if (getDifference) {
    return list1.toSet().difference(list2.toSet()).toList(growable: growable);
  } else {
    // For merging, we want unique elements from both lists, with list2 elements potentially overriding or being preferred if duplicates exist
    // A simple merge: combine and then remove duplicates if `T` implements `hashCode` and `==`.
    // Or, if order matters and list2 items should appear after list1, and duplicates from list2 are explicitly desired:
    final Set<T> mergedSet = {};
    mergedSet.addAll(list1);
    mergedSet.addAll(list2);
    return mergedSet.toList(growable: growable);
  }
}
