import 'package:expensetracker/domain/usecase/debt/getters/get_all_debt_usecase.dart';
import 'package:expensetracker/domain/usecase/debt/getters/get_debt_by_id_usecase.dart';
import 'package:expensetracker/domain/event_bus/event.dart';

import 'package:expensetracker/domain/repository/account.dart';
import 'package:expensetracker/domain/repository/debt.dart';
import 'package:expensetracker/domain/repository/expense.dart';
import 'package:expensetracker/domain/repository/person.dart';
import 'package:expensetracker/domain/repository/unaccountedmoney.dart';

import 'package:expensetracker/domain/usecase/debt/mutations/create_debt_usecase.dart';
import 'package:expensetracker/domain/usecase/debt/mutations/delete_debt_usecase.dart';
import 'package:expensetracker/domain/usecase/debt/mutations/update_debt_usecase.dart';
import 'package:expensetracker/domain/usecase/debt/getters/get_page_debt_usecase.dart';
import 'package:expensetracker/domain/usecase/debt/getters/get_debts_by_creditor_id_usecase.dart';
import 'package:expensetracker/domain/usecase/debt/getters/get_debts_by_debtor_id_usecase.dart';

import 'package:expensetracker/domain/usecase/account/getters/get_all_accounts_usecase.dart';
import 'package:expensetracker/domain/usecase/account/getters/get_account_by_id_usecase.dart';
import 'package:expensetracker/domain/usecase/account/getters/get_page_accounts_usecase.dart';
import 'package:expensetracker/domain/usecase/account/mutations/create_account_usecase.dart';
import 'package:expensetracker/domain/usecase/account/mutations/update_account_usecase.dart';
import 'package:expensetracker/domain/usecase/account/mutations/delete_account_usecase.dart';

import 'package:expensetracker/domain/usecase/person/getters/get_all_people_usecase.dart';
import 'package:expensetracker/domain/usecase/person/getters/get_page_people_usecase.dart';
import 'package:expensetracker/domain/usecase/person/getters/get_person_by_id_usecase.dart';

import 'package:expensetracker/domain/usecase/person/mutations/create_person_usecase.dart';
import 'package:expensetracker/domain/usecase/person/mutations/delete_person_usecase.dart';
import 'package:expensetracker/domain/usecase/person/mutations/update_person_usecase.dart';
import 'package:expensetracker/domain/usecase/person/mutations/remove_debt_owed_from_person_usecase.dart';
import 'package:expensetracker/domain/usecase/person/mutations/remove_debt_receivable_from_person_usecase.dart';
import 'package:expensetracker/domain/usecase/person/mutations/add_debt_owed_to_person_usecase.dart';
import 'package:expensetracker/domain/usecase/person/mutations/add_debt_receivable_to_person_usecase.dart';

import 'package:expensetracker/domain/usecase/expense/getters/get_expense_by_id_usecase.dart';
import 'package:expensetracker/domain/usecase/expense/mutations/add_participation_to_expense_usecase.dart';
import 'package:expensetracker/domain/usecase/expense/mutations/remove_participation_from_expense_usecase.dart';
import 'package:expensetracker/domain/usecase/expense/mutations/delete_expense_usecase.dart';
import 'package:expensetracker/domain/usecase/expense/mutations/update_expense_usecase.dart';
import 'package:expensetracker/domain/usecase/expense/mutations/create_expense_usecase.dart';
import 'package:expensetracker/domain/usecase/expense/getters/get_all_expenses_usecase.dart';
import 'package:expensetracker/domain/usecase/expense/mutations/add_debt_to_expense_usecase.dart';
import 'package:expensetracker/domain/usecase/expense/mutations/remove_debt_from_expense_usecase.dart';

import 'package:expensetracker/domain/usecase/unaccounted_money/mutations/create_unaccountedmoney_usecase.dart';
import 'package:expensetracker/domain/usecase/unaccounted_money/mutations/delete_unaccountedmoney_usecase.dart';
import 'package:expensetracker/domain/usecase/unaccounted_money/mutations/update_unaccountedmoney_usecase.dart';

import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

