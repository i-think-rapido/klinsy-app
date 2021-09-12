
import 'package:flutter/material.dart';
import 'package:nylo_support/helpers/helper.dart';
import 'package:nylo_support/localization/app_localization.dart';

import '../models/task_model.dart';

typedef TasksFound = Iterable<ITask>;

const _REMINDER_TIME_HOUR = 'com.jellobird.klinsy._REMINDER_TIME_HOUR';
const _REMINDER_TIME_MINUTE = 'com.jellobird.klinsy._REMINDER_TIME_MINUTE';
const _LOCALE = 'com.jellobird.klinsy._LOCALE';

class SettingsService {

  int _reminderTimeHour = 9;
  int _reminderTimeMinute = 0;
  Locale _locale = Locale('en', 'US');


  // Singleton
  SettingsService._privateConstructor() {
    NyStorage.read(_REMINDER_TIME_HOUR).then((value) => _reminderTimeHour = int.tryParse(value) ?? _reminderTimeHour);
    NyStorage.read(_REMINDER_TIME_MINUTE).then((value) => _reminderTimeMinute = int.tryParse(value) ?? _reminderTimeMinute);
    NyStorage.read(_LOCALE).then((value) {
      final localeStr = (value as String?) ?? 'en_US';
      final parts = localeStr.split('_');
      if (parts.length > 1) {
        _locale = Locale(parts[0], parts[1]);
      }
      else {
        _locale = Locale(parts[0]);
      }
    });
    NyStorage.store(_REMINDER_TIME_HOUR, _reminderTimeHour);
    NyStorage.store(_REMINDER_TIME_MINUTE, _reminderTimeMinute);
    NyStorage.store(_LOCALE, locale);
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
    NyStorage.store(_REMINDER_TIME_HOUR, _reminderTimeHour);
    NyStorage.store(_REMINDER_TIME_MINUTE, _reminderTimeMinute);
  }

  Locale get locale {
    return _locale;
  }
  set locale(Locale locale) {
    AppLocale.instance.locale = locale;
    _locale = locale;
    NyStorage.store(_LOCALE, locale.toString());
  }

  void initLocale(void Function(Locale locale) fn) {
    NyStorage.read(_LOCALE).then((value) {
      final localeStr = (value as String?) ?? 'en_US';
      final parts = localeStr.split('_');
      if (parts.length > 1) {
        _locale = Locale(parts[0], parts[1]);
      }
      else {
        _locale = Locale(parts[0]);
      }
      fn(_locale);
    });
  }

}

