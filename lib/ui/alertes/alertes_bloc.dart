import 'dart:async';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:immonot/models/requests/create_alerte_request.dart';
import 'package:immonot/models/responses/get_alertes_response.dart';
import 'package:immonot/network/repository/alertes_repository.dart';

class AlertesBloc extends Disposable {
  final controller = StreamController();
  final _alertesRepository = AlertesRepository();

  Future<bool> addAlerte(CreateAlerteRequest req) async {
    return _alertesRepository.ajouterAlerte(req);
  }

  Future<GetAlertesResponse> getAlertes(int pageId) async {
    return _alertesRepository.getAlertes(pageId);
  }

  Future<bool> supprimerAlertes(String idAlerte) async {
    return _alertesRepository.supprimerAlertes(idAlerte);
  }

  dispose() {
    controller.close();
  }
}
