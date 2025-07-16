import 'package:flutter/material.dart';
import 'package:objectbox/objectbox.dart';

class OverviewScreen extends StatelessWidget {
  final AppBar Function(Widget, [List<Widget>]) appBar;
  final Store store;
  const OverviewScreen(
    this.appBar,
    this.store, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(Text('0')),
      body: Text('placeholder'),
      floatingActionButton: FloatingActionButton(
        shape: CircleBorder(),
        onPressed: () => print("Hello"),
        child: Icon(Icons.add),
      ),
    );
  }
}
