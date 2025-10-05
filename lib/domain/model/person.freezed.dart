// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'person.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Person {

 int get id; String get name; String get phoneNumber; List<Debt> get debtsOwed; List<Debt> get debtsReceivable; List<Expense> get transactions; List<Expense> get participations;
/// Create a copy of Person
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PersonCopyWith<Person> get copyWith => _$PersonCopyWithImpl<Person>(this as Person, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Person&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.phoneNumber, phoneNumber) || other.phoneNumber == phoneNumber)&&const DeepCollectionEquality().equals(other.debtsOwed, debtsOwed)&&const DeepCollectionEquality().equals(other.debtsReceivable, debtsReceivable)&&const DeepCollectionEquality().equals(other.transactions, transactions)&&const DeepCollectionEquality().equals(other.participations, participations));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,phoneNumber,const DeepCollectionEquality().hash(debtsOwed),const DeepCollectionEquality().hash(debtsReceivable),const DeepCollectionEquality().hash(transactions),const DeepCollectionEquality().hash(participations));

@override
String toString() {
  return 'Person(id: $id, name: $name, phoneNumber: $phoneNumber, debtsOwed: $debtsOwed, debtsReceivable: $debtsReceivable, transactions: $transactions, participations: $participations)';
}


}

/// @nodoc
abstract mixin class $PersonCopyWith<$Res>  {
  factory $PersonCopyWith(Person value, $Res Function(Person) _then) = _$PersonCopyWithImpl;
@useResult
$Res call({
 int id, String name, String phoneNumber, List<Debt> debtsOwed, List<Debt> debtsReceivable, List<Expense> transactions, List<Expense> participations
});




}
/// @nodoc
class _$PersonCopyWithImpl<$Res>
    implements $PersonCopyWith<$Res> {
  _$PersonCopyWithImpl(this._self, this._then);

  final Person _self;
  final $Res Function(Person) _then;

/// Create a copy of Person
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? phoneNumber = null,Object? debtsOwed = null,Object? debtsReceivable = null,Object? transactions = null,Object? participations = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,phoneNumber: null == phoneNumber ? _self.phoneNumber : phoneNumber // ignore: cast_nullable_to_non_nullable
as String,debtsOwed: null == debtsOwed ? _self.debtsOwed : debtsOwed // ignore: cast_nullable_to_non_nullable
as List<Debt>,debtsReceivable: null == debtsReceivable ? _self.debtsReceivable : debtsReceivable // ignore: cast_nullable_to_non_nullable
as List<Debt>,transactions: null == transactions ? _self.transactions : transactions // ignore: cast_nullable_to_non_nullable
as List<Expense>,participations: null == participations ? _self.participations : participations // ignore: cast_nullable_to_non_nullable
as List<Expense>,
  ));
}

}


/// Adds pattern-matching-related methods to [Person].
extension PersonPatterns on Person {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Person value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Person() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Person value)  $default,){
final _that = this;
switch (_that) {
case _Person():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Person value)?  $default,){
final _that = this;
switch (_that) {
case _Person() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String name,  String phoneNumber,  List<Debt> debtsOwed,  List<Debt> debtsReceivable,  List<Expense> transactions,  List<Expense> participations)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Person() when $default != null:
return $default(_that.id,_that.name,_that.phoneNumber,_that.debtsOwed,_that.debtsReceivable,_that.transactions,_that.participations);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String name,  String phoneNumber,  List<Debt> debtsOwed,  List<Debt> debtsReceivable,  List<Expense> transactions,  List<Expense> participations)  $default,) {final _that = this;
switch (_that) {
case _Person():
return $default(_that.id,_that.name,_that.phoneNumber,_that.debtsOwed,_that.debtsReceivable,_that.transactions,_that.participations);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String name,  String phoneNumber,  List<Debt> debtsOwed,  List<Debt> debtsReceivable,  List<Expense> transactions,  List<Expense> participations)?  $default,) {final _that = this;
switch (_that) {
case _Person() when $default != null:
return $default(_that.id,_that.name,_that.phoneNumber,_that.debtsOwed,_that.debtsReceivable,_that.transactions,_that.participations);case _:
  return null;

}
}

}

