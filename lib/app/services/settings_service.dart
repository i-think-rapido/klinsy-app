import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_app/app/models/task_model.dart';
import 'package:nylo_support/helpers/helper.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/reminder_model.dart';
import '../models/task_model.dart';

typedef TasksFound = Iterable<ITask>;

const _REMINDER_TIME_HOUR = 'reminderTimeHour';
const _REMINDER_TIME_MINUTE = 'reminderTimeMinute';

class SettingsService {

  int _reminderTimeHour = 9;
  int _reminderTimeMinute = 0;


  // Singleton
  SettingsService._privateConstructor() {
    NyStorage.read(_REMINDER_TIME_HOUR).then((value) => _reminderTimeHour);
    NyStorage.read(_REMINDER_TIME_MINUTE).then((value) => _reminderTimeMinute);
  }
  static final SettingsService _instance = SettingsService._privateConstructor();
  factory SettingsService() {
    return _instance;
  }

  TimeOfDay get reminderTime {
    return TimeOfDay(hour: _reminderTimeHour, minute: _reminderTimeMinute);
  }
  set reminderTime(TimeOfDay value) {
    _reminderTimeHour = value.hour;
    _reminderTimeMinute = value.minute;
    _reminderTimeSave();
  }
  void _reminderTimeSave() {
    NyStorage.store(_REMINDER_TIME_HOUR, _reminderTimeHour);
    NyStorage.store(_REMINDER_TIME_MINUTE, _reminderTimeMinute);
  }

}

