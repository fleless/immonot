import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_tags/flutter_tags.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:immonot/constants/app_colors.dart';
import 'package:immonot/constants/app_constants.dart';
import 'package:immonot/constants/app_images.dart';
import 'package:immonot/constants/routes.dart';
import 'package:immonot/constants/styles/app_styles.dart';
import 'package:immonot/models/enum/type_biens.dart';
import 'package:immonot/models/enum/type_ventes.dart';
import 'package:immonot/models/fake/filtersModel.dart';
import 'package:immonot/utils/shared_preferences.dart';
import 'package:immonot/utils/user_location.dart';

import '../home_bloc.dart';

class HomeHeaderWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HomeHeaderWidgetState();
}

class _HomeHeaderWidgetState extends State<HomeHeaderWidget> {
  final _searchController = TextEditingController();
  final GlobalKey<TagsState> _tagStateKey = GlobalKey<TagsState>();
  final userLocation = Modular.get<UserLocation>();
  final bloc = Modular.get<HomeBloc>();
  final SharedPref sharedPref = SharedPref();

  // cette booléenne détermine si on a fait une recherche avant ou non
  bool lastSearchFound = false;

  // c'est la dernière requete pour l'utilisateur dans le device
  FilterModels req;

  // 0 pour acheter, 1 pour louer, 2 pour vendre
  int selectionType = 0;

  @override
  void initState() {
    super.initState();
    _loadLastSearchFilters();
  }

  _loadLastSearchFilters() async {
    req =
        FilterModels.fromJson(await sharedPref.read(AppConstants.LAST_FILTER));
    if (req != null) {
      setState(() {
        lastSearchFound = true;
      });
    }
  }

