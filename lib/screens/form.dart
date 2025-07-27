import 'package:expensetracker/domain/model/person.dart';
import 'package:expensetracker/widgets/person_form.dart';
import 'package:flutter/material.dart';

abstract class CustomFormWidget {
  bool save(BuildContext context);
  void cancel(BuildContext context);
}

enum FormType {
  person,
}

class CustomForm extends StatelessWidget {
  final FormType type;
  final BuildContext providerContext;
  final Person? person;
  const CustomForm({
    required this.providerContext,
    required this.type,
    this.person,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    CustomFormWidget body;

    switch (type) {
      case FormType.person:
        body = PersonForm(person: person);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(type.name),
      ),
      body: (body as Widget),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            OutlinedButton(
              onPressed: () {
                body.cancel(providerContext);
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                if (!body.save(providerContext)) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Error saving ${type.name}',
                      ),
                    ),
                  );
                  return;
                }
                Navigator.of(context).pop();
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
