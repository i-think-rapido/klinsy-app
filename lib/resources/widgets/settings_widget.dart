library widgets;


import 'package:Klinsy/app/controllers/task_edit_controller.dart';
import 'package:Klinsy/app/models/locales.dart';
import 'package:Klinsy/app/models/task_model.dart';
import 'package:Klinsy/app/services/settings_service.dart';
import 'package:flutter/material.dart';
import 'package:nylo_support/helpers/helper.dart';
import 'package:nylo_support/localization/app_localization.dart';
import 'package:nylo_support/widgets/ny_state.dart';
import 'package:nylo_support/widgets/ny_stateful_widget.dart';

class SettingsWidget extends NyStatefulWidget {
  SettingsWidget() : super(controller: TaskEditController());

  @override
  State<StatefulWidget> createState() => SettingsWidgetState();
}

class SettingsWidgetState extends NyState<SettingsWidget> {
  final _formKey = GlobalKey<FormState>();

  _selectTime(BuildContext context) async {
    final TimeOfDay? timeOfDay = await showTimePicker(
      context: context,
      initialTime: SettingsService().reminderTime,
      initialEntryMode: TimePickerEntryMode.dial,
    );
    if (timeOfDay != null) {
      setState(() {
        SettingsService().reminderTime = timeOfDay;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final localesMap = supportedLocalesMap(context);
    final languageItems = localesMap.keys.map<DropdownMenuItem<Locale>>((Locale e) => DropdownMenuItem(value: e, child: Text(trans(context, localesMap[e])!))).toList();

    return Form(
      key: _formKey,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
        child: ListView(
          children: [
            Column(
              children: <Widget>[
                Text(trans(context, 'Time of day to pop up:')!),
                Text(
                    timeOfDayToString(context, SettingsService().reminderTime)),
                ElevatedButton(
                    onPressed: () {
                      _selectTime(context);
                    },
                    child: Text(trans(context, 'Choose Time')!)),
                Divider(),
                Text(trans(context, 'Set language:')!),
                DropdownButton(
                  value: AppLocale.instance.locale,
                  onChanged: (value) {
                    setState(() {
                      AppLocale.instance.updateLocale(context, (value as Locale?)!);
                      SettingsService().locale =  (value as Locale?)!;
                      Navigator.pushNamedAndRemoveUntil(context,'/',(_) => false);
                    });
                  },
                  items: languageItems,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
