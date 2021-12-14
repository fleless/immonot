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
import 'package:immonot/models/responses/DetailAnnonceResponse.dart';
import 'package:immonot/ui/home/details_annonce/widgets/send_contact_message.dart';
import 'package:immonot/utils/launchUrl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:page_indicator/page_indicator.dart';
import 'package:url_launcher/url_launcher.dart';
import "dart:ui" as ui;

import '../../home_bloc.dart';

class DetailContactWidget extends StatefulWidget {
  DetailAnnonceResponse fake;

  DetailContactWidget(DetailAnnonceResponse item) {
    this.fake = item;
  }

  @override
  State<StatefulWidget> createState() => _DetailContactWidgetState();
}

class _DetailContactWidgetState extends State<DetailContactWidget> {
  GlobalKey<PageContainerState> key = GlobalKey();
  DetailAnnonceResponse _fakeItem;
  double widthLeftBox = 70;
  final bloc = Modular.get<HomeBloc>();

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
          _buildContact(),
          SizedBox(height: 10),
          (_fakeItem.contact.website != null) &&
                  (_fakeItem.contact.website.length > 7)
              ? Center(
                  child: GestureDetector(
                    onTap: () {
                      launchUrl(_fakeItem.contact.website);
                    },
                    child: Text(
                      "Voir le site web",
                      style: AppStyles.underlinedBaremeHonoraireStyle,
                    ),
                  ),
                )
              : SizedBox.shrink()
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
            shadowColor: AppColors.white,
            elevation: 10.0,
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
                    _fakeItem.contact.nom != null
                        ? Text(_fakeItem.contact.nom,
                            style: AppStyles.filterSubStyle,
                            maxLines: 10,
                            overflow: TextOverflow.ellipsis)
                        : SizedBox.shrink(),
                    _fakeItem.contact.nom != null
                        ? Divider(
                            color: AppColors.hint.withOpacity(0.6),
                          )
                        : SizedBox.shrink(),
                    _fakeItem.contact.adresse != null
                        ? Text(_fakeItem.contact.adresse,
                            style: AppStyles.filterSubStyle,
                            maxLines: 10,
                            overflow: TextOverflow.ellipsis)
                        : SizedBox.shrink(),
                    Text(_getPostalCodeAndVille(),
                        style: AppStyles.filterSubStyle,
                        maxLines: 10,
                        overflow: TextOverflow.ellipsis),
                    Divider(
                      color: AppColors.hint.withOpacity(0.6),
                    ),
                    _fakeItem.contact.nom != null
                        ? Container(
                            width: double.infinity,
                            child: ListTile(
                              contentPadding: EdgeInsets.all(0),
                              minLeadingWidth: 10,
                              leading: Container(
                                  width: 10,
                                  child: Center(
                                    child: FaIcon(
                                      FontAwesomeIcons.user,
                                      size: 15,
                                    ),
                                  )),
                              title: Text("Votre contact :",
                                  style: AppStyles.filterSubStyle),
                              subtitle: Text(_fakeItem.contact.nom,
                                  style: AppStyles.filterSubStyle),
                            ),
                          )
                        : SizedBox.shrink(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getPostalCodeAndVille() {
    String adresse2 = "";
    _fakeItem.contact.codePostal != null
        ? adresse2 += _fakeItem.contact.codePostal + " "
        : adresse2 += "";
    _fakeItem.contact.ville != null
        ? adresse2 += " " + _fakeItem.contact.ville
        : adresse2 += "";
    return adresse2;
  }

  Widget _buildButton() {
    return Align(
      alignment: FractionalOffset.bottomCenter,
      child: InkWell(
        onTap: () {
          bloc.currentFilter.oidNotaires.add(_fakeItem.oidNotaire);
          Modular.to.pushNamed(Routes.searchResults);
        },
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

  Widget _buildContact() {
    return Column(
      children: [
        SizedBox(height: 15),
        Container(
          width: MediaQuery.of(context).size.width * 0.7,
          decoration: BoxDecoration(
              color: AppColors.appBackground,
              borderRadius: BorderRadius.all(Radius.circular(8))),
          child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                  elevation: 3,
                  onPrimary: AppColors.defaultColor,
                  primary: AppColors.white,
                  side: BorderSide(color: AppColors.defaultColor),
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                  textStyle:
                      TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
              onPressed: () {
                showCupertinoModalBottomSheet(
                  context: context,
                  expand: false,
                  enableDrag: true,
                  builder: (context) =>
                      SendContactMessageDialog(_fakeItem.oidAnnonce),
                );
              },
              icon: Icon(
                Icons.send,
                color: AppColors.defaultColor,
              ),
              label: Text(
                "   CONTACTER L'OFFICE NOTARIAL",
                style: AppStyles.smallTitleStylePink,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              )),
        ),
        SizedBox(height: 15),
      ],
    );
  }
}
