import 'package:flutter/material.dart';

/// This class allows for global overrides of material TextStyles
///
class AppTextTheme {
  AppTextTheme._();

  // Example :

  // Add TextTheme properties you wish to override in this const
  // Example to override headline1 style of source TextTheme with a custom TextStyle "_headline1"
  // textTheme = TextTheme(headline1: _headline1);
  static const TextTheme textTheme = TextTheme();

// Add your the custom TextStyles below
// static const TextStyle _headline1 = TextStyle(
//   fontFamily: 'WorkSans',
//   fontWeight: FontWeight.w800,
//   fontSize: 20,
//   letterSpacing: 5,
//   color: AppColors.primary,
// );

}
