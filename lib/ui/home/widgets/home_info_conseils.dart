import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:immonot/constants/app_colors.dart';
import 'package:immonot/constants/endpoints.dart';
import 'package:immonot/constants/routes.dart';
import 'package:immonot/constants/styles/app_styles.dart';

class HomeInfoConseilWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HomeInfoConseilWidgetState();
}

class _HomeInfoConseilWidgetState extends State<HomeInfoConseilWidget> {
  TextEditingController _rechercheController = TextEditingController();
  final List<String> hashTagsList = [
    "Je m'informe sur l'immobilier",
    "J'achète",
    "Je vends",
    "Je rénove",
    "Je prépare l'avenir",
    "Je veux des infos pratiques",
    "J'investis",
    "Interview de notaires",
    "Interview de personnalités"
  ];

  @override
  Widget build(BuildContext context) {
    return _buildContent();
  }

  Widget _buildContent() {
    return Container(
      width: double.infinity,
      child: Padding(
        padding: EdgeInsets.only(right: 0, top: 40, bottom: 40, left: 15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Infos et conseils",
              textAlign: TextAlign.left,
              style: AppStyles.titleStyle,
              overflow: TextOverflow.clip,
              maxLines: 1,
            ),
            SizedBox(height: 5),
            Text("Les informations et conseils d’immonot",
                overflow: TextOverflow.ellipsis,
                maxLines: 3,
                style: AppStyles.subTitleStyle),
            Padding(padding: EdgeInsets.only(top: 20)),
            _buildTextField(),
            _buildHashTags(),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField() {
    return Container(
      height: 55,
      width: double.infinity,
      child: Padding(
        padding: EdgeInsets.only(right: 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.start,
          // If you want align text to left
          children: [
            Flexible(
              child: Card(
                shape: RoundedRectangleBorder(
                    side: new BorderSide(color: AppColors.hint, width: 0.2),
                    borderRadius: BorderRadius.circular(4.0)),
                elevation: 2,
                shadowColor: AppColors.hint,
                color: AppColors.appBackground,
                child: Center(
                  child: TextFormField(
                    controller: _rechercheController,
                    cursorColor: AppColors.defaultColor,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.only(
                          bottom: 0.0, left: 10.0, right: 0.0, top: 0.0),
                      hintText: "Tapez votre recherche..",
                      hintStyle: AppStyles.hintSearch,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 55,
              child: InkWell(
                splashColor: AppColors.white,
                onTap: () {
                  Modular.to.pushNamed(Routes.infoConseilWebView, arguments: {
                    "url": Endpoints.INFO_CONSEIL_WEB_VIEW +
                        _rechercheController.text
                  });
                },
                child: Card(
                  shape: RoundedRectangleBorder(
                      side: new BorderSide(color: AppColors.hint, width: 0.2),
                      borderRadius: BorderRadius.circular(4.0)),
                  elevation: 2,
                  shadowColor: AppColors.hint,
                  color: AppColors.defaultColor,
                  child: Center(
                    child: FaIcon(
                      FontAwesomeIcons.search,
                      color: AppColors.white,
                      size: 18,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHashTags() {
    return Container(
      height: 50,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: hashTagsList.length,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () => {
                Modular.to.pushNamed(Routes.infoConseilWebView, arguments: {
                  "url": Endpoints.INFO_CONSEIL_WEB_VIEW +
                      (index > 6 ? (index + 1).toString() : index.toString())
                })
              }, //changeSelectionTypeDeBien(index),
              child: Center(
                child: Container(
                  height: 33,
                  margin: const EdgeInsets.symmetric(horizontal: 5.0),
                  padding: const EdgeInsets.all(8.0),
                  decoration: new BoxDecoration(
                    color: AppColors.defaultColor,
                    borderRadius: BorderRadius.circular(5.0),
                    border: Border.all(color: AppColors.defaultColor),
                  ),
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      "#" + hashTagsList[index],
                      style: AppStyles.selectionedItemText,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            );
          }),
    );
  }
}
