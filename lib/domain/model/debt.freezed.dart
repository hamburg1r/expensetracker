// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'debt.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Debt {

 int get id; Person? get debtor; Person get creditor; double get amount; DateTime get date; String get note; List<String> get tags; double get paidAmount; Expense? get expense;
/// Create a copy of Debt
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DebtCopyWith<Debt> get copyWith => _$DebtCopyWithImpl<Debt>(this as Debt, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Debt&&(identical(other.id, id) || other.id == id)&&(identical(other.debtor, debtor) || other.debtor == debtor)&&(identical(other.creditor, creditor) || other.creditor == creditor)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.date, date) || other.date == date)&&(identical(other.note, note) || other.note == note)&&const DeepCollectionEquality().equals(other.tags, tags)&&(identical(other.paidAmount, paidAmount) || other.paidAmount == paidAmount)&&(identical(other.expense, expense) || other.expense == expense));
}


@override
int get hashCode => Object.hash(runtimeType,id,debtor,creditor,amount,date,note,const DeepCollectionEquality().hash(tags),paidAmount,expense);

@override
String toString() {
  return 'Debt(id: $id, debtor: $debtor, creditor: $creditor, amount: $amount, date: $date, note: $note, tags: $tags, paidAmount: $paidAmount, expense: $expense)';
}


}

/// @nodoc
abstract mixin class $DebtCopyWith<$Res>  {
  factory $DebtCopyWith(Debt value, $Res Function(Debt) _then) = _$DebtCopyWithImpl;
@useResult
$Res call({
 int id, Person? debtor, Person creditor, double amount, DateTime date, String note, List<String> tags, double paidAmount, Expense? expense
});


$PersonCopyWith<$Res>? get debtor;$PersonCopyWith<$Res> get creditor;$ExpenseCopyWith<$Res>? get expense;

}
/// @nodoc
class _$DebtCopyWithImpl<$Res>
    implements $DebtCopyWith<$Res> {
  _$DebtCopyWithImpl(this._self, this._then);

  final Debt _self;
  final $Res Function(Debt) _then;

/// Create a copy of Debt
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? debtor = freezed,Object? creditor = null,Object? amount = null,Object? date = null,Object? note = null,Object? tags = null,Object? paidAmount = null,Object? expense = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,debtor: freezed == debtor ? _self.debtor : debtor // ignore: cast_nullable_to_non_nullable
as Person?,creditor: null == creditor ? _self.creditor : creditor // ignore: cast_nullable_to_non_nullable
as Person,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as double,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,note: null == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String,tags: null == tags ? _self.tags : tags // ignore: cast_nullable_to_non_nullable
as List<String>,paidAmount: null == paidAmount ? _self.paidAmount : paidAmount // ignore: cast_nullable_to_non_nullable
as double,expense: freezed == expense ? _self.expense : expense // ignore: cast_nullable_to_non_nullable
as Expense?,
  ));
}
/// Create a copy of Debt
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PersonCopyWith<$Res>? get debtor {
    if (_self.debtor == null) {
    return null;
  }

  return $PersonCopyWith<$Res>(_self.debtor!, (value) {
    return _then(_self.copyWith(debtor: value));
  });
}/// Create a copy of Debt
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PersonCopyWith<$Res> get creditor {
  
  return $PersonCopyWith<$Res>(_self.creditor, (value) {
    return _then(_self.copyWith(creditor: value));
  });
}/// Create a copy of Debt
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ExpenseCopyWith<$Res>? get expense {
    if (_self.expense == null) {
    return null;
  }

  return $ExpenseCopyWith<$Res>(_self.expense!, (value) {
    return _then(_self.copyWith(expense: value));
  });
}
}


/// Adds pattern-matching-related methods to [Debt].
extension DebtPatterns on Debt {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Debt value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Debt() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Debt value)  $default,){
final _that = this;
switch (_that) {
case _Debt():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Debt value)?  $default,){
final _that = this;
switch (_that) {
case _Debt() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  Person? debtor,  Person creditor,  double amount,  DateTime date,  String note,  List<String> tags,  double paidAmount,  Expense? expense)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Debt() when $default != null:
return $default(_that.id,_that.debtor,_that.creditor,_that.amount,_that.date,_that.note,_that.tags,_that.paidAmount,_that.expense);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  Person? debtor,  Person creditor,  double amount,  DateTime date,  String note,  List<String> tags,  double paidAmount,  Expense? expense)  $default,) {final _that = this;
switch (_that) {
case _Debt():
return $default(_that.id,_that.debtor,_that.creditor,_that.amount,_that.date,_that.note,_that.tags,_that.paidAmount,_that.expense);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  Person? debtor,  Person creditor,  double amount,  DateTime date,  String note,  List<String> tags,  double paidAmount,  Expense? expense)?  $default,) {final _that = this;
switch (_that) {
case _Debt() when $default != null:
return $default(_that.id,_that.debtor,_that.creditor,_that.amount,_that.date,_that.note,_that.tags,_that.paidAmount,_that.expense);case _:
  return null;

}
}

}

