// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TaskJsonCompatible _$TaskJsonCompatibleFromJson(Map<String, dynamic> json) {
  return TaskJsonCompatible(
    id: json['id'] as String,
    isArchived: json['isArchived'] as bool,
    title: json['title'] as String,
    timeOfDayHour: json['timeOfDayHour'] as int,
    timeOfDayMinute: json['timeOfDayMinute'] as int,
    alertMillis: json['alertMillis'] as int,
    type: _$enumDecode(_$ReminderTypeEnumMap, json['type']),
    reminder: IReminder.fromJson(json['reminder'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$TaskJsonCompatibleToJson(TaskJsonCompatible instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'isArchived': instance.isArchived,
      'timeOfDayHour': instance.timeOfDayHour,
      'timeOfDayMinute': instance.timeOfDayMinute,
      'alertMillis': instance.alertMillis,
      'type': _$ReminderTypeEnumMap[instance.type],
      'reminder': instance.reminder,
    };

K _$enumDecode<K, V>(
  Map<K, V> enumValues,
  Object? source, {
  K? unknownValue,
}) {
  if (source == null) {
    throw ArgumentError(
      'A value must be provided. Supported values: '
      '${enumValues.values.join(', ')}',
    );
  }

  return enumValues.entries.singleWhere(
    (e) => e.value == source,
    orElse: () {
      if (unknownValue == null) {
        throw ArgumentError(
          '`$source` is not one of the supported values: '
          '${enumValues.values.join(', ')}',
        );
      }
      return MapEntry(unknownValue, enumValues.values.first);
    },
  ).key;
}

const _$ReminderTypeEnumMap = {
  ReminderType.PROXY: 'PROXY',
  ReminderType.DAYS_REMINDER: 'DAYS_REMINDER',
  ReminderType.WEEKS_REMINDER: 'WEEKS_REMINDER',
  ReminderType.MONTHS_REMINDER: 'MONTHS_REMINDER',
  ReminderType.ULTIMO_REMINDER: 'ULTIMO_REMINDER',
  ReminderType.DAY_REMINDER: 'DAY_REMINDER',
};
