import 'package:expensetracker/screens/form.dart';
import 'package:flutter/material.dart';

class _PersonControllers {
  TextEditingController name = TextEditingController();
  TextEditingController number = TextEditingController();
  dispose() {
    name.dispose();
    number.dispose();
  }
}

class PersonForm extends StatefulWidget implements CustomFormWidget {
  final _PersonControllers _controllers = _PersonControllers();
  PersonForm({
    super.key,
  });

  @override
  void save() {
    final List<String> name = _controllers.name.text.split(' ');
    print(name);
    if (name.length > 2) print(name.getRange(1, name.length - 1).join(' '));
    print(_controllers.number);
  }

  @override
  void cancel() {}

  @override
  State<PersonForm> createState() => _PersonFormState();
}

class _PersonFormState extends State<PersonForm> {
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    widget._controllers.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          spacing: 8.0,
          children: <Widget>[
            TextFormField(
              controller: widget._controllers.name,
              validator: (String? value) {
                if (value?.isEmpty ?? true) return 'Name cannot be empty';
                return null;
              },
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Name',
              ),
            ),
            TextFormField(
              controller: widget._controllers.number,
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
            ),
          ],
        ),
      ),
    );
  }
}
