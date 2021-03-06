import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:immonot/constants/app_colors.dart';
import 'package:immonot/constants/app_images.dart';
import 'package:immonot/constants/routes.dart';
import 'package:immonot/constants/styles/app_styles.dart';
import 'package:immonot/models/enum/bookmark_params_model.dart';
import 'package:immonot/models/fake/fakeResults.dart';
import 'package:immonot/models/fake/fake_json_response.dart';
import 'package:immonot/models/fake/fake_list.dart';
import 'package:immonot/models/requests/create_alerte_request.dart';
import 'package:immonot/models/requests/search_request.dart';
import 'package:immonot/models/responses/DetailAnnonceResponse.dart';
import 'package:immonot/models/responses/SearchResponse.dart';
import 'package:immonot/ui/favoris/favoris_bloc.dart';
import 'package:immonot/ui/home/widgets/shimmers/shimmer_annonces_horizontal.dart';
import 'package:immonot/ui/home/widgets/shimmers/shimmer_annonces_result.dart';
import 'package:immonot/ui/profil/auth/auth_screen.dart';
import 'package:immonot/utils/session_controller.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:page_indicator/page_indicator.dart';

import '../../home_bloc.dart';

class DetailPropAnnoncesWidget extends StatefulWidget {
  DetailAnnonceResponse fake;
  double heightPadding;

  DetailPropAnnoncesWidget(DetailAnnonceResponse item, double heightPadding) {
    this.fake = item;
    this.heightPadding = heightPadding;
  }

  @override
  State<StatefulWidget> createState() => _DetailPropAnnoncesWidgetState();
}

class _DetailPropAnnoncesWidgetState extends State<DetailPropAnnoncesWidget> {
  GlobalKey<PageContainerState> key = GlobalKey();
  DetailAnnonceResponse _fakeItem;
  final bloc = Modular.get<HomeBloc>();
  final favorisBloc = Modular.get<FavorisBloc>();
  final sessionController = Modular.get<SessionController>();
  bool loading = false;
  List<Content> searchList = <Content>[];
  SearchResponse _searchResponse = SearchResponse(totalElements: 0);

  @override
  void initState() {
    super.initState();
    _fakeItem = widget.fake;
    _loadAnnonces();
  }

  _loadAnnonces() async {
    if (mounted) {
      setState(() {
        loading = true;
      });
    }
    SearchResponse resp = await bloc.searchAnnonces(
        0,
        Recherche(
            typeVentes: [_fakeItem.typeVenteCode],
            references: null,
            oidCommunes: [_fakeItem.commune.code],
            departements: null,
            rayons: null,
            typeBiens: [_fakeItem.typeBienCode],
            prix: null,
            surfaceExterieure: null,
            surfaceInterieure: null,
            nbPieces: null,
            nbChambres: null),
        bloc.tri,
        false,
        bloc.currentFilter);
    if (mounted)
      setState(() {
        searchList = resp.content;
        searchList.removeWhere(
            (element) => element.oidAnnonce == _fakeItem.oidAnnonce);
        _searchResponse = resp;
        loading = false;
      });
  }

  @override
  Widget build(BuildContext context) {
    return _buildContent();
  }