  _reprendreRechercheButton() async {
    await _loadLastSearchFilters();
    _launchPrecedentSearch(req);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _buildHeader();
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      decoration: new BoxDecoration(
        image: new DecorationImage(
          colorFilter: new ColorFilter.mode(
              Colors.black.withOpacity(0.5), BlendMode.darken),
          image: NetworkImage(
              'https://core-immonot.notariat.services/api/v1/params?project=immonot&key=banniere'),
          fit: BoxFit.cover,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.only(left: 12, top: 50),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: Image(
                image: AssetImage(AppImages.logo),
              ),
            ),
            SizedBox(height: 50),
            lastSearchFound ? _buildRequestLastSearch() : _buildNewSearch(),
            SizedBox(height: lastSearchFound ? 50 : 20),
          ],
        ),
      ),
    );
  }

  Widget _buildNewSearch() {
    return Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
      _buildSelections(),
      SizedBox(height: 10),
      _buildHomeFilters(),
      SizedBox(height: 15),
      _buildSearch(),
      SizedBox(height: 15),
      bloc.currentFilter.listPlaces.length > 0
          ? _buildTags()
          : SizedBox.shrink(),
      bloc.currentFilter.listPlaces.length > 0
          ? SizedBox(height: 15)
          : SizedBox.shrink(),
      _buildButton(),
    ]);
  }

  Widget _buildRequestLastSearch() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.appBackground,
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      alignment: Alignment.center,
      padding: EdgeInsets.all(15),
      margin: EdgeInsets.only(right: 15),
      child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
        Text(
          "Voulez-vous reprendre votre dernière recherche ?",
          textAlign: TextAlign.center,
          style: AppStyles.titleStyleH2,
        ),
        SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            ElevatedButton(
              child: Ink(
                decoration: BoxDecoration(
                  color: AppColors.defaultColor,
                  border: Border.all(color: AppColors.defaultColor),
                  borderRadius: BorderRadius.all(
                    Radius.circular(8),
                  ),
                ),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  alignment: Alignment.center,
                  height: 50,
                  child: Text(
                    "Reprendre",
                    style: AppStyles.buttonTextWhite,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              onPressed: () {
                _reprendreRechercheButton();
              },
              style: ElevatedButton.styleFrom(
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  onPrimary: AppColors.white.withOpacity(0.1),
                  primary: Colors.transparent,
                  padding: EdgeInsets.zero,
                  textStyle:
                      TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
            ),
            ElevatedButton(
              child: Ink(
                decoration: BoxDecoration(
                  color: AppColors.white,
                  border: Border.all(color: AppColors.defaultColor),
                  borderRadius: BorderRadius.all(
                    Radius.circular(8),
                  ),
                ),
                child: Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  height: 50,
                  child: Text(
                    "NOUVELLE RECHERCHE",
                    style: AppStyles.buttonTextPink,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              onPressed: () {
                setState(() {
                  sharedPref.remove(AppConstants.LAST_FILTER);
                  bloc.reinitCurrentFilter();
                  lastSearchFound = false;
                });
              },
              style: ElevatedButton.styleFrom(
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  onPrimary: AppColors.defaultColor.withOpacity(0.1),
                  primary: Colors.transparent,
                  padding: EdgeInsets.zero,
                  textStyle:
                      TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ]),
    );
  }

  Widget _buildSelections() {
    return Row(
      children: [
        InkWell(
          onTap: () {
            changeSelectionType(0);
          },
          child: Text("Acheter",
              style: selectionType == 0
                  ? AppStyles.underlinedSelectionedText
                  : AppStyles.notSelectionedText),
        ),
        SizedBox(width: 20),
        InkWell(
          onTap: () {
            changeSelectionType(1);
          },
          child: Text("Louer",
              style: selectionType == 1
                  ? AppStyles.underlinedSelectionedText
                  : AppStyles.notSelectionedText),
        ),
      ],
    );
  }

  Widget _buildHomeFilters() {
    return Container(
        height: 50,
        child: Stack(
          children: [
            ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: typeBiens.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () => changeSelectionTypeDeBien(index),
                    child: Center(
                      child: Container(
                        height: 33,
                        margin: const EdgeInsets.symmetric(horizontal: 5.0),
                        padding: const EdgeInsets.symmetric(
                            vertical: 3.0, horizontal: 8.0),
                        decoration: new BoxDecoration(
                          color: bloc.currentFilter.listtypeDeBien
                                  .contains(typeBiens[index])
                              ? AppColors.defaultColor
                              : AppColors.white.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(5.0),
                          border: Border.all(
                              color: bloc.currentFilter.listtypeDeBien
                                      .contains(typeBiens[index])
                                  ? AppColors.defaultColor
                                  : AppColors.white),
                        ),
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            typeBiens[index].label,
                            style: bloc.currentFilter.listtypeDeBien
                                    .contains(typeBiens[index])
                                ? AppStyles.selectionedItemText
                                : AppStyles.notSelectionedItemText,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                  );
                }),
            //Blur effect on right
            Positioned(
              right: 0,
              top: 0,
              bottom: 0,
              child: Container(
                height: 10,
                width: 10,
                child: ClipRect(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 0, sigmaY: 0.0),
                    child: Container(
                      color: AppColors.defaultColor.withOpacity(0.04),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ));
  }

  Widget _buildSearch() {
    return Padding(
      padding: EdgeInsets.only(right: 12),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          // If you want align text to left
          mainAxisSize: MainAxisSize.max,
          children: [
            Flexible(
              child: GestureDetector(
                onTap: () => {
                  FocusScope.of(context).requestFocus(new FocusNode()),
                  Modular.to
                      .pushNamed(Routes.search, arguments: {'address': ""}),
                },
                child: Container(
                  height: 45,
                  decoration: new BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(5),
                        bottomLeft: Radius.circular(5)),
                    border: Border.all(color: AppColors.white),
                  ),
                  child: Center(
                    child: TextField(
                      controller: _searchController,
                      enabled: false,
                      style: AppStyles.textNormal,
                      textAlign: TextAlign.left,
                      textAlignVertical: TextAlignVertical.center,
                      cursorColor: AppColors.defaultColor,
                      decoration: InputDecoration(
                        hintText: "Villes, départements, codes postaux",
                        hintStyle: AppStyles.hintSearch,
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.only(left: 8.0, top: -32.0),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            InkWell(
              onTap: () async {
                String _address;
                _address = await userLocation.getUserAddress();
                FocusScope.of(context).requestFocus(new FocusNode());
                Modular.to
                    .pushNamed(Routes.search, arguments: {'address': _address});
              },
              child: Container(
                decoration: new BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(5),
                      bottomRight: Radius.circular(5)),
                  border: Border.all(color: AppColors.white),
                ),
                width: 45,
                height: 45,
                child: Center(
                  child: FaIcon(
                    FontAwesomeIcons.crosshairs,
                    color: AppColors.defaultColor,
                    size: 20,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTags() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Tags(
          key: _tagStateKey,
          alignment: WrapAlignment.start,
          itemCount: bloc.currentFilter.listPlaces.length,
          itemBuilder: (int index) {
            final item = bloc.currentFilter.listPlaces[index];
            return ItemTags(
              key: Key(index.toString()),
              index: index,
              // required
              borderRadius: BorderRadius.circular(7),
              color: AppColors.white,
              activeColor: AppColors.white,
              textActiveColor: AppColors.default_black,
              textColor: AppColors.default_black,
              splashColor: AppColors.defaultColor,
              highlightColor: AppColors.defaultColor,
              textStyle: AppStyles.subTitleStyle,
              //pressEnabled: false,
              active: true,
              title: (item.codePostal == null ? item.code : item.codePostal) +
                  " " +
                  item.nom,
              removeButton: ItemTagsRemoveButton(
                backgroundColor: AppColors.white,
                color: AppColors.defaultColor,
                size: 16,
                onRemoved: () {
                  setState(() {
                    bloc.currentFilter.listPlaces.removeAt(index);
                  });
                  return true;
                },
              ), // OR null,
            );
          }),
    );
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
            _launchSearch();
          },
          child: Container(
            width: MediaQuery.of(context).size.width * 0.35,
            height: 45,
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FaIcon(
                    FontAwesomeIcons.search,
                    color: AppColors.white,
                    size: 17,
                  ),
                  SizedBox(width: 10),
                  Text("TROUVER",
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

  changeSelectionType(int index) {
    setState(() {
      selectionType = index;
    });
  }

  changeSelectionTypeDeBien(int index) {
    setState(() {
      if (bloc.currentFilter.listtypeDeBien.contains(typeBiens[index])) {
        bloc.currentFilter.listtypeDeBien
            .removeWhere((element) => element == typeBiens[index]);
      } else {
        bloc.currentFilter.listtypeDeBien.add(typeBiens[index]);
      }
    });
  }

  _launchSearch() {
    //save the data we need
    num _rayon = bloc.currentFilter.rayon;
    if (bloc.currentFilter.listPlaces.length == 0) {
      _rayon = 0.0;
    }
    // we clear the filters
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
    bloc.currentFilter.listPlaces.forEach((element) {
      print(element.code);
    });
    bloc.currentFilter.rayon = _rayon;
    bloc.currentFilter.listTypeVente.clear();
    selectionType == 0
        ? bloc.currentFilter.listTypeVente.add(typeVentes[3])
        : selectionType == 1
            ? bloc.currentFilter.listTypeVente.add(typeVentes[0])
            : null;
    Modular.to.pushNamed(Routes.searchResults);
  }

  _launchPrecedentSearch(FilterModels model) {
    //save the data we need
    double _rayon = model.rayon == null ? null : model.rayon;
    if (bloc.currentFilter.listPlaces.length == 0) {
      _rayon = 0.0;
    }
    // we clear the filters
    bloc.currentFilter.priceMin = model.priceMin == null ? 0.0 : model.priceMin;
    bloc.currentFilter.priceMax = model.priceMax == null ? 0.0 : model.priceMax;
    bloc.currentFilter.piecesMax =
        model.piecesMax == null ? 0.0 : model.piecesMax;
    bloc.currentFilter.piecesMin =
        model.piecesMin == null ? 0.0 : model.piecesMin;
    bloc.currentFilter.reference = null;
    bloc.currentFilter.chambresMin =
        model.chambresMin == null ? 0 : model.chambresMin;
    bloc.currentFilter.chambresMax =
        model.chambresMax == null ? 0 : model.chambresMax;
    bloc.currentFilter.surInterieurMax =
        model.surInterieurMax == null ? 0.0 : model.surInterieurMax;
    bloc.currentFilter.surInterieurMin =
        model.surInterieurMin == null ? 0.0 : model.surInterieurMin;
    bloc.currentFilter.surExterieurMin =
        model.surExterieurMin == null ? 0.0 : model.surExterieurMin;
    bloc.currentFilter.surExterieurMax =
        model.surExterieurMax == null ? 0.0 : model.surExterieurMax;
    bloc.currentFilter.listPlaces.clear();
    if (model.listPlaces.length != 0) {
      bloc.currentFilter.listPlaces.addAll(model.listPlaces);
    }
    bloc.currentFilter.rayon = _rayon;
    bloc.currentFilter.listTypeVente.clear();
    if (model.listTypeVente.length != 0) {
      model.listTypeVente.forEach((element) {
        bloc.currentFilter.listTypeVente
            .add(TypeVentesEnumeration.findTypeVenteByCode(element.code));
      });
    }
    bloc.currentFilter.listtypeDeBien.clear();
    if (model.listtypeDeBien.length != 0) {
      model.listtypeDeBien.forEach((element) {
        bloc.currentFilter.listtypeDeBien
            .add(TypeBienEnumeration.findTypeBienByCode(element.code));
      });
    }
    Modular.to.pushNamed(Routes.searchResults);
  }
}
