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
  final List<String> typeDeBiensStrings = [
    "Maisons",
    "Appartements",
    "Terrains à batir",
    "Propriétés",
    "Garages / Parkings",
    "Biens agricoles",
    "Immeubles",
    "Propriétés viticoles",
    "Fonds / Murs commerciaux",
    "Terrins de loisirs / Bois / Étangs",
    "Divers"
  ];

  // 0 pour acheter, 1 pour louer, 2 pour vendre
  int selectionType = 0;

  // liste du choix dans la liste prédéfini
  List<int> selectionTypeDeBienListe = <int>[];

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
              Colors.black.withOpacity(0.6), BlendMode.darken),
          image: new AssetImage(AppImages.printemps),
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
            _buildSelections(),
            SizedBox(height: 10),
            _buildHomeFilters(),
            SizedBox(height: 15),
            _buildSearch(),
            SizedBox(height: 15),
            bloc.tagsList.length > 0 ? _buildTags() : SizedBox.shrink(),
            bloc.tagsList.length > 0 ? SizedBox(height: 15) : SizedBox.shrink(),
            _buildButton(),
            SizedBox(height: 20),
          ],
        ),
      ),
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
        SizedBox(width: 20),
        InkWell(
          onTap: () {
            changeSelectionType(2);
          },
          child: Text("Vendre",
              style: selectionType == 2
                  ? AppStyles.underlinedSelectionedText
                  : AppStyles.notSelectionedText),
        ),
      ],
    );
  }

  Widget _buildHomeFilters() {
    return Container(
      height: 50,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: typeDeBiensStrings.length,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () => changeSelectionTypeDeBien(index),
              child: Center(
                child: Container(
                  height: 33,
                  margin: const EdgeInsets.symmetric(horizontal: 5.0),
                  padding: const EdgeInsets.all(8.0),
                  decoration: new BoxDecoration(
                    color: selectionTypeDeBienListe.contains(index)
                        ? AppColors.defaultColor
                        : AppColors.white.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(5.0),
                    border: Border.all(
                        color: selectionTypeDeBienListe.contains(index)
                            ? AppColors.defaultColor
                            : AppColors.white),
                  ),
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      typeDeBiensStrings[index],
                      style: selectionTypeDeBienListe.contains(index)
                          ? AppStyles.selectionedItemText
                          : AppStyles.notSelectionedItemText,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            );
          }),
    );
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
                        hintText: "Ville, départements, code postal",
                        hintStyle: AppStyles.hintSearch,
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.only(left: 8.0, top: -30.0),
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
          itemCount: bloc.tagsList.length,
          itemBuilder: (int index) {
            final item = bloc.tagsList[index];
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
              title: item.code + " " + item.label,
              removeButton: ItemTagsRemoveButton(
                backgroundColor: AppColors.white,
                color: AppColors.defaultColor,
                size: 16,
                onRemoved: () {
                  setState(() {
                    bloc.tagsList.removeAt(index);
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
      if (selectionTypeDeBienListe.contains(index)) {
        selectionTypeDeBienListe.removeWhere((element) => element == index);
      } else {
        selectionTypeDeBienListe.add(index);
      }
    });
  }

  _launchSearch() {
    bloc.currentFilter.clear();
    bloc.currentFilter.listPlaces.addAll(bloc.tagsList);
    selectionType == 0
        ? bloc.currentFilter.listTransactions.add("Achat")
        : selectionType == 1
            ? bloc.currentFilter.listTransactions.add("Location")
            : null;
    selectionTypeDeBienListe.forEach((element) {
      bloc.currentFilter.listtypeDeBien.add(typeDeBiensStrings[element]);
    });
    Modular.to.pushNamed(Routes.searchResults);
  }
}
