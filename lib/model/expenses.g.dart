// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'expenses.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$transactionsHash() => r'7f6767f392e5923c0073d0527d0e7e21fb22e90c';

/// See also [Transactions].
@ProviderFor(Transactions)
final transactionsProvider = AutoDisposeAsyncNotifierProvider<Transactions,
    List<TransactionModel>>.internal(
  Transactions.new,
  name: r'transactionsProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$transactionsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$Transactions = AutoDisposeAsyncNotifier<List<TransactionModel>>;
String _$debtsHash() => r'439cb1983b9de2ff01fd04a2c6baaf758ed10e5c';

/// See also [Debts].
@ProviderFor(Debts)
final debtsProvider =
    AutoDisposeAsyncNotifierProvider<Debts, List<TransactionModel>>.internal(
  Debts.new,
  name: r'debtsProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$debtsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$Debts = AutoDisposeAsyncNotifier<List<TransactionModel>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
