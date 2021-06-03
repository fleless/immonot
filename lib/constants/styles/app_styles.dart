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

  static const textNormalTitleStyle = TextStyle(
    fontFamily: 'openSans',
    color: AppColors.default_black,
    fontWeight: FontWeight.w400,
    fontSize: 18,
  );
  static const titleNormal = TextStyle(
    fontFamily: 'openSans',
    color: AppColors.default_black,
    fontWeight: FontWeight.w400,
    fontSize: 18,
  );

  static const buttonTextWhite = TextStyle(
    fontFamily: 'openSans',
    color: AppColors.white,
    fontWeight: FontWeight.w600,
    fontSize: 15,
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

  static const titleStyleWhite = TextStyle(
    fontFamily: 'openSans',
    color: AppColors.white,
    fontWeight: FontWeight.w700,
    fontSize: 20,
  );

  static const titleStylePink = TextStyle(
    fontFamily: 'openSans',
    color: AppColors.defaultColor,
    fontWeight: FontWeight.w700,
    fontSize: 20,
  );

  static const mediumTitleStyle = TextStyle(
    fontFamily: 'openSans',
    color: AppColors.default_black,
    fontWeight: FontWeight.w700,
    fontSize: 16,
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

  static const pinkTwelveNormalStyle = TextStyle(
    fontFamily: 'openSans',
    color: AppColors.defaultColor,
    fontWeight: FontWeight.w400,
    fontSize: 12,
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

  static const pinkTitleStyle = TextStyle(
    fontFamily: 'openSans',
    color: AppColors.defaultColor,
    fontWeight: FontWeight.w700,
    fontSize: 13,
  );

  static const pinkButtonStyle = TextStyle(
    fontFamily: 'openSans',
    color: AppColors.defaultColor,
    fontWeight: FontWeight.w700,
    fontSize: 16,
  );

  static const filterSubStyle = TextStyle(
    fontFamily: 'openSans',
    color: AppColors.default_black,
    fontWeight: FontWeight.w400,
    fontSize: 14,
  );

  static const underlinedNotaireText = TextStyle(
    shadows: [Shadow(color: AppColors.white, offset: Offset(0, -5))],
    fontFamily: 'openSans',
    color: AppColors.default_black,
    fontWeight: FontWeight.w700,
    fontSize: 16,
    decoration: TextDecoration.underline,
    decorationColor: AppColors.default_black,
    decorationThickness: 2,
  );

  static const underlinedBaremeHonoraireStyle = TextStyle(
    shadows: [Shadow(color: AppColors.defaultColor, offset: Offset(0, -5))],
    fontFamily: 'openSans',
    color: Colors.transparent,
    fontWeight: FontWeight.w400,
    fontSize: 13,
    decoration: TextDecoration.underline,
    decorationColor: AppColors.defaultColor,
    decorationThickness: 2,
  );

  static const detailsBottomStyle = TextStyle(
    fontFamily: 'openSans',
    color: AppColors.white,
    fontWeight: FontWeight.w300,
    fontSize: 12,
  );

  static const textDescriptionStyle = TextStyle(
    fontFamily: 'openSans',
    color: AppColors.default_black,
    fontWeight: FontWeight.w400,
    height: 1.3,
    fontSize: 15,
  );

  static const textDescriptionBoldStyle = TextStyle(
    fontFamily: 'openSans',
    color: AppColors.default_black,
    fontWeight: FontWeight.w700,
    height: 1.3,
    fontSize: 15,
  );

  static const textDescriptionDefaultColorStyle = TextStyle(
    fontFamily: 'openSans',
    color: AppColors.defaultColor,
    fontWeight: FontWeight.w400,
    height: 1.3,
    fontSize: 15,
  );

  static const pinkTextDescriptionStyle = TextStyle(
    fontFamily: 'openSans',
    color: AppColors.defaultColor,
    fontWeight: FontWeight.w400,
    height: 1.3,
    fontSize: 15,
  );

  static const normalTextWhite = TextStyle(
    fontFamily: 'openSans',
    color: AppColors.white,
    fontWeight: FontWeight.w300,
    fontSize: 14,
  );

  static const underlinedButtonWhiteStyle = TextStyle(
    shadows: [Shadow(color: Colors.white, offset: Offset(0, -3))],
    fontFamily: 'openSans',
    color: Colors.transparent,
    fontWeight: FontWeight.w600,
    fontSize: 16,
    decoration: TextDecoration.underline,
    decorationColor: AppColors.white,
    decorationThickness: 1,
  );

  static const errorText = TextStyle(
    fontFamily: 'openSans',
    color: Colors.red,
    fontWeight: FontWeight.w300,
    fontSize: 12,
  );
}
