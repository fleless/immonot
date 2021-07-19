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
    getDpePosition();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void getDpePosition() {
    if (ges == null) {
      gesPosition = "null";
      gesColor = AppColors.nullEnergy;
    } else if (ges < 51) {
      gesPosition = "A";
      gesColor = AppColors.gesColor.withOpacity(0.1);
    } else if (ges < 92) {
      gesPosition = "B";
      gesColor = AppColors.gesColor.withOpacity(0.2);
    } else if (ges < 151) {
      gesPosition = "C";
      gesColor = AppColors.gesColor.withOpacity(0.3);
    } else if (ges < 231) {
      gesPosition = "D";
      gesColor = AppColors.gesColor.withOpacity(0.4);
    } else if (ges < 331) {
      gesPosition = "E";
      gesColor = AppColors.gesColor.withOpacity(0.5);
    } else if (ges < 451) {
      gesPosition = "F";
      gesColor = AppColors.gesColor.withOpacity(0.8);
    } else {
      gesPosition = "G";
      gesColor = AppColors.gesColor.withOpacity(1);
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
        _buildGesA(),
        _buildGesB(),
        _buildGesC(),
        _buildGesD(),
        _buildGesE(),
        _buildGesF(),
        _buildGesG(),
      ],
    );
  }

  _buildGesA() {
    return Padding(
      padding: EdgeInsets.only(top: 0),
      child: Row(
        children: [
          Container(
            height: 35,
            width: MediaQuery.of(context).size.width * 0.2,
            color: ges == null ? AppColors.nullEnergy : AppColors.gesColor.withOpacity(0.1),
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
          gesPosition == "A"
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

  _buildGesB() {
    return Padding(
      padding: EdgeInsets.only(top: 10),
      child: Row(
        children: [
          Container(
            height: 35,
            width: MediaQuery.of(context).size.width * 0.3,
            color: ges == null ? AppColors.nullEnergy : AppColors.gesColor.withOpacity(0.2),
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
          gesPosition == "B"
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

  _buildGesC() {
    return Padding(
      padding: EdgeInsets.only(top: 10),
      child: Row(
        children: [
          Container(
            height: 35,
            width: MediaQuery.of(context).size.width * 0.4,
            color: ges == null ? AppColors.nullEnergy : AppColors.gesColor.withOpacity(0.3),
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
          gesPosition == "C"
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

  _buildGesD() {
    return Padding(
      padding: EdgeInsets.only(top: 10),
      child: Row(
        children: [
          Container(
            height: 35,
            width: MediaQuery.of(context).size.width * 0.5,
            color: ges == null ? AppColors.nullEnergy : AppColors.gesColor.withOpacity(0.4),
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
          gesPosition == "D"
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

  _buildGesE() {
    return Padding(
      padding: EdgeInsets.only(top: 10),
      child: Row(
        children: [
          Container(
            height: 35,
            width: MediaQuery.of(context).size.width * 0.6,
            color: ges == null ? AppColors.nullEnergy : AppColors.gesColor.withOpacity(0.5),
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
          gesPosition == "E"
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

  _buildGesF() {
    return Padding(
      padding: EdgeInsets.only(top: 10),
      child: Row(
        children: [
          Container(
            height: 35,
            width: MediaQuery.of(context).size.width * 0.7,
            color: ges == null ? AppColors.nullEnergy : AppColors.gesColor.withOpacity(0.8),
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
          gesPosition == "F"
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

  _buildGesG() {
    return Padding(
      padding: EdgeInsets.only(top: 10),
      child: Row(
        children: [
          Container(
            height: 35,
            width: MediaQuery.of(context).size.width * 0.8,
            color: ges == null ? AppColors.nullEnergy : AppColors.gesColor.withOpacity(1),
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
          gesPosition == "G"
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
