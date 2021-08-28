library widgets;

import 'package:flutter/material.dart';
import 'package:flutter_app/app/models/reminder_model.dart';
import 'package:flutter_app/app/models/task_model.dart';
import 'package:flutter_app/app/services/task_service.dart';
import 'package:nylo_support/widgets/ny_state.dart';
import 'package:nylo_support/widgets/ny_stateful_widget.dart';

import './task_widget.dart';
import 'dismissable_widget.dart';

class ActiveWidget extends NyStatefulWidget {
  @override
  _ActiveWidgetState createState() => _ActiveWidgetState();
}

class _ActiveWidgetState extends NyState<ActiveWidget> {
  List<ITask> tasks = <ITask>[];
  bool isDirty = true;

  void _addTask() {
    TaskService()
        .persist(TaskService.defaultTask())
        .whenComplete(() => loadList(true));
  }

  void loadList(isDirty) {
    TaskService().findAllActive().then((value) => setState(() {
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
              key: ObjectKey(tasks[index]),
              task: tasks[index],
              action: () => loadList(true),
            ),
            direction: DismissDirection.startToEnd,
            onDismissed: (direction) => dismissItem(context, index, direction),
            backgroundIcon: const Icon(
              Icons.save_alt,
              color: Colors.white,
            ),
          ),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: FloatingActionButton(
            onPressed: _addTask,
            tooltip: 'Add Task',
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).accentColor,
                shape: BoxShape.circle,
              ),
              child: IconButton(
                  onPressed: () {
                    Navigator.pushNamed(context, "/new",
                            arguments: TaskProxy(TaskService.defaultTask()))
                        .then((value) {
                      var task = (value as ITask?)!;
                      TaskService().persist(task);
                      loadList(true);
                    });
                  },
                  icon: Icon(
                    Icons.add,
                    color: Theme.of(context).buttonColor,
                  )),
            ),
          ),
        ),
      ],
    );
  }

  void dismissItem(
      BuildContext context, int index, DismissDirection direction) {
    if (tasks[index].hasToBeDone()) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('undone todo'),
          content: Text(
              'This Task has still to be done. Do you want to archive it anyway?'),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () => Navigator.pop(context, false),
            ),
            TextButton(
              child: Text('Proceed'),
              onPressed: () => Navigator.pop(context, true),
            ),
          ],
        ),
      ).then((value) {
        if (value) {
          archiveTask(index, context);
        }
      });
    } else {
      archiveTask(index, context);
    }
  }

  void archiveTask(int index, BuildContext context) {
    setState(() {
      final task = tasks.removeAt(index);
      task.isArchived = true;
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Task archived...')));
      TaskService().persist(task);
    });
  }
}
