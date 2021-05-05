import 'dart:async';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:immonot/models/fake/filtersModel.dart';
import 'package:immonot/models/responses/places_response.dart';
import 'package:immonot/network/repository/places_repository.dart';
import 'package:rxdart/rxdart.dart';

class FavorisBloc extends Disposable {
  final controller = StreamController();

  dispose() {
    controller.close();
  }
}
