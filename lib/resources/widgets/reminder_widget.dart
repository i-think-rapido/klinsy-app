import 'package:Klinsy/app/models/reminder_model.dart';
import 'package:Klinsy/resources/widgets/task_edit_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:nylo_support/widgets/ny_state.dart';
import 'package:nylo_support/widgets/ny_stateful_widget.dart';

typedef ReminderOnChangeAction = void Function(ReminderType);

class ReminderWidget extends NyStatefulWidget {
  final TaskEditWidgetState state;

  ReminderWidget({required this.state});

  @override
  _ReminderWidgetState createState() => _ReminderWidgetState();
}

class _ReminderWidgetState extends NyState<ReminderWidget> {
  ReminderType dropDownValue = ReminderType.DAYS_REMINDER;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        DropdownButton(
          value: widget.state.task(context).reminder.type,
          onChanged: (value) {
            setState(() {
              dropDownValue = (value as ReminderType?)!;
              widget.state.setTask(widget.state
                  .task(context)
                  .change(reminder: reminderMapTemplate[dropDownValue]!));
            });
          },
          items: reminderMapText.keys
              .map((e) =>
                  DropdownMenuItem(value: e, child: Text(reminderMapText[e]!)))
              .toList(),
        ),
        _determineReminderWidget(
            widget.state.task(context).reminder,
            (value) => setState(() {
                  widget.state.setTask(
                      widget.state.task(context).change(reminder: value));
                })),
      ],
    );
  }
}

Widget _determineReminderWidget(
    IReminder initialValue, void Function(IReminder) onChanged) {
  Widget out = SizedBox.shrink();

  switch (initialValue.type) {
    case ReminderType.DAYS_REMINDER:
      out = _MyNumberField(
        initialValue: (initialValue as DaysReminder).days.toString(),
        onChanged: (value) => _stringOnChanged(
            value, onChanged, (value) => DaysReminder(days: value)),
      );
      break;
    case ReminderType.WEEKS_REMINDER:
      out = _MyNumberField(
        initialValue: (initialValue as WeeksReminder).weeks.toString(),
        onChanged: (value) => _stringOnChanged(
            value, onChanged, (value) => WeeksReminder(weeks: value)),
      );
      break;
    case ReminderType.MONTHS_REMINDER:
      out = _MyNumberField(
        initialValue: (initialValue as MonthsReminder).months.toString(),
        onChanged: (value) => _stringOnChanged(
            value, onChanged, (value) => MonthsReminder(months: value)),
      );
      break;
  }

  return out;
}

class _MyNumberField extends TextFormField {
  final String initialValue;
  final void Function(String) onChanged;

  _MyNumberField({required this.initialValue, required this.onChanged})
      : super(
          initialValue: initialValue,
          onChanged: onChanged,
          keyboardType: TextInputType.number,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Value must be provided';
            }
            return null;
          },
        );
}

void _stringOnChanged(String value, void Function(IReminder) onChanged,
    IReminder Function(int) handler) {
  if (value.isNotEmpty) {
    onChanged(handler(int.parse(value)));
  }
}
