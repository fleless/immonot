import 'dart:async';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:immonot/constants/app_constants.dart';
import 'package:immonot/models/fake/filtersModel.dart';
import 'package:immonot/models/requests/create_alerte_request.dart';
import 'package:immonot/models/requests/search_request.dart';
import 'package:immonot/models/responses/DetailAnnonceResponse.dart';
import 'package:immonot/models/responses/SearchResponse.dart';
import 'package:immonot/models/responses/places_response.dart';
import 'package:immonot/models/responses/themes_response.dart';
import 'package:immonot/network/repository/places_repository.dart';
import 'package:immonot/network/repository/profil_repository.dart';
import 'package:immonot/network/repository/search_annonces_repository.dart';
import 'package:immonot/utils/shared_preferences.dart';
import 'package:rxdart/rxdart.dart';

class HomeBloc extends Disposable {
  final controller = StreamController();
  final PlacesRepository _placesRepository = PlacesRepository();
  final ProfilRepository _profilRepository = ProfilRepository();
  final SearchAnnoncesRepository _searchAnnoncesRepository =
      SearchAnnoncesRepository();
  FilterModels currentFilter = FilterModels();
  final changesNotifier = PublishSubject<bool>();

  /// to notify when saving alert
  /// ths purpose is updating widgetsx
  final detailChangesNotifier = PublishSubject<bool>();

  /// to notify when following price from honoraires
  /// notify search_result_screen
  final suiviPrixFromHonoraireSearchScreenNotifier = PublishSubject<String>();

  final triNotifier = PublishSubject<String>();
  String tri = "";
  final SharedPref sharedPref = SharedPref();
  List<ThemeResponse> themesList = <ThemeResponse>[];
  final themesNotifier = PublishSubject<bool>();

  Future<List<PlacesResponse>> searchPlaces(String item) async {
    List<PlacesResponse> response = await _placesRepository.searchPlaces(item);
    return response;
  }

  Future<SearchResponse> searchAnnonces(int pageNumber, Recherche request,
      String sort, bool _saveSearch, FilterModels filterModel) async {
    SearchResponse response = await _searchAnnoncesRepository.searchAnnonces(
        pageNumber, request, sort);
    //Save last search request params
    if (_saveSearch) sharedPref.save(AppConstants.LAST_FILTER, filterModel);
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

  Future<List<ThemeResponse>> getThemes() async {
    themesList = await _profilRepository.getThemes();
    themesNotifier.add(true);
  }

  notifChanges() {
    changesNotifier.add(true);
  }

  notifTri(String value) {
    triNotifier.add(value);
  }

  notifyDetailChanges(bool favorite) {
    detailChangesNotifier.add(favorite);
  }

  suiviPrixnotifier(String annonceId) {
    suiviPrixFromHonoraireSearchScreenNotifier.add(annonceId);
  }

  dispose() {
    controller.close();
    changesNotifier.close();
    triNotifier.close();
    detailChangesNotifier.close();
    suiviPrixFromHonoraireSearchScreenNotifier.close();
    themesNotifier.close();
  }

  reinitCurrentFilter() {
    currentFilter = FilterModels();
  }
}
