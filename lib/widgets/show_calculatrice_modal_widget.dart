import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:immonot/constants/app_colors.dart';
import 'package:immonot/constants/routes.dart';
import 'package:immonot/constants/styles/app_styles.dart';
import 'dart:ui' as ui;

Widget ShowCalculatriceModalWidget() {
  double _paddingSpace = 10;
  return Container(
    padding: EdgeInsets.all(15),
    color: Colors.transparent,
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: EdgeInsets.symmetric(vertical: 20),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.all(Radius.circular(15)),
          ),
          child: Column(
            children: [
              Text(
                "Choisissez votre calculatrice",
                style: AppStyles.hintSearch,
              ),
              SizedBox(height: _paddingSpace),
              Divider(color: AppColors.hint),
              SizedBox(height: _paddingSpace),
              InkWell(
                onTap: () {
                  Modular.to
                      .pushNamed(Routes.calculatrice, arguments: {'index': 0});
                },
                child: Container(
                  width: double.infinity,
                  child: RichText(
                    overflow: TextOverflow.clip,
                    maxLines: 1,
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      children: [
                        WidgetSpan(
                          alignment: ui.PlaceholderAlignment.middle,
                          child: FaIcon(
                            FontAwesomeIcons.calculator,
                            color: AppColors.defaultColor,
                            size: 16,
                          ),
                        ),
                        TextSpan(
                            text: "     Montant des mensualités",
                            style: AppStyles.textNormal),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: _paddingSpace),
              Divider(color: AppColors.hint),
              SizedBox(height: _paddingSpace),
              InkWell(
                onTap: () {
                  Modular.to
                      .pushNamed(Routes.calculatrice, arguments: {'index': 1});
                },
                child: Container(
                  width: double.infinity,
                  child: RichText(
                    overflow: TextOverflow.clip,
                    maxLines: 1,
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      children: [
                        WidgetSpan(
                          alignment: ui.PlaceholderAlignment.middle,
                          child: FaIcon(
                            FontAwesomeIcons.euroSign,
                            color: AppColors.defaultColor,
                            size: 16,
                          ),
                        ),
                        TextSpan(
                            text: "     Capacité d'emprunt",
                            style: AppStyles.textNormal),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: _paddingSpace),
              Divider(color: AppColors.hint),
              SizedBox(height: _paddingSpace),
              InkWell(
                onTap: () {
                  Modular.to
                      .pushNamed(Routes.calculatrice, arguments: {'index': 2});
                },
                child: Container(
                  width: double.infinity,
                  child: RichText(
                    overflow: TextOverflow.clip,
                    maxLines: 1,
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      children: [
                        WidgetSpan(
                          alignment: ui.PlaceholderAlignment.middle,
                          child: FaIcon(
                            FontAwesomeIcons.ticketAlt,
                            color: AppColors.defaultColor,
                            size: 16,
                          ),
                        ),
                        TextSpan(
                            text: "     Frais de notaire",
                            style: AppStyles.textNormal),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 20),
        InkWell(
          splashColor: AppColors.defaultColor,
          onTap: () {
            Modular.to.pop();
          },
          child: Container(
            width: double.infinity,
            alignment: Alignment.center,
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 0),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.all(Radius.circular(15)),
            ),
            child: Text("Annuler", style: AppStyles.titleStyleH2),
          ),
        ),
        SizedBox(height: 20),
      ],
    ),
  );
}
