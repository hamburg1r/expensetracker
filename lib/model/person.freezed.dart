// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'person.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PersonModel {
  String get firstName;
  String? get middleName;
  String get lastName;
  int get number;

  /// Create a copy of PersonModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $PersonModelCopyWith<PersonModel> get copyWith =>
      _$PersonModelCopyWithImpl<PersonModel>(this as PersonModel, _$identity);

  /// Serializes this PersonModel to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is PersonModel &&
            (identical(other.firstName, firstName) ||
                other.firstName == firstName) &&
            (identical(other.middleName, middleName) ||
                other.middleName == middleName) &&
            (identical(other.lastName, lastName) ||
                other.lastName == lastName) &&
            (identical(other.number, number) || other.number == number));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, firstName, middleName, lastName, number);

  @override
  String toString() {
    return 'PersonModel(firstName: $firstName, middleName: $middleName, lastName: $lastName, number: $number)';
  }
}

/// @nodoc
abstract mixin class $PersonModelCopyWith<$Res> {
  factory $PersonModelCopyWith(
          PersonModel value, $Res Function(PersonModel) _then) =
      _$PersonModelCopyWithImpl;
  @useResult
  $Res call(
      {String firstName, String? middleName, String lastName, int number});
}

/// @nodoc
class _$PersonModelCopyWithImpl<$Res> implements $PersonModelCopyWith<$Res> {
  _$PersonModelCopyWithImpl(this._self, this._then);

  final PersonModel _self;
  final $Res Function(PersonModel) _then;

  /// Create a copy of PersonModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? firstName = null,
    Object? middleName = freezed,
    Object? lastName = null,
    Object? number = null,
  }) {
    return _then(_self.copyWith(
      firstName: null == firstName
          ? _self.firstName
          : firstName // ignore: cast_nullable_to_non_nullable
              as String,
      middleName: freezed == middleName
          ? _self.middleName
          : middleName // ignore: cast_nullable_to_non_nullable
              as String?,
      lastName: null == lastName
          ? _self.lastName
          : lastName // ignore: cast_nullable_to_non_nullable
              as String,
      number: null == number
          ? _self.number
          : number // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _PersonModel implements PersonModel {
  _PersonModel(
      {required this.firstName,
      this.middleName,
      required this.lastName,
      required this.number});
  factory _PersonModel.fromJson(Map<String, dynamic> json) =>
      _$PersonModelFromJson(json);

  @override
  final String firstName;
  @override
  final String? middleName;
  @override
  final String lastName;
  @override
  final int number;

  /// Create a copy of PersonModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$PersonModelCopyWith<_PersonModel> get copyWith =>
      __$PersonModelCopyWithImpl<_PersonModel>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$PersonModelToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _PersonModel &&
            (identical(other.firstName, firstName) ||
                other.firstName == firstName) &&
            (identical(other.middleName, middleName) ||
                other.middleName == middleName) &&
            (identical(other.lastName, lastName) ||
                other.lastName == lastName) &&
            (identical(other.number, number) || other.number == number));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, firstName, middleName, lastName, number);

  @override
  String toString() {
    return 'PersonModel(firstName: $firstName, middleName: $middleName, lastName: $lastName, number: $number)';
  }
}

/// @nodoc
abstract mixin class _$PersonModelCopyWith<$Res>
    implements $PersonModelCopyWith<$Res> {
  factory _$PersonModelCopyWith(
          _PersonModel value, $Res Function(_PersonModel) _then) =
      __$PersonModelCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String firstName, String? middleName, String lastName, int number});
}

/// @nodoc
class __$PersonModelCopyWithImpl<$Res> implements _$PersonModelCopyWith<$Res> {
  __$PersonModelCopyWithImpl(this._self, this._then);

  final _PersonModel _self;
  final $Res Function(_PersonModel) _then;

  /// Create a copy of PersonModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? firstName = null,
    Object? middleName = freezed,
    Object? lastName = null,
    Object? number = null,
  }) {
    return _then(_PersonModel(
      firstName: null == firstName
          ? _self.firstName
          : firstName // ignore: cast_nullable_to_non_nullable
              as String,
      middleName: freezed == middleName
          ? _self.middleName
          : middleName // ignore: cast_nullable_to_non_nullable
              as String?,
      lastName: null == lastName
          ? _self.lastName
          : lastName // ignore: cast_nullable_to_non_nullable
              as String,
      number: null == number
          ? _self.number
          : number // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

// dart format on
