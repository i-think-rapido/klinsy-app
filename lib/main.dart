import 'package:Klinsy/app/services/settings_service.dart';
import 'package:Klinsy/resources/themes/dark_theme.dart';
import 'package:Klinsy/resources/themes/light_theme.dart';
import 'package:Klinsy/routes/router.dart';
import 'package:flutter/material.dart';
import 'package:nylo_support/localization/app_localization.dart';
import 'package:nylo_support/nylo.dart';
import 'package:nylo_framework/nylo_framework.dart';
import 'package:nylo_framework/theme/helper/theme_helper.dart';

import 'app/services/camera_service.dart';
import 'bootstrap/app.dart';
import 'config/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final AppTheme appTheme = AppTheme();

  Nylo nylo = await initNylo(theme: lightTheme(appTheme), router: buildRouter());

  CameraService();

  SettingsService().initLocale((Locale locale) {
    AppLocale.instance.locale = locale;
    runApp(
      AppBuild(
        navigatorKey: nylo.router!.navigatorKey,
        onGenerateRoute: nylo.router!.generator(),
        themeData: CurrentTheme.instance.theme!,
        darkTheme: darkTheme(appTheme),
        locale: AppLocale.instance.locale,
      ),
    );
  });
}
