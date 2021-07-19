import 'dart:async';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:immonot/models/fake/filtersModel.dart';
import 'package:immonot/models/requests/search_request.dart';
import 'package:immonot/models/responses/DetailAnnonceResponse.dart';
import 'package:immonot/models/responses/SearchResponse.dart';
import 'package:immonot/models/responses/places_response.dart';
import 'package:immonot/network/repository/places_repository.dart';
import 'package:immonot/network/repository/search_annonces_repository.dart';
import 'package:rxdart/rxdart.dart';

class HomeBloc extends Disposable {
  final controller = StreamController();
  final PlacesRepository _placesRepository = PlacesRepository();
  final SearchAnnoncesRepository _searchAnnoncesRepository =
      SearchAnnoncesRepository();
  FilterModels currentFilter = FilterModels();
  final changesNotifier = PublishSubject<bool>();
  final triNotifier = PublishSubject<String>();
  String tri;

  Future<List<PlacesResponse>> searchPlaces(String item) async {
    List<PlacesResponse> response = await _placesRepository.searchPlaces(item);
    return response;
  }

  Future<SearchResponse> searchAnnonces(
      int pageNumber, SearchRequest request, String sort) async {
    SearchResponse response = await _searchAnnoncesRepository.searchAnnonces(
        pageNumber, request, sort);
    return response;
  }

  Future<DetailAnnonceResponse> getDetailAnnonce(String oidAnnonce) async {
    DetailAnnonceResponse response =
        await _searchAnnoncesRepository.getDetailAnnonce(oidAnnonce);
    return response;
  }

  Future<String> contactAnnonce(String oidAnnonce, String nom, String prenom,
      int phone, String email, String message) async {
    String response = await _searchAnnoncesRepository.contactAnnonce(
        oidAnnonce, nom, prenom, phone, email, message);
    return response;
  }

  notifChanges() {
    changesNotifier.add(true);
  }

  notifTri(String value) {
    triNotifier.add(value);
  }

  dispose() {
    controller.close();
    changesNotifier.close();
    triNotifier.close();
  }
}
