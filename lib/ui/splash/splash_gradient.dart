import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:immonot/constants/app_colors.dart';

LinearGradient SplashGradient() {
  return LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    transform: GradientRotation(pi / 2),
    colors: [
      AppColors.splashEndColor,
      AppColors.splashStartColor,
    ],
  );
}
