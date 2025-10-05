import 'package:expensetracker/domain/model/debt.dart';
import 'package:expensetracker/domain/model/person.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'expense.freezed.dart';

@Freezed()
abstract class Expense with _$Expense {
  const factory Expense({
    @Default(0) int id,
    required String name,
    @Default("") String description,
    @Default([]) List<String> tags,
    required DateTime date,
    required double amount,
    Person? payer,
    required List<Person> participation,
    @Default([]) List<Debt> debts,
  }) = _Expense;
}