/// @nodoc


class _Person implements Person {
  const _Person({this.id = 0, required this.name, required this.phoneNumber, final  List<Debt> debtsOwed = const [], final  List<Debt> debtsReceivable = const [], final  List<Expense> transactions = const [], final  List<Expense> participations = const []}): _debtsOwed = debtsOwed,_debtsReceivable = debtsReceivable,_transactions = transactions,_participations = participations;
  

@override@JsonKey() final  int id;
@override final  String name;
@override final  String phoneNumber;
 final  List<Debt> _debtsOwed;
@override@JsonKey() List<Debt> get debtsOwed {
  if (_debtsOwed is EqualUnmodifiableListView) return _debtsOwed;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_debtsOwed);
}

 final  List<Debt> _debtsReceivable;
@override@JsonKey() List<Debt> get debtsReceivable {
  if (_debtsReceivable is EqualUnmodifiableListView) return _debtsReceivable;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_debtsReceivable);
}

 final  List<Expense> _transactions;
@override@JsonKey() List<Expense> get transactions {
  if (_transactions is EqualUnmodifiableListView) return _transactions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_transactions);
}

 final  List<Expense> _participations;
@override@JsonKey() List<Expense> get participations {
  if (_participations is EqualUnmodifiableListView) return _participations;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_participations);
}


/// Create a copy of Person
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PersonCopyWith<_Person> get copyWith => __$PersonCopyWithImpl<_Person>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Person&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.phoneNumber, phoneNumber) || other.phoneNumber == phoneNumber)&&const DeepCollectionEquality().equals(other._debtsOwed, _debtsOwed)&&const DeepCollectionEquality().equals(other._debtsReceivable, _debtsReceivable)&&const DeepCollectionEquality().equals(other._transactions, _transactions)&&const DeepCollectionEquality().equals(other._participations, _participations));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,phoneNumber,const DeepCollectionEquality().hash(_debtsOwed),const DeepCollectionEquality().hash(_debtsReceivable),const DeepCollectionEquality().hash(_transactions),const DeepCollectionEquality().hash(_participations));

@override
String toString() {
  return 'Person(id: $id, name: $name, phoneNumber: $phoneNumber, debtsOwed: $debtsOwed, debtsReceivable: $debtsReceivable, transactions: $transactions, participations: $participations)';
}


}

/// @nodoc
abstract mixin class _$PersonCopyWith<$Res> implements $PersonCopyWith<$Res> {
  factory _$PersonCopyWith(_Person value, $Res Function(_Person) _then) = __$PersonCopyWithImpl;
@override @useResult
$Res call({
 int id, String name, String phoneNumber, List<Debt> debtsOwed, List<Debt> debtsReceivable, List<Expense> transactions, List<Expense> participations
});




}
/// @nodoc
class __$PersonCopyWithImpl<$Res>
    implements _$PersonCopyWith<$Res> {
  __$PersonCopyWithImpl(this._self, this._then);

  final _Person _self;
  final $Res Function(_Person) _then;

/// Create a copy of Person
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? phoneNumber = null,Object? debtsOwed = null,Object? debtsReceivable = null,Object? transactions = null,Object? participations = null,}) {
  return _then(_Person(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,phoneNumber: null == phoneNumber ? _self.phoneNumber : phoneNumber // ignore: cast_nullable_to_non_nullable
as String,debtsOwed: null == debtsOwed ? _self._debtsOwed : debtsOwed // ignore: cast_nullable_to_non_nullable
as List<Debt>,debtsReceivable: null == debtsReceivable ? _self._debtsReceivable : debtsReceivable // ignore: cast_nullable_to_non_nullable
as List<Debt>,transactions: null == transactions ? _self._transactions : transactions // ignore: cast_nullable_to_non_nullable
as List<Expense>,participations: null == participations ? _self._participations : participations // ignore: cast_nullable_to_non_nullable
as List<Expense>,
  ));
}


}

// dart format on
