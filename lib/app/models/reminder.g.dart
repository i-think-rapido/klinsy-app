// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reminder.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_IReminder _$_IReminderFromJson(Map<String, dynamic> json) {
  return _IReminder();
}

Map<String, dynamic> _$_IReminderToJson(_IReminder instance) =>
    <String, dynamic>{};

ReminderProxy _$ReminderProxyFromJson(Map<String, dynamic> json) {
  return ReminderProxy();
}

Map<String, dynamic> _$ReminderProxyToJson(ReminderProxy instance) =>
    <String, dynamic>{};

DaysReminder _$DaysReminderFromJson(Map<String, dynamic> json) {
  return DaysReminder(
    days: json['days'] as int,
  );
}

Map<String, dynamic> _$DaysReminderToJson(DaysReminder instance) =>
    <String, dynamic>{
      'days': instance.days,
    };

WeeksReminder _$WeeksReminderFromJson(Map<String, dynamic> json) {
  return WeeksReminder(
    weeks: json['weeks'] as int,
  );
}

Map<String, dynamic> _$WeeksReminderToJson(WeeksReminder instance) =>
    <String, dynamic>{
      'weeks': instance.weeks,
    };

MonthsReminder _$MonthsReminderFromJson(Map<String, dynamic> json) {
  return MonthsReminder(
    months: json['months'] as int,
  );
}

Map<String, dynamic> _$MonthsReminderToJson(MonthsReminder instance) =>
    <String, dynamic>{
      'months': instance.months,
    };

UltimoReminder _$UltimoReminderFromJson(Map<String, dynamic> json) {
  return UltimoReminder();
}

Map<String, dynamic> _$UltimoReminderToJson(UltimoReminder instance) =>
    <String, dynamic>{};

DayReminder _$DayReminderFromJson(Map<String, dynamic> json) {
  return DayReminder();
}

Map<String, dynamic> _$DayReminderToJson(DayReminder instance) =>
    <String, dynamic>{};
