import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:immonot/constants/styles/app_styles.dart';
import 'package:immonot/models/responses/DetailAnnonceResponse.dart';

Widget buildCaracteristiqueDetail(DetailAnnonceResponse item) {
  return Wrap(
    spacing: 0,
    runSpacing: 25,
    crossAxisAlignment: WrapCrossAlignment.start,
    alignment: WrapAlignment.start,
    children: [
      item.caracteristiques.surfaceHabitable == 0
          ? SizedBox.shrink()
          : _buildColumn("Surface habitable",
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
      if (item.caracteristiques.nbTetes != null)
        item.caracteristiques.nbTetes == 0
            ? SizedBox.shrink()
            : _buildColumn("Têtes", item.caracteristiques.nbTetes.toString()),
      if (item.caracteristiques.typeChauffage != null)
        item.caracteristiques.typeChauffage.isEmpty
            ? SizedBox.shrink()
            : item.caracteristiques.typeChauffage[0] == ""
                ? SizedBox.shrink()
                : _buildColumn("Chauffage",
                    item.caracteristiques.typeChauffage.join("\n")),
      if (item.caracteristiques.complements != null)
        for (var complement in item.caracteristiques.complements)
          if ((!([
                "COMMODITE_COMMERCES",
                "COMMODITE_ECOLE",
                "COMMODITE_SERVICES",
                "COMMODITE_CENTRE_VILLE",
                "COMMODITE_GARE",
                "COMMODITE_METRO",
                "COMMODITE_BUS",
                "COMMODITE_TRAMWAY",
                "CODE_SOUS_NATURE"
              ].contains(complement.key))) &&
              (complement.value != 0))
            _buildColumn(complement.label, complement.value.toString()),
      if (item.refClient != null)
        if (item.refClient.isNotEmpty)
          _buildColumn("Référence", item.refClient.toString())
    ],
  );
}

//A workaround to get space valid between wrap children when it has many sizedBox.shrink() :: so much space
Widget _buildColumn(String titre, String data) {
  return Container(
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(titre,
                style: AppStyles.hintSearch,
                maxLines: 10,
                overflow: TextOverflow.ellipsis),
            Text(data,
                style: AppStyles.textNormal,
                maxLines: 10,
                overflow: TextOverflow.ellipsis)
          ],
        ),
        SizedBox(width: 33),
      ],
    ),
  );
}
