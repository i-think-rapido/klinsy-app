
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

import 'task.dart';

part 'reminder.g.dart';

typedef JsonMap = Map<String, dynamic>;

enum ReminderType {
  PROXY,
  DAYS_REMINDER,
  WEEKS_REMINDER,
  MONTHS_REMINDER,
  ULTIMO_REMINDER,
  DAY_REMINDER,
}
final reminderMap = {
  ReminderType.DAYS_REMINDER: (JsonMap json) => DaysReminder.fromJson(json['reminder']!),
  ReminderType.WEEKS_REMINDER: (JsonMap json) => WeeksReminder.fromJson(json['reminder']!),
  ReminderType.MONTHS_REMINDER: (JsonMap json) => MonthsReminder.fromJson(json['reminder']!),
  ReminderType.ULTIMO_REMINDER: (JsonMap json) => UltimoReminder.fromJson(json['reminder']!),
  ReminderType.DAY_REMINDER: (JsonMap json) => DayReminder.fromJson(json['reminder']!),
};

abstract class IReminder {

  final ReminderType type = ReminderType.PROXY;

  const IReminder();

  void setNewAlarm(Task task);

  DateTime getTodayAlertDateTime(Task task) {
    var now = DateTime.now();
    var date = DateTime.utc(now.year, now.month, now.day);//, task.timeOfDay.hour, task.timeOfDay.minute);
    return date;
  }

  void addDuration(Task task, Duration duration) {
    var alert = getTodayAlertDateTime(task);
    alert = alert.add(duration);
    task.alert = alert;
  }

  DateTime addMonths(DateTime date, int months) {
    months = date.month + months - 1;
    int m = months % 12;
    int y = months ~/ 12;
    if (m == 0) {
      y -= 1;
      m = 12;
    }
    else {
      m += 1;
    }
    date = DateTime.utc(y, m, date.day, date.hour, date.minute);
    return date;
  }

  factory IReminder.fromJson(JsonMap json) => _IReminder.fromJson(json);
  JsonMap toJson();

}
@JsonSerializable()
class _IReminder extends IReminder {

  @override
  final ReminderType type = ReminderType.PROXY;

  _IReminder();

  @override
  void setNewAlarm(Task task) {
    throw Exception('unreachable');
  }

  factory _IReminder.fromJson(JsonMap json) => _$_IReminderFromJson(json);
  @override
  JsonMap toJson() => _$_IReminderToJson(this);
}

@JsonSerializable()
class ReminderProxy extends IReminder {

  @override
  final ReminderType type = ReminderType.PROXY;

  final IReminder? _reminder;

  void setNewAlarm(Task task) {
    //if (_reminder == null) return;
    _reminder!.setNewAlarm(task);
  }

  const ReminderProxy({ IReminder reminder: const DaysReminder(days: 1) }) : _reminder = reminder;

  factory ReminderProxy.fromJson(JsonMap json) => _$ReminderProxyFromJson(json);
  @override
  JsonMap toJson() => _$ReminderProxyToJson(this);
}

@JsonSerializable()
class DaysReminder extends IReminder {

  @override
  final ReminderType type = ReminderType.DAYS_REMINDER;

  final int days;

  @override
  void setNewAlarm(Task task) {
    addDuration(task, Duration(days: days,));
  }

  const DaysReminder({ required this.days }) :
    assert(days > 0),
    super();

  factory DaysReminder.fromJson(JsonMap json) => _$DaysReminderFromJson(json);
  @override
  JsonMap toJson() => _$DaysReminderToJson(this);
}
@JsonSerializable()
class WeeksReminder extends IReminder {

  @override
  final ReminderType type = ReminderType.WEEKS_REMINDER;

  final int weeks;

  @override
  void setNewAlarm(Task task) {
    addDuration(task, Duration(days: weeks * 7));
  }

  const WeeksReminder({ required this.weeks }) :
    assert(weeks > 0),
    super();

  factory WeeksReminder.fromJson(JsonMap json) => _$WeeksReminderFromJson(json);
  @override
  JsonMap toJson() => _$WeeksReminderToJson(this);
}
@JsonSerializable()
class MonthsReminder extends IReminder {

  @override
  final ReminderType type = ReminderType.MONTHS_REMINDER;

  final int months;

  @override
  void setNewAlarm(Task task) {
    var alert = getTodayAlertDateTime(task);
    var date = addMonths(alert, months);
//    task.alert = date;
  }

  const MonthsReminder({ required this.months }) :
        assert(months > 0),
        super();

  factory MonthsReminder.fromJson(JsonMap json) => _$MonthsReminderFromJson(json);
  @override
  JsonMap toJson() => _$MonthsReminderToJson(this);
}
@JsonSerializable()
class UltimoReminder extends IReminder {

  @override
  final ReminderType type = ReminderType.ULTIMO_REMINDER;

  @override
  void setNewAlarm(Task task) {
    var alert = getTodayAlertDateTime(task);
    var date = addMonths(alert, 1);
    date = DateTime.utc(date.year, date.month).add(Duration(days: -1));
//    task.alert = date;
  }

  UltimoReminder() : super();

  factory UltimoReminder.fromJson(JsonMap json) => _$UltimoReminderFromJson(json);
  @override
  JsonMap toJson() => _$UltimoReminderToJson(this);
}
@JsonSerializable()
class DayReminder extends IReminder {

  @override
  final ReminderType type = ReminderType.DAY_REMINDER;

  @override
  void setNewAlarm(Task task) {
    // TODO: implement setNewAlarm
  }

  DayReminder() : super();

  factory DayReminder.fromJson(JsonMap json) => _$DayReminderFromJson(json);
  @override
  JsonMap toJson() => _$DayReminderToJson(this);
}

