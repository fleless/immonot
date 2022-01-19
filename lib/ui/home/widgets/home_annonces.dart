import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:immonot/constants/app_colors.dart';
import 'package:immonot/constants/app_constants.dart';
import 'package:immonot/constants/routes.dart';
import 'package:immonot/constants/styles/app_styles.dart';
import 'package:immonot/models/enum/bookmark_params_model.dart';
import 'package:immonot/models/enum/type_biens.dart';
import 'package:immonot/models/enum/type_ventes.dart';
import 'package:immonot/models/fake/fake_json_response.dart';
import 'package:immonot/models/fake/fake_list.dart';
import 'package:immonot/models/fake/filtersModel.dart';
import 'package:immonot/models/requests/create_alerte_request.dart';
import 'package:immonot/models/requests/search_request.dart';
import 'package:immonot/models/responses/SearchResponse.dart';
import 'package:immonot/models/responses/places_response.dart';
import 'package:immonot/ui/favoris/favoris_bloc.dart';
import 'package:immonot/ui/home/widgets/shimmers/shimmer_annonces_horizontal.dart';
import 'package:immonot/ui/profil/auth/auth_screen.dart';
import 'package:immonot/utils/session_controller.dart';
import 'package:immonot/utils/shared_preferences.dart';
import 'package:immonot/utils/user_location.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import '../home_bloc.dart';

class HomeAnnoncesWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HomeAnnoncesWidgetState();
}

class _HomeAnnoncesWidgetState extends State<HomeAnnoncesWidget> {
  List<FakeJsonResponse> fakeAnnonces = <FakeJsonResponse>[];
  bool loading = false;
  final bloc = Modular.get<HomeBloc>();
  final favorisBloc = Modular.get<FavorisBloc>();
  final sessionController = Modular.get<SessionController>();
  List<Content> searchList = <Content>[];
  SearchResponse _searchResponse = SearchResponse(totalElements: 0);
  final userLocation = Modular.get<UserLocation>();
  PlacesResponse _currentDepartment;
  final SharedPref sharedPref = SharedPref();

  @override
  void initState() {
    super.initState();
    _loadAnnonces();
  }

  @override
  Widget build(BuildContext context) {
    return _buildContent();
  }

  _loadAnnonces() async {
    if (mounted) {
      setState(() {
        loading = true;
      });
    }
    bool _gpsEnabled = await userLocation.checkIfGPSEnabled();
    String _positionToSearch = "";
    bool _locationPermission =
        await userLocation.checkIfLocalisationPermissionProvided();
    if ((_gpsEnabled) && (_locationPermission)) {
      String _userDepartment = await userLocation.getUserDepartment();
      List<PlacesResponse> resp = await bloc.searchPlaces(_userDepartment);
      if (resp != null) {
        if (resp.isNotEmpty) {
          _currentDepartment = resp.first;
          _positionToSearch = resp.first.code;
        }
      }
    } else {
      print("permission not enabled");
    }

    /// On lance une recherche des annonces les plus proches
    SearchResponse resp = await bloc.searchAnnonces(
        0,
        Recherche(
            typeVentes: null,
            references: null,
            oidCommunes: [_positionToSearch],
            departements: [_positionToSearch],
            rayons: null,
            typeBiens: null,
            prix: null,
            surfaceExterieure: null,
            surfaceInterieure: null,
            nbPieces: null,
            nbChambres: null),
        bloc.tri,
        false,
        bloc.currentFilter);

    /// Si le nombre de résultats retournés est zéro on lance la dernière recherche faite
    if (resp.numberOfElements == 0) {
      // c'est la dernière requete pour l'utilisateur dans le device
      //check if there is last_filter to avoid error when parsing
      dynamic test = await sharedPref.read(AppConstants.LAST_FILTER);
      if (test != null) {
        FilterModels request = FilterModels.fromJson(
            await sharedPref.read(AppConstants.LAST_FILTER));
        if (request != null) {
          //parse bloc elements to recherche type before sending them
          List<String> _oidCommunes = <String>[];
          List<String> _oidDepartements = <String>[];
          List<double> _rayons = <double>[];
          List<double> _prix = <double>[];
          List<double> _surfaceExterieur = <double>[];
          List<double> _surfaceInterieur = <double>[];
          List<double> _nbPieces = <double>[];
          List<double> _nbChambres = <double>[];

          List<String> _typeBiens =
              request.listtypeDeBien.map((e) => e.code).toList();
          List<String> _typesVenteLabels =
              request.listTypeVente.map((e) => e.code).toList();
          List<String> _references =
              request.reference == null ? [] : [request.reference];
          request.listPlaces.forEach((element) {
            if (element.code.length < 5) {
              _oidDepartements.add(element.code);
            } else {
              _oidCommunes.add(element.code);
            }
          });
          _rayons.add(request.rayon);
          _prix.addAll([request.priceMin, request.priceMax]);
          _surfaceExterieur
              .addAll([request.surExterieurMin, request.surExterieurMax]);
          _surfaceInterieur
              .addAll([request.surInterieurMin, request.surInterieurMax]);
          _nbPieces.addAll([request.piecesMin, bloc.currentFilter.piecesMax]);
          _nbChambres.addAll([request.chambresMin, request.chambresMin]);

          resp = await bloc.searchAnnonces(
              0,
              Recherche(
                  typeVentes: _typesVenteLabels,
                  references: _references,
                  oidCommunes: _oidCommunes,
                  departements: _oidDepartements,
                  rayons: _oidCommunes.length == 0 ? [] : _rayons,
                  typeBiens: _typeBiens,
                  prix: _prix,
                  surfaceExterieure: _surfaceExterieur,
                  surfaceInterieure: _surfaceInterieur,
                  nbPieces: _nbPieces,
                  nbChambres: _nbChambres,
                  oidNotaires: bloc.currentFilter.oidNotaires),
              bloc.tri,
              false,
              bloc.currentFilter);
        }
      }
    }

    /// Si le nombre de résultats retournés est zéro on lance une nouvelle recherche par défaut
    if (resp.numberOfElements == 0) {
      resp = await bloc.searchAnnonces(
          0,
          Recherche(
              typeVentes: null,
              references: null,
              oidCommunes: null,
              departements: null,
              rayons: null,
              typeBiens: null,
              prix: null,
              surfaceExterieure: null,
              surfaceInterieure: null,
              nbPieces: null,
              nbChambres: null),
          bloc.tri,
          false,
          bloc.currentFilter);
    }
    if (mounted)
      setState(() {
        searchList = resp.content;
        _searchResponse = resp;
        loading = false;
      });
  }

