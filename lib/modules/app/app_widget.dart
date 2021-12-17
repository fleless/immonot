import 'dart:async';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:immonot/constants/app_colors.dart';
import 'package:immonot/constants/app_constants.dart';
import 'package:immonot/constants/routes.dart';
import 'package:immonot/constants/styles/app_theme.dart';
import 'package:immonot/utils/app_localization.dart';

class AppWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _AppWidgetState();
}

class _AppWidgetState extends State<AppWidget> {
  @override
  void initState() {
    super.initState();
    initPlatformState();
    Future.delayed(Duration(milliseconds: 1)).then(
        (value) => SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
              systemNavigationBarColor: Colors.black,
              systemNavigationBarDividerColor: Colors.black,
              systemNavigationBarIconBrightness: Brightness.dark,
              statusBarColor: Colors.black,
              statusBarBrightness: Brightness.light,
              statusBarIconBrightness: Brightness.dark,
            )));

    /// handling push notifications functions
    _initFlutterDownloaderPackage();
    initialize(context);
  }

  _initFlutterDownloaderPackage() async {
    ///when app is terminated or closed gives you the message on which user taps
    FirebaseMessaging.instance.getInitialMessage().then((message) {});

    ///Only work on Foreground listener
    FirebaseMessaging.onMessage.listen((event) {});

    ///when app is in background but opened and user taps on the notification
    FirebaseMessaging.onMessageOpenedApp.listen((event) {});
  }

  Future initialize(context) async {
    final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
    if (Platform.isIOS) {
      firebaseMessaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: Modular.navigatorKey,
      title: AppConstants.title,
      color: AppColors.white,
      theme: AppTheme.themeData,
      supportedLocales: AppLocalizations.supportedLocales(),
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      onGenerateRoute: Modular.generateRoute,
      initialRoute: Routes.splash,
    );
  }

  Future<void> initPlatformState() async {}

  @override
  void dispose() {
    super.dispose();
  }
}