  Widget _buildContent() {
    return searchList.length == 0
        ? SizedBox.shrink()
        : Container(
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: widget.heightPadding),
                Divider(color: AppColors.hint),
                SizedBox(height: widget.heightPadding),
                Text("Ces biens peuvent aussi vous int??resser",
                    style: AppStyles.titleStyle),
                loading ? buildShimmerAnnoncesHorizontal() : _buildList(),
              ],
            ),
          );
  }

  Widget _buildList() {
    return Container(
      height: 330,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: searchList == null ? 0 : searchList.length,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            var item = searchList[index];
            return InkWell(
              onTap: () => _moveToDetails(item.oidAnnonce),
              child: Container(
                width: 190,
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        height: 222,
                        child: Stack(
                          children: [
                            Container(
                              height: double.infinity,
                              child: Card(
                                clipBehavior: Clip.antiAliasWithSaveLayer,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                elevation: 5,
                                child: item.photo.principale == null
                                    ? Image.network(
                                        "https://www.generationsforpeace.org/wp-content/uploads/2018/03/empty.jpg",
                                        fit: BoxFit.cover)
                                    : Image.network(item.photo.principale,
                                        fit: BoxFit.cover),
                              ),
                            ),
                            Positioned(
                              top: 15.0,
                              right: 15.0,
                              child: InkWell(
                                splashColor: AppColors.defaultColor,
                                onTap: () async {
                                  await sessionController.isSessionConnected()
                                      ? _addOrDeleteFavori(
                                          item,
                                          item.favori == null
                                              ? false
                                              : item.favori)
                                      : _showConnectionDialog();
                                },
                                child: CircleAvatar(
                                    child: FaIcon(FontAwesomeIcons.solidHeart,
                                        color: item.favori == null
                                            ? AppColors.default_black
                                            : item.favori
                                                ? AppColors.defaultColor
                                                : AppColors.default_black,
                                        size: 18),
                                    radius: 17.0,
                                    backgroundColor: AppColors.white),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 5, left: 10, right: 10),
                      child: RichText(
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        text: TextSpan(
                          children: <TextSpan>[
                            TextSpan(
                                text: item.typeVente,
                                style: item.typeVente == "Achat"
                                    ? AppStyles.typeAnnoncesAchat
                                    : item.typeVente == "Location"
                                        ? AppStyles.typeAnnoncesLocation
                                        : item.typeVente == "Viager"
                                            ? AppStyles.typeAnnoncesViager
                                            : item.typeVente ==
                                                    "Vente aux ench??res"
                                                ? AppStyles
                                                    .typeAnnoncesVenteAuxEncheres
                                                : AppStyles.typeAnnoncesEVente),
                            TextSpan(
                                text: ' - ', style: AppStyles.genreAnnonces),
                            TextSpan(
                                text: item.typeBien,
                                style: AppStyles.genreAnnonces)
                          ],
                        ),
                      ),
                    ),
                    item.afficheCommune
                        ? Padding(
                            padding:
                                EdgeInsets.only(top: 6, left: 10, right: 10),
                            child: Text(
                              item.commune.nom +
                                  " - " +
                                  item.commune.codePostal,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              style: AppStyles.locationAnnonces,
                            ))
                        : SizedBox.shrink(),
                    item.affichePrix
                        ? Padding(
                            padding:
                                EdgeInsets.only(top: 6, left: 10, right: 10),
                            child: Text(
                              item.prixLigne1 != null
                                  ? item.prixLigne1.replaceAll("&euro;", "???") +
                                      " "
                                  : " Nous consulter ",
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: AppStyles.titleStyle,
                            ),
                          )
                        : SizedBox.shrink(),
                  ],
                ),
              ),
            );
          }),
    );
  }

  _addOrDeleteFavori(Content item, bool isFavoris) async {
    if (isFavoris) {
      bool resp = await favorisBloc.deleteFavoris(item.oidAnnonce);
      if (resp) {
        setState(() {
          item.favori = false;
        });
      }
    } else {
      bool resp = await favorisBloc.addFavoris(item.oidAnnonce);
      if (resp) {
        setState(() {
          item.favori = true;
        });
      }
    }
  }

  _showConnectionDialog() {
    return showCupertinoModalBottomSheet(
      context: context,
      expand: false,
      enableDrag: true,
      builder: (context) => AuthScreen(true),
    ).then((value) async =>
        await sessionController.isSessionConnected() ? _loadAnnonces() : null);
  }

  /// this function allow the push to details section with callback if the item was bookmarked
  _moveToDetails(String oidAnnonce) async {
    final _params = (await Navigator.pushNamed(context, Routes.detailsAnnonce,
        arguments: {'id': oidAnnonce})) as BookmarkParamsModel;
    setState(() {
      searchList
          .where((element) => element.oidAnnonce == oidAnnonce)
          .first
          .favori = _params.favoris;
      searchList
          .where((element) => element.oidAnnonce == oidAnnonce)
          .first
          .suiviPrix = _params.suivrPrix;
    });
  }
}
