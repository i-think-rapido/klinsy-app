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
  List<Task> tasks = <Task>[];
  bool isDirty = true;

  void _addTask() {
    TaskService()
        .persist(
          Task(
            title: "clean kitchen sink",
            timeOfDay: TimeOfDay.now(),
            alert: DateTime.now(),
            reminder: DaysReminder(days: 1),
          ),
        )
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
//                    Navigator.pushNamed(context, "/new");
                    TaskService().persist(
                      Task(
                        title: "clean kitchen sink",
                        timeOfDay: TimeOfDay.now(),
                        alert: DateTime.now(),
                        reminder: DaysReminder(days: 1),
                      ),
                    ).whenComplete(() => loadList(true));
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
          BuildContext context, int index, DismissDirection direction) =>
      setState(() {
        final task = tasks.removeAt(index);
        switch (direction) {
          case DismissDirection.startToEnd:
            task.reminder.setNewAlarm(task);
            ScaffoldMessenger.of(context)
                .showSnackBar(const SnackBar(content: Text('Task done...')));
            break;
          case DismissDirection.endToStart:
            task.isArchived = true;
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Task archived...')));
            break;
        }
        TaskService().persist(task);
      });
}
