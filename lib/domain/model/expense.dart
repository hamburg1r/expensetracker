import 'package:expensetracker/domain/model/account.dart';
import 'package:expensetracker/domain/model/category.dart';
import 'package:expensetracker/domain/model/debt.dart';
import 'package:expensetracker/domain/model/person.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:expensetracker/domain/model/base_entity.dart'; // Add this import

part 'expense.freezed.dart';

@Freezed()
abstract class Expense with _$Expense implements BaseEntity { // Corrected order
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
    Category? category,
    required Account account,
  }) = _Expense;
}
