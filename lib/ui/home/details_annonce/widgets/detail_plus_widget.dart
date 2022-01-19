import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:immonot/constants/app_colors.dart';
import 'package:immonot/constants/styles/app_styles.dart';
import 'package:immonot/models/fake/fakeResults.dart';
import 'package:immonot/models/responses/DetailAnnonceResponse.dart';

Widget buildPlusDetail(DetailAnnonceResponse item) {
  int _indexCommerce = item.caracteristiques.complements
      .indexWhere((element) => element.key == "COMMODITE_COMMERCES");
  int _indexEcole = item.caracteristiques.complements
      .indexWhere((element) => element.key == "COMMODITE_ECOLE");
  int _indexService = item.caracteristiques.complements
      .indexWhere((element) => element.key == "COMMODITE_SERVICES");
  int _indexCentreVille = item.caracteristiques.complements
      .indexWhere((element) => element.key == "COMMODITE_CENTRE_VILLE");
  int _indexGare = item.caracteristiques.complements
      .indexWhere((element) => element.key == "COMMODITE_GARE");
  int _indexMetro = item.caracteristiques.complements
      .indexWhere((element) => element.key == "COMMODITE_METRO");
  int _indexBus = item.caracteristiques.complements
      .indexWhere((element) => element.key == "COMMODITE_BUS");
  int _indexTramway = item.caracteristiques.complements
      .indexWhere((element) => element.key == "COMMODITE_TRAMWAY");

  return Wrap(
    alignment: WrapAlignment.start,
    crossAxisAlignment: WrapCrossAlignment.start,
    runAlignment: WrapAlignment.start,
    spacing: 0,
    runSpacing: 25,
    children: [
      _indexCommerce == -1
          ? SizedBox.shrink()
          : _buildColumn(FontAwesomeIcons.building, "COMMERCES"),
      _indexEcole == -1
          ? SizedBox.shrink()
          : _buildColumn(FontAwesomeIcons.university, "ÉCOLE"),
      _indexService == -1
          ? SizedBox.shrink()
          : _buildColumn(FontAwesomeIcons.handsHelping, "SERVICES"),
      _indexCentreVille == -1
          ? SizedBox.shrink()
          : _buildColumn(FontAwesomeIcons.home, "CENTRE VILLE"),
      _indexGare == -1
          ? SizedBox.shrink()
          : _buildColumn(FontAwesomeIcons.train, "GARE"),
      _indexMetro == -1
          ? SizedBox.shrink()
          : _buildColumn(FontAwesomeIcons.subway, "MÉTRO"),
      _indexBus == -1
          ? SizedBox.shrink()
          : _buildColumn(FontAwesomeIcons.bus, "Bus"),
      _indexTramway == -1
          ? SizedBox.shrink()
          : _buildColumn(FontAwesomeIcons.tram, "Tramway"),

    ],
  );
}

Widget _buildColumn(IconData icon, String data) {
  return Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          FaIcon(icon, color: AppColors.default_black, size: 15),
          SizedBox(height: 5),
          Text(data,
              style: AppStyles.filterSubStyle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis)
        ],
      ),
      SizedBox(width: 20),
    ],
  );
}
