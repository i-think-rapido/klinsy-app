library widgets;

import 'dart:io';

import 'package:Klinsy/app/models/task_model.dart';
import 'package:Klinsy/app/services/camera_service.dart';
import 'package:flutter/material.dart';

typedef PerformAction = void Function();

class TaskWidget extends StatelessWidget {
  ITask task;
  PerformAction action = () {};

  TaskWidget({
    Key? key,
    required this.task,
    PerformAction? action,
  }) : super(key: key) {
    if (action != null) {
      this.action = action;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
      child: Stack(
        children: [
          Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(10.0),
                child: Title(
                    color: Colors.blue,
                    child: Text(
                      task.title,
                      textAlign: TextAlign.left,
                    )),
              ),
              Divider(),
              task.picturePath == NO_PICTURE
                  ? SizedBox.shrink()
                  : Container(
                      height: 200,
                      child: ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        child: Image.file(File(task.picturePath)),
                      ),
                    ),
            ],
          ),
          Positioned(
            top: -5,
            right: 0,
            child: IconButton(
              onPressed: () {
                Navigator.pushNamed(context, "/edit",
                        arguments: TaskProxy(task, cloned: true))
                    .then((value) {
                  task = (value as ITask?)!;
                  action();
                });
              },
              icon: Icon(
                Icons.edit,
                size: 18.0,
                color: Theme.of(context).accentColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
