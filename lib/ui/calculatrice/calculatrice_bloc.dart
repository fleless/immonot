import 'dart:async';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:immonot/models/responses/capacite_emprunt_response.dart';
import 'package:immonot/models/responses/frais_notaires_response.dart';
import 'package:immonot/models/responses/montant_mensualite_response.dart';
import 'package:immonot/network/repository/calculatrice_repository.dart';

class CalculatriceBloc extends Disposable {
  final controller = StreamController();
  final CalculatriceRepository _calculatriceRepository =
      CalculatriceRepository();
  MontantMensualiteResponse montantMensualiteResponse =
      MontantMensualiteResponse();
  CapaciteEmpruntResponse capaciteEmpruntResponse = CapaciteEmpruntResponse();
  FraisNotairesResponse fraisNotairesResponse = FraisNotairesResponse();

  Future<MontantMensualiteResponse> calculMontantMensualite(
      double capital, double interet, int duree) async {
    MontantMensualiteResponse response = await _calculatriceRepository
        .calculMontantMensualite(capital, interet, duree);
    montantMensualiteResponse = response;
    return response;
  }

  Future<CapaciteEmpruntResponse> calculCapaciteEmprunt(
      double interet, int mensualite) async {
    CapaciteEmpruntResponse response = await _calculatriceRepository
        .calculCapaciteEmprunt(interet, mensualite);
    capaciteEmpruntResponse = response;
    return response;
  }

  Future<FraisNotairesResponse> calculFraisNotaires(
      double prix, String departement) async {
    FraisNotairesResponse response = await _calculatriceRepository
        .calculFraisNotaires(prix, departement);
    fraisNotairesResponse = response;
    return response;
  }

  dispose() {
    controller.close();
  }
}
