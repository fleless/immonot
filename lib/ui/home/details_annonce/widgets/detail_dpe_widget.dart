import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:immonot/constants/app_colors.dart';
import 'package:immonot/constants/app_images.dart';
import 'package:immonot/constants/styles/app_styles.dart';
import 'package:immonot/models/fake/fakeResults.dart';
import 'package:immonot/models/responses/DetailAnnonceResponse.dart';

class DetailDpeWidget extends StatefulWidget {
  //For now wee pass type to static values until we get endpoint and change this with int id
  DetailAnnonceResponse idAnnonce;

  DetailDpeWidget(DetailAnnonceResponse id) {
    this.idAnnonce = id;
  }

  @override
  State<StatefulWidget> createState() => _DetailDpeWidgetState();
}

class _DetailDpeWidgetState extends State<DetailDpeWidget> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  DetailAnnonceResponse _fakeItem;
  bool expanded = false;
  double dpe;
  String dpePosition;
  Color dpeColor;

  @override
  void initState() {
    super.initState();
    _fakeItem = widget.idAnnonce;
    dpe = _fakeItem.energie.energie;
    getDpePosition();
    getDpeColor();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void getDpePosition() {
    if ((_fakeItem.energie.vierge) || (_fakeItem.energie.exempte)) {
      dpePosition = "null";
    } else {
      dpePosition = _fakeItem.energie.energieNote;
    }
  }

  void getDpeColor() {
    if ((_fakeItem.energie.vierge) || (_fakeItem.energie.exempte)) {
      dpeColor = AppColors.nullEnergy;
    } else if (dpePosition == "A") {
      dpeColor = AppColors.dpeA;
    } else if (dpePosition == "B") {
      dpeColor = AppColors.dpeB;
    } else if (dpePosition == "C") {
      dpeColor = AppColors.dpeC;
    } else if (dpePosition == "D") {
      dpeColor = AppColors.dpeD;
    } else if (dpePosition == "E") {
      dpeColor = AppColors.dpeE;
    } else if (dpePosition == "F") {
      dpeColor = AppColors.dpeF;
    } else if (dpePosition == "G") {
      dpeColor = AppColors.dpeG;
    }
    print("dpe color is " + dpeColor.toString());
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
                        Text("DPE", style: AppStyles.mediumTitleStyle),
                        SizedBox(height: 2),
                        Text("Consommations énergétiques",
                            style: AppStyles.textNormal)
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
                                  fit: BoxFit.fill, color: dpeColor),
                            ),
                          ),
                          Center(
                            child: Text(
                              dpe == null
                                  ? 'VIERGE'
                                  : dpePosition + " (" + dpe.toString() + ")",
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
                _fakeItem.energie.exempte ? "Dpe non requis" : "Dpe vierge", style: AppStyles.hintSearch,),
          )
        : Container(
            width: double.infinity,
            color: AppColors.white,
            child: Column(children: [
              Container(
                child: Image.network(_fakeItem.energie.energieEtiquette,
                    fit: BoxFit.contain),
              ),
              SizedBox(height: 15),
              Container(
                color: AppColors.grey,
                height: 1,
                margin: EdgeInsets.symmetric(horizontal: 15),
              ),
              SizedBox(height: 20),
              _buildSubtitleDpe(),
              SizedBox(
                height: 30,
              ),
            ]),
          );
  }

  _buildSubtitleDpe() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        children: [
          Center(
            child: Text(
              'Consommations énergétiques',
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
              'Consommations énergétiques (en énergie primaire) pour le chauffage, la production d\'eau chaude sanitaire et le refroidissement Indice de mesure : kWhEP/m 2 .an',
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
