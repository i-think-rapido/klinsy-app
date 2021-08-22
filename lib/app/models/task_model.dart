
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import './reminder_model.dart';

import 'package:uuid/uuid.dart';

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

  factory TaskJsonCompatible.ofTask(Task task) {
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
  factory TaskJsonCompatible.fromJson(Map<String, dynamic> json) => _$TaskJsonCompatibleFromJson(json);
  JsonMap toJson() => _$TaskJsonCompatibleToJson(this);
}


class Task {
  String id = Uuid().v1();

  final String title;
  bool isArchived;
  final TimeOfDay timeOfDay;
  DateTime alert;
  final IReminder reminder;

  Task({
    required this.title,
    this.isArchived = false,
    required this.timeOfDay,
    required this.alert,
    required this.reminder,
  });

  factory Task.fromJson(JsonMap json) => Task.fromJsonCompatible(TaskJsonCompatible.fromJson(json), json);
  JsonMap toJson() => TaskJsonCompatible.ofTask(this).toJson();

  factory Task.fromJsonCompatible(TaskJsonCompatible taskjson, JsonMap json) {
    var out = Task(
      title: taskjson.title,
      isArchived: taskjson.isArchived,
      timeOfDay: TimeOfDay(hour: taskjson.timeOfDayHour, minute: taskjson.timeOfDayMinute),
      alert: DateTime.fromMillisecondsSinceEpoch(taskjson.alertMillis),
      reminder: reminderMap[taskjson.type]!(json),
    );

    out.id = taskjson.id;

    return out;
  }

  bool hasToBeDone() => alert.isBefore(DateTime.now()) && !isArchived;

}

