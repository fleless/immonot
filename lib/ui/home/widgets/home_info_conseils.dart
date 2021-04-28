import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:immonot/constants/app_colors.dart';
import 'package:immonot/constants/styles/app_styles.dart';

class HomeInfoConseilWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HomeInfoConseilWidgetState();
}

class _HomeInfoConseilWidgetState extends State<HomeInfoConseilWidget> {
  final List<String> hashTagsList = [
    "#J'achète",
    "#Je vends",
    "#J'investis",
    "#Je prépare l'avenir",
    "#Je rénove",
    "#Je veux des infos pratiques"
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
                    cursorColor: AppColors.defaultColor,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.only(
                          bottom: 0.0, left: 10.0, right: 0.0, top: 0.0),
                      hintText: "Nom de votre notaire",
                      hintStyle: AppStyles.hintSearch,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 55,
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
              onTap: () => {}, //changeSelectionTypeDeBien(index),
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
                      hashTagsList[index],
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
