library widgets;

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_app/app/controllers/task_edit_controller.dart';
import 'package:flutter_app/app/models/reminder_model.dart';
import 'package:flutter_app/app/models/task_model.dart';
import 'package:flutter_app/app/services/camera_service.dart';
import 'package:flutter_app/app/services/task_service.dart';
import 'package:flutter_app/resources/widgets/reminder_widget.dart';
import 'package:nylo_support/helpers/helper.dart';
import 'package:nylo_support/widgets/ny_state.dart';
import 'package:nylo_support/widgets/ny_stateful_widget.dart';

class TaskEditWidget extends NyStatefulWidget {
  TaskEditWidget() : super(controller: TaskEditController());

  @override
  State<StatefulWidget> createState() => TaskEditWidgetState();
}

class TaskEditWidgetState extends NyState<TaskEditWidget> {
  final _formKey = GlobalKey<FormState>();

  TaskProxy? _task;

  ITask task(BuildContext context) {
    _task = _task ?? ModalRoute.of(context)!.settings.arguments as TaskProxy;
    return _task!;
  }

  ITask setTask(ITask task) {
    _task = TaskProxy(task);
    return _task!;
  }

  _selectTime(BuildContext context) async {
    final TimeOfDay? timeOfDay = await showTimePicker(
      context: context,
      initialTime: task(context).timeOfDay,
      initialEntryMode: TimePickerEntryMode.dial,
    );
    if (timeOfDay != null && timeOfDay != task(context).timeOfDay) {
      setState(() {
        setTask(task(context).change(timeOfDay: timeOfDay));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
        child: ListView(
          children: [
            Column(
              children: <Widget>[
                Text('Title:'),
                Padding(
                  padding: EdgeInsets.all(10.0),
                  child: TextFormField(
                    initialValue: task(context).title,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      }
                      setTask(task(context).change(title: value));
                      return null;
                    },
                  ),
                ),
                Divider(),
                Text('Time of day to pop up:'),
                Text(
                    '${task(context).timeOfDay.hour}:${task(context).timeOfDay.minute}'),
                ElevatedButton(
                    onPressed: () {
                      _selectTime(context);
                    },
                    child: Text("Choose Time")),
                Divider(),
                Text('How to remind you:'),
                ReminderWidget(
                  state: this,
                ),
                Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    IconButton(
                      onPressed: () {
                        Navigator.of(context)
                            .pushNamed("/camera")
                            .then((value) => setState(() {
                                  setTask(task(context).change(
                                    picturePath: (value as String?)!,
                                  ));
                                }));
                      },
                      icon: Icon(
                        Icons.camera_alt,
                        color: Theme.of(context).accentColor,
                      ),
                      tooltip: 'Take a picture',
                    ),
                    IconButton(
                      onPressed: () => setState(() {
                        setTask(task(context).change(
                          picturePath: '<none>',
                        ));
                      }),
                      icon: Icon(
                        Icons.delete_forever,
                        color: Theme.of(context).accentColor,
                      ),
                      tooltip: 'Erase picture',
                    ),
                  ],
                ),
                Container(
                  height: 200,
                  child: task(context).picturePath == NO_PICTURE
                      ? Image.asset(
                    getImageAsset("no-photo.png"),
                    height: 100,
                    width: 100,
                  )
                  : ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    child: Image.file(File(task(context).picturePath)),
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 15),
              child: Column(
                children: [
                  FloatingActionButton(
                    //onPressed: _addTask,
                    tooltip: 'Add Task',
                    onPressed: () {},
                    child: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).accentColor,
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            TaskService().persist(task(context));
                            Navigator.pop(context, task(context));
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('Saving task...')));
                          }
                        },
                        icon: Icon(
                          Icons.save_outlined,
                          size: 18.0,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
