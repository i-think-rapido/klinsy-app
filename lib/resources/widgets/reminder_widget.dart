import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_app/app/models/reminder_model.dart';
import 'package:flutter_app/resources/widgets/task_edit_widget.dart';
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
          onChanged: (ReminderType? value) {
            setState(() {
              dropDownValue = value!;
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

Widget _determineReminderWidget(IReminder initialValue,
    void Function(IReminder) onChanged) {
  Widget out = SizedBox.shrink();

  switch (initialValue.type) {
    case ReminderType.DAYS_REMINDER:
      out = TextFormField(
        initialValue: (initialValue as DaysReminder).days.toString(),
        keyboardType: TextInputType.number,
        onChanged: (value) {
          onChanged(DaysReminder(days: int.parse(value)));
        },
      );
      break;
    case ReminderType.WEEKS_REMINDER:
      out = TextFormField(
        initialValue: (initialValue as WeeksReminder).weeks.toString(),
        keyboardType: TextInputType.number,
        onChanged: (value) {
          onChanged(WeeksReminder(weeks: int.parse(value)));
        },
      );
      break;
    case ReminderType.MONTHS_REMINDER:
      out = TextFormField(
        initialValue: (initialValue as MonthsReminder).months.toString(),
        keyboardType: TextInputType.number,
        onChanged: (value) {
          onChanged(MonthsReminder(months: int.parse(value)));
        },
      );
      break;
  }

  return out;
}