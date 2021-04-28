import 'package:flutter/material.dart';

/// This class provides custom colors to be used in the project.
///
class AppColors {
  AppColors._();

  static const Color defaultColor = Color(0xFFC91773);
  static const Color appBackground = Color(0xFFF5F6F8);
  static const Color white = Color(0xFFFFFFFF);
  static const Color default_black = Color(0xFF110c11);
  static const Color hint = Color(0xFF808080);
  static const Color dividerColor = Color(0xFFC9B7C0);
  static const Color greenColor = Color(0xFF34A853);
  static const Color orangeColor = Color(0xFFF1705E);
  static const Color viagerColor = Color(0xFF6C6260);
  static const Color blueTypeColor = Color(0xFF4BA2FE);

  static Map<int, Color> colorCodes = {
    50: const Color.fromRGBO(0, 51, 153, .1),
    100: const Color.fromRGBO(0, 51, 153, .2),
    200: const Color.fromRGBO(0, 51, 153, .3),
    300: const Color.fromRGBO(0, 51, 153, .4),
    400: const Color.fromRGBO(0, 51, 153, .5),
    500: const Color.fromRGBO(0, 51, 153, .6),
    600: const Color.fromRGBO(0, 51, 153, .7),
    700: const Color.fromRGBO(0, 51, 153, .8),
    800: const Color.fromRGBO(0, 51, 153, .9),
    900: const Color.fromRGBO(0, 51, 153, 1),
  };// Opacity 20%
}
