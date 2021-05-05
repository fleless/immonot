import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:immonot/constants/app_colors.dart';
import 'package:immonot/constants/app_images.dart';
import 'package:immonot/constants/styles/app_styles.dart';
import 'package:immonot/models/fake/fake_json_response.dart';
import 'package:immonot/models/fake/fake_list.dart';
import 'package:immonot/models/responses/places_response.dart';

class ListSearchFavorisWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ListSearchFavorisWidgetState();
}

class _ListSearchFavorisWidgetState extends State<ListSearchFavorisWidget> {
  List<FakeJsonResponse> fakeAnnonces = <FakeJsonResponse>[];

  @override
  void initState() {
    super.initState();
    var res = jsonDecode(annonces.toString()) as List;
    fakeAnnonces = res.map((x) => FakeJsonResponse.fromJson(x)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return _buildContent();
  }

  Widget _buildContent() {
    return Container(
      height: double.infinity,
      child: ListView.builder(
          scrollDirection: Axis.vertical,
          itemCount: fakeAnnonces.length,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            var item = fakeAnnonces[index];
            return InkWell(
              onTap: () => {},
              child: Column(
                children: [
                  Slidable(
                      actionPane: SlidableDrawerActionPane(),
                      actionExtentRatio: 0.3,
                      secondaryActions: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(left: 10),
                          child: IconSlideAction(
                            color: Colors.transparent,
                            iconWidget: Container(
                              height: double.infinity,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: AppColors.grey.withOpacity(0.7),
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  FaIcon(FontAwesomeIcons.pen,
                                      color: AppColors.default_black, size: 22),
                                  SizedBox(height: 20),
                                  Text("Modifier",
                                      style: AppStyles.smallTitleStyleBlack),
                                ],
                              ),
                            ),
                            foregroundColor: AppColors.defaultColor,
                            onTap: () {
                              modifierRecherche(item);
                            },
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 10),
                          child: IconSlideAction(
                            color: Colors.transparent,
                            iconWidget: Container(
                              height: double.infinity,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: AppColors.grey.withOpacity(0.7),
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  FaIcon(FontAwesomeIcons.trash,
                                      color: AppColors.defaultColor, size: 22),
                                  SizedBox(height: 20),
                                  Text("Supprimer",
                                      style: AppStyles.smallTitleStylePink),
                                ],
                              ),
                            ),
                            foregroundColor: AppColors.defaultColor,
                            onTap: () {
                              deleteSearch(item);
                            },
                          ),
                        ),
                      ],
                      child: Card(
                        clipBehavior: Clip.antiAlias,
                        shape: RoundedRectangleBorder(
                          side: BorderSide(color: Colors.white70, width: 1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        elevation: 5,
                        child: Container(
                          height: 160,
                          width: double.infinity,
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Flexible(
                                flex: 2,
                                child: Container(
                                  height: double.infinity,
                                  child: Image.network(item.photo,
                                      fit: BoxFit.fill),
                                ),
                              ),
                              Flexible(
                                flex: 3,
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(item.genre,
                                          style: item.genre == "ACHAT"
                                              ? AppStyles.typeAnnoncesAchat
                                              : item.genre == "LOCATION"
                                                  ? AppStyles
                                                      .typeAnnoncesLocation
                                                  : item.genre == "VIAGER"
                                                      ? AppStyles
                                                          .typeAnnoncesViager
                                                      : AppStyles
                                                          .typeAnnoncesVenteAuxEncheres),
                                      SizedBox(height: 5),
                                      Text(
                                          "Exemple de titre à vendre Bordeaux en Gironde (33000)",
                                          style: AppStyles.textNormal,
                                          maxLines: 10,
                                          overflow: TextOverflow.ellipsis),
                                      SizedBox(height: 5),
                                      Text(
                                        item.prize + " €",
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                        style: AppStyles.titleStyle,
                                      ),
                                      SizedBox(height: 35),
                                      Text(
                                        item.location,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 2,
                                        style: AppStyles.locationAnnonces,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )),
                  SizedBox(height: 10),
                ],
              ),
            );
          }),
    );
  }

  deleteSearch(FakeJsonResponse fake) {
    setState(() {
      fakeAnnonces.removeWhere((element) => element.prize == fake.prize);
    });
  }

  modifierRecherche(FakeJsonResponse fake){

  }
}
