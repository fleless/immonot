import 'package:immonot/models/responses/capacite_emprunt_response.dart';
import 'package:immonot/models/responses/frais_notaires_response.dart';
import 'package:immonot/models/responses/montant_mensualite_response.dart';
import 'package:immonot/network/api/calculatrice_api_provider.dart';

class CalculatriceRepository {
  CalculatriceApiProvider _apiProvider = new CalculatriceApiProvider();

  Future<MontantMensualiteResponse> calculMontantMensualite(
      double capital, double interet, int duree) {
    return _apiProvider.calculMontantMensualite(capital, interet, duree);
  }

  Future<CapaciteEmpruntResponse> calculCapaciteEmprunt(
      double interet, int mensualite) {
    return _apiProvider.calculCapaciteEmprunt(interet, mensualite);
  }

  Future<FraisNotairesResponse> calculFraisNotaires(
      double prix, String departement) {
    return _apiProvider.calculFraisNotaires(prix, departement);
  }
}
