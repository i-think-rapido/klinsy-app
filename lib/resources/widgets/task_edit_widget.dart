library widgets;

import 'package:flutter/material.dart';
import 'package:flutter_app/app/controllers/task_edit_controller.dart';
import 'package:flutter_app/app/models/reminder_model.dart';
import 'package:flutter_app/app/models/task_model.dart';
import 'package:nylo_support/widgets/ny_state.dart';
import 'package:nylo_support/widgets/ny_stateful_widget.dart';

class TaskEditWidget extends NyStatefulWidget {
  TaskEditWidget() : super(controller: TaskEditController());

  @override
  State<StatefulWidget> createState() => _TaskEditWidget();
}

class _TaskEditWidget extends NyState<TaskEditWidget> {
  ITask task(BuildContext context) {
    return ModalRoute.of(context)!.settings.arguments as TaskProxy;
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
                      task(context).title,
                      textAlign: TextAlign.left,
                    )),
              ),
              Divider(),
              Container(
                height: 200,
                child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  child: Image.network(
                    'https://image.made-in-china.com/2f0j00bKLaYsGFJrfW/China-Supplier-Oil-Resistance-Composite-Stone-Sink-Granite-Kitchen-Sinks.jpg',
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: FloatingActionButton(
              //onPressed: _addTask,
              tooltip: 'Add Task',
              onPressed: () {},
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).accentColor,
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  onPressed: () => {},
                  icon: Icon(
                    Icons.save_outlined,
                    size: 18.0,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
