import 'package:flutter/material.dart';

/// This class provides custom colors to be used in the project.
///
class AppColors {
  AppColors._();

  static const Color defaultColor = Color(0xFFC91773);
  static const Color appBackground = Color(0xFFF5F6F8);
  static const Color white = Color(0xFFFFFFFF);
  static const Color default_black = Color(0xFF110c11);
  static const Color desactivatedBell = Color(0xFF333333);
  static const Color hint = Color(0xFF808080);
  static const Color grey = Color(0xFFE2DFDF);
  static const Color nullEnergy = Color(0xFFD8D8D8);
  static const Color dividerColor = Color(0xFFC9B7C0);
  static const Color greenColor = Color(0xFF34A853);
  static const Color orangeColor = Color(0xFFF1705E);
  static const Color viagerColor = Color(0xFF6C6260);
  static const Color blueTypeColor = Color(0xFF4BA2FE);
  static const Color infoBlocColor = Color(0xFFC3D8EA);
  static const Color firstChartColor = Color(0xFFD8D8D8);
  static const Color secondChartColor = Color(0xFFA4C342);
  static const Color thirdChartColor = Color(0xFF0073CB);
  static Color headerTableColor = Color(0xFF0D0C0C).withOpacity(0.35);
  static Color rowTableColor = Color(0xFF999999).withOpacity(0.15);
  static Color clipperWaveColor = Color(0xFF999999).withOpacity(0.15);
  static Color faceBookColor = Color(0xFF3B5998);
  static const Color alert = Color(0xFFF50029);
  static const Color splashStartColor = Color(0xFFc91773);
  static const Color splashEndColor = Color(0xFFc9175e);
  static const Color dpeA = Color(0xFF00a06c);
  static const Color dpeB = Color(0xFF50b154);
  static const Color dpeC = Color(0xFFa4cc73);
  static const Color dpeD = Color(0xFFf2e71b);
  static const Color dpeE = Color(0xFFf1b519);
  static const Color dpeF = Color(0xFFed8335);
  static const Color dpeG = Color(0xFFd71d20);
  static const Color gesA = Color(0xFFa4dbf9);
  static const Color gesB = Color(0xFF8cb5d3);
  static const Color gesC = Color(0xFF7693b3);
  static const Color gesD = Color(0xFF5f6e8d);
  static const Color gesE = Color(0xFF4d506f);
  static const Color gesF = Color(0xFF393651);
  static const Color gesG = Color(0xFF271a34);

  static Map<int, Color> colorCodes = {
    50: const Color.fromRGBO(201, 23, 115, .1),
    100: const Color.fromRGBO(201, 23, 115, .2),
    200: const Color.fromRGBO(201, 23, 115, .3),
    300: const Color.fromRGBO(201, 23, 115, .4),
    400: const Color.fromRGBO(201, 23, 115, .5),
    500: const Color.fromRGBO(201, 23, 115, .6),
    600: const Color.fromRGBO(201, 23, 115, .7),
    700: const Color.fromRGBO(201, 23, 115, .8),
    800: const Color.fromRGBO(201, 23, 115, .9),
    900: const Color.fromRGBO(201, 23, 115, 1),
  }; // Opacity 20%

  static MaterialColor defaultColorMaterial =
      MaterialColor(0xFFC91773, colorCodes);
}
