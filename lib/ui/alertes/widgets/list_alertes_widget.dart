import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:immonot/constants/app_colors.dart';
import 'package:immonot/constants/styles/app_styles.dart';
import 'package:immonot/models/enum/type_ventes.dart';
import 'package:immonot/models/fake/fake_json_response.dart';
import 'package:immonot/models/fake/fake_list.dart';
import 'package:immonot/models/fake/filtersModel.dart';
import 'package:immonot/models/requests/create_alerte_request.dart';
import 'package:immonot/models/responses/get_alertes_response.dart';
import 'package:immonot/ui/alertes/alertes_bloc.dart';
import 'package:immonot/utils/flushbar_utils.dart';
import 'package:immonot/utils/session_controller.dart';
import 'package:immonot/utils/shared_preferences.dart';
import 'package:intl/intl.dart';

class ListSearchFavorisWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ListSearchFavorisWidgetState();
}

class _ListSearchFavorisWidgetState extends State<ListSearchFavorisWidget> {
  List<FilterModels> listSavedFilters = <FilterModels>[];
  bool _loading = false;
  ScrollController _controller;
  bool _showPaginationLoader = false;
  bool scrolling = false;
  GetAlertesResponse resp;
  List<Content> lista = <Content>[];
  final sessionController = Modular.get<SessionController>();
  final SharedPref sharedPref = SharedPref();
  final alertesBloc = Modular.get<AlertesBloc>();

  @override
  void initState() {
    _controller = ScrollController();
    _controller.addListener(_scrollListener);
    super.initState();
    _loadAlertes();
  }

  _loadAlertes() async {
    setState(() {
      _loading = true;
    });
    resp = await _goSearch(0);
    lista = resp.content;
    setState(() {
      _loading = false;
    });
  }

  _goSearch(int pageId) async {
    setState(() {
      _showPaginationLoader = true;
    });
    resp = await alertesBloc.getAlertes(pageId);
    if (pageId > 0) lista.addAll(resp.content);
    setState(() {
      _showPaginationLoader = false;
    });
    return resp;
  }

