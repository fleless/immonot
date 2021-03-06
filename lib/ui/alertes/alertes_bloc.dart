import 'dart:async';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:immonot/models/requests/create_alerte_request.dart';
import 'package:immonot/models/responses/get_alertes_response.dart';
import 'package:immonot/models/responses/places_response.dart';
import 'package:immonot/network/repository/alertes_repository.dart';
import 'package:immonot/network/repository/places_repository.dart';
import 'package:rxdart/rxdart.dart';

class AlertesBloc extends Disposable {
  final controller = StreamController();
  final _alertesRepository = AlertesRepository();
  final _placesRepository = PlacesRepository();
  Recherche selectedAlerte = Recherche();
  final changesNotifier = PublishSubject<bool>();

  Future<bool> addAlerte(CreateAlerteRequest req) async {
    return _alertesRepository.ajouterAlerte(req);
  }

  Future<GetAlertesResponse> getAlertes(int pageId) async {
    return _alertesRepository.getAlertes(pageId);
  }

  Future<bool> supprimerAlertes(String idAlerte) async {
    return _alertesRepository.supprimerAlertes(idAlerte);
  }

  Future<bool> modifierAlertes(CreateAlerteRequest alerte, num idAlerte) async {
    return _alertesRepository.modifierAlertes(alerte, idAlerte);
  }

  Future<PlacesResponse> searchDepartment(String codeDep) async {
    return _placesRepository.searchDepartment(codeDep);
  }

  Future<PlacesResponse> searchCommune(String oidCommune) async {
    return _placesRepository.searchCommune(oidCommune);
  }

  dispose() {
    controller.close();
    changesNotifier.close();
  }
}
