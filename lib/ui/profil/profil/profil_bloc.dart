import 'dart:async';
import 'package:flutter_modular/flutter_modular.dart';

class ProfilBloc extends Disposable {
  final controller = StreamController();


  dispose() {
    controller.close();
  }
}
