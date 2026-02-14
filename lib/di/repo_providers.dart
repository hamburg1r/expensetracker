import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import 'package:expensetracker/domain/repository/person.dart';
import 'package:expensetracker/domain/repository/debt.dart';
import 'package:expensetracker/domain/repository/expense.dart';
import 'package:expensetracker/domain/repository/account.dart';

// --- Mock Implementations ---
import 'package:expensetracker/domain/repository/mock/person.dart';
import 'package:expensetracker/domain/repository/mock/debt.dart';
import 'package:expensetracker/domain/repository/mock/expense.dart';
import 'package:expensetracker/domain/repository/mock/account.dart';
import 'package:expensetracker/domain/repository/unaccountedmoney.dart';
import 'package:expensetracker/domain/repository/mock/unaccounted_entry.dart';

List<SingleChildWidget> repoProviders = [
  Provider<PersonRepo>(create: (_) => MockPersonRepo()),
  Provider<DebtRepo>(create: (_) => MockDebtRepo()),
  Provider<ExpenseRepo>(create: (_) => MockExpenseRepo()),
  Provider<AccountRepo>(create: (_) => MockAccountRepo()),
  Provider<UnaccountedMoneyRepo>(create: (_) => MockUnaccountedMoneyRepo()),
];