/// @nodoc


class _Debt implements Debt {
  const _Debt({this.id = 0, this.debtor, required this.creditor, required this.amount, required this.date, this.note = "", final  List<String> tags = const [], this.paidAmount = 0, this.expense}): _tags = tags;
  

@override@JsonKey() final  int id;
@override final  Person? debtor;
@override final  Person creditor;
@override final  double amount;
@override final  DateTime date;
@override@JsonKey() final  String note;
 final  List<String> _tags;
@override@JsonKey() List<String> get tags {
  if (_tags is EqualUnmodifiableListView) return _tags;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_tags);
}

@override@JsonKey() final  double paidAmount;
@override final  Expense? expense;

/// Create a copy of Debt
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DebtCopyWith<_Debt> get copyWith => __$DebtCopyWithImpl<_Debt>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Debt&&(identical(other.id, id) || other.id == id)&&(identical(other.debtor, debtor) || other.debtor == debtor)&&(identical(other.creditor, creditor) || other.creditor == creditor)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.date, date) || other.date == date)&&(identical(other.note, note) || other.note == note)&&const DeepCollectionEquality().equals(other._tags, _tags)&&(identical(other.paidAmount, paidAmount) || other.paidAmount == paidAmount)&&(identical(other.expense, expense) || other.expense == expense));
}


@override
int get hashCode => Object.hash(runtimeType,id,debtor,creditor,amount,date,note,const DeepCollectionEquality().hash(_tags),paidAmount,expense);

@override
String toString() {
  return 'Debt(id: $id, debtor: $debtor, creditor: $creditor, amount: $amount, date: $date, note: $note, tags: $tags, paidAmount: $paidAmount, expense: $expense)';
}


}

/// @nodoc
abstract mixin class _$DebtCopyWith<$Res> implements $DebtCopyWith<$Res> {
  factory _$DebtCopyWith(_Debt value, $Res Function(_Debt) _then) = __$DebtCopyWithImpl;
@override @useResult
$Res call({
 int id, Person? debtor, Person creditor, double amount, DateTime date, String note, List<String> tags, double paidAmount, Expense? expense
});


@override $PersonCopyWith<$Res>? get debtor;@override $PersonCopyWith<$Res> get creditor;@override $ExpenseCopyWith<$Res>? get expense;

}
/// @nodoc
class __$DebtCopyWithImpl<$Res>
    implements _$DebtCopyWith<$Res> {
  __$DebtCopyWithImpl(this._self, this._then);

  final _Debt _self;
  final $Res Function(_Debt) _then;

/// Create a copy of Debt
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? debtor = freezed,Object? creditor = null,Object? amount = null,Object? date = null,Object? note = null,Object? tags = null,Object? paidAmount = null,Object? expense = freezed,}) {
  return _then(_Debt(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,debtor: freezed == debtor ? _self.debtor : debtor // ignore: cast_nullable_to_non_nullable
as Person?,creditor: null == creditor ? _self.creditor : creditor // ignore: cast_nullable_to_non_nullable
as Person,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as double,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,note: null == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String,tags: null == tags ? _self._tags : tags // ignore: cast_nullable_to_non_nullable
as List<String>,paidAmount: null == paidAmount ? _self.paidAmount : paidAmount // ignore: cast_nullable_to_non_nullable
as double,expense: freezed == expense ? _self.expense : expense // ignore: cast_nullable_to_non_nullable
as Expense?,
  ));
}

/// Create a copy of Debt
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PersonCopyWith<$Res>? get debtor {
    if (_self.debtor == null) {
    return null;
  }

  return $PersonCopyWith<$Res>(_self.debtor!, (value) {
    return _then(_self.copyWith(debtor: value));
  });
}/// Create a copy of Debt
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PersonCopyWith<$Res> get creditor {
  
  return $PersonCopyWith<$Res>(_self.creditor, (value) {
    return _then(_self.copyWith(creditor: value));
  });
}/// Create a copy of Debt
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ExpenseCopyWith<$Res>? get expense {
    if (_self.expense == null) {
    return null;
  }

  return $ExpenseCopyWith<$Res>(_self.expense!, (value) {
    return _then(_self.copyWith(expense: value));
  });
}
}

// dart format on
