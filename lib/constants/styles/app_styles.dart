import 'dart:ui';
import 'package:flutter/material.dart';

import '../app_colors.dart';

/// This class provides custom styles to be used in the project.
///
class AppStyles {
  AppStyles._();

  static const underlinedSelectionedText = TextStyle(
    shadows: [Shadow(color: AppColors.white, offset: Offset(0, -5))],
    fontFamily: 'openSans',
    color: Colors.transparent,
    fontWeight: FontWeight.w600,
    fontSize: 16,
    decoration: TextDecoration.underline,
    decorationColor: AppColors.white,
    decorationThickness: 2,
  );

  static const notSelectionedText = TextStyle(
    shadows: [Shadow(color: AppColors.white, offset: Offset(0, -5))],
    fontFamily: 'openSans',
    color: Colors.transparent,
    fontWeight: FontWeight.w300,
    fontSize: 14,
  );

  static const selectionedItemText = TextStyle(
    fontFamily: 'openSans',
    color: AppColors.white,
    fontWeight: FontWeight.w400,
    fontSize: 14,
  );

  static const notSelectionedItemText = TextStyle(
    fontFamily: 'openSans',
    color: AppColors.white,
    fontWeight: FontWeight.w300,
    fontSize: 13,
  );

  static const hintSearch = TextStyle(
    fontFamily: 'openSans',
    color: AppColors.hint,
    fontWeight: FontWeight.w400,
    fontSize: 14,
  );

  static const textNormal = TextStyle(
    fontFamily: 'openSans',
    color: AppColors.default_black,
    fontWeight: FontWeight.w400,
    fontSize: 16,
  );

  static const buttonTextWhite = TextStyle(
    fontFamily: 'openSans',
    color: AppColors.white,
    fontWeight: FontWeight.w600,
    fontSize: 16,
  );

  static const titleStyle = TextStyle(
    fontFamily: 'openSans',
    color: AppColors.default_black,
    fontWeight: FontWeight.w700,
    fontSize: 22,
  );

  static const titleStyleH2 = TextStyle(
    fontFamily: 'openSans',
    color: AppColors.default_black,
    fontWeight: FontWeight.w700,
    fontSize: 18,
  );

  static const smallTitleStyleBlack = TextStyle(
    fontFamily: 'openSans',
    color: AppColors.default_black,
    fontWeight: FontWeight.w700,
    fontSize: 14,
  );

  static const typeAnnonceBlack = TextStyle(
    fontFamily: 'openSans',
    color: AppColors.default_black,
    fontWeight: FontWeight.w700,
    fontSize: 12,
  );

  static const smallTitleStylePink = TextStyle(
    fontFamily: 'openSans',
    color: AppColors.defaultColor,
    fontWeight: FontWeight.w700,
    fontSize: 14,
  );

  static const subTitleStyle = TextStyle(
    fontFamily: 'openSans',
    color: AppColors.default_black,
    fontWeight: FontWeight.w400,
    fontSize: 14,
  );

  static const bottomNavTextStyle = TextStyle(
    fontFamily: 'openSans',
    color: AppColors.defaultColor,
    fontWeight: FontWeight.w400,
    fontSize: 10,
  );

  static const bottomNavTextNotSelectedStyle = TextStyle(
    fontFamily: 'openSans',
    color: AppColors.default_black,
    fontWeight: FontWeight.w400,
    fontSize: 10,
  );

  static const typeAnnoncesAchat = TextStyle(
    fontFamily: 'openSans',
    color: AppColors.defaultColor,
    fontWeight: FontWeight.w700,
    fontSize: 12,
  );

  static const typeAnnoncesLocation = TextStyle(
    fontFamily: 'openSans',
    color: AppColors.greenColor,
    fontWeight: FontWeight.w700,
    fontSize: 12,
  );

  static const typeAnnoncesVenteAuxEncheres = TextStyle(
    fontFamily: 'openSans',
    color: AppColors.orangeColor,
    fontWeight: FontWeight.w700,
    fontSize: 12,
  );

  static const typeAnnoncesEVente = TextStyle(
    fontFamily: 'openSans',
    color: AppColors.blueTypeColor,
    fontWeight: FontWeight.w700,
    fontSize: 12,
  );

  static const typeAnnoncesViager = TextStyle(
    fontFamily: 'openSans',
    color: AppColors.viagerColor,
    fontWeight: FontWeight.w700,
    fontSize: 12,
  );

  static const genreAnnonces = TextStyle(
    fontFamily: 'openSans',
    color: AppColors.hint,
    fontWeight: FontWeight.w700,
    fontSize: 12,
  );

  static const locationAnnonces = TextStyle(
    fontFamily: 'openSans',
    color: AppColors.default_black,
    fontWeight: FontWeight.w400,
    fontSize: 12,
  );

  static const nbrPictures = TextStyle(
    fontFamily: 'openSans',
    color: AppColors.white,
    fontWeight: FontWeight.w500,
    fontSize: 12,
  );

  static const offreStyle = TextStyle(
    fontFamily: 'openSans',
    color: AppColors.white,
    fontWeight: FontWeight.w400,
    fontSize: 13,
  );

  static const whiteTitleStyle = TextStyle(
    fontFamily: 'openSans',
    color: AppColors.white,
    fontWeight: FontWeight.w700,
    fontSize: 13,
  );

  static const filterSubStyle = TextStyle(
    fontFamily: 'openSans',
    color: AppColors.default_black,
    fontWeight: FontWeight.w400,
    fontSize: 14,
  );
}
