import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_tags/flutter_tags.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:immonot/constants/app_colors.dart';
import 'package:immonot/constants/routes.dart';
import 'package:immonot/constants/styles/app_styles.dart';
import 'package:immonot/ui/home/search_results/filter_bloc.dart';
import 'package:immonot/utils/user_location.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

import '../home_bloc.dart';

class FilterSearchWidget extends StatefulWidget {
  FilterSearchWidget() {}

  @override
  State<StatefulWidget> createState() => _FilterSearchWidgetState();
}

class _FilterSearchWidgetState extends State<FilterSearchWidget> {
  final _searchController = TextEditingController();
  final _rayonController = TextEditingController();
  final userLocation = Modular.get<UserLocation>();
  final bloc = Modular.get<FilterBloc>();
  final homeBloc = Modular.get<HomeBloc>();
  final GlobalKey<TagsState> _multitagStateKey = GlobalKey<TagsState>();
  double _value = 0.0;
  List<String> listTransactions = <String>[];
  List<String> listTypeDeBiens = <String>[];
  SfRangeValues _priceValues = SfRangeValues(0.0, 0.0);
  SfRangeValues _surfInterieurValues = SfRangeValues(0.0, 0.0);
  SfRangeValues _surfExterieureValues = SfRangeValues(0.0, 0.0);
  SfRangeValues _piecesValues = SfRangeValues(0.0, 0.0);
  SfRangeValues _chambresValues = SfRangeValues(0.0, 0.0);
  TextEditingController _referenceController = TextEditingController();

  @override
  void initState() {
    super.initState();
    bloc.filterTagsList.clear();
    bloc.filterTagsList.addAll(homeBloc.tagsList);
    initData();
  }

