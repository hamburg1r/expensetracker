// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'expenses.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TransactionModel {
  String get id;
  double get amount;
  String get category;
  DateTime get date; // DateTime? dueDate,
// @Default(false) bool due,
  String? get description;
  String get payerId;
  List<String>? get participantIds;

  /// Create a copy of TransactionModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $TransactionModelCopyWith<TransactionModel> get copyWith =>
      _$TransactionModelCopyWithImpl<TransactionModel>(
          this as TransactionModel, _$identity);

  /// Serializes this TransactionModel to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is TransactionModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.payerId, payerId) || other.payerId == payerId) &&
            const DeepCollectionEquality()
                .equals(other.participantIds, participantIds));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      amount,
      category,
      date,
      description,
      payerId,
      const DeepCollectionEquality().hash(participantIds));

  @override
  String toString() {
    return 'TransactionModel(id: $id, amount: $amount, category: $category, date: $date, description: $description, payerId: $payerId, participantIds: $participantIds)';
  }
}

/// @nodoc
abstract mixin class $TransactionModelCopyWith<$Res> {
  factory $TransactionModelCopyWith(
          TransactionModel value, $Res Function(TransactionModel) _then) =
      _$TransactionModelCopyWithImpl;
  @useResult
  $Res call(
      {String id,
      double amount,
      String category,
      DateTime date,
      String? description,
      String payerId,
      List<String>? participantIds});
}

/// @nodoc
class _$TransactionModelCopyWithImpl<$Res>
    implements $TransactionModelCopyWith<$Res> {
  _$TransactionModelCopyWithImpl(this._self, this._then);

  final TransactionModel _self;
  final $Res Function(TransactionModel) _then;

  /// Create a copy of TransactionModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? amount = null,
    Object? category = null,
    Object? date = null,
    Object? description = freezed,
    Object? payerId = null,
    Object? participantIds = freezed,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      amount: null == amount
          ? _self.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double,
      category: null == category
          ? _self.category
          : category // ignore: cast_nullable_to_non_nullable
              as String,
      date: null == date
          ? _self.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      description: freezed == description
          ? _self.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      payerId: null == payerId
          ? _self.payerId
          : payerId // ignore: cast_nullable_to_non_nullable
              as String,
      participantIds: freezed == participantIds
          ? _self.participantIds
          : participantIds // ignore: cast_nullable_to_non_nullable
              as List<String>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _TransactionModel implements TransactionModel {
  _TransactionModel(
      {required this.id,
      required this.amount,
      required this.category,
      required this.date,
      this.description,
      required this.payerId,
      final List<String>? participantIds})
      : _participantIds = participantIds;
  factory _TransactionModel.fromJson(Map<String, dynamic> json) =>
      _$TransactionModelFromJson(json);

  @override
  final String id;
  @override
  final double amount;
  @override
  final String category;
  @override
  final DateTime date;
// DateTime? dueDate,
// @Default(false) bool due,
  @override
  final String? description;
  @override
  final String payerId;
  final List<String>? _participantIds;
  @override
  List<String>? get participantIds {
    final value = _participantIds;
    if (value == null) return null;
    if (_participantIds is EqualUnmodifiableListView) return _participantIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  /// Create a copy of TransactionModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$TransactionModelCopyWith<_TransactionModel> get copyWith =>
      __$TransactionModelCopyWithImpl<_TransactionModel>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$TransactionModelToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _TransactionModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.payerId, payerId) || other.payerId == payerId) &&
            const DeepCollectionEquality()
                .equals(other._participantIds, _participantIds));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      amount,
      category,
      date,
      description,
      payerId,
      const DeepCollectionEquality().hash(_participantIds));

  @override
  String toString() {
    return 'TransactionModel(id: $id, amount: $amount, category: $category, date: $date, description: $description, payerId: $payerId, participantIds: $participantIds)';
  }
}

/// @nodoc
abstract mixin class _$TransactionModelCopyWith<$Res>
    implements $TransactionModelCopyWith<$Res> {
  factory _$TransactionModelCopyWith(
          _TransactionModel value, $Res Function(_TransactionModel) _then) =
      __$TransactionModelCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String id,
      double amount,
      String category,
      DateTime date,
      String? description,
      String payerId,
      List<String>? participantIds});
}

/// @nodoc
class __$TransactionModelCopyWithImpl<$Res>
    implements _$TransactionModelCopyWith<$Res> {
  __$TransactionModelCopyWithImpl(this._self, this._then);

  final _TransactionModel _self;
  final $Res Function(_TransactionModel) _then;

  /// Create a copy of TransactionModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? amount = null,
    Object? category = null,
    Object? date = null,
    Object? description = freezed,
    Object? payerId = null,
    Object? participantIds = freezed,
  }) {
    return _then(_TransactionModel(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      amount: null == amount
          ? _self.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double,
      category: null == category
          ? _self.category
          : category // ignore: cast_nullable_to_non_nullable
              as String,
      date: null == date
          ? _self.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      description: freezed == description
          ? _self.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      payerId: null == payerId
          ? _self.payerId
          : payerId // ignore: cast_nullable_to_non_nullable
              as String,
      participantIds: freezed == participantIds
          ? _self._participantIds
          : participantIds // ignore: cast_nullable_to_non_nullable
              as List<String>?,
    ));
  }
}

