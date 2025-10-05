// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'expense.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Expense {

 int get id; String get name; String get description; List<String> get tags; DateTime get date; double get amount; Person? get payer; List<Person> get participation; List<Debt> get debts;
/// Create a copy of Expense
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ExpenseCopyWith<Expense> get copyWith => _$ExpenseCopyWithImpl<Expense>(this as Expense, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Expense&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&const DeepCollectionEquality().equals(other.tags, tags)&&(identical(other.date, date) || other.date == date)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.payer, payer) || other.payer == payer)&&const DeepCollectionEquality().equals(other.participation, participation)&&const DeepCollectionEquality().equals(other.debts, debts));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,description,const DeepCollectionEquality().hash(tags),date,amount,payer,const DeepCollectionEquality().hash(participation),const DeepCollectionEquality().hash(debts));

@override
String toString() {
  return 'Expense(id: $id, name: $name, description: $description, tags: $tags, date: $date, amount: $amount, payer: $payer, participation: $participation, debts: $debts)';
}


}

/// @nodoc
abstract mixin class $ExpenseCopyWith<$Res>  {
  factory $ExpenseCopyWith(Expense value, $Res Function(Expense) _then) = _$ExpenseCopyWithImpl;
@useResult
$Res call({
 int id, String name, String description, List<String> tags, DateTime date, double amount, Person? payer, List<Person> participation, List<Debt> debts
});


$PersonCopyWith<$Res>? get payer;

}
/// @nodoc
class _$ExpenseCopyWithImpl<$Res>
    implements $ExpenseCopyWith<$Res> {
  _$ExpenseCopyWithImpl(this._self, this._then);

  final Expense _self;
  final $Res Function(Expense) _then;

/// Create a copy of Expense
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? description = null,Object? tags = null,Object? date = null,Object? amount = null,Object? payer = freezed,Object? participation = null,Object? debts = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,tags: null == tags ? _self.tags : tags // ignore: cast_nullable_to_non_nullable
as List<String>,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as double,payer: freezed == payer ? _self.payer : payer // ignore: cast_nullable_to_non_nullable
as Person?,participation: null == participation ? _self.participation : participation // ignore: cast_nullable_to_non_nullable
as List<Person>,debts: null == debts ? _self.debts : debts // ignore: cast_nullable_to_non_nullable
as List<Debt>,
  ));
}
/// Create a copy of Expense
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PersonCopyWith<$Res>? get payer {
    if (_self.payer == null) {
    return null;
  }

  return $PersonCopyWith<$Res>(_self.payer!, (value) {
    return _then(_self.copyWith(payer: value));
  });
}
}


/// Adds pattern-matching-related methods to [Expense].
extension ExpensePatterns on Expense {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Expense value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Expense() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Expense value)  $default,){
final _that = this;
switch (_that) {
case _Expense():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Expense value)?  $default,){
final _that = this;
switch (_that) {
case _Expense() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String name,  String description,  List<String> tags,  DateTime date,  double amount,  Person? payer,  List<Person> participation,  List<Debt> debts)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Expense() when $default != null:
return $default(_that.id,_that.name,_that.description,_that.tags,_that.date,_that.amount,_that.payer,_that.participation,_that.debts);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String name,  String description,  List<String> tags,  DateTime date,  double amount,  Person? payer,  List<Person> participation,  List<Debt> debts)  $default,) {final _that = this;
switch (_that) {
case _Expense():
return $default(_that.id,_that.name,_that.description,_that.tags,_that.date,_that.amount,_that.payer,_that.participation,_that.debts);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String name,  String description,  List<String> tags,  DateTime date,  double amount,  Person? payer,  List<Person> participation,  List<Debt> debts)?  $default,) {final _that = this;
switch (_that) {
case _Expense() when $default != null:
return $default(_that.id,_that.name,_that.description,_that.tags,_that.date,_that.amount,_that.payer,_that.participation,_that.debts);case _:
  return null;

}
}

}

/// @nodoc


class _Expense implements Expense {
  const _Expense({this.id = 0, required this.name, this.description = "", final  List<String> tags = const [], required this.date, required this.amount, this.payer, required final  List<Person> participation, final  List<Debt> debts = const []}): _tags = tags,_participation = participation,_debts = debts;
  

@override@JsonKey() final  int id;
@override final  String name;
@override@JsonKey() final  String description;
 final  List<String> _tags;
@override@JsonKey() List<String> get tags {
  if (_tags is EqualUnmodifiableListView) return _tags;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_tags);
}

@override final  DateTime date;
@override final  double amount;
@override final  Person? payer;
 final  List<Person> _participation;
@override List<Person> get participation {
  if (_participation is EqualUnmodifiableListView) return _participation;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_participation);
}

 final  List<Debt> _debts;
@override@JsonKey() List<Debt> get debts {
  if (_debts is EqualUnmodifiableListView) return _debts;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_debts);
}


/// Create a copy of Expense
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ExpenseCopyWith<_Expense> get copyWith => __$ExpenseCopyWithImpl<_Expense>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Expense&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&const DeepCollectionEquality().equals(other._tags, _tags)&&(identical(other.date, date) || other.date == date)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.payer, payer) || other.payer == payer)&&const DeepCollectionEquality().equals(other._participation, _participation)&&const DeepCollectionEquality().equals(other._debts, _debts));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,description,const DeepCollectionEquality().hash(_tags),date,amount,payer,const DeepCollectionEquality().hash(_participation),const DeepCollectionEquality().hash(_debts));

@override
String toString() {
  return 'Expense(id: $id, name: $name, description: $description, tags: $tags, date: $date, amount: $amount, payer: $payer, participation: $participation, debts: $debts)';
}


}

/// @nodoc
abstract mixin class _$ExpenseCopyWith<$Res> implements $ExpenseCopyWith<$Res> {
  factory _$ExpenseCopyWith(_Expense value, $Res Function(_Expense) _then) = __$ExpenseCopyWithImpl;
@override @useResult
$Res call({
 int id, String name, String description, List<String> tags, DateTime date, double amount, Person? payer, List<Person> participation, List<Debt> debts
});


@override $PersonCopyWith<$Res>? get payer;

}
/// @nodoc
class __$ExpenseCopyWithImpl<$Res>
    implements _$ExpenseCopyWith<$Res> {
  __$ExpenseCopyWithImpl(this._self, this._then);

  final _Expense _self;
  final $Res Function(_Expense) _then;

/// Create a copy of Expense
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? description = null,Object? tags = null,Object? date = null,Object? amount = null,Object? payer = freezed,Object? participation = null,Object? debts = null,}) {
  return _then(_Expense(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,tags: null == tags ? _self._tags : tags // ignore: cast_nullable_to_non_nullable
as List<String>,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as double,payer: freezed == payer ? _self.payer : payer // ignore: cast_nullable_to_non_nullable
as Person?,participation: null == participation ? _self._participation : participation // ignore: cast_nullable_to_non_nullable
as List<Person>,debts: null == debts ? _self._debts : debts // ignore: cast_nullable_to_non_nullable
as List<Debt>,
  ));
}

/// Create a copy of Expense
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PersonCopyWith<$Res>? get payer {
    if (_self.payer == null) {
    return null;
  }

  return $PersonCopyWith<$Res>(_self.payer!, (value) {
    return _then(_self.copyWith(payer: value));
  });
}
}

// dart format on
