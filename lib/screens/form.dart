import 'package:expensetracker/widgets/person_form.dart';
import 'package:flutter/material.dart';

// TODO: add widgets with enum
enum FormType {
  person,
}

class CustomForm extends StatelessWidget {
  const CustomForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: const PersonForm(),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            OutlinedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {},
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