  _scrollListener() async {
    if (_controller.offset <= _controller.position.minScrollExtent &&
        !_controller.position.outOfRange) {
      setState(() {
        scrolling = false;
      });
    } else {
      setState(() {
        scrolling = true;
      });
    }
    // detect when we reach the bottom of the listview
    if (_controller.offset >= _controller.position.maxScrollExtent &&
        !_controller.position.outOfRange) {
      if (resp.number != resp.totalPages) {
        setState(() {
          _goSearch(resp.number + 1);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return _buildContent();
  }

  Widget _buildContent() {
    return Container(
      height: double.infinity,
      child: _loading
          ? Center(
              child: CircularProgressIndicator(
                color: AppColors.defaultColor,
              ),
            )
          : lista.isEmpty
              ? Center(
                  child: Text(
                    "Vous n'avez actuellement aucune alerte enregistrée dans votre sélection.",
                    style: AppStyles.hintSearch,
                    textAlign: TextAlign.center,
                  ),
                )
              : ListView.builder(
                  controller: _controller,
                  scrollDirection: Axis.vertical,
                  itemCount: lista == null ? 0 : lista.length + 1,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    Content item;
                    if (index != lista.length) {
                      item = lista[index];
                    }
                    return index == lista.length
                        ? _showPaginationLoader
                            ? SizedBox(
                                height: 50,
                                width: 50,
                                child: Center(
                                  child: CircularProgressIndicator(
                                      color: AppColors.defaultColor),
                                ),
                              )
                            : SizedBox.shrink()
                        : item.recherche == null
                            ? SizedBox.shrink()
                            : InkWell(
                                onTap: () => {},
                                child: item.recherche == SizedBox.shrink()
                                    ? null
                                    : Column(
                                        children: [
                                          Slidable(
                                              actionPane:
                                                  SlidableDrawerActionPane(),
                                              actionExtentRatio: 0.3,
                                              secondaryActions: <Widget>[
                                                Padding(
                                                  padding:
                                                      EdgeInsets.only(left: 10),
                                                  child: IconSlideAction(
                                                    color: Colors.transparent,
                                                    iconWidget: Container(
                                                      height: double.infinity,
                                                      width: double.infinity,
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(20),
                                                        color: AppColors.grey
                                                            .withOpacity(0.7),
                                                      ),
                                                      child: Column(
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: [
                                                          FaIcon(
                                                              FontAwesomeIcons
                                                                  .pen,
                                                              color: AppColors
                                                                  .default_black,
                                                              size: 22),
                                                          SizedBox(height: 20),
                                                          Text("Modifier",
                                                              style: AppStyles
                                                                  .smallTitleStyleBlack),
                                                        ],
                                                      ),
                                                    ),
                                                    foregroundColor:
                                                        AppColors.defaultColor,
                                                    onTap: () {
                                                      //modifierRecherche(item);
                                                    },
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      EdgeInsets.only(left: 10),
                                                  child: IconSlideAction(
                                                    color: Colors.transparent,
                                                    iconWidget: Container(
                                                      height: double.infinity,
                                                      width: double.infinity,
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(20),
                                                        color: AppColors.grey
                                                            .withOpacity(0.7),
                                                      ),
                                                      child: Column(
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: [
                                                          FaIcon(
                                                              FontAwesomeIcons
                                                                  .trash,
                                                              color: AppColors
                                                                  .defaultColor,
                                                              size: 22),
                                                          SizedBox(height: 20),
                                                          Text("Supprimer",
                                                              style: AppStyles
                                                                  .smallTitleStylePink),
                                                        ],
                                                      ),
                                                    ),
                                                    foregroundColor:
                                                        AppColors.defaultColor,
                                                    onTap: () {
                                                      deleteAlerte(item, index);
                                                    },
                                                  ),
                                                ),
                                              ],
                                              child: Card(
                                                clipBehavior: Clip.antiAlias,
                                                shape: RoundedRectangleBorder(
                                                  side: BorderSide(
                                                      color: Colors.white70,
                                                      width: 1),
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                ),
                                                elevation: 5,
                                                child: Container(
                                                  width: double.infinity,
                                                  child: Row(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    children: [
                                                      Padding(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                horizontal: 10),
                                                        child: InkWell(
                                                          onTap: () async {
                                                            //await _showNotifDialog(item);
                                                            setState(() {});
                                                          },
                                                          child: Container(
                                                            decoration:
                                                                BoxDecoration(
                                                              color: ((item
                                                                              .push ==
                                                                          null) &&
                                                                      (item
                                                                              .mail ==
                                                                          null))
                                                                  ? AppColors
                                                                      .desactivatedBell
                                                                  : AppColors
                                                                      .defaultColor,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          8.0),
                                                            ),
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                                    horizontal:
                                                                        8,
                                                                    vertical:
                                                                        8),
                                                            child: FaIcon(
                                                                ((item.push ==
                                                                            null) &&
                                                                        (item.mail ==
                                                                            null))
                                                                    ? FontAwesomeIcons
                                                                        .solidBellSlash
                                                                    : FontAwesomeIcons
                                                                        .solidBell,
                                                                color: AppColors
                                                                    .white,
                                                                size: 22),
                                                          ),
                                                        ),
                                                      ),
                                                      Expanded(
                                                        child: Container(
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  horizontal:
                                                                      10,
                                                                  vertical: 15),
                                                          child: Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                item.nom == null
                                                                    ? "Recherche sans nom"
                                                                    : item.nom ==
                                                                            ""
                                                                        ? "Recherche sans nom"
                                                                        : item
                                                                            .nom,
                                                                style: AppStyles
                                                                    .mediumTitleStyle,
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                maxLines: 2,
                                                              ),
                                                              SizedBox(
                                                                  height: 10),
                                                              Text(
                                                                  item.recherche
                                                                              .typeVentes ==
                                                                          null
                                                                      ? "Achat, Location, Vente aux enchères"
                                                                      : _getTypesVentes(item
                                                                          .recherche),
                                                                  style: AppStyles
                                                                      .textNormal,
                                                                  maxLines: 10,
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis),
                                                              Text(
                                                                  _getEndroits(item
                                                                      .recherche),
                                                                  style: AppStyles
                                                                      .textNormal,
                                                                  maxLines: 1,
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis),
                                                              SizedBox(
                                                                  height: 20),
                                                              Text(
                                                                item.dateCreation ==
                                                                        null
                                                                    ? "Date non définie"
                                                                    : _parseDate(
                                                                        item.dateCreation),
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                maxLines: 2,
                                                                style: AppStyles
                                                                    .hintSearch,
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                      Container(
                                                        alignment:
                                                            Alignment.center,
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                horizontal: 15),
                                                        child: FaIcon(
                                                            FontAwesomeIcons
                                                                .chevronRight,
                                                            color: AppColors
                                                                .defaultColor,
                                                            size: 20),
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

  String _getTypesVentes(Recherche recherche) {
    String collection = "";
    recherche.typeVentes.forEach((element) {
      collection += (element == "VENT"
              ? "Achat"
              : element == "LOCA"
                  ? "Location"
                  : "Vente aux enchères") +
          ", ";
    });
    return collection.length > 2
        ? collection.substring(0, collection.length - 2)
        : collection;
  }

  String _getEndroits(Recherche recherche) {
    String collection = "";
    if (recherche.oidCommunes != null) {
      recherche.oidCommunes.forEach((element) {
        collection += ", " + element;
      });
    }
    if (recherche.departements != null) {
      recherche.departements.forEach((element) {
        collection += ", " + element;
      });
    }
    return collection == ""
        ? "Toute la france"
        : collection.replaceFirst(", ", "");
  }

  String _parseDate(String item) {
    final dateTime = DateTime.parse(item);
    final format = DateFormat('dd-MM-yyyy');
    final clockString = format.format(dateTime);
    return clockString;
  }

  deleteAlerte(Content item, int index) async {
    await _showDeleteConfirmDialog(item, index);
  }

  _showDeleteConfirmDialog(Content item, int index) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
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
                        "Confirmation suppression alerte",
                        textAlign: TextAlign.center,
                        style: AppStyles.titleStyleH2,
                      ),
                    ),
                    SizedBox(height: 10),
                    Container(
                      color: AppColors.defaultColor,
                      height: 5,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      child: Text(
                        "Souhaitez-vous réellement supprimer votre alerte ?",
                        style: AppStyles.subTitleStyle,
                      ),
                    ),
                    Divider(color: AppColors.hint),
                    SizedBox(height: 5),
                    Container(
                      width: double.infinity,
                      alignment: Alignment.centerRight,
                      child: Center(
                        child: ElevatedButton(
                          child: Text("Supprimer cette alerte",
                              style: AppStyles.buttonTextWhite,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2),
                          onPressed: () async {
                            bool resp = await alertesBloc
                                .supprimerAlertes(item.id.toString());
                            if (resp) {
                              lista.removeAt(index);
                              Modular.to.pop();
                            } else {
                              showErrorToast(
                                  context, "Une erreur est survenue");
                            }
                          },
                          style: ElevatedButton.styleFrom(
                              elevation: 1,
                              onPrimary: AppColors.white,
                              primary: AppColors.defaultColor,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 15),
                              textStyle: TextStyle(
                                  fontSize: 30, fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          });
        }).then((value) => setState(() {}));
  }

  modifierRecherche(FilterModels fake) {}

/*_showNotifDialog(GetAlertesResponse item) {
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
  }*/
}
