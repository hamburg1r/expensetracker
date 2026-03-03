import 'package:expensetracker/domain/event_bus/event.dart';

import 'package:expensetracker/domain/repository/account.dart';
import 'package:expensetracker/domain/repository/debt.dart';
import 'package:expensetracker/domain/repository/expense.dart';
import 'package:expensetracker/domain/repository/person.dart';
import 'package:expensetracker/domain/repository/unaccountedmoney.dart';

import 'package:expensetracker/domain/usecase/person/getters/debt/get_person_debts_owed_usecase.dart';
import 'package:expensetracker/domain/usecase/person/getters/debt/get_person_debts_receivable_usecase.dart';
import 'package:expensetracker/domain/usecase/person/getters/get_all_people_usecase.dart';
import 'package:expensetracker/domain/usecase/person/getters/get_page_people_usecase.dart';
import 'package:expensetracker/domain/usecase/person/getters/get_person_by_id_usecase.dart';

import 'package:expensetracker/domain/usecase/person/mutations/create_person_usecase.dart';
import 'package:expensetracker/domain/usecase/person/mutations/debt/add_debt_owed_to_person_usecase.dart';
import 'package:expensetracker/domain/usecase/person/mutations/debt/add_debt_receivable_to_person_usecase.dart';
import 'package:expensetracker/domain/usecase/person/mutations/debt/remove_debt_owed_from_person_usecase.dart';
import 'package:expensetracker/domain/usecase/person/mutations/debt/remove_debt_receivable_from_person_usecase.dart';
import 'package:expensetracker/domain/usecase/person/mutations/delete_person_usecase.dart';
import 'package:expensetracker/domain/usecase/person/mutations/expense/add_participation_to_person_usecase.dart';
import 'package:expensetracker/domain/usecase/person/mutations/expense/add_transaction_to_person_usecase.dart';
import 'package:expensetracker/domain/usecase/person/mutations/expense/remove_participation_from_person_usecase.dart';
import 'package:expensetracker/domain/usecase/person/mutations/expense/remove_transaction_from_person_usecase.dart';
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
  Provider<GetPersonDebtsOwedUseCase>(
    create: (context) => GetPersonDebtsOwedUseCase(
      Provider.of<PersonRepo>(context, listen: false),
      Provider.of<DebtRepo>(context, listen: false),
    ),
  ),
  Provider<GetPersonDebtsReceivableUseCase>(
    create: (context) => GetPersonDebtsReceivableUseCase(
      Provider.of<PersonRepo>(context, listen: false),
      Provider.of<DebtRepo>(context, listen: false),
    ),
  ),

  Provider<AddDebtOwedToPersonUseCase>(
    create: (context) => AddDebtOwedToPersonUseCase(
      Provider.of<PersonRepo>(context, listen: false),
      Provider.of<EventBus>(context, listen: false),
    ),
  ),
  Provider<AddDebtReceivableToPersonUseCase>(
    create: (context) => AddDebtReceivableToPersonUseCase(
      Provider.of<PersonRepo>(context, listen: false),
      Provider.of<EventBus>(context, listen: false),
    ),
  ),
  Provider<RemoveDebtOwedFromPersonUseCase>(
    create: (context) => RemoveDebtOwedFromPersonUseCase(
      Provider.of<PersonRepo>(context, listen: false),
      Provider.of<EventBus>(context, listen: false),
    ),
  ),
  Provider<RemoveDebtReceivableFromPersonUseCase>(
    create: (context) => RemoveDebtReceivableFromPersonUseCase(
      Provider.of<PersonRepo>(context, listen: false),
      Provider.of<EventBus>(context, listen: false),
    ),
  ),
  Provider<AddTransactionToPersonUseCase>(
    create: (context) => AddTransactionToPersonUseCase(
      Provider.of<PersonRepo>(context, listen: false),
      Provider.of<EventBus>(context, listen: false),
    ),
  ),
  Provider<RemoveTransactionFromPersonUseCase>(
    create: (context) => RemoveTransactionFromPersonUseCase(
      Provider.of<PersonRepo>(context, listen: false),
      Provider.of<EventBus>(context, listen: false),
    ),
  ),
  Provider<AddParticipationToPersonUseCase>(
    create: (context) => AddParticipationToPersonUseCase(
      Provider.of<PersonRepo>(context, listen: false),
      Provider.of<EventBus>(context, listen: false),
    ),
  ),
  Provider<RemoveParticipationFromPersonUseCase>(
    create: (context) => RemoveParticipationFromPersonUseCase(
      Provider.of<PersonRepo>(context, listen: false),
      Provider.of<EventBus>(context, listen: false),
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