  Widget _buildContent() {
    return Padding(
      padding: EdgeInsets.only(right: 0, top: 40, bottom: 10, left: 15),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            "Annonces immobilières",
            textAlign: TextAlign.left,
            style: AppStyles.titleStyle,
            overflow: TextOverflow.clip,
            maxLines: 1,
          ),
          SizedBox(height: 5),
          Padding(
            padding: EdgeInsets.only(right: 15),
            child: Container(
              child: InkWell(
                splashColor: AppColors.defaultColor.withOpacity(0.2),
                highlightColor: Colors.transparent,
                onTap: () => _openSearch(),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                          "Trouvez un bien immobilier avec les notaires de France",
                          overflow: TextOverflow.ellipsis,
                          maxLines: 3,
                          style: AppStyles.subTitleStyle),
                    ),
                    SizedBox(width: 40),
                    FaIcon(FontAwesomeIcons.chevronRight,
                        size: 15, color: AppColors.defaultColor),
                  ],
                ),
              ),
            ),
          ),
          Padding(padding: EdgeInsets.only(top: 15)),
          loading ? buildShimmerAnnoncesHorizontal() : _buildCards(),
        ],
      ),
    );
  }

  Widget _buildCards() {
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
                                                    "Vente aux enchères"
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
                                  ? item.prixLigne1.replaceAll("&euro;", "€") +
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

  _openSearch() {
    bloc.currentFilter.priceMin = 0.0;
    bloc.currentFilter.priceMax = 0.0;
    bloc.currentFilter.piecesMax = 0.0;
    bloc.currentFilter.piecesMin = 0.0;
    bloc.currentFilter.reference = null;
    bloc.currentFilter.chambresMin = 0;
    bloc.currentFilter.chambresMax = 0;
    bloc.currentFilter.surInterieurMax = 0.0;
    bloc.currentFilter.surInterieurMin = 0.0;
    bloc.currentFilter.surExterieurMin = 0.0;
    bloc.currentFilter.surExterieurMax = 0.0;
    bloc.currentFilter.rayon = null;
    bloc.currentFilter.listTypeVente.clear();
    bloc.currentFilter.listPlaces.clear();
    if (_currentDepartment != null)
      bloc.currentFilter.listPlaces.add(_currentDepartment);
    Modular.to.pushNamed(Routes.searchResults);
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
