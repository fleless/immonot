import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:immonot/constants/app_colors.dart';
import 'package:immonot/constants/app_icons.dart';
import 'package:immonot/constants/app_images.dart';
import 'package:immonot/constants/routes.dart';
import 'package:immonot/constants/styles/app_styles.dart';
import 'package:immonot/models/enum/bookmark_params_model.dart';
import 'package:immonot/models/requests/create_alerte_request.dart';
import 'package:immonot/models/responses/DetailAnnonceResponse.dart';
import 'package:immonot/models/responses/SearchResponse.dart';
import 'package:immonot/ui/alertes/alertes_bloc.dart';
import 'package:immonot/ui/favoris/favoris_bloc.dart';
import 'package:immonot/ui/home/search_results/filter_bloc.dart';
import 'package:immonot/ui/home/search_results/filter_screen.dart';
import 'package:immonot/ui/home/search_results/honoraires/honoraire_bottom_sheet.dart';
import 'package:immonot/ui/home/search_results/tri_bottom_sheet.dart';
import 'package:immonot/ui/home/widgets/shimmers/shimmer_annonces_result.dart';
import 'package:immonot/ui/profil/auth/auth_screen.dart';
import 'package:immonot/utils/flushbar_utils.dart';
import 'package:immonot/utils/session_controller.dart';
import 'package:immonot/widgets/bottom_navbar_widget.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import "dart:ui" as ui;
import '../home_bloc.dart';

class SearchResultsScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SearchResultsScreenState();
}

