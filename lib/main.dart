import 'package:flutter/cupertino.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'modules/app/app_module.dart';

/// Application entry point
// Wraps  main module in ModularApp to initialize it with Modular
void main() => runApp(ModularApp(module: AppModule()));
