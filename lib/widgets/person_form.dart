import 'package:expensetracker/cubit/person_cubit.dart';
import 'package:expensetracker/domain/model/person.dart';
import 'package:expensetracker/screens/form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class _PersonControllers {
  TextEditingController name = TextEditingController();
  TextEditingController number = TextEditingController();
  dispose() {
    name.dispose();
    number.dispose();
  }
}

class PersonForm extends StatefulWidget implements CustomFormWidget {
  final _formKey = GlobalKey<FormState>();
  final _PersonControllers _controllers = _PersonControllers();

  PersonForm({
    super.key,
  });

  @override
  bool save(BuildContext context) {
    print('Saving Person form');
    final List<String> name = _controllers.name.text.split(' ');
    final bool isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) return false;

    String? middleName;
    String? lastName;

    if (name.length > 1) {
      lastName = name.last;
      if (name.length > 2) {
        middleName = name.getRange(1, name.length - 1).join(' ');
      }
    }
    var person = Person(
      firstName: name.first,
      middleName: middleName,
      lastName: lastName,
      number: int.parse(_controllers.number.text),
    );
    BlocProvider.of<PersonCubit>(context).add(person);
    print(person);

    return true;
  }

  @override
  void cancel(BuildContext context) {
    print('Closing Person form');
  }

  @override
  State<PersonForm> createState() => _PersonFormState();
}

class _PersonFormState extends State<PersonForm> {
  @override
  void dispose() {
    widget._controllers.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget._formKey,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          spacing: 8.0,
          children: <Widget>[
            TextFormField(
              controller: widget._controllers.name,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (String? value) {
                if (value?.isEmpty ?? true) return 'Name cannot be empty';
                return null;
              },
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Name',
              ),
              textInputAction: TextInputAction.next,
            ),
            TextFormField(
              controller: widget._controllers.number,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (String? value) {
                if (value?.isEmpty ?? false) return "Number can not be empty";
                int? num = int.tryParse(value!);
                if (num == null) return "Enter number only";
                return null;
              },
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Number',
              ),
              textInputAction: TextInputAction.done,
            ),
          ],
        ),
      ),
    );
  }
}
