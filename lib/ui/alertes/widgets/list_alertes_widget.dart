import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:immonot/constants/app_colors.dart';
import 'package:immonot/constants/routes.dart';
import 'package:immonot/constants/styles/app_styles.dart';
import 'package:immonot/models/enum/type_biens.dart';
import 'package:immonot/models/enum/type_ventes.dart';
import 'package:immonot/models/fake/filtersModel.dart';
import 'package:immonot/models/requests/create_alerte_request.dart';
import 'package:immonot/models/responses/get_alertes_response.dart';
import 'package:immonot/models/responses/places_response.dart';
import 'package:immonot/ui/alertes/alertes_bloc.dart';
import 'package:immonot/ui/alertes/screens/add_modif_alerte.dart';
import 'package:immonot/ui/home/home_bloc.dart';
import 'package:immonot/utils/flushbar_utils.dart';
import 'package:immonot/utils/session_controller.dart';
import 'package:immonot/utils/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'dart:ui' as ui;
import 'dart:math' as math;

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
  final homeBloc = Modular.get<HomeBloc>();
  bool _showSlidableIndication = true;

  @override
  void initState() {
    _controller = ScrollController();
    _controller.addListener(_scrollListener);
    super.initState();
    _loadAlertes();
    alertesBloc.changesNotifier.listen((value) async {
      lista.clear();
      await _loadAlertes();
    });
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
    setState(() {
      _showSlidableIndication = false;
    });
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
    return Column(
      children: [
        _buildButton(),
        SizedBox(height: 15),
        if (_showSlidableIndication)
          Padding(
            padding: EdgeInsets.symmetric(vertical: 5),
            child: RichText(
              textAlign: TextAlign.left,
              maxLines: 10,
              overflow: TextOverflow.clip,
              text: TextSpan(
                children: [
                  TextSpan(
                    children: [
                      WidgetSpan(
                        alignment: ui.PlaceholderAlignment.middle,
                        child: Transform.rotate(
                          angle: math.pi,
                          child: Icon(
                            Icons.double_arrow_rounded,
                            color: AppColors.hint,
                            size: 14,
                          ),
                        ),
                      ),
                      TextSpan(
                          text:
                              '  Swipez une tuile vers la gauche pour supprimer ou modifier une alerte',
                          style: AppStyles.hintSearch),
                    ],
                  ),
                ],
              ),
            ),
          ),
        Expanded(
          child: Container(
            height: double.infinity,
            child: ((lista == null) || (_loading))
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
                                      onTap: () => {_lancerRecherche(item)},
                                      child: item.recherche == null
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
                                                            EdgeInsets.only(
                                                                left: 10),
                                                        child: IconSlideAction(
                                                          color: Colors
                                                              .transparent,
                                                          iconWidget: Container(
                                                            height:
                                                                double.infinity,
                                                            width:
                                                                double.infinity,
                                                            decoration:
                                                                BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          20),
                                                              color: AppColors
                                                                  .grey
                                                                  .withOpacity(
                                                                      0.7),
                                                            ),
                                                            child: Column(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .max,
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
                                                                SizedBox(
                                                                    height: 20),
                                                                Text("Modifier",
                                                                    style: AppStyles
                                                                        .smallTitleStyleBlack),
                                                              ],
                                                            ),
                                                          ),
                                                          foregroundColor:
                                                              AppColors
                                                                  .defaultColor,
                                                          onTap: () {
                                                            modifierRecherche(
                                                                item);
                                                          },
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                left: 10),
                                                        child: IconSlideAction(
                                                          color: Colors
                                                              .transparent,
                                                          iconWidget: Container(
                                                            height:
                                                                double.infinity,
                                                            width:
                                                                double.infinity,
                                                            decoration:
                                                                BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          20),
                                                              color: AppColors
                                                                  .grey
                                                                  .withOpacity(
                                                                      0.7),
                                                            ),
                                                            child: Column(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .max,
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
                                                                SizedBox(
                                                                    height: 20),
                                                                Text(
                                                                    "Supprimer",
                                                                    style: AppStyles
                                                                        .smallTitleStylePink),
                                                              ],
                                                            ),
                                                          ),
                                                          foregroundColor:
                                                              AppColors
                                                                  .defaultColor,
                                                          onTap: () {
                                                            deleteAlerte(
                                                                item, index);
                                                          },
                                                        ),
                                                      ),
                                                    ],
                                                    child: Card(
                                                      clipBehavior:
                                                          Clip.antiAlias,
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        side: BorderSide(
                                                            color:
                                                                Colors.white70,
                                                            width: 1),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(20),
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
                                                                      horizontal:
                                                                          10),
                                                              child: InkWell(
                                                                onTap:
                                                                    () async {
                                                                  await _showNotifDialog(
                                                                      item);
                                                                  setState(
                                                                      () {});
                                                                },
                                                                child:
                                                                    Container(
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    color: ((!item.push) &&
                                                                            (!item
                                                                                .mail))
                                                                        ? AppColors
                                                                            .desactivatedBell
                                                                        : AppColors
                                                                            .defaultColor,
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            8.0),
                                                                  ),
                                                                  padding: EdgeInsets
                                                                      .symmetric(
                                                                          horizontal:
                                                                              8,
                                                                          vertical:
                                                                              8),
                                                                  child: FaIcon(
                                                                      ((!item.push) &&
                                                                              (!item
                                                                                  .mail))
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
                                                                        vertical:
                                                                            15),
                                                                child: Column(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Text(
                                                                      item.nom ==
                                                                              null
                                                                          ? "Recherche sans nom"
                                                                          : item.nom == ""
                                                                              ? "Recherche sans nom"
                                                                              : item.nom,
                                                                      style: AppStyles
                                                                          .mediumTitleStyle,
                                                                      overflow:
                                                                          TextOverflow
                                                                              .ellipsis,
                                                                      maxLines:
                                                                          2,
                                                                    ),
                                                                    SizedBox(
                                                                        height:
                                                                            10),
                                                                    Text(
                                                                        item.recherche.typeVentes ==
                                                                                null
                                                                            ? "Achat, Location, Vente aux enchères"
                                                                            : _getTypesVentes(item
                                                                                .recherche),
                                                                        style: AppStyles
                                                                            .textNormal,
                                                                        maxLines:
                                                                            10,
                                                                        overflow:
                                                                            TextOverflow.ellipsis),
                                                                    Text(
                                                                        _getEndroits(item
                                                                            .recherche),
                                                                        style: AppStyles
                                                                            .textNormal,
                                                                        maxLines:
                                                                            1,
                                                                        overflow:
                                                                            TextOverflow.ellipsis),
                                                                    SizedBox(
                                                                        height:
                                                                            20),
                                                                    Text(
                                                                      item.dateCreation ==
                                                                              null
                                                                          ? "Date non définie"
                                                                          : _parseDate(
                                                                              item.dateCreation),
                                                                      overflow:
                                                                          TextOverflow
                                                                              .ellipsis,
                                                                      maxLines:
                                                                          2,
                                                                      style: AppStyles
                                                                          .hintSearch,
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                            Container(
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              padding: EdgeInsets
                                                                  .symmetric(
                                                                      horizontal:
                                                                          15),
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
          ),
        ),
      ],
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
    if (recherche.communeInfos != null) {
      recherche.communeInfos.forEach((element) {
        collection += ", " + element.codePostal;
      });
    }
    if (recherche.departements != null) {
      recherche.departements.forEach((element) {
        if (element != null) collection += ", " + element;
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

  Widget _buildButton() {
    return Container(
      decoration: new BoxDecoration(
        color: AppColors.defaultColor,
        borderRadius: BorderRadius.all(Radius.circular(5)),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            showCupertinoModalBottomSheet(
              context: context,
              expand: false,
              enableDrag: true,
              builder: (context) => AddModifAlerteScreen(true, null),
            );
          },
          child: Container(
            width: MediaQuery.of(context).size.width * 0.50,
            height: 45,
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FaIcon(
                    FontAwesomeIcons.plus,
                    color: AppColors.white,
                    size: 17,
                  ),
                  SizedBox(width: 10),
                  Text("CRÉER MON ALERTE",
                      style: AppStyles.buttonTextWhite,
                      overflow: TextOverflow.clip,
                      maxLines: 1)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  modifierRecherche(Content item) {
    showCupertinoModalBottomSheet(
        context: context,
        expand: false,
        enableDrag: true,
        builder: (context) => AddModifAlerteScreen(false, item));
  }

  _lancerRecherche(Content item) async {
    //Parse Recherche to FilterModel
    homeBloc.reinitCurrentFilter();
    if (item.recherche.prix != null) {
      if (item.recherche.prix.length > 0) {
        homeBloc.currentFilter.priceMin = item.recherche.prix[0];
        homeBloc.currentFilter.priceMax = item.recherche.prix[1];
      }
    }
    if (item.recherche.surfaceInterieure != null) {
      if (item.recherche.surfaceInterieure.length > 0) {
        homeBloc.currentFilter.surInterieurMin =
            item.recherche.surfaceInterieure[0];
        homeBloc.currentFilter.surInterieurMax =
            item.recherche.surfaceInterieure[1];
      }
    }
    if (item.recherche.surfaceExterieure != null) {
      if (item.recherche.surfaceExterieure.length > 0) {
        homeBloc.currentFilter.surExterieurMin =
            item.recherche.surfaceExterieure[0];
        homeBloc.currentFilter.surExterieurMax =
            item.recherche.surfaceExterieure[1];
      }
    }
    if (item.recherche.references != null) {
      if (item.recherche.references.length > 0) {
        homeBloc.currentFilter.reference = item.recherche.references[0];
      } else {
        homeBloc.currentFilter.reference = null;
      }
    }

    if (item.recherche.rayons != null) {
      if (item.recherche.rayons.length > 0) {
        if (item.recherche.rayons[0] == null) {
          item.recherche.rayons[0] = 0.0;
        }
        homeBloc.currentFilter.rayon =
            double.parse(item.recherche.rayons[0].toString());
      }
    }

    if (item.recherche.typeVentes != null) {
      if (item.recherche.typeVentes.length > 0) {
        item.recherche.typeVentes.forEach((element) {
          TypeVentesEnumeration _type =
              TypeVentesEnumeration.findTypeVenteByCode(element);
          homeBloc.currentFilter.listTypeVente.add(_type);
        });
      }
    }

    if (item.recherche.typeBiens != null) {
      if (item.recherche.typeBiens.length > 0) {
        item.recherche.typeBiens.forEach((element) {
          TypeBienEnumeration _type =
              TypeBienEnumeration.findTypeBienByCode(element);
          homeBloc.currentFilter.listtypeDeBien.add(_type);
        });
      }
    }
    if (item.recherche.nbPieces != null) {
      if (item.recherche.nbPieces.length > 0) {
        homeBloc.currentFilter.piecesMin =
            double.parse(item.recherche.nbPieces[0].toString());
        homeBloc.currentFilter.piecesMax =
            double.parse(item.recherche.nbPieces[1].toString());
      }
    }
    if (item.recherche.nbChambres != null) {
      if (item.recherche.nbChambres.length > 0) {
        homeBloc.currentFilter.chambresMin =
            double.parse(item.recherche.nbChambres[0].toString());
        homeBloc.currentFilter.chambresMax =
            double.parse(item.recherche.nbChambres[1].toString());
      }
    }
    List<PlacesResponse> lista = <PlacesResponse>[];
    if (item.recherche.departements == null) {
      item.recherche.departements = <String>[];
    }
    if (item.recherche.oidCommunes == null) {
      item.recherche.oidCommunes = <String>[];
    }
    int lengthOfDeps = item.recherche.departements == null
        ? 0
        : item.recherche.departements.length;
    int lengthOfCommunes = item.recherche.oidCommunes == null
        ? 0
        : item.recherche.oidCommunes.length;
    if (lengthOfCommunes + lengthOfDeps == 0) {
      Modular.to.pushNamed(Routes.searchResults);
    } else {
      item.recherche.oidCommunes.forEach((element) async {
        PlacesResponse resp = await alertesBloc.searchCommune(element);
        lista.add(resp);
        if (lista.length == lengthOfCommunes + lengthOfDeps) {
          homeBloc.currentFilter.listPlaces.addAll(lista);
          Modular.to.pushNamed(Routes.searchResults);
        }
      });
      item.recherche.departements.forEach((element) async {
        PlacesResponse resp = await alertesBloc.searchDepartment(element);
        lista.add(resp);
        if (lista.length == lengthOfCommunes + lengthOfDeps) {
          homeBloc.currentFilter.listPlaces.addAll(lista);
          Modular.to.pushNamed(Routes.searchResults);
        }
      });
    }
  }

  _showNotifDialog(Content item) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          bool notifOn = item.push;
          bool emailOn = item.mail;
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
                                  onPressed: () async {
                                    CreateAlerteRequest req =
                                        CreateAlerteRequest(
                                            push: notifOn, mail: emailOn);
                                    bool resp = await alertesBloc
                                        .modifierAlertes(req, item.id);
                                    if (resp) {
                                      setState(() {
                                        item.push = notifOn;
                                        item.mail = emailOn;
                                      });
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                        content:
                                            Text("Une erreur est survenue"),
                                      ));
                                    }
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
