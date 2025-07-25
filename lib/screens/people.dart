import 'package:expensetracker/cubit/person_cubit.dart';
import 'package:expensetracker/data/repository/person.dart';
import 'package:expensetracker/domain/model/person.dart';
import 'package:expensetracker/screens/form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:objectbox/objectbox.dart';

class PeopleScreen extends StatelessWidget {
  final AppBar Function(Widget, [List<Widget>]) appBar;
  final Store store;
  const PeopleScreen(
    this.appBar,
    this.store, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider<PersonCubit>(
      create: (ctx) => PersonCubit(OBPersonRepo(store)),
      child: Scaffold(
        appBar: appBar(
          const Text('People'),
        ),
        body: BlocBuilder<PersonCubit, PersonState>(
          builder: (BuildContext context, PersonState state) {
            if (state is PersonLoading || state is PersonInitial) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is PersonLoaded) {
              List<Person> people = state.people;
              if (people.isNotEmpty) {
                return ListView.builder(
                  itemCount: people.length,
                  itemBuilder: (BuildContext context, int index) {
                    Person person = people[index];
                    return ListTile(
                      title: Text(index.toString()),
                    );
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
        floatingActionButton: BlocBuilder<PersonCubit, PersonState>(
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
