library widgets;

import 'package:flutter/material.dart';
import 'package:flutter_app/app/models/task_model.dart';

typedef PerformAction = void Function();

class TaskWidget extends StatelessWidget {
  ITask task;
  PerformAction action = () {};

  TaskWidget({Key? key, required this.task, PerformAction? action,}) : super(key: key) {
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
              Container(
                height: 200,
                child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  child: Image.network(
                    'https://www-signaturehardware.com.imgeng.in/media/catalog/product/cache/1/image/9df78eab33525d08d6e5fb8d27136e95/5/2/522442-32-stainless-steel-undermount-kitchen-sink-beauty.jpg',
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            top: -5,
            right: 0,
            child: IconButton(
              onPressed: () {
                Navigator.pushNamed(
                    context, "/edit", arguments: TaskProxy(task, cloned: true))
                    .then((value) {
                      task = (value as ITask?)!;
                      action();
                    });
              },
              icon: Icon(
                Icons.edit,
                size: 18.0,
                color: Theme
                    .of(context)
                    .accentColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
