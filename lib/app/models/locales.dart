
import 'package:flutter/material.dart';
import 'package:nylo_support/helpers/helper.dart';

supportedLocalesMap(context) {
  return {
    Locale('en', 'US'): trans(context, 'English')!,
    Locale('de', 'DE'): trans(context, 'German')!,
  };
}