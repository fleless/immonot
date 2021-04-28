import 'dart:async';

import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_modular/flutter_modular.dart';
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
    SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(statusBarColor: Colors.black));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: Modular.navigatorKey,
      title: AppConstants.title,
      theme: AppTheme.themeData,
      supportedLocales: AppLocalizations.supportedLocales(),
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      onGenerateRoute: Modular.generateRoute,
      initialRoute: Routes.home,
    );
  }

  Future<void> initPlatformState() async {}

  @override
  void dispose() {
    super.dispose();
  }
}