/// @nodoc
mixin _$DebtModel {
  String get id;
  String get personId;
  double get amount;
  DebtType get type;
  String? get description;
  DateTime get date;
  bool get isSettled;

  /// Create a copy of DebtModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $DebtModelCopyWith<DebtModel> get copyWith =>
      _$DebtModelCopyWithImpl<DebtModel>(this as DebtModel, _$identity);

  /// Serializes this DebtModel to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is DebtModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.personId, personId) ||
                other.personId == personId) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.isSettled, isSettled) ||
                other.isSettled == isSettled));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, id, personId, amount, type, description, date, isSettled);

  @override
  String toString() {
    return 'DebtModel(id: $id, personId: $personId, amount: $amount, type: $type, description: $description, date: $date, isSettled: $isSettled)';
  }
}

/// @nodoc
abstract mixin class $DebtModelCopyWith<$Res> {
  factory $DebtModelCopyWith(DebtModel value, $Res Function(DebtModel) _then) =
      _$DebtModelCopyWithImpl;
  @useResult
  $Res call(
      {String id,
      String personId,
      double amount,
      DebtType type,
      String? description,
      DateTime date,
      bool isSettled});
}

/// @nodoc
class _$DebtModelCopyWithImpl<$Res> implements $DebtModelCopyWith<$Res> {
  _$DebtModelCopyWithImpl(this._self, this._then);

  final DebtModel _self;
  final $Res Function(DebtModel) _then;

  /// Create a copy of DebtModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? personId = null,
    Object? amount = null,
    Object? type = null,
    Object? description = freezed,
    Object? date = null,
    Object? isSettled = null,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      personId: null == personId
          ? _self.personId
          : personId // ignore: cast_nullable_to_non_nullable
              as String,
      amount: null == amount
          ? _self.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double,
      type: null == type
          ? _self.type
          : type // ignore: cast_nullable_to_non_nullable
              as DebtType,
      description: freezed == description
          ? _self.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      date: null == date
          ? _self.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      isSettled: null == isSettled
          ? _self.isSettled
          : isSettled // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _DebtModel implements DebtModel {
  _DebtModel(
      {required this.id,
      required this.personId,
      required this.amount,
      required this.type,
      this.description,
      required this.date,
      this.isSettled = false});
  factory _DebtModel.fromJson(Map<String, dynamic> json) =>
      _$DebtModelFromJson(json);

  @override
  final String id;
  @override
  final String personId;
  @override
  final double amount;
  @override
  final DebtType type;
  @override
  final String? description;
  @override
  final DateTime date;
  @override
  @JsonKey()
  final bool isSettled;

  /// Create a copy of DebtModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$DebtModelCopyWith<_DebtModel> get copyWith =>
      __$DebtModelCopyWithImpl<_DebtModel>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$DebtModelToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _DebtModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.personId, personId) ||
                other.personId == personId) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.isSettled, isSettled) ||
                other.isSettled == isSettled));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, id, personId, amount, type, description, date, isSettled);

  @override
  String toString() {
    return 'DebtModel(id: $id, personId: $personId, amount: $amount, type: $type, description: $description, date: $date, isSettled: $isSettled)';
  }
}

/// @nodoc
abstract mixin class _$DebtModelCopyWith<$Res>
    implements $DebtModelCopyWith<$Res> {
  factory _$DebtModelCopyWith(
          _DebtModel value, $Res Function(_DebtModel) _then) =
      __$DebtModelCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String id,
      String personId,
      double amount,
      DebtType type,
      String? description,
      DateTime date,
      bool isSettled});
}

/// @nodoc
class __$DebtModelCopyWithImpl<$Res> implements _$DebtModelCopyWith<$Res> {
  __$DebtModelCopyWithImpl(this._self, this._then);

  final _DebtModel _self;
  final $Res Function(_DebtModel) _then;

  /// Create a copy of DebtModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? personId = null,
    Object? amount = null,
    Object? type = null,
    Object? description = freezed,
    Object? date = null,
    Object? isSettled = null,
  }) {
    return _then(_DebtModel(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      personId: null == personId
          ? _self.personId
          : personId // ignore: cast_nullable_to_non_nullable
              as String,
      amount: null == amount
          ? _self.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double,
      type: null == type
          ? _self.type
          : type // ignore: cast_nullable_to_non_nullable
              as DebtType,
      description: freezed == description
          ? _self.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      date: null == date
          ? _self.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      isSettled: null == isSettled
          ? _self.isSettled
          : isSettled // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

// dart format on
