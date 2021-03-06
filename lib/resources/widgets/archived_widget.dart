library widgets;

import 'package:Klinsy/app/models/task_model.dart';
import 'package:Klinsy/app/services/task_service.dart';
import 'package:flutter/material.dart';
import 'package:nylo_support/helpers/helper.dart';
import 'package:nylo_support/widgets/ny_state.dart';
import 'package:nylo_support/widgets/ny_stateful_widget.dart';

import './task_widget.dart';
import 'dismissable_widget.dart';

class ArchivedWidget extends NyStatefulWidget {
  @override
  _ArchivedWidgetState createState() => _ArchivedWidgetState();
}

class _ArchivedWidgetState extends NyState<ArchivedWidget> {
  List<ITask> tasks = <ITask>[];
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
              action: () => loadList(false),
            ),
            onDismissed: (direction) => dismissItem(context, index, direction),
            backgroundIcon: const Icon(
              Icons.undo,
              color: Colors.white,
            ),
            secondaryBackgroundIcon: const Icon(
              Icons.delete_forever_outlined,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  void dismissItem(BuildContext context, int index, DismissDirection direction) {
    setState(() async {
      final task = tasks.removeAt(index);
      switch(direction) {
        case DismissDirection.startToEnd:
          task.isArchived = false;
          task.reminder.setNewAlarm(task);
          TaskService().persist(task);
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(trans(context, 'Task active...')!)));
          break;
        case DismissDirection.endToStart:
          TaskService().delete(task);
          await task.deleteImage();
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(trans(context, 'Task deleted...')!)));
          break;
      }
    });
  }
}
