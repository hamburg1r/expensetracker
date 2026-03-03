import 'package:expensetracker/bloc/account_bloc.dart';
import 'package:expensetracker/bloc/debt_bloc.dart';
import 'package:expensetracker/bloc/index_cubit.dart';
import 'package:expensetracker/bloc/person_bloc.dart';

import 'package:expensetracker/domain/cache.dart';
import 'package:expensetracker/domain/event_bus/event.dart';
import 'package:expensetracker/domain/repository/account.dart';
import 'package:expensetracker/domain/repository/debt.dart';

import 'package:expensetracker/domain/usecase/person/getters/debt/get_person_debts_owed_usecase.dart';
import 'package:expensetracker/domain/usecase/person/getters/debt/get_person_debts_receivable_usecase.dart';
import 'package:expensetracker/domain/usecase/person/getters/get_all_people_usecase.dart';
import 'package:expensetracker/domain/usecase/person/getters/get_page_people_usecase.dart';
import 'package:expensetracker/domain/usecase/person/getters/get_person_by_id_usecase.dart';

import 'package:expensetracker/domain/usecase/person/mutations/create_person_usecase.dart';
import 'package:expensetracker/domain/usecase/person/mutations/delete_person_usecase.dart';
import 'package:expensetracker/domain/usecase/person/mutations/update_person_usecase.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

List<SingleChildWidget> blocProviders = [
  BlocProvider<IndexCubit>(
    create: (context) => IndexCubit(),
  ),
  BlocProvider<PersonBloc>(
    create: (context) => PersonBloc(
      Provider.of<GetAllPeopleUseCase>(context, listen: false),
      Provider.of<CreatePersonUseCase>(context, listen: false),
      Provider.of<UpdatePersonUseCase>(context, listen: false),
      Provider.of<DeletePersonUseCase>(context, listen: false),
      Provider.of<GetPagePeopleUseCase>(context, listen: false),
      Provider.of<GetPersonByIdUseCase>(context, listen: false),
      Provider.of<GetPersonDebtsOwedUseCase>(context, listen: false),
      Provider.of<GetPersonDebtsReceivableUseCase>(context, listen: false),
      Provider.of<Cache>(context, listen: false),
      Provider.of<EventBus>(context, listen: false),
    ),
    lazy: false,
  ),
  BlocProvider<DebtBloc>(
    create: (context) => DebtBloc(
      Provider.of<DebtRepo>(context, listen: false),
      Provider.of<EventBus>(context, listen: false),
      Provider.of<Cache>(context, listen: false), // Inject Cache
    ),
    lazy: false,
  ),
  BlocProvider<AccountBloc>(
    create: (context) => AccountBloc(
      Provider.of<AccountRepo>(context, listen: false),
      Provider.of<EventBus>(context, listen: false),
      Provider.of<Cache>(context, listen: false), // Inject Cache
    ),
    lazy: false,
  ),
];
