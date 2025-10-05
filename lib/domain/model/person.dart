import 'package:expensetracker/domain/model/debt.dart';
import 'package:expensetracker/domain/model/expense.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'person.freezed.dart';

@Freezed()
abstract class Person with _$Person {
  const factory Person({
    @Default(0) int id,
    required String name,
    required String phoneNumber,
    @Default([]) List<Debt> debtsOwed,
    @Default([]) List<Debt> debtsReceivable,
    @Default([]) List<Expense> transactions,
    @Default([]) List<Expense> participations,
  }) = _Person;
}
