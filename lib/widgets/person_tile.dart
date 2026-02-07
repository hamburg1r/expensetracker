import 'package:expensetracker/cubit/person_bloc.dart';
import 'package:expensetracker/domain/model/person.dart';
import 'package:expensetracker/screens/form.dart';
import 'package:expensetracker/widgets/menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PersonTile extends StatelessWidget {
  final Person? person;
  const PersonTile({
    required this.person,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    if (person != null) {
      return ListTile(
        leading: Icon(Icons.person),
        title: Text(person!.name),
        subtitle: Text(person!.phoneNumber.toString()),
        trailing: CustomMenu(
          items: {
            'Edit': () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (BuildContext ctx) {
                    return CustomForm(
                      type: FormType.person,
                      providerContext: context,
                      person: person,
                    );
                  },
                ),
              );
            },
            'Delete': () {
              context.read<PersonBloc>().add(RemovePersonEvent(person!.id));
            },
          },
        ),
      );
    }
    return ListTile(
      title: Text("id contains null"),
    );
  }
}
