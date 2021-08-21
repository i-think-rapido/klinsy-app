library widgets;

import 'package:flutter/material.dart';
import 'package:flutter_app/app/models/reminder_model.dart';
import 'package:flutter_app/app/models/task_model.dart';
import 'package:flutter_app/app/services/task_service.dart';
import 'package:nylo_support/widgets/ny_state.dart';
import 'package:nylo_support/widgets/ny_stateful_widget.dart';

import './task_widget.dart';
import 'dismissable_widget.dart';

class ArchivedWidget extends NyStatefulWidget {
  @override
  _ArchivedWidgetState createState() => _ArchivedWidgetState();
}

class _ArchivedWidgetState extends NyState<ArchivedWidget> {
  List<Task> tasks = <Task>[];
  bool isDirty = true;

  void loadList(isDirty) {
    TaskService().findAllArchived().then((value) => setState(() {
          tasks = value.toList();
          this.isDirty = isDirty;
        }));
  }

  @override
  Widget build(BuildContext context) {
    if (isDirty) {
      loadList(false);
    }

    return Stack(
      children: [
        ListView.builder(
          itemCount: tasks.length,
          itemBuilder: (context, index) => DismissibleWidget(
            item: tasks[index],
            child: TaskWidget(
              task: tasks[index],
            ),
            onDismissed: (direction) => dismissItem(context, index, direction),
            leftIcon: const Icon(
              Icons.done,
              color: Colors.white,
            ),
            rightIcon: const Icon(
              Icons.delete,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  void dismissItem(BuildContext context, int index, DismissDirection direction) {
    setState(() {
      final task = tasks.removeAt(index);
      switch(direction) {
        case DismissDirection.startToEnd:
          task.isArchived = false;
          task.reminder.setNewAlarm(task);
          TaskService().persist(task);
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Task active...')));
          break;
        case DismissDirection.endToStart:
          TaskService().delete(task);
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Task deleted...')));
          break;
      }
    });
  }
}
