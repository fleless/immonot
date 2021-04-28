import 'dart:async';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:immonot/models/responses/places_response.dart';
import 'package:immonot/network/repository/places_repository.dart';

class HomeBloc extends Disposable {
  final controller = StreamController();
  final PlacesRepository _placesRepository = PlacesRepository();
  final List<PlacesResponse> tagsList = <PlacesResponse>[];

  Future<List<PlacesResponse>> searchPlaces(String item) async {
    List<PlacesResponse> response = await _placesRepository.searchPlaces(item);
    return response;
  }

  dispose() {
    controller.close();
  }
}
