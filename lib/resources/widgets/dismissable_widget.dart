library widgets;

import 'package:flutter/material.dart';

class DismissibleWidget<T> extends StatelessWidget {
  final T item;
  final Widget child;
  final DismissDirectionCallback onDismissed;
  final Icon? backgroundIcon;
  final Icon? secondaryBackgroundIcon;
  final DismissDirection direction;

  DismissibleWidget({
    Key? key,
    required this.item,
    required this.child,
    required this.onDismissed,
    this.backgroundIcon = const Icon(
      Icons.archive_sharp,
      color: Colors.white,
    ),
    this.secondaryBackgroundIcon = const Icon(
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

  Widget? swipeLeftAction() => backgroundIcon == null ? null : Container(
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.symmetric(horizontal: 20),
        color: Colors.green,
        child: backgroundIcon!,
      ) as Widget;

  Widget? swipeRightAction() => secondaryBackgroundIcon == null ? null : Container(
        alignment: Alignment.centerRight,
        padding: EdgeInsets.symmetric(horizontal: 20),
        color: Colors.orange,
        child: secondaryBackgroundIcon!,
      );
}
