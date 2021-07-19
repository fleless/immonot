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

//TODO: null condition
  @override
  void initState() {
    super.initState();
    _fakeItem = widget.idAnnonce;
    dpe = _fakeItem.energie.energie;
    getDpePosition();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void getDpePosition() {
    if (dpe == null) {
      dpePosition = "null";
      dpeColor = AppColors.nullEnergy;
    } else if (dpe < 51) {
      dpePosition = "A";
      dpeColor = AppColors.dpeA;
    } else if (dpe < 92) {
      dpePosition = "B";
      dpeColor = AppColors.dpeB;
    } else if (dpe < 151) {
      dpePosition = "C";
      dpeColor = AppColors.dpeC;
    } else if (dpe < 231) {
      dpePosition = "D";
      dpeColor = AppColors.dpeD;
    } else if (dpe < 331) {
      dpePosition = "E";
      dpeColor = AppColors.dpeE;
    } else if (dpe < 451) {
      dpePosition = "F";
      dpeColor = AppColors.dpeF;
    } else {
      dpePosition = "G";
      dpeColor = AppColors.dpeG;
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
                              dpe == null ? 'VIERGE' :dpePosition + " (" + dpe.toString() + ")",
                              style: AppStyles.smallTitleStyleBlack,
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
    return Column(
      children: [
        _buildDpeA(),
        _buildDpeB(),
        _buildDpeC(),
        _buildDpeD(),
        _buildDpeE(),
        _buildDpeF(),
        _buildDpeG(),
      ],
    );
  }

  _buildDpeA() {
    return Padding(
      padding: EdgeInsets.only(top: 0),
      child: Row(
        children: [
          Container(
            height: 35,
            width: MediaQuery.of(context).size.width * 0.2,
            color: dpe == null ? AppColors.nullEnergy : AppColors.dpeA,
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("  < 51   ", style: AppStyles.textNormal),
                  Text("A   ", style: AppStyles.titleStyleH2),
                ],
              ),
            ),
          ),
          SizedBox(width: 20),
          dpePosition == "A"
              ? Container(
                  height: 15,
                  width: 17,
                  child: Center(
                    child: Container(
                      width: double.infinity,
                      height: double.infinity,
                      child: Image.asset(AppImages.customShape,
                          fit: BoxFit.fill, color: AppColors.default_black),
                    ),
                  ),
                )
              : SizedBox.shrink(),
        ],
      ),
    );
  }

  _buildDpeB() {
    return Padding(
      padding: EdgeInsets.only(top: 10),
      child: Row(
        children: [
          Container(
            height: 35,
            width: MediaQuery.of(context).size.width * 0.3,
            color: dpe == null ? AppColors.nullEnergy : AppColors.dpeB,
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("  51 à 91  ", style: AppStyles.textNormal),
                  Text("B  ", style: AppStyles.titleStyleH2),
                ],
              ),
            ),
          ),
          SizedBox(width: 20),
          dpePosition == "B"
              ? Container(
                  height: 15,
                  width: 17,
                  child: Center(
                    child: Container(
                      width: double.infinity,
                      height: double.infinity,
                      child: Image.asset(AppImages.customShape,
                          fit: BoxFit.fill, color: AppColors.default_black),
                    ),
                  ),
                )
              : SizedBox.shrink(),
        ],
      ),
    );
  }

  _buildDpeC() {
    return Padding(
      padding: EdgeInsets.only(top: 10),
      child: Row(
        children: [
          Container(
            height: 35,
            width: MediaQuery.of(context).size.width * 0.4,
            color: dpe == null ? AppColors.nullEnergy : AppColors.dpeC,
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("  91 à 150  ", style: AppStyles.textNormal),
                  Text("C  ", style: AppStyles.titleStyleH2),
                ],
              ),
            ),
          ),
          SizedBox(width: 20),
          dpePosition == "C"
              ? Container(
                  height: 15,
                  width: 17,
                  child: Center(
                    child: Container(
                      width: double.infinity,
                      height: double.infinity,
                      child: Image.asset(AppImages.customShape,
                          fit: BoxFit.fill, color: AppColors.default_black),
                    ),
                  ),
                )
              : SizedBox.shrink(),
        ],
      ),
    );
  }

  _buildDpeD() {
    return Padding(
      padding: EdgeInsets.only(top: 10),
      child: Row(
        children: [
          Container(
            height: 35,
            width: MediaQuery.of(context).size.width * 0.5,
            color: dpe == null ? AppColors.nullEnergy : AppColors.dpeD,
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("  151 à 230  ", style: AppStyles.textNormal),
                  Text("D  ", style: AppStyles.titleStyleH2),
                ],
              ),
            ),
          ),
          SizedBox(width: 20),
          dpePosition == "D"
              ? Container(
                  height: 15,
                  width: 17,
                  child: Center(
                    child: Container(
                      width: double.infinity,
                      height: double.infinity,
                      child: Image.asset(AppImages.customShape,
                          fit: BoxFit.fill, color: AppColors.default_black),
                    ),
                  ),
                )
              : SizedBox.shrink(),
        ],
      ),
    );
  }

  _buildDpeE() {
    return Padding(
      padding: EdgeInsets.only(top: 10),
      child: Row(
        children: [
          Container(
            height: 35,
            width: MediaQuery.of(context).size.width * 0.6,
            color: dpe == null ? AppColors.nullEnergy : AppColors.dpeE,
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("  231 à 330  ", style: AppStyles.textNormal),
                  Text("E  ", style: AppStyles.titleStyleH2),
                ],
              ),
            ),
          ),
          SizedBox(width: 20),
          dpePosition == "E"
              ? Container(
                  height: 15,
                  width: 17,
                  child: Center(
                    child: Container(
                      width: double.infinity,
                      height: double.infinity,
                      child: Image.asset(AppImages.customShape,
                          fit: BoxFit.fill, color: AppColors.default_black),
                    ),
                  ),
                )
              : SizedBox.shrink(),
        ],
      ),
    );
  }

  _buildDpeF() {
    return Padding(
      padding: EdgeInsets.only(top: 10),
      child: Row(
        children: [
          Container(
            height: 35,
            width: MediaQuery.of(context).size.width * 0.7,
            color: dpe == null ? AppColors.nullEnergy : AppColors.dpeF,
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("  331 à 450  ", style: AppStyles.textNormal),
                  Text("F  ", style: AppStyles.titleStyleH2),
                ],
              ),
            ),
          ),
          SizedBox(width: 20),
          dpePosition == "F"
              ? Container(
                  height: 15,
                  width: 17,
                  child: Center(
                    child: Container(
                      width: double.infinity,
                      height: double.infinity,
                      child: Image.asset(AppImages.customShape,
                          fit: BoxFit.fill, color: AppColors.default_black),
                    ),
                  ),
                )
              : SizedBox.shrink(),
        ],
      ),
    );
  }

  _buildDpeG() {
    return Padding(
      padding: EdgeInsets.only(top: 10),
      child: Row(
        children: [
          Container(
            height: 35,
            width: MediaQuery.of(context).size.width * 0.8,
            color: dpe == null ? AppColors.nullEnergy : AppColors.dpeG,
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("  > 450  ", style: AppStyles.textNormal),
                  Text("G  ", style: AppStyles.titleStyleH2),
                ],
              ),
            ),
          ),
          SizedBox(width: 20),
          dpePosition == "G"
              ? Container(
                  height: 15,
                  width: 17,
                  child: Center(
                    child: Container(
                      width: double.infinity,
                      height: double.infinity,
                      child: Image.asset(AppImages.customShape,
                          fit: BoxFit.fill, color: AppColors.default_black),
                    ),
                  ),
                )
              : SizedBox.shrink(),
        ],
      ),
    );
  }
}