class _SearchResultsScreenState extends State<SearchResultsScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  ScrollController _controller;
  TextEditingController _nameController = TextEditingController();
  final bloc = Modular.get<HomeBloc>();
  final filterBloc = Modular.get<FilterBloc>();
  final favorisBloc = Modular.get<FavorisBloc>();
  final alertesBloc = Modular.get<AlertesBloc>();
  final sessionController = Modular.get<SessionController>();
  final _searchController = TextEditingController();
  bool loading = false;
  bool _showPaginationLoader = false;
  List<Content> searchList = <Content>[];
  SearchResponse _searchResponse = SearchResponse(totalElements: 0);
  bool scrolling = false;
  final _formKey = GlobalKey<FormState>();
  bool _buttonDialogLoading = false;

  @override
  void initState() {
    _controller = ScrollController();
    _controller.addListener(_scrollListener);
    _searchController.text = _searchDetails();
    bloc.changesNotifier.listen((value) {
      _goSearch(0, false);
      _searchController.text = _searchDetails();
    });
    bloc.suiviPrixFromHonoraireSearchScreenNotifier.listen((value) {
      if (mounted)
        setState(() {
          int index =
              searchList.indexWhere((element) => element.oidAnnonce == value);
          searchList[index].suiviPrix = true;
          searchList[index].favori = true;
        });
    });

    bloc.triNotifier.listen((value) {
      _goTri();
    });

    _goSearch(0, false);

    filterBloc.filterTagsList.clear();

    super.initState();
  }

  _goTri() async {
    _goSearch(0, true);
  }

  _goSearch(int pageNumber, bool sorted) async {
    print("looking for search " +
        bloc.currentFilter.listtypeDeBien.length.toString());
    if (!sorted) bloc.tri = "";
    if (pageNumber == 0) {
      if (mounted) {
        setState(() {
          loading = true;
        });
      }
    } else {
      if (mounted) {
        setState(() {
          _showPaginationLoader = true;
        });
      }
    }
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
        bloc.currentFilter.listtypeDeBien.map((e) => e.code).toList();
    List<String> _typesVenteLabels =
        bloc.currentFilter.listTypeVente.map((e) => e.code).toList();
    List<String> _references = bloc.currentFilter.reference == null
        ? []
        : [bloc.currentFilter.reference];
    bloc.currentFilter.listPlaces.forEach((element) {
      if (element.code.length < 5) {
        _oidDepartements.add(element.code);
      } else {
        _oidCommunes.add(element.code);
      }
    });
    _rayons.add(bloc.currentFilter.rayon);
    _prix.addAll([bloc.currentFilter.priceMin, bloc.currentFilter.priceMax]);
    _surfaceExterieur.addAll([
      bloc.currentFilter.surExterieurMin,
      bloc.currentFilter.surExterieurMax
    ]);
    _surfaceInterieur.addAll([
      bloc.currentFilter.surInterieurMin,
      bloc.currentFilter.surInterieurMax
    ]);
    _nbPieces
        .addAll([bloc.currentFilter.piecesMin, bloc.currentFilter.piecesMax]);
    _nbChambres.addAll(
        [bloc.currentFilter.chambresMin, bloc.currentFilter.chambresMin]);

    SearchResponse resp = await bloc.searchAnnonces(
        pageNumber,
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
        true,
        bloc.currentFilter);
    if (pageNumber == 0) {
      _firstSearh(resp);
    } else {
      _getMoreSearch(resp);
    }
  }

  _firstSearh(SearchResponse resp) {
    if (mounted) {
      setState(() {
        searchList = resp.content;
        _searchResponse = resp;
        loading = false;
      });
    }
  }

  _getMoreSearch(SearchResponse resp) {
    setState(() {
      searchList.addAll(resp.content);
      _searchResponse = resp;
      _showPaginationLoader = false;
    });
  }

  String _searchDetails() {
    String str = "";
    if (bloc.currentFilter.listPlaces.length == 0) {
      str += "Toute la france";
    } else {
      bloc.currentFilter.listPlaces.forEach((element) {
        str = str +
            (element.nom == null ? "" : element.nom) +
            " (" +
            (element.codePostal == null ? element.code : element.codePostal) +
            "), ";
      });
    }
    return str;
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
      if (_searchResponse.number != _searchResponse.totalPages) {
        setState(() {
          _goSearch(_searchResponse.number + 1, bloc.tri != "" ? true : false);
        });
        //_searchResponse = await _goSearch();
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomInset: true,
      backgroundColor: AppColors.appBackground,
      //drawer: DrawerWidget(),
      body: SafeArea(
        child: Container(
          height: double.infinity,
          child: Stack(
            children: [
              _buildContent(),
              !scrolling ? _buildLargeSaveButton() : _buildSmallSaveButton()
            ],
          ),
        ),
      ),
      //LoadingIndicator(loading: _bloc.loading),
      //NetworkErrorMessages(error: _bloc.error),
      bottomNavigationBar: const BottomNavbar(route: Routes.home),
    );
  }

  Widget _buildContent() {
    return Container(
      height: double.infinity,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Card(
            elevation: 3,
            color: AppColors.white,
            child: Padding(
              padding: EdgeInsets.only(top: 30),
              child: Column(
                children: [
                  _buildHeader(),
                  SizedBox(height: 15),
                  _buildBottomHeader(),
                  SizedBox(height: 25),
                ],
              ),
            ),
          ),
          SizedBox(height: 10),
          Expanded(
            child: loading
                ? buildShimmerSearchAnnonces()
                : (searchList == null
                    ? _buildNoItemWidget()
                    : searchList.isEmpty
                        ? _buildNoItemWidget()
                        : _buildList()),
          ),
        ],
      ),
    );
  }

  Widget _buildNoItemWidget() {
    return Container(
      height: double.infinity,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(AppImages.noElement),
            Padding(
              padding: EdgeInsets.all(30),
              child: Text(
                  "Nous n'avons trouvé aucune annonce pour votre recherche immobilière",
                  style: AppStyles.textNormal,
                  textAlign: TextAlign.center),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          InkWell(
            onTap: () {
              Modular.to.pop();
            },
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: FaIcon(
                FontAwesomeIcons.chevronLeft,
                size: 17,
                color: AppColors.defaultColor,
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => {
                showCupertinoModalBottomSheet(
                  context: context,
                  expand: false,
                  enableDrag: true,
                  builder: (context) => FilterSearchWidget(),
                ),
              },
              child: Card(
                clipBehavior: Clip.antiAlias,
                shape: RoundedRectangleBorder(
                  side: new BorderSide(color: AppColors.hint, width: 0.2),
                  borderRadius: BorderRadius.all(Radius.circular(7.0)),
                ),
                elevation: 2,
                shadowColor: AppColors.hint,
                color: AppColors.appBackground,
                child: Container(
                  color: AppColors.white,
                  child: TextFormField(
                    controller: _searchController,
                    enabled: false,
                    cursorColor: AppColors.defaultColor,
                    decoration: const InputDecoration(
                      fillColor: AppColors.white,
                      hoverColor: AppColors.white,
                      focusColor: AppColors.white,
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.only(
                          bottom: 15.0, left: 10.0, right: 10.0, top: 15.0),
                      hintText: "Ville, département, code postal",
                      hintStyle: AppStyles.hintSearch,
                    ),
                  ),
                ),
              ),
            ),
          ),
          InkWell(
            onTap: () {
              showCupertinoModalBottomSheet(
                context: context,
                expand: false,
                enableDrag: true,
                builder: (context) => FilterSearchWidget(),
              );
            },
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: FaIcon(
                FontAwesomeIcons.pencilAlt,
                size: 17,
                color: AppColors.defaultColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomHeader() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 30),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                _searchResponse.totalElements == null
                    ? "Aucun réusltat"
                    : (_searchResponse.totalElements.toString() +
                        (_searchResponse.totalElements == null
                            ? " Résultat"
                            : _searchResponse.totalElements < 2
                                ? " Résultat"
                                : " Résultats")),
                style: AppStyles.subTitleStyle,
                textAlign: TextAlign.left,
              ),
            ),
          ),
          Expanded(
            child: InkWell(
              onTap: () {
                showBarModalBottomSheet(
                  context: context,
                  expand: false,
                  enableDrag: true,
                  builder: (context) => TriBottomSheetWidget(),
                );
              },
              child: Align(
                alignment: Alignment.centerRight,
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    children: [
                      TextSpan(text: "Tri   ", style: AppStyles.subTitleStyle),
                      WidgetSpan(
                          alignment: ui.PlaceholderAlignment.middle,
                          child: Image(
                              image: AssetImage('assets/icons/sort.png'))),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildList() {
    return Container(
      child: ListView.builder(
        controller: _controller,
        scrollDirection: Axis.vertical,
        itemCount: searchList == null ? 0 : searchList.length + 1,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          Content item = Content();
          if (index != searchList.length) {
            item = searchList[index];
          }
          return index == searchList.length
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
                  onTap: () => _moveToDetails(item.oidAnnonce),
                  child: Container(
                      //height: 222,
                      child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                    child: Card(
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        elevation: 5,
                        color: AppColors.white,
                        child: Column(
                          children: [
                            _buildImage(item),
                            SizedBox(height: 10),
                            _buildDescription(item),
                            SizedBox(height: 10),
                          ],
                        )),
                  )),
                );
        },
      ),
    );
  }

  /// this function allow the push to details section with callback if the item was bookmarked or following price changed
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

  _buildImage(Content fake) {
    return Container(
      height: MediaQuery.of(context).size.width > 1000 ? 400 : 230,
      width: double.infinity,
      child: Stack(
        children: [
          Container(
              width: double.infinity,
              height: double.infinity,
              child: fake.photo.principale == null
                  ? Image.network(
                      "https://www.generationsforpeace.org/wp-content/uploads/2018/03/empty.jpg",
                      fit: BoxFit.cover)
                  : Image.network(fake.photo.principale, fit: BoxFit.cover)),
          Positioned(
            top: 15.0,
            right: 15.0,
            child: InkWell(
              splashColor: AppColors.defaultColor,
              onTap: () async {
                await sessionController.isSessionConnected()
                    ? _addOrDeleteFavori(
                        fake, fake.favori == null ? false : fake.favori)
                    : _showConnectionDialog();
              },
              child: CircleAvatar(
                  child: FaIcon(FontAwesomeIcons.solidHeart,
                      color: fake.favori == null
                          ? AppColors.default_black
                          : fake.favori
                              ? AppColors.defaultColor
                              : AppColors.default_black,
                      size: 18),
                  radius: 17.0,
                  backgroundColor: AppColors.white),
            ),
          ),
          Positioned(
            bottom: 15.0,
            right: 15.0,
            child: Container(
              width: 30,
              height: 20,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6.0),
                  color: AppColors.default_black.withOpacity(0.7)),
              child: Center(
                child: Text(
                  fake.photo.count == null ? "0" : fake.photo.count.toString(),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppStyles.nbrPictures,
                ),
              ),
            ),
          ),
          (!fake.coupDeCoeur) || (fake.coupDeCoeur == null)
              ? SizedBox.shrink()
              : Positioned(
                  top: 15.0,
                  left: 0.0,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(15.0),
                        bottomRight: Radius.circular(15.0),
                      ),
                      color: AppColors.defaultColor,
                    ),
                    child: Center(
                      child: Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                        child: Text(
                          "Sélection",
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppStyles.offreStyle,
                        ),
                      ),
                    ),
                  ),
                ),
          //TODO: 36H immo
          /*fake.offre != null
              ? Positioned(
                  top: 15.0,
                  left: 0.0,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(15.0),
                        bottomRight: Radius.circular(15.0),
                      ),
                      color: fake.offre.startsWith("E")
                          ? AppColors.blueTypeColor
                          : AppColors.defaultColor,
                    ),
                    child: Center(
                      child: Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                        child: Text(
                          fake.offre,
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppStyles.offreStyle,
                        ),
                      ),
                    ),
                  ),
                )
              : SizedBox.shrink(),*/
        ],
      ),
    );
  }

  _buildDescription(Content fake) {
    return Container(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 5, left: 10, right: 10),
            child: RichText(
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              text: TextSpan(
                children: <TextSpan>[
                  TextSpan(
                      text: fake.typeVente,
                      style: fake.typeVente == "Achat"
                          ? AppStyles.typeAnnoncesAchat
                          : fake.typeVente == "Location"
                              ? AppStyles.typeAnnoncesLocation
                              : fake.typeVente == "Viager"
                                  ? AppStyles.typeAnnoncesViager
                                  : fake.typeVente == "Vente aux enchères"
                                      ? AppStyles.typeAnnoncesVenteAuxEncheres
                                      : AppStyles.typeAnnoncesEVente),
                  TextSpan(text: ' - ', style: AppStyles.typeAnnonceBlack),
                  TextSpan(
                      text: fake.typeBien, style: AppStyles.typeAnnonceBlack)
                ],
              ),
            ),
          ),
          fake.afficheCommune
              ? Padding(
                  padding: EdgeInsets.only(top: 10, left: 10, right: 10),
                  child: Text(
                    fake.commune.nom + " - " + fake.commune.codePostal,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    style: AppStyles.locationAnnonces,
                  ))
              : SizedBox.shrink(),
          fake.affichePrix
              ? Padding(
                  padding: EdgeInsets.only(top: 10, left: 10, right: 10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        fake.prixLigne1 != null
                            ? fake.prixLigne1.replaceAll("&euro;", "€") + " "
                            : " Nous consulter ",
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: AppStyles.titleStyle,
                      ),
                      if (fake.prixEnBaisse != null)
                        fake.prixEnBaisse
                            ? Container(
                                alignment: Alignment.topLeft,
                                child: FaIcon(
                                  FontAwesomeIcons.arrowDown,
                                  color: AppColors.greenColor,
                                  size: 10,
                                ),
                              )
                            : SizedBox.shrink(),
                      SizedBox(width: 5),
                      InkWell(
                        onTap: () {
                          _showHonoraire(
                              DetailAnnonceResponse(
                                  oidAnnonce: fake.oidAnnonce,
                                  favori: fake.favori,
                                  suiviPrix: fake.suiviPrix,
                                  contact: Contact(
                                      hasBareme: fake.contact.hasBareme)),
                              fake.prixLigne1,
                              fake.prixLigne2,
                              fake.prixLigne3,
                              fake.typeVente,
                              fake.contact != null
                                  ? (fake.contact.nom != null
                                      ? fake.contact.nom
                                      : "Nom du notaire")
                                  : "Nom du notaire",
                              fake.prixEnBaisse != null
                                  ? fake.prixEnBaisse
                                  : false,
                              fake.oidNotaire);
                        },
                        child: Image(
                          image: AssetImage(AppIcons.info),
                          color: AppColors.defaultColor,
                          alignment: Alignment.center,
                        ),
                      ),
                    ],
                  ),
                )
              : SizedBox.shrink(),
          //TODO: encheres en ligne à faire
          /*fake.debutEnchere != null
              ? Padding(
                  padding: EdgeInsets.only(top: 5, left: 10, right: 10),
                  child: Text("1er offre possible",
                      style: AppStyles.locationAnnonces),
                )
              : SizedBox.shrink(),*/
          _buildFooterDetails(fake)
        ],
      ),
    );
  }

  Widget _buildFooterDetails(Content fake) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      child: ((fake.typeVente.startsWith("E-") ||
              (fake.typeVente.startsWith("Vente aux enchères en ligne"))))
          ? _buildAlternativeFooterDetails(fake)
          : ((fake.caracteristiques.surfaceHabitable == 0.0) &&
                  (fake.caracteristiques.surfaceTerrain == 0) &&
                  (fake.caracteristiques.nbPieces == 0) &&
                  (fake.caracteristiques.nbChambres == 0))
              ? SizedBox.shrink()
              : _buildNormalFooterDetails(fake),
    );
  }

  Widget _buildAlternativeFooterDetails(Content fake) {
    return Row(
      children: [
        //TODO: when des enchères
        /*fake.debutEnchere.startsWith("Début")
            ? FaIcon(FontAwesomeIcons.calendarAlt,
                color: AppColors.blueTypeColor, size: 22)
            : FaIcon(FontAwesomeIcons.clock,
                color: AppColors.defaultColor, size: 22),
        SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(fake.etatEnchere,
                style: AppStyles.locationAnnonces, textAlign: TextAlign.start),
            SizedBox(height: 3),13.99
            Text(fake.debutEnchere,
                style: AppStyles.typeAnnonceBlack, textAlign: TextAlign.start)
          ],
        )*/
      ],
    );
  }

  Widget _buildNormalFooterDetails(Content fake) {
    double bigPadding = 12;
    double smallPadding = 3;
    return Container(
      height: 18,
      child: Row(
        children: [
          fake.caracteristiques.surfaceHabitable != 0.0
              ? Image(
                  image: AssetImage(AppIcons.square),
                  color: AppColors.defaultColor,
                )
              : SizedBox.shrink(),
          fake.caracteristiques.surfaceHabitable != 0.0
              ? SizedBox(width: smallPadding)
              : SizedBox.shrink(),
          fake.caracteristiques.surfaceHabitable != 0.0
              ? Text(fake.caracteristiques.surfaceHabitable.toString() + "m²",
                  style: AppStyles.typeAnnonceBlack)
              : SizedBox.shrink(),
          fake.caracteristiques.surfaceHabitable != 0.0
              ? SizedBox(width: bigPadding)
              : SizedBox.shrink(),
          fake.caracteristiques.surfaceTerrain != 0
              ? Image(
                  image: AssetImage(AppIcons.selectAll),
                  color: AppColors.defaultColor,
                )
              : SizedBox.shrink(),
          fake.caracteristiques.surfaceTerrain != 0
              ? SizedBox(width: smallPadding)
              : SizedBox.shrink(),
          fake.caracteristiques.surfaceTerrain != 0
              ? Text(fake.caracteristiques.surfaceTerrain.toString() + "m²",
                  style: AppStyles.typeAnnonceBlack)
              : SizedBox.shrink(),
          fake.caracteristiques.surfaceTerrain != 0
              ? SizedBox(width: bigPadding)
              : SizedBox.shrink(),
          fake.caracteristiques.nbPieces != 0
              ? Image(
                  image: AssetImage(AppIcons.door),
                  color: AppColors.defaultColor,
                )
              : SizedBox.shrink(),
          fake.caracteristiques.nbPieces != 0
              ? SizedBox(width: smallPadding)
              : SizedBox.shrink(),
          fake.caracteristiques.nbPieces != 0
              ? Text(fake.caracteristiques.nbPieces.toString(),
                  style: AppStyles.typeAnnonceBlack)
              : SizedBox.shrink(),
          fake.caracteristiques.nbPieces != 0
              ? SizedBox(width: bigPadding)
              : SizedBox.shrink(),
          fake.caracteristiques.nbChambres != 0
              ? Image(
                  image: AssetImage(AppIcons.lit),
                  color: AppColors.defaultColor,
                )
              : SizedBox.shrink(),
          fake.caracteristiques.nbChambres != 0
              ? SizedBox(width: smallPadding)
              : SizedBox.shrink(),
          fake.caracteristiques.nbChambres != 0
              ? Text(fake.caracteristiques.nbChambres.toString(),
                  style: AppStyles.typeAnnonceBlack)
              : SizedBox.shrink(),
        ],
      ),
    );
  }

  Widget _buildSmallSaveButton() {
    return Positioned(
      bottom: 10,
      right: 15,
      child: InkWell(
        onTap: () async {
          if (await sessionController.isSessionConnected()) {
            _saveSearch();
          } else {
            if (!loading)
              showCupertinoModalBottomSheet(
                context: context,
                expand: false,
                enableDrag: true,
                builder: (context) => AuthScreen(true),
              ).then((value) async {
                await sessionController.isSessionConnected()
                    ? _saveSearch()
                    : null;
              });
          }
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
            width: 70,
            child: Center(
              child: FaIcon(
                FontAwesomeIcons.solidBell,
                color: AppColors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLargeSaveButton() {
    return Align(
      alignment: FractionalOffset.bottomCenter,
      child: InkWell(
        onTap: () async {
          if (await sessionController.isSessionConnected()) {
            _saveSearch();
          } else {
            if (!loading)
              showCupertinoModalBottomSheet(
                context: context,
                expand: false,
                enableDrag: true,
                builder: (context) => AuthScreen(true),
              ).then((value) async {
                await sessionController.isSessionConnected()
                    ? _saveSearch()
                    : null;
              });
          }
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
            width: MediaQuery.of(context).size.width * 0.6,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Center(
                child: RichText(
                  overflow: TextOverflow.clip,
                  maxLines: 2,
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    children: [
                      WidgetSpan(
                        alignment: ui.PlaceholderAlignment.middle,
                        child: FaIcon(
                          FontAwesomeIcons.solidBell,
                          color: AppColors.white,
                          size: 16,
                        ),
                      ),
                      TextSpan(
                          text: "  SAUVEGARDER LA RECHERCHE",
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

  _saveSearch() {
    _nameController.text = "";
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
                        "Sauvegarder la recherche et créer une alerte",
                        textAlign: TextAlign.center,
                        style: AppStyles.titleStyleH2,
                      ),
                    ),
                    SizedBox(height: 10),
                    Container(
                      color: AppColors.defaultColor,
                      height: 5,
                    ),
                    SizedBox(height: 10),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                      child: Form(
                        key: _formKey,
                        child: TextFormField(
                          controller: _nameController,
                          cursorColor: AppColors.defaultColor,
                          style: AppStyles.textNormal,
                          onChanged: (value) =>
                              _formKey.currentState.validate(),
                          decoration: InputDecoration(
                            hintText: "Nom de l'alerte",
                            hintStyle: AppStyles.hintSearch,
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: AppColors.hint),
                            ),
                            errorBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: AppColors.alert),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide:
                                  BorderSide(color: AppColors.defaultColor),
                            ),
                          ),
                          validator: (value) {
                            if (value.isEmpty) {
                              return "Le nom est obligatoire";
                            } else {
                              return null;
                            }
                          },
                        ),
                      ),
                    ),
                    SizedBox(height: 5),
                    Container(
                      width: double.infinity,
                      alignment: Alignment.centerRight,
                      child: Center(
                        child: ElevatedButton(
                          child: Text("Sauvegarder",
                              style: AppStyles.buttonTextWhite,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2),
                          onPressed: () async {
                            if (_formKey.currentState.validate()) {
                              if (!loading) _goSaveAlerte();
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

  _goSaveAlerte() async {
    setState(() {
      _buttonDialogLoading = true;
    });
    //We parse the current Filter to create alert request
    CreateAlerteRequest req = CreateAlerteRequest();
    Recherche contenu = Recherche();
    contenu.rayons = <double>[];
    contenu.prix = <double>[];
    contenu.surfaceInterieure = <double>[];
    contenu.surfaceExterieure = <double>[];
    contenu.nbPieces = <double>[];
    contenu.nbChambres = <double>[];
    contenu.departements = <String>[];
    contenu.oidCommunes = <String>[];
    contenu.typeBiens = <String>[];
    contenu.typeVentes = <String>[];

    req.nom = _nameController.text;
    req.token = "";
    req.commentaire = "";
    contenu.rayons.add(bloc.currentFilter.rayon);
    contenu.prix.add(bloc.currentFilter.priceMin);
    contenu.prix.add(bloc.currentFilter.priceMax);
    contenu.surfaceInterieure.add(bloc.currentFilter.surInterieurMin);
    contenu.surfaceInterieure.add(bloc.currentFilter.surInterieurMax);
    contenu.surfaceExterieure.add(bloc.currentFilter.surExterieurMin);
    contenu.surfaceExterieure.add(bloc.currentFilter.surExterieurMax);
    contenu.nbPieces.add(bloc.currentFilter.piecesMin);
    contenu.nbPieces.add(bloc.currentFilter.piecesMax);
    contenu.nbChambres.add(bloc.currentFilter.chambresMin);
    contenu.nbChambres.add(bloc.currentFilter.chambresMin);
    bloc.currentFilter.listPlaces.forEach((element) {
      element.code.length == 2
          ? contenu.departements.add(element.code)
          : contenu.oidCommunes.add(element.code);
    });
    bloc.currentFilter.listTypeVente.forEach((element) {
      contenu.typeVentes.add(element.code);
    });
    bloc.currentFilter.listtypeDeBien.forEach((element) {
      contenu.typeBiens.add(element.code);
    });
    req.recherche = contenu;
    bool resp = await alertesBloc.addAlerte(req);
    if (resp) {
      Modular.to.pop();
      showSuccessToast(context, "Votre alerte a été sauvegardé");
    } else {
      showErrorToast(context, 'Une erreur est survenue');
    }
    setState(() {
      _buttonDialogLoading = false;
    });
  }

  _showConnectionDialog() {
    return showCupertinoModalBottomSheet(
      context: context,
      expand: false,
      enableDrag: true,
      builder: (context) => AuthScreen(true),
    );
  }

  _showHonoraire(
      DetailAnnonceResponse annonce,
      String ligne1,
      String ligne2,
      String ligne3,
      String type,
      String nom,
      bool prixEnBaisse,
      String oidNotaire) {
    showBarModalBottomSheet(
        context: context,
        expand: false,
        enableDrag: true,
        builder: (context) => HonorairesBottomSheetWidget(annonce, ligne1,
            ligne2, ligne3, type, nom, prixEnBaisse, oidNotaire));
  }
}
