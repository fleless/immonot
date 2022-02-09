import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:immonot/constants/app_colors.dart';
import 'package:immonot/constants/routes.dart';
import 'package:immonot/constants/styles/app_styles.dart';
import 'package:immonot/models/responses/get_favoris_response.dart';
import 'package:immonot/utils/flushbar_utils.dart';
import 'package:immonot/utils/session_controller.dart';
import 'package:immonot/utils/shared_preferences.dart';
import "dart:ui" as ui;
import '../favoris_bloc.dart';

class ListAnnoncesFavorisWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ListAnnoncesFavorisWidgetState();
}

class _ListAnnoncesFavorisWidgetState extends State<ListAnnoncesFavorisWidget> {
  final bloc = Modular.get<FavorisBloc>();
  final sessionController = Modular.get<SessionController>();
  final SharedPref sharedPref = SharedPref();
  bool _loading = false;
  ScrollController _controller;
  bool _showPaginationLoader = false;
  bool scrolling = false;
  GetFavorisResponse resp;
  List<Content> lista = <Content>[];
  SlidableController _slidableController;
  bool _showSlidableIndication = true;

  @override
  void initState() {
    _initData();
    _controller = ScrollController();
    _controller.addListener(_scrollListener);
    super.initState();
  }

  _initData() async {
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
    resp = await bloc.getFavoris(pageId);
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
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
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
                          child: Icon(
                            Icons.double_arrow_rounded,
                            color: AppColors.hint,
                            size: 14,
                          )),
                      TextSpan(
                          text:
                              '  Swipez une tuile vers la gauche pour supprimer un favoris',
                          style: AppStyles.hintSearch),
                    ],
                  ),
                ],
              ),
            ),
          ),
        Expanded(child: _buildContent()),
      ],
    );
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
                    "Vous n'avez actuellement aucune annonce dans votre sélection.",
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
                    Content item = Content();
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
                        : InkWell(
                            onTap: () => {
                              if (index < lista.length)
                                {
                                  Modular.to.pushNamed(Routes.detailsAnnonce,
                                      arguments: {'id': item.oidAnnonce})
                                }
                            },
                            child: Column(
                              children: [
                                Slidable(
                                    controller: _slidableController,
                                    key: Key(item.oidAnnonce),
                                    actionPane: SlidableDrawerActionPane(),
                                    actionExtentRatio: 0.3,
                                    closeOnScroll: true,
                                    secondaryActions: <Widget>[
                                      IconSlideAction(
                                        color: Colors.transparent,
                                        iconWidget: Container(
                                          height: double.infinity,
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            color:
                                                AppColors.grey.withOpacity(0.7),
                                          ),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              FaIcon(FontAwesomeIcons.trash,
                                                  color: AppColors.defaultColor,
                                                  size: 22),
                                              SizedBox(height: 20),
                                              Text("Supprimer",
                                                  style: AppStyles
                                                      .smallTitleStylePink),
                                            ],
                                          ),
                                        ),
                                        foregroundColor: AppColors.defaultColor,
                                        onTap: () {
                                          deleteAnnonce(item, index);
                                        },
                                      ),
                                    ],
                                    child: Card(
                                      clipBehavior: Clip.antiAlias,
                                      shape: RoundedRectangleBorder(
                                        side: BorderSide(
                                            color: Colors.white70, width: 1),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      elevation: 5,
                                      child: Container(
                                        width: double.infinity,
                                        constraints: BoxConstraints(
                                            minHeight: 160, maxHeight: 160),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Flexible(
                                              flex: 2,
                                              child: Container(
                                                width: double.infinity,
                                                height: double.infinity,
                                                color: AppColors.hint,
                                                child: Image.network(
                                                    item.annonce.photo
                                                                .principale ==
                                                            null
                                                        ? "https://www.generationsforpeace.org/wp-content/uploads/2018/03/empty.jpg"
                                                        : item.annonce.photo
                                                            .principale,
                                                    fit: BoxFit.cover),
                                              ),
                                            ),
                                            Flexible(
                                              flex: 3,
                                              child: Container(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 10,
                                                    vertical: 10),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      item.annonce.typeVente
                                                          .toUpperCase(),
                                                      style: item.annonce
                                                                  .typeVente ==
                                                              "Achat"
                                                          ? AppStyles
                                                              .typeAnnoncesAchat
                                                          : item.annonce
                                                                      .typeVente ==
                                                                  "Location"
                                                              ? AppStyles
                                                                  .typeAnnoncesLocation
                                                              : item.annonce
                                                                          .typeVente ==
                                                                      "Viager"
                                                                  ? AppStyles
                                                                      .typeAnnoncesViager
                                                                  : item.annonce
                                                                              .typeVente ==
                                                                          "Vente aux enchères"
                                                                      ? AppStyles
                                                                          .typeAnnoncesVenteAuxEncheres
                                                                      : AppStyles
                                                                          .typeAnnoncesEVente,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      maxLines: 4,
                                                    ),
                                                    SizedBox(height: 10),
                                                    if (item.annonce.titre !=
                                                        null)
                                                      Text(item.annonce.titre,
                                                          style: AppStyles
                                                              .subTitleStyle,
                                                          maxLines: 3,
                                                          overflow: TextOverflow
                                                              .ellipsis),
                                                    SizedBox(height: 5),
                                                    if (item
                                                        .annonce.affichePrix)
                                                      Text(
                                                        item.annonce.prixLigne1 ==
                                                                null
                                                            ? ""
                                                            : item.annonce
                                                                .prixLigne1
                                                                .replaceAll(
                                                                    "&euro;",
                                                                    "€"),
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        maxLines: 1,
                                                        style: AppStyles
                                                            .mediumTitleStyle,
                                                      ),
                                                    SizedBox(height: 20),
                                                    if (item
                                                        .annonce.afficheCommune)
                                                      Text(
                                                        item.annonce.commune
                                                                .nom +
                                                            " - " +
                                                            item.annonce.commune
                                                                .codePostal,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        maxLines: 2,
                                                        style: AppStyles
                                                            .locationAnnonces,
                                                      ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    )),
                                SizedBox(height: 5),
                              ],
                            ),
                          );
                  }),
    );
  }

  deleteAnnonce(Content item, int index) async {
    await _showNotifDialog(item, index);
  }

  _showNotifDialog(Content item, int index) {
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
                        "Confirmation du retrait de l'annonce de votre sélection",
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
                        "Souhaitez-vous réellement retirer cette annonce de votre sélection ?",
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
                          child: Text("Supprimer cette annonce",
                              style: AppStyles.buttonTextWhite,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2),
                          onPressed: () async {
                            bool resp = await bloc.deleteFavorisWithIdFavoris(
                                item.oidFavori.toString());
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
}
