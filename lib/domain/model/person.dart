import 'package:expensetracker/domain/model/debt.dart';
import 'package:expensetracker/domain/model/expense.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:expensetracker/domain/model/base_entity.dart';

part 'person.freezed.dart';

@Freezed()
abstract class Person with _$Person implements BaseEntity {
  const factory Person({
    @Default(0) int id,
    required String name,
    // TODO: Use E.164 for saving to database
    // Use libphonenumber_plugin? and phone_form_field
    required String phoneNumber,
    @Default([]) List<Debt> debtsOwed,
    @Default([]) List<Debt> debtsReceivable,
    @Default([]) List<Expense> transactions,
    @Default([]) List<Expense> participations,
    @Default(0) int version,
  }) = _Person;
}
