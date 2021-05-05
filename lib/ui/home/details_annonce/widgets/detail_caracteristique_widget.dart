import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:immonot/constants/styles/app_styles.dart';
import 'package:immonot/models/fake/fakeResults.dart';

Widget buildCaracteristiqueDetail(FakeResults item) {
  return Wrap(
    spacing: 33,
    runSpacing: 25,
    children: [
      _buildColumn("Surface Habitable", "139 m²"),
      _buildColumn("Surface terrain", "195 m²"),
      _buildColumn("Pièces", "6"),
      _buildColumn("Chambres", "4"),
      _buildColumn("Meublé", "Non"),
      _buildColumn("Chauffage", "Gaz"),
      _buildColumn("Nombre d'étage(s)", "2"),
      _buildColumn("Terrasse", "Oui"),
      _buildColumn("Place(s) parking", "1"),
      _buildColumn("Garage", "Oui"),
      _buildColumn("Garage(s)", "1"),
      _buildColumn("Construction", "2000"),
      _buildColumn("État général", "Excellent"),
      _buildColumn("Référence", "016/859"),
    ],
  );
}

Widget _buildColumn(String titre, String data) {
  return Column(
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
  );
}
