import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import 'package:expensetracker/bloc/person_bloc.dart';
import 'package:expensetracker/bloc/index_cubit.dart';
import 'package:expensetracker/domain/repository/person.dart';
import 'package:expensetracker/domain/repository/debt.dart';
import 'package:expensetracker/domain/cache.dart';
import 'package:expensetracker/domain/event_bus/event_bus.dart';

List<SingleChildWidget> blocProviders = [
  BlocProvider<IndexCubit>(
    create: (context) => IndexCubit(),
  ),
  BlocProvider<PersonBloc>(
    create: (context) => PersonBloc(
      Provider.of<PersonRepo>(context, listen: false),
      Provider.of<DebtRepo>(context, listen: false),
      Provider.of<Cache>(context, listen: false),
      Provider.of<EventBus>(context, listen: false),
    ),
    lazy: false,
  ),
];
