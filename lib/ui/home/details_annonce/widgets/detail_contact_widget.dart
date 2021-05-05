import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:immonot/constants/app_colors.dart';
import 'package:immonot/constants/app_icons.dart';
import 'package:immonot/constants/app_images.dart';
import 'package:immonot/constants/routes.dart';
import 'package:immonot/constants/styles/app_styles.dart';
import 'package:immonot/models/fake/fakeResults.dart';
import 'package:page_indicator/page_indicator.dart';
import 'package:url_launcher/url_launcher.dart';
import "dart:ui" as ui;

class DetailContactWidget extends StatefulWidget {
  FakeResults fake;

  DetailContactWidget(FakeResults item) {
    this.fake = item;
  }

  @override
  State<StatefulWidget> createState() => _DetailContactWidgetState();
}

class _DetailContactWidgetState extends State<DetailContactWidget> {
  GlobalKey<PageContainerState> key = GlobalKey();
  FakeResults _fakeItem;
  double widthLeftBox = 100;

  @override
  void initState() {
    super.initState();
    _fakeItem = widget.fake;
  }

  @override
  Widget build(BuildContext context) {
    return _buildContent();
  }

  Widget _buildContent() {
    return Container(
      child: Column(
        children: [
          SizedBox(height: 20),
          Stack(
            children: [
              Container(
                height: 80,
                color: AppColors.defaultColor,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  _buildLeftSide(),
                  Expanded(
                    child: _buildRightSide(),
                  )
                ],
              )
            ],
          ),
          _buildButton(),
          SizedBox(height: 10),
          Center(
            child: Text(
              "Voir le site web",
              style: AppStyles.underlinedBaremeHonoraireStyle,
            ),
          )
        ],
      ),
    );
  }

  Widget _buildLeftSide() {
    return Padding(
      padding: EdgeInsets.only(top: 40, left: 20),
      child: Container(
        width: widthLeftBox,
        decoration: new BoxDecoration(
          color: const Color(0xFFFFFFFF), // border color
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Card(
            elevation: 18.0,
            shape: CircleBorder(),
            child: Center(
              child:
                  Image.asset(AppImages.notaire, fit: BoxFit.fill, width: 70),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRightSide() {
    return Padding(
      padding: EdgeInsets.only(top: 0, left: 20),
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 80,
              alignment: Alignment.bottomLeft,
              child: Text("Contacter l'office notarial",
                  style: AppStyles.titleStyleWhite),
            ),
            SizedBox(height: 20),
            Container(
              width: double.infinity,
              child: Padding(
                padding: EdgeInsets.only(right: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                        "SCP Adrien DUTOUR, Cyrille DE RUL, Christophe LACOSTE, Sandrine PAGÈS, Audrey PELLET-LAVÊVE, Grégory DANDIEU, Mélodie REMIA et Delphine HUREL",
                        style: AppStyles.filterSubStyle,
                        maxLines: 10,
                        overflow: TextOverflow.ellipsis),
                    Divider(
                      color: AppColors.hint.withOpacity(0.6),
                    ),
                    Text("20 rue Ferrère - CS 12037\n33001 BORDEAUX CEDEX",
                        style: AppStyles.filterSubStyle,
                        maxLines: 10,
                        overflow: TextOverflow.ellipsis),
                    Divider(
                      color: AppColors.hint.withOpacity(0.6),
                    ),
                    Container(
                      width: double.infinity,
                      child: ListTile(
                        minLeadingWidth : 10,
                        leading: Container(
                          width: 10,
                            child: Center(
                              child: FaIcon(FontAwesomeIcons.user, size: 15,),
                            )
                        ),
                        title: Text("Votre contact :", style: AppStyles.filterSubStyle),
                        subtitle: Text("Caroline Bouchereau", style: AppStyles.filterSubStyle),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildButton() {
    return Align(
      alignment: FractionalOffset.bottomCenter,
      child: InkWell(
        child: Card(
          clipBehavior: Clip.antiAliasWithSaveLayer,
          shape: RoundedRectangleBorder(
            side: new BorderSide(color: AppColors.hint, width: 0.2),
            borderRadius: BorderRadius.circular(5.0),
          ),
          elevation: 5,
          child: Container(
            color: AppColors.defaultColor,
            height: 50,
            width: MediaQuery.of(context).size.width * 0.8,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Center(
                child: RichText(
                  overflow: TextOverflow.clip,
                  maxLines: 1,
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    children: [
                      WidgetSpan(
                        alignment: ui.PlaceholderAlignment.middle,
                        child: FaIcon(
                          FontAwesomeIcons.plusSquare,
                          color: AppColors.white,
                          size: 18,
                        ),
                      ),
                      TextSpan(
                          text: "  Tous les biens de l'office notarial",
                          style: AppStyles.whiteTitleStyle),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

}
