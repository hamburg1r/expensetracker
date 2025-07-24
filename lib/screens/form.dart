import 'package:expensetracker/widgets/person_form.dart';
import 'package:flutter/material.dart';

abstract class CustomFormWidget {
  void save();
  void cancel();
}

enum FormType {
  person,
}

class CustomForm extends StatelessWidget {
  final FormType type;
  const CustomForm({
    required this.type,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    CustomFormWidget body;

    switch (type) {
      case FormType.person:
        body = PersonForm();
    }

    return Scaffold(
      appBar: AppBar(),
      body: (body as Widget),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            OutlinedButton(
              onPressed: () {
                body.cancel();
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                body.save();
                // Navigator.of(context).pop();
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
