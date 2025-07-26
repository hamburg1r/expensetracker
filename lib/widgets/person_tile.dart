import 'package:expensetracker/cubit/person_cubit.dart';
import 'package:expensetracker/domain/model/person.dart';
import 'package:expensetracker/widgets/menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PersonTile extends StatelessWidget {
  final Person person;
  const PersonTile({
    required this.person,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PersonCubit, PersonState>(
      builder: (context, state) {
        return ListTile(
          leading: Icon(Icons.person),
          title: Text(person.name),
          subtitle: Text(person.number.toString()),
          trailing: CustomMenu(
            items: {
              'Delete': () {
                context.read<PersonCubit>().remove(person.id);
              },
            },
          ),
        );
      },
    );
  }
}
