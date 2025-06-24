import 'package:expensetracker/model/entities/expenses.dart';
import 'package:isar/isar.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'person.g.dart';

@collection
class PersonModel {
  Id id = Isar.autoIncrement;

  String firstName;
  String? middleName;
  String? lastName;
  int number;
  @Backlink(to: 'payerId')
  final paid = IsarLinks<TransactionModel>();
  @Backlink(to: 'participantIds')
  final participation = IsarLinks<TransactionModel>();
  final debts = IsarLinks<DebtModel>();

  PersonModel({
    required this.firstName,
    this.middleName,
    this.lastName,
    required this.number,
  });
}
