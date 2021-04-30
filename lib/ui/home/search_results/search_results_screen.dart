import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:immonot/constants/app_colors.dart';
import 'package:immonot/constants/app_icons.dart';
import 'package:immonot/constants/app_images.dart';
import 'package:immonot/constants/routes.dart';
import 'package:immonot/constants/styles/app_styles.dart';
import 'package:immonot/models/fake/fakeResults.dart';
import 'package:immonot/ui/home/search_results/filter_bloc.dart';
import 'package:immonot/ui/home/search_results/filter_screen.dart';
import 'package:immonot/ui/home/search_results/honoraires/honoraire_bottom_sheet.dart';
import 'package:immonot/ui/home/search_results/tri_bottom_sheet.dart';
import 'package:immonot/ui/home/widgets/home_annuaire_notaires.dart';
import 'package:immonot/ui/home/widgets/home_header.dart';
import 'package:immonot/ui/home/widgets/home_info_conseils.dart';
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
  final _searchController = TextEditingController();
  List<FakeResults> fakeList = <FakeResults>[];
  bool scrolling = false;

  @override
  Future<void> initState() {
    super.initState();
    _controller = ScrollController();
    _controller.addListener(_scrollListener);
    _searchController.text = _searchDetails();
    _fillFakeList();
  }

  String _searchDetails() {
    String str = "";
    print(bloc.tagsList.length.toString() + " hedha hwa");
    bloc.tagsList.forEach((element) {
      str = str + element.label + " (" + element.code + "), ";
    });
    return str;
  }

  _scrollListener() {
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
            child: _buildList(),
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
                shape: RoundedRectangleBorder(
                  side: new BorderSide(color: AppColors.hint, width: 0.2),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(4.0),
                    bottomLeft: Radius.circular(4.0),
                  ),
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
                fakeList.length.toString() + " Résultats",
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
        itemCount: fakeList.length,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          final item = fakeList[index];
          return InkWell(
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

  _buildImage(FakeResults fake) {
    return Container(
      height: 230,
      width: double.infinity,
      child: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            child: Image.network(fake.picture, fit: BoxFit.fill),
          ),
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
                  fake.numberPictures.toString(),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppStyles.nbrPictures,
                ),
              ),
            ),
          ),
          fake.offre != null
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
              : SizedBox.shrink(),
        ],
      ),
    );
  }

  _buildDescription(FakeResults fake) {
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
                      text: fake.genre,
                      style: fake.genre == "ACHAT"
                          ? AppStyles.typeAnnoncesAchat
                          : fake.genre == "LOCATION"
                              ? AppStyles.typeAnnoncesLocation
                              : fake.genre == "VIAGER"
                                  ? AppStyles.typeAnnoncesViager
                                  : fake.genre == "VENTE AUX ENCHÈRES"
                                      ? AppStyles.typeAnnoncesVenteAuxEncheres
                                      : AppStyles.typeAnnoncesEVente),
                  TextSpan(text: ' - ', style: AppStyles.typeAnnonceBlack),
                  TextSpan(text: fake.type, style: AppStyles.typeAnnonceBlack)
                ],
              ),
            ),
          ),
          Padding(
              padding: EdgeInsets.only(top: 10, left: 10, right: 10),
              child: Text(
                fake.location,
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
                style: AppStyles.locationAnnonces,
              )),
          Padding(
            padding: EdgeInsets.only(top: 10, left: 10, right: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  fake.prize + " ",
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: AppStyles.titleStyle,
                ),
                fake.down
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
                    _showHonoraire(fake);
                  },
                  child: Image(
                    image: AssetImage(AppIcons.info),
                    color: AppColors.defaultColor,
                    alignment: Alignment.center,
                  ),
                ),
              ],
            ),
          ),
          fake.debutEnchere != null
              ? Padding(
                  padding: EdgeInsets.only(top: 5, left: 10, right: 10),
                  child: Text("1er offre possible",
                      style: AppStyles.locationAnnonces),
                )
              : SizedBox.shrink(),
          _buildFooterDetails(fake)
        ],
      ),
    );
  }

  Widget _buildFooterDetails(FakeResults fake) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      child: ((fake.genre.startsWith("E-") ||
              (fake.genre.startsWith("VENTE AUX ENCHÈRES EN"))))
          ? _buildAlternativeFooterDetails(fake)
          : _buildNormalFooterDetails(fake),
    );
  }

  Widget _buildAlternativeFooterDetails(FakeResults fake) {
    return Row(
      children: [
        fake.debutEnchere.startsWith("Début")
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
            SizedBox(height: 3),
            Text(fake.debutEnchere,
                style: AppStyles.typeAnnonceBlack, textAlign: TextAlign.start)
          ],
        )
      ],
    );
  }

  Widget _buildNormalFooterDetails(FakeResults fake) {
    double bigPadding = 12;
    double smallPadding = 3;
    return Container(
      height: 18,
      child: Row(
        children: [
          fake.superficie != null
              ? Image(
                  image: AssetImage(AppIcons.square),
                  color: AppColors.defaultColor,
                )
              : SizedBox.shrink(),
          fake.superficie != null
              ? SizedBox(width: smallPadding)
              : SizedBox.shrink(),
          fake.superficie != null
              ? Text(fake.superficie, style: AppStyles.typeAnnonceBlack)
              : SizedBox.shrink(),
          fake.superficie != null
              ? SizedBox(width: bigPadding)
              : SizedBox.shrink(),
          fake.surfaceTerrain != null
              ? Image(
                  image: AssetImage(AppIcons.selectAll),
                  color: AppColors.defaultColor,
                )
              : SizedBox.shrink(),
          fake.surfaceTerrain != null
              ? SizedBox(width: smallPadding)
              : SizedBox.shrink(),
          fake.surfaceTerrain != null
              ? Text(fake.surfaceTerrain, style: AppStyles.typeAnnonceBlack)
              : SizedBox.shrink(),
          fake.surfaceTerrain != null
              ? SizedBox(width: bigPadding)
              : SizedBox.shrink(),
          fake.nbrChambres != null
              ? Image(
                  image: AssetImage(AppIcons.door),
                  color: AppColors.defaultColor,
                )
              : SizedBox.shrink(),
          fake.nbrChambres != null
              ? SizedBox(width: smallPadding)
              : SizedBox.shrink(),
          fake.nbrChambres != null
              ? Text(fake.nbrChambres.toString(),
                  style: AppStyles.typeAnnonceBlack)
              : SizedBox.shrink(),
          fake.nbrChambres != null
              ? SizedBox(width: bigPadding)
              : SizedBox.shrink(),
          fake.lits != null
              ? Image(
                  image: AssetImage(AppIcons.lit),
                  color: AppColors.defaultColor,
                )
              : SizedBox.shrink(),
          fake.lits != null ? SizedBox(width: smallPadding) : SizedBox.shrink(),
          fake.lits != null
              ? Text(fake.lits.toString(), style: AppStyles.typeAnnonceBlack)
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

  _showHonoraire(FakeResults item) {
    showBarModalBottomSheet(
        context: context,
        expand: false,
        enableDrag: true,
        builder: (context) => HonorairesBottomSheetWidget(item));
  }

  void _fillFakeList() {
    setState(() {
      fakeList.add(
        FakeResults(
            "ACHAT",
            "APPARTEMENT",
            "690 000 €",
            "Bordeaux - 33000",
            2,
            "https://www.depreux-construction.com/wp-content/uploads/2018/11/depreux-construction.jpg",
            "111 m²",
            "67 m²",
            5,
            2,
            null,
            false,
            null,
            null,
            "660 000 €",
            "30 000 €",
            "4,81%",
            "SCP Adrien DUTOUR, Cyrille DE RUL, Christophe LACOSTE, Sandrine PAGÈS, Audrey PELLET-LAVÊVE, Grégory DANDIEU, Mélodie REMIA et Delphine HUREL",
            null,
            null),
      );
      fakeList.add(
        FakeResults(
            "LOCATION",
            "APPARTEMENT",
            "550 €/mois cc",
            "Bordeaux - 33000",
            1,
            "https://www.trecobat.fr/wp-content/uploads/2020/05/construction-maison-contemporaine-maison-trecobat-1024x682.jpg",
            "75 m²",
            "854 m²",
            4,
            3,
            null,
            false,
            null,
            null,
            null,
            null,
            null,
            "SCP Bruno et Laurent LUTHIER",
            "550 €",
            "393 €"),
      );
      fakeList.add(
        FakeResults(
            "ACHAT",
            "MAISON",
            "680 000 €",
            "Bordeaux - 33000",
            12,
            "https://www.habitatpresto.com/upload/devispresto//3456104__maison_bois_vignette.jpg",
            "195 m²",
            "139 m²",
            3,
            3,
            "Sélection",
            true,
            null,
            null,
            "650 000 €",
            "30 000 €",
            "4,61%",
            "SCP Adrien DUTOUR, Cyrille DE RUL, Christophe LACOSTE, Sandrine PAGÈS, Audrey PELLET-LAVÊVE, Grégory DANDIEU, Mélodie REMIA et Delphine HUREL",
            null,
            null),
      );
      fakeList.add(
        FakeResults(
            "VENTE AUX ENCHÈRES EN LIGNE",
            "APPARTEMENT",
            "1 800 000 €",
            "Nanterre - 92000",
            4,
            "https://cdn.futura-sciences.com/buildsv6/images/mediumoriginal/4/4/2/4420d92444_121015_maison-insolite-491597986.jpg",
            null,
            null,
            null,
            null,
            "Exclusif 36h immo",
            false,
            "Prochainement",
            "Début : 06/05/2021 09:00",
            null,
            null,
            null,
            "SELAS NOTAIRES 82",
            null,
            null),
      );
      fakeList.add(
        FakeResults(
            "ACHAT",
            "FONDS ET/OU MURS COMMERCIAUX",
            "74 800 €",
            "Bordeaux - 33000",
            1,
            "https://pbs.twimg.com/profile_images/1082578265859084289/OuS5RqsZ.jpg",
            "64 m²",
            "64 m²",
            4,
            null,
            "Sélection",
            false,
            null,
            null,
            "68 320 €",
            "7 480 €",
            "10%",
            "SCP Adrien DUTOUR, Cyrille DE RUL, Christophe LACOSTE, Sandrine PAGÈS, Audrey PELLET-LAVÊVE, Grégory DANDIEU, Mélodie REMIA et Delphine HUREL",
            null,
            null),
      );
      fakeList.add(
        FakeResults(
            "VENTE AUX ENCHÈRES",
            "APPARTEMENT",
            "199 000 €",
            "Nanterre - 92000",
            4,
            "https://www.travaux.com/images/cms/original/ebcd4d3c-6a00-47d2-8165-6d9e192082af.jpeg",
            "91 m²",
            "76 m²",
            3,
            null,
            null,
            false,
            null,
            null,
            null,
            null,
            null,
            "SELAS NOTAIRES 82",
            null,
            null),
      );
      fakeList.add(
        FakeResults(
            "E-VENTE",
            "MAISON",
            "1 000 000 €",
            "Nanterre - 92000",
            4,
            "https://www.sothebysrealty-france.com/datas/biens/images/18093/18093_00-2021-02-05-0332.jpg",
            null,
            null,
            null,
            null,
            "Exclusif e-vente",
            false,
            "En cours",
            "e-vente en cours",
            null,
            null,
            null,
            "SELAS NOTAIRES 82",
            null,
            null),
      );
      fakeList.add(
        FakeResults(
            "VIAGER",
            "APPARTEMENT",
            "Bouquet: 156 763,90 €",
            "Bordeaux - 33000",
            5,
            "https://s.iha.com/2939700015264/Locations-vacances-Paris-13eme-arrondissement-Chez-jeannot_15.jpeg",
            "41 m²",
            null,
            2,
            1,
            null,
            true,
            null,
            null,
            "650 000 €",
            "30 000 €",
            "4,61%",
            "SCP Adrien DUTOUR, Cyrille DE RUL, Christophe LACOSTE, Sandrine PAGÈS, Audrey PELLET-LAVÊVE, Grégory DANDIEU, Mélodie REMIA et Delphine HUREL",
            null,
            null),
      );
    });
  }
}
