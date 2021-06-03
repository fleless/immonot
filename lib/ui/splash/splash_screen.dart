import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:immonot/constants/app_colors.dart';
import 'package:immonot/ui/home/home_screen.dart';
import 'package:splashscreen/splashscreen.dart';

class SplashScreenWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SplashScreenWidgetState();
}

class _SplashScreenWidgetState extends State<SplashScreenWidget> {

  @override
  Widget build(BuildContext context) {
    return SplashScreen(
        seconds: 2,
        navigateAfterSeconds: HomeScreen(false),
        title: new Text('Welcome In SplashScreen',
          style: new TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20.0
          ),),
        image: new Image.network('https://i.imgur.com/TyCSG9A.png'),
        backgroundColor: Colors.white,
        styleTextUnderTheLoader: new TextStyle(),
        photoSize: 100.0,
        onClick: () => print("Flutter Egypt"),
        loaderColor: AppColors.defaultColor
    );
  }

}
