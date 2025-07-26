import 'package:flutter/material.dart';

class CustomMenu extends StatelessWidget {
  final Map<String, VoidCallback> items;
  const CustomMenu({
    required this.items,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MenuAnchor(
      menuChildren: items.entries
          .map(
            (entries) => SizedBox(
              width: 180,
              child: MenuItemButton(
                onPressed: entries.value,
                child: Text(entries.key),
              ),
            ),
          )
          .toList(),
      builder: (context, controller, widget) {
        return IconButton(
          onPressed: () {
            if (controller.isOpen) {
              controller.close();
            } else {
              controller.open();
            }
          },
          icon: Icon(Icons.menu),
        );
      },
    );
  }
}
