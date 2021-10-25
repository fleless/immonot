import 'package:immonot/models/requests/create_alerte_request.dart';
import 'package:immonot/models/responses/get_alertes_response.dart';
import 'package:immonot/network/api/alertes_api_provider.dart';

class AlertesRepository {
  AlertesApiProvider _apiProvider = new AlertesApiProvider();

  Future<bool> ajouterAlerte(CreateAlerteRequest alerte) {
    return _apiProvider.ajouterAlertes(alerte);
  }

  Future<GetAlertesResponse> getAlertes(int pageId) async {
    return _apiProvider.getAlertes(pageId);
  }

  Future<bool> supprimerAlertes(String idAlerte) async {
    return _apiProvider.supprimerAlertes(idAlerte);
  }
}
