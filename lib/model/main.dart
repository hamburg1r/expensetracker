import 'package:expensetracker/model/entities/budget.dart';
import 'package:expensetracker/model/entities/category.dart';
import 'package:expensetracker/model/entities/debt.dart';
import 'package:expensetracker/model/entities/expenses.dart';
import 'package:expensetracker/model/entities/person.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'main.g.dart';

@riverpod
Future<Isar> expenseDatabase(Ref ref) async {
  final dir = await getApplicationDocumentsDirectory();
  final isar = await Isar.open(
    [
      PersonSchema,
      ExpenseSchema,
      CategorySchema,
    ],
    directory: dir.path,
  );
  return isar;
}

@riverpod
Future<Isar> debtDatabase(Ref ref) async {
  final dir = await getApplicationDocumentsDirectory();
  final isar = await Isar.open(
    [
      PersonSchema,
      DebtSchema,
    ],
    directory: dir.path,
  );
  return isar;
}

@riverpod
Future<Isar> categoryDatabase(Ref ref) async {
  final dir = await getApplicationDocumentsDirectory();
  final isar = await Isar.open(
    [
      CategorySchema,
      BudgetSchema,
    ],
    directory: dir.path,
  );
  return isar;
}
