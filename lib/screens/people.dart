import 'package:expensetracker/bloc/person_bloc.dart';
import 'package:expensetracker/domain/cache.dart';
import 'package:expensetracker/domain/event_bus/event.dart';
import 'package:expensetracker/domain/model/person.dart';
import 'package:expensetracker/domain/usecase/person/getters/debt/get_person_debts_owed_usecase.dart';
import 'package:expensetracker/domain/usecase/person/getters/debt/get_person_debts_receivable_usecase.dart';
// Removed unused PersonRepo and DebtRepo imports
import 'package:expensetracker/domain/usecase/person/mutations/delete_person_usecase.dart'; // Path changed

// New use cases for PersonBloc
import 'package:expensetracker/domain/usecase/person/getters/get_all_people_usecase.dart';
import 'package:expensetracker/domain/usecase/person/mutations/create_person_usecase.dart';
import 'package:expensetracker/domain/usecase/person/mutations/update_person_usecase.dart';
import 'package:expensetracker/domain/usecase/person/getters/get_page_people_usecase.dart';
import 'package:expensetracker/domain/usecase/person/getters/get_person_by_id_usecase.dart';
import 'package:expensetracker/screens/form.dart';
import 'package:expensetracker/widgets/person_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class PeopleScreen extends StatelessWidget {
  final AppBar Function(Widget, [List<Widget>]) appBar;
  const PeopleScreen(
    this.appBar, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider<PersonBloc>(
      create: (ctx) =>
          PersonBloc(
            Provider.of<GetAllPeopleUseCase>(context),
            Provider.of<CreatePersonUseCase>(context),
            Provider.of<UpdatePersonUseCase>(context),
            Provider.of<DeletePersonUseCase>(context),
            Provider.of<GetPagePeopleUseCase>(context),
            Provider.of<GetPersonByIdUseCase>(context),
            Provider.of<GetPersonDebtsOwedUseCase>(context),
            Provider.of<GetPersonDebtsReceivableUseCase>(context),
            Provider.of<Cache>(context),
            Provider.of<EventBus>(context),
          )..add(
            LoadAllPeopleEvent(),
          ), // Dispatch LoadAllPeopleEvent when bloc is created
      child: Scaffold(
        appBar: appBar(
          const Text('People'),
        ),
        body: BlocBuilder<PersonBloc, PersonState>(
          builder: (BuildContext context, PersonState state) {
            if (state is PersonLoading || state is PersonInitial) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is PersonLoaded) {
              List<Person> people = state.people.values.toList(growable: false);
              if (people.isNotEmpty) {
                return ListView.builder(
                  itemCount: people.length, // Corrected to use people.length
                  itemBuilder: (BuildContext context, int index) {
                    return PersonTile(person: people[index]);
                  },
                );
              }
              return Center(
                child: FittedBox(
                  child: Text(
                    'Press + to add contacts',
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),
                ),
              );
            } else {
              return const Center(
                child: Text("Error loading database"),
              );
            }
          },
        ),
        floatingActionButton: BlocBuilder<PersonBloc, PersonState>(
          builder: (BuildContext providerContext, _) {
            return FloatingActionButton(
              onPressed: () {
                Navigator.of(
                  context,
                ).push(
                  MaterialPageRoute(
                    builder: (BuildContext ctx) {
                      return CustomForm(
                        type: FormType.person,
                        providerContext: providerContext,
                      );
                    },
                  ),
                );
              },
              child: const Icon(Icons.add),
            );
          },
        ),
      ),
    );
  }
}
