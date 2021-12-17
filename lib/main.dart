import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'modules/app/app_module.dart';

/// Application entry point
// Wraps  main module in ModularApp to initialize it with Modular
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(backgroundHandler);
  runApp(ModularApp(module: AppModule()));
}

//Recieve message when app is in background
Future<void> backgroundHandler(RemoteMessage message) async {}
