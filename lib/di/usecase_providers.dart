import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import 'package:expensetracker/domain/repository/person.dart';
import 'package:expensetracker/domain/repository/debt.dart';
import 'package:expensetracker/domain/repository/expense.dart';
import 'package:expensetracker/domain/event_bus/event_bus.dart';

import 'package:expensetracker/domain/usecase/add_debt_to_person_usecase.dart';
import 'package:expensetracker/domain/usecase/remove_debt_from_person_usecase.dart';
import 'package:expensetracker/domain/usecase/add_transaction_to_person_usecase.dart';
import 'package:expensetracker/domain/usecase/remove_transaction_from_person_usecase.dart';
import 'package:expensetracker/domain/usecase/add_participation_to_person_usecase.dart';
import 'package:expensetracker/domain/usecase/remove_participation_from_person_usecase.dart';

List<SingleChildWidget> useCaseProviders = [
  Provider<AddDebtToPersonUseCase>(
    create: (context) => AddDebtToPersonUseCase(
      Provider.of<PersonRepo>(context, listen: false),
      Provider.of<EventBus>(context, listen: false),
    ),
  ),
  Provider<RemoveDebtFromPersonUseCase>(
    create: (context) => RemoveDebtFromPersonUseCase(
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
];
