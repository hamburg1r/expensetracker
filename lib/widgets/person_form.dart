import 'package:flutter/material.dart';

class _PersonControllers {
  TextEditingController name = TextEditingController();
  TextEditingController number = TextEditingController();
  dispose() {
    name.dispose();
    number.dispose();
  }
}

class PersonForm extends StatefulWidget {
  const PersonForm({
    super.key,
  });

  @override
  State<PersonForm> createState() => _PersonFormState();
}

class _PersonFormState extends State<PersonForm> {
  final _formKey = GlobalKey<FormState>();

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
