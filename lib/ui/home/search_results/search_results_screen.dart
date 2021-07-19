import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:immonot/constants/app_colors.dart';
import 'package:immonot/constants/app_icons.dart';
import 'package:immonot/constants/app_images.dart';
import 'package:immonot/constants/routes.dart';
import 'package:immonot/constants/styles/app_styles.dart';
import 'package:immonot/models/fake/fakeResults.dart';
import 'package:immonot/models/requests/search_request.dart';
import 'package:immonot/models/responses/SearchResponse.dart';
import 'package:immonot/ui/home/search_results/filter_bloc.dart';
import 'package:immonot/ui/home/search_results/filter_screen.dart';
import 'package:immonot/ui/home/search_results/honoraires/honoraire_bottom_sheet.dart';
import 'package:immonot/ui/home/search_results/tri_bottom_sheet.dart';
import 'package:immonot/ui/home/widgets/home_annuaire_notaires.dart';
import 'package:immonot/ui/home/widgets/home_header.dart';
import 'package:immonot/ui/home/widgets/home_info_conseils.dart';
import 'package:immonot/ui/home/widgets/shimmers/shimmer_annonces_result.dart';
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
  final bloc = Modular.get<HomeBloc>();
  final filterBloc = Modular.get<FilterBloc>();
  final _searchController = TextEditingController();
  bool loading = false;
  bool _showPaginationLoader = false;
  List<Content> searchList = <Content>[];
  SearchResponse _searchResponse = SearchResponse(totalElements: 0);
  bool scrolling = false;

  @override
  void initState() {
    _controller = ScrollController();
    _controller.addListener(_scrollListener);
    _searchController.text = _searchDetails();
    bloc.changesNotifier.listen((value) {
      _goSearch(0);
    });
    bloc.triNotifier.listen((value) {
      _goTri();
    });
    _goSearch(0);
    filterBloc.filterTagsList.clear();
    super.initState();
  }

  _goTri() async {
    _goSearch(0);
  }

  _goSearch(int pageNumber) async {
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
    //parse bloc elements to searchrequest before sending them
    String _typeVentesFormatted = "";
    String _typeVentesLabelFormatted = "";
    String _references = "";
    String _oidCommunes = "";
    double _rayons = 0;
    String _typeBiens = "";
    String _prix = "";
    String _surfaceExterieur = "";
    String _surfaceInterieur = "";
    String _nbPieces = "";
    String _nbChambres = "";

    print(bloc.currentFilter.listtypeDeBien.length.toString() + " la length");
    bloc.currentFilter.listTypeVente.forEach((element) {
      _typeVentesFormatted += element.code + ",";
      _typeVentesLabelFormatted += element.label + ",";
    });
    _references = bloc.currentFilter.reference;
    bloc.currentFilter.listPlaces.forEach((element) {
      _oidCommunes += element.code + ",";
    });
    _rayons = bloc.currentFilter.rayon;
    bloc.currentFilter.listtypeDeBien.forEach((element) {
      _typeBiens += element.code + ",";
    });
    _prix = bloc.currentFilter.priceMin.toStringAsFixed(2) +
        "," +
        bloc.currentFilter.priceMax.toStringAsFixed(2);
    _surfaceExterieur = bloc.currentFilter.surExterieurMin.toStringAsFixed(2) +
        "," +
        bloc.currentFilter.surExterieurMax.toStringAsFixed(2);
    _surfaceInterieur = bloc.currentFilter.surInterieurMin.toStringAsFixed(2) +
        "," +
        bloc.currentFilter.surInterieurMax.toStringAsFixed(2);
    _nbPieces = (bloc.currentFilter.piecesMin.toInt()).toString() +
        "," +
        (bloc.currentFilter.piecesMax.toInt()).toString();
    _nbChambres = (bloc.currentFilter.chambresMin.toInt()).toString() +
        "," +
        (bloc.currentFilter.chambresMin.toInt()).toString();

    SearchResponse resp = await bloc.searchAnnonces(
        pageNumber,
        SearchRequest(
            typeVentes: _typeVentesFormatted,
            references: _references,
            oidCommunes: _oidCommunes,
            //TODO: fix api
            rayons: null,
            typeBiens: _typeBiens,
            prix: _prix == "0.00,0.00" ? null : _prix,
            surfaceExterieure:
                _surfaceExterieur == "0.00,0.00" ? null : _surfaceExterieur,
            surfaceInterieure:
                _surfaceInterieur == "0.00,0.00" ? null : _surfaceInterieur,
            nbPieces: _nbPieces == "0,0" ? null : _nbPieces,
            nbChambres: _nbChambres == "0,0" ? null : _nbChambres),
        bloc.tri);
    bloc.tri = null;
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
    bloc.currentFilter.listPlaces.forEach((element) {
      str = str + element.nom + " (" + element.code + "), ";
    });
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
          _goSearch(_searchResponse.number + 1);
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
            child: loading ? buildShimmerSearchAnnonces() : _buildList(),
          ),
        ],
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
                _searchResponse.totalElements.toString() + " Résultats",
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
                  onTap: () => Modular.to.pushNamed(Routes.detailsAnnonce,
                      arguments: {'id': item.oidAnnonce}),
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

  _buildImage(Content fake) {
    return Container(
      height: 230,
      width: double.infinity,
      child: Stack(
        children: [
          Container(
              width: double.infinity,
              height: double.infinity,
              child: fake.photo.principale == null
                  ? Image.network(
                      "https://www.generationsforpeace.org/wp-content/uploads/2018/03/empty.jpg",
                      fit: BoxFit.fill)
                  : Image.network(fake.photo.principale, fit: BoxFit.fill)),
          Positioned(
            top: 15.0,
            right: 15.0,
            child: CircleAvatar(
                child: FaIcon(FontAwesomeIcons.solidHeart,
                    color: AppColors.default_black, size: 18),
                radius: 17.0,
                backgroundColor: AppColors.white),
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
                        fake.prixLigne1.replaceAll("&euro;", "€") + " ",
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: AppStyles.titleStyle,
                      ),
                      //TODO: prix en bas n'est pas retourné dans l'api
                      /*fake.down
                    ? Container(
                        alignment: Alignment.topLeft,
                        child: FaIcon(
                          FontAwesomeIcons.arrowDown,
                          color: AppColors.greenColor,
                          size: 10,
                        ),
                      )
                    : SizedBox.shrink(),*/
                      SizedBox(width: 5),
                      //TODO: add nom notaire (non provided in API)
                      InkWell(
                        onTap: () {
                          _showHonoraire(
                              fake.prixLigne1,
                              fake.prixLigne2,
                              fake.prixLigne3,
                              fake.typeVente,
                              "Nom du notaire");
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
                  maxLines: 1,
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

  _showHonoraire(
      String ligne1, String ligne2, String ligne3, String type, String nom) {
    showBarModalBottomSheet(
        context: context,
        expand: false,
        enableDrag: true,
        builder: (context) =>
            HonorairesBottomSheetWidget(ligne1, ligne2, ligne3, type, nom));
  }
}
