import 'package:flutter/material.dart';

class Overview extends StatelessWidget {
  final AppBar Function(Widget, [List<Widget>]) appBar;
  const Overview({
    super.key,
    required this.appBar,
  });
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(Text('Overview'), []),
      body: Placeholder(),
    );
  }
}
