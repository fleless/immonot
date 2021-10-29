import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:immonot/constants/styles/app_styles.dart';
import 'package:immonot/models/responses/DetailAnnonceResponse.dart';

Widget buildCaracteristiqueDetail(DetailAnnonceResponse item) {
  int __indexEtatGeneral = item.caracteristiques.complements
      .indexWhere((element) => element.key == "ETAT_GENERAL");
  int _indexChauffage = item.caracteristiques.complements
      .indexWhere((element) => element.key == "CHAUFFAGE_ELECTRICITE");
  int _indexMeuble = item.caracteristiques.complements
      .indexWhere((element) => element.key == "MEUBLE");
  int _indexNbEtages = item.caracteristiques.complements
      .indexWhere((element) => element.key == "NOMBRE_ETAGES");
  int _indexTerrasse = item.caracteristiques.complements
      .indexWhere((element) => element.key == "TERRASSE");
  int _indexPlacesParking = item.caracteristiques.complements
      .indexWhere((element) => element.key == "PLACES_PARKING");
  int _indexGarage = item.caracteristiques.complements
      .indexWhere((element) => element.key == "NOMBRE_GARAGES");
  int _indexConstruction = item.caracteristiques.complements
      .indexWhere((element) => element.key == "ANNEE_CONSTRUCTION");
  int _indexReference = item.caracteristiques.complements
      .indexWhere((element) => element.key == "REFERENCE");
  int _indexCave = item.caracteristiques.complements
      .indexWhere((element) => element.key == "CAVE");

  return Wrap(
    spacing: 0,
    runSpacing: 25,
    crossAxisAlignment: WrapCrossAlignment.start,
    alignment: WrapAlignment.start,
    children: [
      item.caracteristiques.surfaceHabitable == 0
          ? SizedBox.shrink()
          : _buildColumn("Surface Habitable",
              item.caracteristiques.surfaceHabitable.toString() + " m²"),
      item.caracteristiques.surfaceTerrain == 0
          ? SizedBox.shrink()
          : _buildColumn("Surface terrain",
              item.caracteristiques.surfaceTerrain.toString() + " m²"),
      item.caracteristiques.nbPieces == 0
          ? SizedBox.shrink()
          : _buildColumn("Pièces", item.caracteristiques.nbPieces.toString()),
      item.caracteristiques.nbChambres == 0
          ? SizedBox.shrink()
          : _buildColumn(
              "Chambres", item.caracteristiques.nbChambres.toString()),
      _indexMeuble == -1
          ? SizedBox.shrink()
          : _buildColumn("Meublé",
              item.caracteristiques.complements[_indexMeuble].value.toString()),
      _indexChauffage == -1
          ? SizedBox.shrink()
          : _buildColumn(
              "Chauffage",
              item.caracteristiques.complements[_indexChauffage].value
                  .toString()),
      _indexNbEtages == -1
          ? SizedBox.shrink()
          : _buildColumn(
              "Nombre d'étage(s)",
              item.caracteristiques.complements[_indexNbEtages].value
                  .toString()),
      _indexTerrasse == -1
          ? SizedBox.shrink()
          : _buildColumn(
              "Terasse",
              item.caracteristiques.complements[_indexTerrasse].value
                  .toString()),
      _indexPlacesParking == -1
          ? SizedBox.shrink()
          : _buildColumn(
              "Place(s) parking",
              item.caracteristiques.complements[_indexPlacesParking].value
                  .toString()),
      _indexGarage == -1
          ? SizedBox.shrink()
          : _buildColumn("Garage(s)",
              item.caracteristiques.complements[_indexGarage].value.toString()),
      _indexConstruction == -1
          ? SizedBox.shrink()
          : _buildColumn(
              "Année construction",
              item.caracteristiques.complements[_indexConstruction].value
                  .toString()),
      __indexEtatGeneral == -1
          ? SizedBox.shrink()
          : _buildColumn(
              "État général",
              item.caracteristiques.complements[__indexEtatGeneral].value
                  .toString()),
      _indexReference == -1
          ? SizedBox.shrink()
          : _buildColumn(
              "Référence",
              item.caracteristiques.complements[_indexReference].value
                  .toString()),
      _indexCave == -1
          ? SizedBox.shrink()
          : _buildColumn("Cave",
              item.caracteristiques.complements[_indexCave].value.toString()),
    ],
  );
}

//A workaround to get space valid between wrap children when it has many sizedBox.shrink() :: so much space
Widget _buildColumn(String titre, String data) {
  return Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(titre,
              style: AppStyles.hintSearch,
              maxLines: 1,
              overflow: TextOverflow.ellipsis),
          Text(data,
              style: AppStyles.textNormal,
              maxLines: 1,
              overflow: TextOverflow.ellipsis)
        ],
      ),
      SizedBox(width: 33),
    ],
  );
}
