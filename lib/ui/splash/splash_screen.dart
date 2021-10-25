import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:immonot/constants/app_colors.dart';
import 'package:immonot/constants/app_constants.dart';
import 'package:immonot/constants/app_icons.dart';
import 'package:immonot/constants/app_images.dart';
import 'package:immonot/models/responses/loginResponse.dart';
import 'package:immonot/ui/home/home_screen.dart';
import 'package:immonot/ui/profil/auth/auth_bloc.dart';
import 'package:immonot/utils/session_controller.dart';
import 'package:immonot/utils/shared_preferences.dart';
import 'package:splashscreen/splashscreen.dart';

class SplashScreenWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SplashScreenWidgetState();
}

class _SplashScreenWidgetState extends State<SplashScreenWidget> {
  final sessionController = Modular.get<SessionController>();
  final authBloc = Modular.get<AuthBloc>();
  final sharedPref = Modular.get<SharedPref>();

  @override
  void initState() {
    _initData();
    super.initState();
  }

  _initData() async {
    if (await sessionController.isSessionConnected()) {
      String email = await sharedPref.read(AppConstants.EMAIL_KEY);
      String password = await sharedPref.read(AppConstants.PASSWORD_KEY);
      LoginResponse resp = await authBloc.login(email, password);
      if (resp != null) {
        if (resp.accessToken != null)
          sharedPref.save(AppConstants.TOKEN_KEY, resp.accessToken);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SplashScreen(
        seconds: 3,
        navigateAfterSeconds: HomeScreen(false),
        image: Image.asset(AppImages.appLogo),
        backgroundColor: Colors.white,
        styleTextUnderTheLoader: new TextStyle(),
        photoSize: 100.0,
        onClick: () => print(""),
        loaderColor: AppColors.defaultColor);
  }
}
