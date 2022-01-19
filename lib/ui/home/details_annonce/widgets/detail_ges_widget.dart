import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:immonot/constants/app_colors.dart';
import 'package:immonot/constants/app_images.dart';
import 'package:immonot/constants/styles/app_styles.dart';
import 'package:immonot/models/fake/fakeResults.dart';
import 'package:immonot/models/responses/DetailAnnonceResponse.dart';

class DetailGesWidget extends StatefulWidget {
  //For now wee pass type to static values until we get endpoint and change this with int id
  DetailAnnonceResponse idAnnonce;

  DetailGesWidget(DetailAnnonceResponse id) {
    this.idAnnonce = id;
  }

  @override
  State<StatefulWidget> createState() => _DetailGesWidgetState();
}

class _DetailGesWidgetState extends State<DetailGesWidget> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  DetailAnnonceResponse _fakeItem;
  bool expanded = false;
  double ges;
  String gesPosition;
  Color gesColor;

//TODO: null condition
  @override
  void initState() {
    super.initState();
    _fakeItem = widget.idAnnonce;
    ges = _fakeItem.energie.ges;
    getGesPosition();
    getGesColor();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void getGesPosition() {
    if ((_fakeItem.energie.vierge) || (_fakeItem.energie.exempte)) {
      gesPosition = "null";
    } else {
      gesPosition = _fakeItem.energie.gesNote;
    }
  }

  void getGesColor() {
    if ((_fakeItem.energie.vierge) || (_fakeItem.energie.exempte)) {
      gesColor = AppColors.nullEnergy;
    } else if (gesPosition == "A") {
      gesColor = AppColors.gesA;
    } else if (gesPosition == "B") {
      gesColor = AppColors.gesB;
    } else if (gesPosition == "C") {
      gesColor = AppColors.gesC;
    } else if (gesPosition == "D") {
      gesColor = AppColors.gesD;
    } else if (gesPosition == "E") {
      gesColor = AppColors.gesE;
    } else if (gesPosition == "F") {
      gesColor = AppColors.gesF;
    } else if (gesPosition == "G") {
      gesColor = AppColors.gesG;
    }
  }

  @override
  Widget build(BuildContext context) {
    return _buildDpeWidget();
  }

  Widget _buildDpeWidget() {
    return Container(
      width: double.infinity,
      child: Column(
        children: [
          InkWell(
            onTap: () {
              setState(() {
                expanded = !expanded;
              });
            },
            child: Container(
              height: 60,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 10),
                    child: FaIcon(
                        expanded
                            ? FontAwesomeIcons.chevronUp
                            : FontAwesomeIcons.chevronDown,
                        color: AppColors.defaultColor,
                        size: 16),
                  ),
                  SizedBox(width: 25),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("GES", style: AppStyles.mediumTitleStyle),
                        SizedBox(height: 2),
                        Text("Emissions de gaz à effet de serre",
                            style: AppStyles.textNormal,
                            overflow: TextOverflow.clip,
                            maxLines: 2),
                      ],
                    ),
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: Container(
                      height: 45,
                      width: 80,
                      child: Stack(
                        children: [
                          Center(
                            child: Container(
                              width: double.infinity,
                              height: double.infinity,
                              child: Image.asset(AppImages.customShape,
                                  fit: BoxFit.fill, color: gesColor),
                            ),
                          ),
                          Center(
                            child: Text(
                              ges == null
                                  ? 'VIERGE'
                                  : gesPosition + " (" + ges.toString() + ")",
                              style: AppStyles.whiteTitleStyle,
                              overflow: TextOverflow.clip,
                              maxLines: 1,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 15),
          expanded ? _buildPyramid() : SizedBox.shrink(),
        ],
      ),
    );
  }

  Widget _buildPyramid() {
    return ((_fakeItem.energie.exempte) || (_fakeItem.energie.vierge))
        ? Container(
            margin: EdgeInsets.symmetric(vertical: 5),
            child: Text(
              _fakeItem.energie.exempte ? "Ges non requis" : "Ges vierge",
              style: AppStyles.hintSearch,
            ),
          )
        : Container(
            width: double.infinity,
            color: AppColors.white,
            child: Column(children: [
              Container(
                child: Image.network(_fakeItem.energie.gesEtiquette,
                    fit: BoxFit.contain),
              ),
              SizedBox(height: 15),
              Container(
                color: AppColors.grey,
                height: 1,
                margin: EdgeInsets.symmetric(horizontal: 15),
              ),
              SizedBox(height: 20),
              _buildSubtitleGes(),
              SizedBox(
                height: 30,
              ),
            ]),
          );
  }

  _buildSubtitleGes() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        children: [
          Center(
            child: Text(
              'Émissions de gaz à effet de serre',
              style: AppStyles.titleStyleH2,
              maxLines: 10,
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Center(
            child: Text(
              'Émissions de gaz à effet de serre (GES) pour le chauffage, la production d\'eau chaude sanitaire et le refroidissement Indice de mesure : kgeqCO2/m 2 .an',
              style: AppStyles.subTitleStyle,
              maxLines: 10,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
