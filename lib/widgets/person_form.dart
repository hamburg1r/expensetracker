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
  final Person? person;

  PersonForm({
    this.person,
    super.key,
  });

  @override
  bool save(BuildContext context) {
    print('Saving Person form');
    final bool isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) return false;

    var person = Person(
      id: this.person?.id ?? 0,
      name: _controllers.name.text,
      phoneNumber: _controllers.number.text,
    );
    BlocProvider.of<PersonCubit>(context).create(person);
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
    if (widget.person != null) {
      widget._controllers
        ..name.text = widget.person?.name ?? ''
        ..number.text = widget.person?.phoneNumber.toString() ?? '';
    }
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
