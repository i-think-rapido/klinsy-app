library widgets;

import 'package:Klinsy/app/models/task_model.dart';
import 'package:Klinsy/app/services/task_service.dart';
import 'package:flutter/material.dart';
import 'package:nylo_support/helpers/helper.dart';
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
    var whenComplete = TaskService()
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
            tooltip: trans(context, 'Add Task')!,
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
          title: Text(trans(context, 'undone todo')!),
          content: Text(
              trans(context, 'This Task has still to be done. Do you want to archive it anyway?')!),
          actions: [
            TextButton(
              child: Text(trans(context, 'Cancel')!),
              onPressed: () => Navigator.pop(context, false),
            ),
            TextButton(
              child: Text(trans(context, 'Proceed')!),
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
          .showSnackBar(SnackBar(content: Text(trans(context, 'Task archived...')!)));
      TaskService().persist(task);
    });
  }
}
