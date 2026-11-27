import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:expensetracker/bloc/person_bloc.dart';
import 'package:expensetracker/domain/model/person.dart';

class PersonListScreen extends StatefulWidget {
  const PersonListScreen({super.key});

  @override
  State<PersonListScreen> createState() => _PersonListScreenState();
}

class _PersonListScreenState extends State<PersonListScreen> {
  final _scrollController = ScrollController();
  final _scrollThreshold = 200.0; // Distance from the end to trigger loading

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    context.read<PersonBloc>().add(LoadAllPeopleEvent()); // Initial load
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lazy Person List'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<PersonBloc>().add(LoadAllPeopleEvent());
            },
          ),
        ],
      ),
      body: BlocBuilder<PersonBloc, PersonState>(
        builder: (context, state) {
          if (state is PersonInitial) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is PersonLoading && state is! PersonLoaded) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is PersonError) {
            return Center(child: Text('Error: ${state.message}'));
          }
          if (state is PersonLoaded) {
            final people = state.people.values.toList();
            if (people.isEmpty) {
              return const Center(child: Text('No people found.'));
            }
            return ListView.builder(
              itemCount: people.length + (state is PersonLoading ? 1 : 0),
              controller: _scrollController,
              itemBuilder: (context, index) {
                return index >= people.length
                    ? const Center(child: CircularProgressIndicator())
                    : PersonListItem(person: people[index]);
              },
            );
          }
          return const Center(child: Text('Unknown State'));
        },
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    if (maxScroll - currentScroll <= _scrollThreshold) {
      // Trigger loading of next page
      // For this prototype, we'll just reload all.
      // In a real app, you'd dispatch GetPagePeopleEvent with page/limit.
      // context.read<PersonBloc>().add(GetPagePeopleEvent(nextPage, limit));
      // For simplicity, this example just reloads all for now.
      // You would implement actual pagination logic here.
      // context.read<PersonBloc>().add(LoadAllPeopleEvent());
    }
  }
}

class PersonListItem extends StatelessWidget {
  final Person person;

  const PersonListItem({super.key, required this.person});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: ListTile(
        title: Text(person.name),
        subtitle: Text('ID: ${person.id}'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                // Simulate updating a person
                final updatedPerson = person.copyWith(
                  name: '${person.name} (Updated ${DateTime.now().second})',
                );
                context.read<PersonBloc>().add(
                  UpdatePersonEvent(updatedPerson),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                // Simulate deleting a person
                context.read<PersonBloc>().add(DeletePersonEvent(person));
              },
            ),
          ],
        ),
        onTap: () {
          // Handle tap, e.g., navigate to person details
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Tapped on ${person.name}')),
          );
        },
      ),
    );
  }
}

