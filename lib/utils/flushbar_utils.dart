import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:immonot/constants/app_colors.dart';

Flushbar showSuccessToast(BuildContext context, String message) {
  return Flushbar(
    title: 'Succès',
    message: message,
    icon: Icon(
      Icons.check,
      size: 28.0,
      color: AppColors.white,
    ),
    duration: const Duration(seconds: 4),
    backgroundGradient: LinearGradient(
      colors: [Colors.green[600], Colors.green[400]],
    ),
    backgroundColor: Colors.green,
    onTap: (flushbar) => flushbar.dismiss(),
  )..show(context);
}

Flushbar showErrorToast(BuildContext context, String message) {
  return Flushbar(
    title: 'Erreur',
    message: message,
    icon: Icon(
      Icons.error,
      size: 28.0,
      color: AppColors.alert,
    ),
    duration: const Duration(seconds: 4),
    backgroundGradient: LinearGradient(
      colors: [Colors.red[600], Colors.red[400]],
    ),
    backgroundColor: Colors.red,
    onTap: (flushbar) => flushbar.dismiss(),
  )..show(context);
}
