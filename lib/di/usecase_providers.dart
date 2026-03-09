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

import 'package:expensetracker/domain/usecase/person/getters/get_all_people_usecase.dart';
import 'package:expensetracker/domain/usecase/person/getters/get_page_people_usecase.dart';
import 'package:expensetracker/domain/usecase/person/getters/get_person_by_id_usecase.dart';

import 'package:expensetracker/domain/usecase/person/mutations/create_person_usecase.dart';
import 'package:expensetracker/domain/usecase/person/mutations/delete_person_usecase.dart';
import 'package:expensetracker/domain/usecase/person/mutations/update_person_usecase.dart';


import 'package:expensetracker/domain/usecase/unaccounted_money/mutations/create_unaccountedmoney_usecase.dart';
import 'package:expensetracker/domain/usecase/unaccounted_money/mutations/delete_unaccountedmoney_usecase.dart';
import 'package:expensetracker/domain/usecase/unaccounted_money/mutations/update_unaccountedmoney_usecase.dart';

import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

List<SingleChildWidget> useCaseProviders = [
  Provider<GetAllPeopleUseCase>(
    create: (context) => GetAllPeopleUseCase(
      Provider.of<PersonRepo>(context, listen: false),
    ),
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
    create: (context) => GetPagePeopleUseCase(
      Provider.of<PersonRepo>(context, listen: false),
    ),
  ),
  Provider<GetPersonByIdUseCase>(
    create: (context) => GetPersonByIdUseCase(
      Provider.of<PersonRepo>(context, listen: false),
    ),
  ),

  Provider<DeletePersonUseCase>(
    create: (context) => DeletePersonUseCase(
      Provider.of<PersonRepo>(context, listen: false),
      Provider.of<EventBus>(context, listen: false),
      Provider.of<DebtRepo>(context, listen: false),
      Provider.of<ExpenseRepo>(context, listen: false),
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
      Provider.of<PersonRepo>(context, listen: false),
      Provider.of<EventBus>(context, listen: false),
    ),
  ),
  Provider<UpdateDebtUseCase>(
    create: (context) => UpdateDebtUseCase(
      Provider.of<DebtRepo>(context, listen: false),
      Provider.of<PersonRepo>(context, listen: false),
      Provider.of<EventBus>(context, listen: false),
    ),
  ),
  Provider<GetPageDebtUseCase>(
    create: (context) => GetPageDebtUseCase(
      Provider.of<DebtRepo>(context, listen: false),
    ),
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
    create: (context) => GetAllDebtUseCase(
      Provider.of<DebtRepo>(context, listen: false),
    ),
  ),
  Provider<GetDebtByIdUseCase>(
    create: (context) => GetDebtByIdUseCase(
      Provider.of<DebtRepo>(context, listen: false),
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