  initData() {
    setState(() {
      _referenceController.text = homeBloc.currentFilter.reference != null
          ? homeBloc.currentFilter.reference
          : "";
      listTransactions.addAll(homeBloc.currentFilter.listTransactions);
      listTypeDeBiens.addAll(homeBloc.currentFilter.listtypeDeBien);
      _rayonController.text = homeBloc.currentFilter.rayon.toStringAsFixed(0);
      _value = homeBloc.currentFilter.rayon;
      _referenceController.text = homeBloc.currentFilter.reference;
      _priceValues = SfRangeValues(homeBloc.currentFilter.priceMin, homeBloc.currentFilter.priceMax);
      _surfInterieurValues = SfRangeValues(homeBloc.currentFilter.surInterieurMin, homeBloc.currentFilter.surInterieurMax);
      _surfExterieureValues = SfRangeValues(homeBloc.currentFilter.surExterieurMin, homeBloc.currentFilter.surExterieurMax);
      _piecesValues = SfRangeValues(homeBloc.currentFilter.piecesMin, homeBloc.currentFilter.piecesMax);
      _chambresValues = SfRangeValues(homeBloc.currentFilter.chambresMin, homeBloc.currentFilter.chambresMax);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Container(
        height: MediaQuery.of(context).size.height * 0.92,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
              color: AppColors.white,
              child: _buildTitle(),
            ),
            Divider(color: AppColors.hint),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                primary: true,
                child: Column(
                  children: [
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                      child: Container(
                        width: double.infinity,
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildLocalisation(),
                            SizedBox(height: 40),
                            _buildRayon(),
                            SizedBox(height: 40),
                            _buildTransaction(),
                            SizedBox(height: 40),
                            _buildTypeDeBien(),
                            SizedBox(height: 40),
                            _buildPrice(),
                            SizedBox(height: 40),
                            _buildSurfaceInterieur(),
                            SizedBox(height: 40),
                            _buildSurfaceExterieure(),
                            SizedBox(height: 40),
                            _buildPieces(),
                            SizedBox(height: 40),
                            _buildChambres(),
                            SizedBox(height: 40),
                            _buildReference(),
                            SizedBox(height: 40),
                          ],
                        ),
                      ),
                    ),
                    Divider(color: AppColors.hint),
                    SizedBox(height: 10),
                    _buildSubmitButton(),
                    SizedBox(height: 10),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return Material(
      child: ListTile(
        tileColor: AppColors.white,
        title: Center(
          child: Text(
            "Modifier la recherche",
            style: AppStyles.titleStyle,
            textAlign: TextAlign.center,
            overflow: TextOverflow.clip,
            maxLines: 2,
          ),
        ),
        trailing: InkWell(
          onTap: () {
            Modular.to.pop();
          },
          child: FaIcon(
            FontAwesomeIcons.times,
            size: 22,
            color: AppColors.default_black,
          ),
        ),
      ),
    );
  }

  Widget _buildLocalisation() {
    return Material(
      color: AppColors.white,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Localisation",
              style: AppStyles.titleStyleH2, textAlign: TextAlign.left),
          SizedBox(height: 10),
          Card(
            elevation: 3,
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
                        Modular.to.pushNamed(Routes.filterSearch,
                            arguments: {'address': ""}),
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
                              contentPadding:
                                  EdgeInsets.only(left: 8.0, top: -30.0),
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
                      Modular.to.pushNamed(Routes.search,
                          arguments: {'address': _address});
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
          ),
          SizedBox(height: 10),
          Align(
            alignment: Alignment.centerLeft,
            child: Tags(
                key: _multitagStateKey,
                alignment: WrapAlignment.start,
                itemCount: bloc.filterTagsList.length,
                itemBuilder: (int index) {
                  final item = bloc.filterTagsList[index];
                  return ItemTags(
                    key: Key(index.toString()),
                    index: index,
                    // required
                    borderRadius: BorderRadius.circular(7),
                    elevation: 0,
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
                      color: AppColors.default_black,
                      size: 16,
                      onRemoved: () {
                        setState(() {
                          bloc.filterTagsList.removeAt(index);
                        });
                        return true;
                      },
                    ), // OR null,
                  );
                }),
          )
        ],
      ),
    );
  }

  Widget _buildRayon() {
    return Material(
      color: AppColors.white,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Rayon",
              style: AppStyles.titleStyleH2, textAlign: TextAlign.left),
          SizedBox(height: 10),
          Container(
            height: 44,
            child: Row(
              children: [
                Container(
                  width: 90,
                  child: Card(
                    shape: RoundedRectangleBorder(
                      side: new BorderSide(color: AppColors.hint, width: 0.2),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    elevation: 2,
                    shadowColor: AppColors.hint,
                    color: AppColors.white,
                    child: TextField(
                      textAlign: TextAlign.center,
                      enabled: false,
                      controller: _rayonController,
                      style: AppStyles.textNormal,
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(child: Text("Km", style: AppStyles.textNormal)),
              ],
            ),
          ),
          SfSlider(
            activeColor: AppColors.defaultColor,
            inactiveColor: AppColors.hint.withOpacity(0.2),
            min: 0.0,
            max: 50.0,
            value: _value,
            interval: 5,
            stepSize: 5,
            showTicks: false,
            showLabels: false,
            enableTooltip: false,
            minorTicksPerInterval: 1,
            onChanged: (dynamic value) {
              setState(() {
                _value = value;
                _rayonController.text = value.toStringAsFixed(0);
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTransaction() {
    return Material(
      color: AppColors.white,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Transaction",
              style: AppStyles.titleStyleH2, textAlign: TextAlign.left),
          SizedBox(height: 10),
          _buildCheckBoxTransactions("Achat"),
          _buildCheckBoxTransactions("Location"),
          _buildCheckBoxTransactions("Enchères en ligne"),
          _buildCheckBoxTransactions("Enchères classiques"),
          _buildCheckBoxTransactions("Viager"),
        ],
      ),
    );
  }

  Widget _buildCheckBoxTransactions(String type) {
    return Theme(
      data: ThemeData(unselectedWidgetColor: AppColors.defaultColor),
      child: CheckboxListTile(
        contentPadding: EdgeInsets.only(left: 0),
        title: Text(type, style: AppStyles.textNormal),
        checkColor: AppColors.white,
        activeColor: AppColors.defaultColor,
        value: listTransactions.contains(type),
        onChanged: (newValue) {
          setState(() {
            if (newValue) {
              listTransactions.add(type);
            } else {
              listTransactions.removeWhere((element) => element == type);
            }
          });
        },
        controlAffinity:
            ListTileControlAffinity.leading, //  <-- leading Checkbox
      ),
    );
  }

  Widget _buildTypeDeBien() {
    return Material(
      color: AppColors.white,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Type de bien",
              style: AppStyles.titleStyleH2, textAlign: TextAlign.left),
          SizedBox(height: 10),
          Container(
            width: double.infinity,
            height: 60,
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: _buildCheckBoxTypeDeBien("Maisons")),
                Expanded(child: _buildCheckBoxTypeDeBien("Immeubles")),
              ],
            ),
          ),
          Container(
            width: double.infinity,
            height: 60,
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: _buildCheckBoxTypeDeBien("Appartements")),
                Expanded(
                    child: _buildCheckBoxTypeDeBien("Propriétés viticoles")),
              ],
            ),
          ),
          Container(
            width: double.infinity,
            height: 60,
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: _buildCheckBoxTypeDeBien("Terrains à batir")),
                Expanded(
                    child:
                        _buildCheckBoxTypeDeBien("Fonds / Murs commerciaux")),
              ],
            ),
          ),
          Container(
            width: double.infinity,
            height: 60,
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: _buildCheckBoxTypeDeBien("Propriétés")),
                Expanded(
                    child: _buildCheckBoxTypeDeBien(
                        "Terrins de loisirs / Bois / Étangs")),
              ],
            ),
          ),
          Container(
            width: double.infinity,
            height: 60,
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: _buildCheckBoxTypeDeBien("Garages / Parkings")),
                Expanded(child: _buildCheckBoxTypeDeBien("Divers")),
              ],
            ),
          ),
          Container(
            width: double.infinity,
            height: 60,
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: _buildCheckBoxTypeDeBien("Biens agricoles")),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCheckBoxTypeDeBien(String type) {
    return Container(
      height: 80,
      width: 123,
      child: Theme(
        data: ThemeData(unselectedWidgetColor: AppColors.defaultColor),
        child: CheckboxListTile(
          contentPadding: EdgeInsets.only(left: 0),
          title: Text(type, style: AppStyles.textNormal),
          checkColor: AppColors.white,
          activeColor: AppColors.defaultColor,
          value: listTypeDeBiens.contains(type),
          onChanged: (newValue) {
            setState(() {
              if (newValue) {
                listTypeDeBiens.add(type);
              } else {
                listTypeDeBiens.removeWhere((element) => element == type);
              }
            });
          },
          controlAffinity:
              ListTileControlAffinity.leading, //  <-- leading Checkbox
        ),
      ),
    );
  }

  Widget _buildPrice() {
    return Material(
      color: AppColors.white,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Prix (€)",
              style: AppStyles.titleStyleH2, textAlign: TextAlign.left),
          SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(_priceValues.start.toStringAsFixed(0),
                  style: AppStyles.textNormal, textAlign: TextAlign.left),
              Text(
                  _priceValues.end != 1000000.0
                      ? _priceValues.end.toStringAsFixed(0)
                      : "1000000 +",
                  style: AppStyles.textNormal,
                  textAlign: TextAlign.right),
            ],
          ),
          SfRangeSlider(
            activeColor: AppColors.defaultColor,
            inactiveColor: AppColors.hint.withOpacity(0.2),
            min: 0.0,
            max: 1000000.0,
            values: _priceValues,
            interval: 3200000,
            //stepSize: 5,
            showTicks: false,
            showLabels: false,
            enableTooltip: false,
            minorTicksPerInterval: 1,
            onChanged: (SfRangeValues value) {
              setState(() {
                _priceValues = value;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSurfaceInterieur() {
    return Material(
      color: AppColors.white,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Surface intérieure (m²)",
              style: AppStyles.titleStyleH2, textAlign: TextAlign.left),
          SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(_surfInterieurValues.start.toStringAsFixed(0),
                  style: AppStyles.textNormal, textAlign: TextAlign.left),
              Text(
                  _surfInterieurValues.end != 2000.0
                      ? _surfInterieurValues.end.toStringAsFixed(0)
                      : "2000 +",
                  style: AppStyles.textNormal,
                  textAlign: TextAlign.right),
            ],
          ),
          SfRangeSlider(
            activeColor: AppColors.defaultColor,
            inactiveColor: AppColors.hint.withOpacity(0.2),
            min: 0.0,
            max: 2000.0,
            values: _surfInterieurValues,
            interval: 100,
            //stepSize: 5,
            showTicks: false,
            showLabels: false,
            enableTooltip: false,
            minorTicksPerInterval: 1,
            onChanged: (SfRangeValues value) {
              setState(() {
                _surfInterieurValues = value;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSurfaceExterieure() {
    return Material(
      color: AppColors.white,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Surface extérieure (m²)",
              style: AppStyles.titleStyleH2, textAlign: TextAlign.left),
          SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(_surfExterieureValues.start.toStringAsFixed(0),
                  style: AppStyles.textNormal, textAlign: TextAlign.left),
              Text(
                  _surfExterieureValues.end != 100000.0
                      ? _surfExterieureValues.end.toStringAsFixed(0)
                      : "100000 +",
                  style: AppStyles.textNormal,
                  textAlign: TextAlign.right),
            ],
          ),
          SfRangeSlider(
            activeColor: AppColors.defaultColor,
            inactiveColor: AppColors.hint.withOpacity(0.2),
            min: 0.0,
            max: 100000.0,
            values: _surfExterieureValues,
            interval: 100,
            //stepSize: 5,
            showTicks: false,
            showLabels: false,
            enableTooltip: false,
            minorTicksPerInterval: 1,
            onChanged: (SfRangeValues value) {
              setState(() {
                _surfExterieureValues = value;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPieces() {
    return Material(
      color: AppColors.white,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Pièces",
              style: AppStyles.titleStyleH2, textAlign: TextAlign.left),
          SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(_piecesValues.start.toStringAsFixed(0),
                  style: AppStyles.textNormal, textAlign: TextAlign.left),
              Text(
                  _piecesValues.end != 6.0
                      ? _piecesValues.end.toStringAsFixed(0)
                      : "6 +",
                  style: AppStyles.textNormal,
                  textAlign: TextAlign.right),
            ],
          ),
          SfRangeSlider(
            activeColor: AppColors.defaultColor,
            inactiveColor: AppColors.hint.withOpacity(0.2),
            min: 0.0,
            max: 6.0,
            values: _piecesValues,
            interval: 1,
            stepSize: 1,
            showTicks: false,
            showLabels: false,
            enableTooltip: false,
            minorTicksPerInterval: 1,
            onChanged: (SfRangeValues value) {
              setState(() {
                _piecesValues = value;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildChambres() {
    return Material(
      color: AppColors.white,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Chambres",
              style: AppStyles.titleStyleH2, textAlign: TextAlign.left),
          SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(_chambresValues.start.toStringAsFixed(0),
                  style: AppStyles.textNormal, textAlign: TextAlign.left),
              Text(
                  _chambresValues.end != 6.0
                      ? _chambresValues.end.toStringAsFixed(0)
                      : "6 +",
                  style: AppStyles.textNormal,
                  textAlign: TextAlign.right),
            ],
          ),
          SfRangeSlider(
            activeColor: AppColors.defaultColor,
            inactiveColor: AppColors.hint.withOpacity(0.2),
            min: 0.0,
            max: 6.0,
            values: _chambresValues,
            interval: 1,
            stepSize: 1,
            showTicks: false,
            showLabels: false,
            enableTooltip: false,
            minorTicksPerInterval: 1,
            onChanged: (SfRangeValues value) {
              setState(() {
                _chambresValues = value;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildReference() {
    return Material(
      color: AppColors.white,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Référence",
              style: AppStyles.titleStyleH2, textAlign: TextAlign.left),
          SizedBox(height: 15),
          Card(
            shape: RoundedRectangleBorder(
                side: new BorderSide(color: AppColors.hint, width: 0.2),
                borderRadius: BorderRadius.circular(4.0)),
            elevation: 2,
            shadowColor: AppColors.hint,
            color: AppColors.white,
            child: Center(
              child: TextFormField(
                controller: _referenceController,
                cursorColor: AppColors.defaultColor,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.only(
                      bottom: 0.0, left: 10.0, right: 0.0, top: 0.0),
                  hintText: "Référence",
                  hintStyle: AppStyles.hintSearch,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildSubmitButton() {
    return Container(
      decoration: new BoxDecoration(
        color: AppColors.defaultColor,
        borderRadius: BorderRadius.all(Radius.circular(5)),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            submitNewFilter();
          },
          child: Container(
            width: MediaQuery.of(context).size.width * 0.35,
            height: 45,
            child: Center(
              child: (Text("MODIFIER",
                  style: AppStyles.buttonTextWhite,
                  overflow: TextOverflow.clip,
                  maxLines: 1)),
            ),
          ),
        ),
      ),
    );
  }

  void submitNewFilter() {
    homeBloc.currentFilter.listPlaces.clear();
    homeBloc.currentFilter.listPlaces.addAll(bloc.filterTagsList);
    homeBloc.currentFilter.listTransactions.clear();
    homeBloc.currentFilter.listTransactions.addAll(listTransactions);
    homeBloc.currentFilter.listtypeDeBien.clear();
    homeBloc.currentFilter.listtypeDeBien.addAll(listTypeDeBiens);
    homeBloc.currentFilter.rayon = _value;
    homeBloc.currentFilter.priceMin = _priceValues.start;
    homeBloc.currentFilter.priceMax = _priceValues.end;
    homeBloc.currentFilter.surInterieurMin = _surfInterieurValues.start;
    homeBloc.currentFilter.surInterieurMax = _surfInterieurValues.end;
    homeBloc.currentFilter.surExterieurMin = _surfExterieureValues.start;
    homeBloc.currentFilter.surExterieurMax = _surfExterieureValues.end;
    homeBloc.currentFilter.piecesMin = _piecesValues.start;
    homeBloc.currentFilter.piecesMax = _piecesValues.end;
    homeBloc.currentFilter.chambresMin = _chambresValues.start;
    homeBloc.currentFilter.chambresMax = _chambresValues.end;
    homeBloc.currentFilter.reference = _referenceController.text;
    Modular.to.pop();
  }
}
