import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:uuid/uuid.dart';

import './reminder_model.dart';

part 'task_model.g.dart';

@JsonSerializable()
class TaskJsonCompatible {
  final String id;

  final String title;
  final bool isArchived;
  final int timeOfDayHour;
  final int timeOfDayMinute;
  final int alertMillis;
  final ReminderType type;
  final IReminder reminder;

  TaskJsonCompatible({
    required this.id,
    required this.isArchived,
    required this.title,
    required this.timeOfDayHour,
    required this.timeOfDayMinute,
    required this.alertMillis,
    required this.type,
    required this.reminder,
  });

  factory TaskJsonCompatible.ofTask(ITask task) {
    return TaskJsonCompatible(
      id: task.id,
      title: task.title,
      isArchived: task.isArchived,
      timeOfDayHour: task.timeOfDay.hour,
      timeOfDayMinute: task.timeOfDay.minute,
      alertMillis: task.alert.millisecondsSinceEpoch,
      type: task.reminder.type,
      reminder: task.reminder,
    );
  }

  factory TaskJsonCompatible.fromJson(Map<String, dynamic> json) =>
      _$TaskJsonCompatibleFromJson(json);

  JsonMap toJson() => _$TaskJsonCompatibleToJson(this);
}

abstract class ITask {

  String get id;
  String get title;
  bool get isArchived;
  TimeOfDay get timeOfDay;
  DateTime get alert;
  IReminder get reminder;

  set id(String value);
  set isArchived(bool value);
  set alert(DateTime value);

  JsonMap toJson();

  bool hasToBeDone();

  ITask clone();

  ITask change({String? title, bool? isArchived, TimeOfDay? timeOfDay, DateTime? alert, IReminder? reminder});
}

class Task extends ITask {
  String _id = Uuid().v1();

  late final String _title;
  late bool _isArchived;
  late final TimeOfDay _timeOfDay;
  late DateTime _alert;
  late final IReminder _reminder;

  @override
  String get id => _id;
  @override
  String get title => _title;
  @override
  bool get isArchived => _isArchived;
  @override
  TimeOfDay get timeOfDay => _timeOfDay;
  @override
  DateTime get alert => _alert;
  @override
  IReminder get reminder => _reminder;
  @override
  set id(String value) => _id = value;
  @override
  set isArchived(bool value) => _isArchived = value;
  @override
  set alert(DateTime value) => _alert = value;

  Task({
    required title,
    isArchived = false,
    required timeOfDay,
    required alert,
    required reminder,
  }) {
    _title = title;
    _isArchived = isArchived;
    _timeOfDay = timeOfDay;
    _alert = alert;
    _reminder = reminder;
  }

  factory Task.fromJson(JsonMap json) =>
      Task.fromJsonCompatible(TaskJsonCompatible.fromJson(json), json);

  @override
  JsonMap toJson() => TaskJsonCompatible.ofTask(this).toJson();

  factory Task.fromJsonCompatible(TaskJsonCompatible taskjson, JsonMap json) {
    var out = Task(
      title: taskjson.title,
      isArchived: taskjson.isArchived,
      timeOfDay: TimeOfDay(
          hour: taskjson.timeOfDayHour, minute: taskjson.timeOfDayMinute),
      alert: DateTime.fromMillisecondsSinceEpoch(taskjson.alertMillis),
      reminder: reminderMap[taskjson.type]!(json),
    );

    out.id = taskjson.id;

    return out;
  }

  @override
  bool hasToBeDone() => alert.isBefore(DateTime.now()) && !isArchived;

  @override
  ITask clone() {
    var out = Task(title: title, isArchived: isArchived, timeOfDay: timeOfDay, alert: alert, reminder: reminder.clone());
    out.id = id;
    return out;
  }

  @override
  ITask change({String? title, bool? isArchived, TimeOfDay? timeOfDay, DateTime? alert, IReminder? reminder}) {
    var out = Task( title: title ?? this.title, isArchived: isArchived ?? this.isArchived, timeOfDay: timeOfDay ?? this.timeOfDay, alert: alert ?? this.alert, reminder: reminder ?? this.reminder, );
    out.id = this.id;
    return out;
  }
}

class TaskProxy extends ITask {
  late final ITask task;
  final bool cloned;

  TaskProxy(ITask? task, { this.cloned = false, }) {
    if (task != null) {
      this.task = cloned ? task.clone() : task;
    } else {
      this.task = Task(
        title: "clean kitchen sink",
        timeOfDay: TimeOfDay.now(),
        alert: DateTime.now(),
        reminder: DaysReminder(days: 1),
      );
    }
  }

  @override
  JsonMap toJson() => task.toJson();
  @override
  bool hasToBeDone() => task.hasToBeDone();
  @override
  ITask clone() => task.clone();

  @override
  String get id => task.id;
  @override
  String get title => task.title;
  @override
  bool get isArchived => task.isArchived;
  @override
  TimeOfDay get timeOfDay => task.timeOfDay;
  @override
  DateTime get alert => task.alert;
  @override
  IReminder get reminder => task.reminder;
  @override
  set id(String value) => task.id = value;
  @override
  set isArchived(bool value) => task.isArchived = value;
  @override
  set alert(DateTime value) => task.alert = value;

  @override
  ITask change({String? title, bool? isArchived, TimeOfDay? timeOfDay, DateTime? alert, IReminder? reminder}) {
    return task.change( title: title, isArchived: isArchived, timeOfDay: timeOfDay, alert: alert, reminder: reminder, );
  }

}
