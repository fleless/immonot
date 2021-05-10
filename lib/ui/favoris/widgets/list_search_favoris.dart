import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:immonot/constants/app_colors.dart';
import 'package:immonot/constants/app_images.dart';
import 'package:immonot/constants/styles/app_styles.dart';
import 'package:immonot/models/fake/fake_json_response.dart';
import 'package:immonot/models/fake/fake_list.dart';
import 'package:immonot/models/fake/filtersModel.dart';
import 'package:immonot/models/responses/places_response.dart';

class ListSearchFavorisWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ListSearchFavorisWidgetState();
}

class _ListSearchFavorisWidgetState extends State<ListSearchFavorisWidget> {
  List<FakeJsonResponse> fakeAnnonces = <FakeJsonResponse>[];
  List<FilterModels> listSavedFilters = <FilterModels>[];

  @override
  void initState() {
    super.initState();
    var res = jsonDecode(annonces.toString()) as List;
    fakeAnnonces = res.map((x) => FakeJsonResponse.fromJson(x)).toList();
    addFakeFilters();
  }

  addFakeFilters() {
    FilterModels filter1 = new FilterModels();
    FilterModels filter2 = new FilterModels();
    filter1.nom = "Filter 1";
    filter1.listTransactions.add("Achat");
    filter2.nom = "Filter 2";
    filter1.listTransactions.add("Viager");
    filter1.listTransactions.add("Location");
    listSavedFilters.add(filter1);
    listSavedFilters.add(filter2);
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
          itemCount: listSavedFilters.length,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            var item = listSavedFilters[index];
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
                          width: double.infinity,
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                child: InkWell(
                                  onTap: () async {
                                    await _showNotifDialog(item);
                                    setState(() {});
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: ((!item.notificationsOn) &&
                                              (!item.emailOn))
                                          ? AppColors.desactivatedBell
                                          : AppColors.defaultColor,
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 8),
                                    child: FaIcon(
                                        ((!item.notificationsOn) &&
                                                (!item.emailOn))
                                            ? FontAwesomeIcons.solidBellSlash
                                            : FontAwesomeIcons.solidBell,
                                        color: AppColors.white,
                                        size: 22),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 15),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item.nom == ""
                                            ? "Recherche sans nom"
                                            : item.nom,
                                        style: AppStyles.mediumTitleStyle,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 2,
                                      ),
                                      SizedBox(height: 10),
                                      Text("Achat, Location",
                                          style: AppStyles.textNormal,
                                          maxLines: 10,
                                          overflow: TextOverflow.ellipsis),
                                      Text("Toute la ville de bordeaux",
                                          style: AppStyles.textNormal,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis),
                                      SizedBox(height: 20),
                                      Text(
                                        '29 avril 2021 - 11h20',
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 2,
                                        style: AppStyles.hintSearch,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Container(
                                alignment: Alignment.center,
                                padding: EdgeInsets.symmetric(horizontal: 15),
                                child: FaIcon(FontAwesomeIcons.chevronRight,
                                    color: AppColors.defaultColor, size: 20),
                              )
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

  deleteSearch(FilterModels fake) {
    setState(() {
      listSavedFilters.removeWhere((element) => element.nom == fake.nom);
    });
  }

  modifierRecherche(FilterModels fake) {}

  _showNotifDialog(FilterModels item) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          bool notifOn = item.notificationsOn;
          bool emailOn = item.emailOn;
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0)),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Text(
                        "Soyez notifié des nouveautés sur vos annonces favorites",
                        textAlign: TextAlign.start,
                        style: AppStyles.titleStyleH2,
                      ),
                    ),
                    SizedBox(height: 5),
                    Divider(color: AppColors.hint),
                    SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Notification push", style: AppStyles.textNormal),
                        Switch(
                            activeColor: AppColors.defaultColor,
                            value: notifOn,
                            onChanged: (value) {
                              setState(() {
                                notifOn = value;
                              });
                            }),
                      ],
                    ),
                    SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("E-mail", style: AppStyles.textNormal),
                        Switch(
                            activeColor: AppColors.defaultColor,
                            value: emailOn,
                            onChanged: (value) {
                              setState(() {
                                emailOn = value;
                              });
                            }),
                      ],
                    ),
                    SizedBox(height: 5),
                    Divider(color: AppColors.hint),
                    Container(
                      width: double.infinity,
                      child: IntrinsicHeight(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Expanded(
                              child: Container(
                                alignment: Alignment.center,
                                child: TextButton(
                                  style: ButtonStyle(
                                    overlayColor: MaterialStateProperty.all(
                                        AppColors.defaultColor
                                            .withOpacity(0.3)),
                                  ),
                                  onPressed: () {
                                    Modular.to.pop();
                                  },
                                  child: Text(
                                    "ANNULER",
                                    style: AppStyles.pinkButtonStyle,
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              width: 1,
                              color: AppColors.hint,
                            ),
                            Expanded(
                              child: Container(
                                alignment: Alignment.center,
                                child: TextButton(
                                  style: ButtonStyle(
                                    overlayColor: MaterialStateProperty.all(
                                        AppColors.defaultColor
                                            .withOpacity(0.3)),
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      item.notificationsOn = notifOn;
                                      item.emailOn = emailOn;
                                    });
                                    Modular.to.pop();
                                  },
                                  child: Text(
                                    "VALIDER",
                                    style: AppStyles.pinkButtonStyle,
                                  ),
                                ),
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
          });
        });
  }
}
