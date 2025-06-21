// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'expenses.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TransactionModel _$TransactionModelFromJson(Map<String, dynamic> json) =>
    _TransactionModel(
      id: json['id'] as String,
      amount: (json['amount'] as num).toDouble(),
      category: json['category'] as String,
      date: DateTime.parse(json['date'] as String),
      description: json['description'] as String?,
      payerId: json['payerId'] as String,
      participantIds: (json['participantIds'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$TransactionModelToJson(_TransactionModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'amount': instance.amount,
      'category': instance.category,
      'date': instance.date.toIso8601String(),
      'description': instance.description,
      'payerId': instance.payerId,
      'participantIds': instance.participantIds,
    };

_DebtModel _$DebtModelFromJson(Map<String, dynamic> json) => _DebtModel(
      id: json['id'] as String,
      personId: json['personId'] as String,
      amount: (json['amount'] as num).toDouble(),
      type: $enumDecode(_$DebtTypeEnumMap, json['type']),
      description: json['description'] as String?,
      date: DateTime.parse(json['date'] as String),
      isSettled: json['isSettled'] as bool? ?? false,
    );

Map<String, dynamic> _$DebtModelToJson(_DebtModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'personId': instance.personId,
      'amount': instance.amount,
      'type': _$DebtTypeEnumMap[instance.type]!,
      'description': instance.description,
      'date': instance.date.toIso8601String(),
      'isSettled': instance.isSettled,
    };

const _$DebtTypeEnumMap = {
  DebtType.owe: 'owe',
  DebtType.borrow: 'borrow',
};

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$transactionsHash() => r'be1534fa208bc0073ad2fad220a03d0150165fc3';

/// See also [Transactions].
@ProviderFor(Transactions)
final transactionsProvider = AutoDisposeAsyncNotifierProvider<Transactions,
    Map<String, List<TransactionModel>>>.internal(
  Transactions.new,
  name: r'transactionsProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$transactionsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$Transactions
    = AutoDisposeAsyncNotifier<Map<String, List<TransactionModel>>>;
String _$debtsHash() => r'46accae943abcdf10f11f436afc49af9f6049d93';

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
