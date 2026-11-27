import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import 'package:expensetracker/domain/repository/person.dart';
import 'package:expensetracker/domain/repository/debt.dart';
import 'package:expensetracker/domain/repository/expense.dart';
import 'package:expensetracker/domain/repository/account.dart';

// --- Mock Implementations ---
import 'package:expensetracker/data/repository/mock/person_mock.dart';
import 'package:expensetracker/data/repository/mock/debt_mock.dart';
import 'package:expensetracker/data/repository/mock/expense_mock.dart';
import 'package:expensetracker/data/repository/mock/account_mock.dart';
import 'package:expensetracker/domain/repository/unaccountedmoney.dart';
import 'package:expensetracker/data/repository/mock/unaccountedmoney_mock.dart'; // Corrected path and name

List<SingleChildWidget> repoProviders = [
  Provider<PersonRepo>(create: (_) => MockPersonRepository()),
  Provider<AccountRepo>(
      create: (context) => MockAccountRepository()),
  Provider<ExpenseRepo>(
      create: (context) => MockExpenseRepository()),
  Provider<DebtRepo>(
      create: (context) => MockDebtRepository()),
  Provider<UnaccountedMoneyRepo>(create: (_) => MockUnaccountedMoneyRepository()),
];