List<SingleChildWidget> useCaseProviders = [
  Provider<GetAllPeopleUseCase>(
    create: (context) =>
        GetAllPeopleUseCase(Provider.of<PersonRepo>(context, listen: false)),
  ),
  Provider<CreatePersonUseCase>(
    create: (context) => CreatePersonUseCase(
      Provider.of<PersonRepo>(context, listen: false),
      Provider.of<EventBus>(context, listen: false),
    ),
  ),
  Provider<UpdatePersonUseCase>(
    create: (context) => UpdatePersonUseCase(
      Provider.of<PersonRepo>(context, listen: false),
      Provider.of<EventBus>(context, listen: false),
    ),
  ),
  Provider<GetPagePeopleUseCase>(
    create: (context) =>
        GetPagePeopleUseCase(Provider.of<PersonRepo>(context, listen: false)),
  ),
  Provider<GetPersonByIdUseCase>(
    create: (context) =>
        GetPersonByIdUseCase(Provider.of<PersonRepo>(context, listen: false)),
  ),

  Provider<DeletePersonUseCase>(
    create: (context) => DeletePersonUseCase(
      Provider.of<PersonRepo>(context, listen: false),
      Provider.of<EventBus>(context, listen: false),
      Provider.of<DebtRepo>(context, listen: false),
      Provider.of<ExpenseRepo>(context, listen: false),
    ),
  ),
  // New Person-Debt related providers
  Provider<RemoveDebtOwedFromPersonUseCase>(
    create: (context) => RemoveDebtOwedFromPersonUseCase(
      Provider.of<GetPersonByIdUseCase>(context, listen: false),
      Provider.of<UpdatePersonUseCase>(context, listen: false),
    ),
  ),
  Provider<RemoveDebtReceivableFromPersonUseCase>(
    create: (context) => RemoveDebtReceivableFromPersonUseCase(
      Provider.of<GetPersonByIdUseCase>(context, listen: false),
      Provider.of<UpdatePersonUseCase>(context, listen: false),
    ),
  ),
  // Providers for adding debts to person
  Provider<AddDebtOwedToPersonUseCase>(
    create: (context) => AddDebtOwedToPersonUseCase(
      Provider.of<GetPersonByIdUseCase>(context, listen: false),
      Provider.of<UpdatePersonUseCase>(context, listen: false),
    ),
  ),
  Provider<AddDebtReceivableToPersonUseCase>(
    create: (context) => AddDebtReceivableToPersonUseCase(
      Provider.of<GetPersonByIdUseCase>(context, listen: false),
      Provider.of<UpdatePersonUseCase>(context, listen: false),
    ),
  ),
  // Debt Use Cases
  Provider<CreateDebtUseCase>(
    create: (context) => CreateDebtUseCase(
      Provider.of<DebtRepo>(context, listen: false),
      Provider.of<PersonRepo>(context, listen: false),
      Provider.of<EventBus>(context, listen: false),
    ),
  ),
  Provider<DeleteDebtUseCase>(
    create: (context) => DeleteDebtUseCase(
      Provider.of<DebtRepo>(context, listen: false),
      Provider.of<EventBus>(context, listen: false),
      Provider.of<RemoveDebtOwedFromPersonUseCase>(context, listen: false),
      Provider.of<RemoveDebtReceivableFromPersonUseCase>(
        context,
        listen: false,
      ),
    ),
  ),
  Provider<UpdateDebtUseCase>(
    create: (context) => UpdateDebtUseCase(
      Provider.of<DebtRepo>(context, listen: false),
      Provider.of<EventBus>(context, listen: false),
      Provider.of<RemoveDebtOwedFromPersonUseCase>(context, listen: false),
      Provider.of<AddDebtOwedToPersonUseCase>(context, listen: false),
      Provider.of<RemoveDebtReceivableFromPersonUseCase>(
        context,
        listen: false,
      ),
      Provider.of<AddDebtReceivableToPersonUseCase>(context, listen: false),
    ),
  ),
  Provider<GetPageDebtUseCase>(
    create: (context) =>
        GetPageDebtUseCase(Provider.of<DebtRepo>(context, listen: false)),
  ),
  Provider<GetDebtsByCreditorIdUseCase>(
    create: (context) => GetDebtsByCreditorIdUseCase(
      Provider.of<DebtRepo>(context, listen: false),
    ),
  ),
  Provider<GetDebtsByDebtorIdUseCase>(
    create: (context) => GetDebtsByDebtorIdUseCase(
      Provider.of<DebtRepo>(context, listen: false),
    ),
  ),
  Provider<GetAllDebtUseCase>(
    create: (context) =>
        GetAllDebtUseCase(Provider.of<DebtRepo>(context, listen: false)),
  ),
  Provider<GetDebtByIdUseCase>(
    create: (context) =>
        GetDebtByIdUseCase(Provider.of<DebtRepo>(context, listen: false)),
  ),

  // Account Use Cases
  Provider<GetAllAccountsUseCase>(
    create: (context) =>
        GetAllAccountsUseCase(Provider.of<AccountRepo>(context, listen: false)),
  ),
  Provider<GetAccountByIdUseCase>(
    create: (context) =>
        GetAccountByIdUseCase(Provider.of<AccountRepo>(context, listen: false)),
  ),
  Provider<GetPageAccountsUseCase>(
    create: (context) => GetPageAccountsUseCase(
      Provider.of<AccountRepo>(context, listen: false),
    ),
  ),
  Provider<CreateAccountUseCase>(
    create: (context) => CreateAccountUseCase(
      Provider.of<AccountRepo>(context, listen: false),
      Provider.of<EventBus>(context, listen: false),
    ),
  ),
  Provider<UpdateAccountUseCase>(
    create: (context) => UpdateAccountUseCase(
      Provider.of<AccountRepo>(context, listen: false),
      Provider.of<EventBus>(context, listen: false),
    ),
  ),
  Provider<DeleteAccountUseCase>(
    create: (context) => DeleteAccountUseCase(
      Provider.of<AccountRepo>(context, listen: false),
      Provider.of<EventBus>(context, listen: false),
    ),
  ),

  // Expense Use Cases
  Provider<GetAllExpensesUseCase>(
    create: (context) =>
        GetAllExpensesUseCase(Provider.of<ExpenseRepo>(context, listen: false)),
  ),
  Provider<GetExpenseByIdUseCase>(
    create: (context) =>
        GetExpenseByIdUseCase(Provider.of<ExpenseRepo>(context, listen: false)),
  ),
  Provider<CreateExpenseUseCase>(
    create: (context) => CreateExpenseUseCase(
      Provider.of<ExpenseRepo>(context, listen: false),
      Provider.of<EventBus>(context, listen: false),
    ),
  ),
  Provider<UpdateExpenseUseCase>(
    create: (context) => UpdateExpenseUseCase(
      Provider.of<ExpenseRepo>(context, listen: false),
      Provider.of<EventBus>(context, listen: false),
    ),
  ),
  Provider<AddParticipationToExpenseUseCase>(
    create: (context) => AddParticipationToExpenseUseCase(
      Provider.of<UpdateExpenseUseCase>(context, listen: false),
      Provider.of<UpdatePersonUseCase>(context, listen: false),
      Provider.of<EventBus>(context, listen: false),
    ),
  ),
  Provider<RemoveParticipationFromExpenseUseCase>(
    create: (context) => RemoveParticipationFromExpenseUseCase(
      Provider.of<UpdateExpenseUseCase>(context, listen: false),
      Provider.of<UpdatePersonUseCase>(context, listen: false),
      Provider.of<EventBus>(context, listen: false),
    ),
  ),
  Provider<AddDebtToExpenseUseCase>(
    create: (context) => AddDebtToExpenseUseCase(
      Provider.of<UpdateExpenseUseCase>(context, listen: false),
      Provider.of<UpdateDebtUseCase>(context, listen: false),
      Provider.of<EventBus>(context, listen: false),
    ),
  ),
  Provider<RemoveDebtFromExpenseUseCase>(
    create: (context) => RemoveDebtFromExpenseUseCase(
      Provider.of<UpdateExpenseUseCase>(context, listen: false),
      Provider.of<UpdateDebtUseCase>(context, listen: false),
      Provider.of<EventBus>(context, listen: false),
    ),
  ),
  Provider<DeleteExpenseUseCase>(
    create: (context) => DeleteExpenseUseCase(
      Provider.of<ExpenseRepo>(context, listen: false),
      Provider.of<PersonRepo>(context, listen: false),
      Provider.of<EventBus>(context, listen: false),
      Provider.of<GetExpenseByIdUseCase>(context, listen: false),
      Provider.of<DeleteDebtUseCase>(context, listen: false),
      Provider.of<RemoveParticipationFromExpenseUseCase>(
        context,
        listen: false,
      ),
    ),
  ),

  // Unaccounted Money Use Cases
  Provider<CreateUnaccountedMoneyUseCase>(
    create: (context) => CreateUnaccountedMoneyUseCase(
      Provider.of<UnaccountedMoneyRepo>(context, listen: false),
      Provider.of<EventBus>(context, listen: false),
      Provider.of<AccountRepo>(context, listen: false),
    ),
  ),
  Provider<UpdateUnaccountedMoneyUseCase>(
    create: (context) => UpdateUnaccountedMoneyUseCase(
      Provider.of<UnaccountedMoneyRepo>(context, listen: false),
      Provider.of<EventBus>(context, listen: false),
      Provider.of<AccountRepo>(context, listen: false),
    ),
  ),
  Provider<DeleteUnaccountedMoneyUseCase>(
    create: (context) => DeleteUnaccountedMoneyUseCase(
      Provider.of<UnaccountedMoneyRepo>(context, listen: false),
      Provider.of<EventBus>(context, listen: false),
      Provider.of<AccountRepo>(context, listen: false),
    ),
  ),
];
