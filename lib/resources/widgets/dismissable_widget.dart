library widgets;

import 'package:flutter/material.dart';

class DismissibleWidget<T> extends StatelessWidget {
  final T item;
  final Widget child;
  final DismissDirectionCallback onDismissed;
  final Icon leftIcon;
  final Icon rightIcon;
  final DismissDirection direction;

  DismissibleWidget({
    Key? key,
    required this.item,
    required this.child,
    required this.onDismissed,
    this.leftIcon = const Icon(
      Icons.archive_sharp,
      color: Colors.white,
    ),
    this.rightIcon = const Icon(
      Icons.delete_forever,
      color: Colors.white,
    ),
    this.direction = DismissDirection.horizontal,
  });

  @override
  Widget build(BuildContext context) => Card(
        elevation: 5,
        child: Dismissible(
          key: ObjectKey(item),
          child: child,
          direction: direction,
          background: swipeLeftAction(),
          secondaryBackground: swipeRightAction(),
          onDismissed: onDismissed,
        ),
      );

  Widget swipeLeftAction() => Container(
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.symmetric(horizontal: 20),
        color: Colors.green,
        child: leftIcon,
      );

  Widget swipeRightAction() => Container(
        alignment: Alignment.centerRight,
        padding: EdgeInsets.symmetric(horizontal: 20),
        color: Colors.orange,
        child: rightIcon,
      );
}
