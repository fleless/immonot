import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_tags/flutter_tags.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:immonot/constants/app_colors.dart';
import 'package:immonot/constants/routes.dart';
import 'package:immonot/constants/styles/app_styles.dart';
import 'package:immonot/models/enum/type_biens.dart';
import 'package:immonot/models/enum/type_ventes.dart';
import 'package:immonot/models/responses/places_response.dart';
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
  List<TypeVentesEnumeration> listTypesVentes = <TypeVentesEnumeration>[];
  List<TypeBienEnumeration> listTypeDeBiens = <TypeBienEnumeration>[];

  SfRangeValues _priceValues = SfRangeValues(0.0, 0.0);
  SfRangeValues _surfInterieurValues = SfRangeValues(0.0, 0.0);
  SfRangeValues _surfExterieureValues = SfRangeValues(0.0, 0.0);
  SfRangeValues _piecesValues = SfRangeValues(0.0, 0.0);
  SfRangeValues _chambresValues = SfRangeValues(0.0, 0.0);
  TextEditingController _referenceController = TextEditingController();

  TextEditingController _minPriceController = TextEditingController();
  TextEditingController _maxPriceController = TextEditingController();
  TextEditingController _minSurfExtController = TextEditingController();
  TextEditingController _maxSurfExtController = TextEditingController();
  TextEditingController _minSurfIntController = TextEditingController();
  TextEditingController _maxSurfIntController = TextEditingController();

  @override
  void initState() {
    super.initState();
    bloc.filterTagsList.clear();
    bloc.filterTagsList.addAll(homeBloc.currentFilter.listPlaces);
    initData();
  }

  initData() {
    setState(() {
      _referenceController.text = homeBloc.currentFilter.reference != null
          ? homeBloc.currentFilter.reference
          : "";
      homeBloc.currentFilter.listTypeVente.forEach((element) {});
      listTypesVentes.addAll(homeBloc.currentFilter.listTypeVente);
      listTypeDeBiens.addAll(homeBloc.currentFilter.listtypeDeBien);
      _rayonController.text = homeBloc.currentFilter.rayon == null
          ? "0"
          : homeBloc.currentFilter.rayon.toStringAsFixed(0);
      _value = homeBloc.currentFilter.rayon;
      _referenceController.text = homeBloc.currentFilter.reference;
      _priceValues = SfRangeValues(
          homeBloc.currentFilter.priceMin, homeBloc.currentFilter.priceMax);
      _minPriceController.text = homeBloc.currentFilter.priceMin == null
          ? "0"
          : homeBloc.currentFilter.priceMin.toStringAsFixed(0);
      _maxPriceController.text = homeBloc.currentFilter.priceMax == null
          ? "0"
          : homeBloc.currentFilter.priceMax.toStringAsFixed(0);
      _surfInterieurValues = SfRangeValues(
          homeBloc.currentFilter.surInterieurMin,
          homeBloc.currentFilter.surInterieurMax);
      _minSurfIntController.text =
          homeBloc.currentFilter.surInterieurMin == null
              ? "0"
              : homeBloc.currentFilter.surInterieurMin.toStringAsFixed(0);
      _maxSurfIntController.text =
          homeBloc.currentFilter.surInterieurMax == null
              ? "0"
              : homeBloc.currentFilter.surInterieurMax.toStringAsFixed(0);
      _surfExterieureValues = SfRangeValues(
          homeBloc.currentFilter.surExterieurMin,
          homeBloc.currentFilter.surExterieurMax);
      _minSurfExtController.text =
          homeBloc.currentFilter.surExterieurMin == null
              ? "0"
              : homeBloc.currentFilter.surExterieurMin.toStringAsFixed(0);
      _maxSurfExtController.text =
          homeBloc.currentFilter.surExterieurMax == null
              ? "0"
              : homeBloc.currentFilter.surExterieurMax.toStringAsFixed(0);
      _piecesValues = SfRangeValues(
          homeBloc.currentFilter.piecesMin, homeBloc.currentFilter.piecesMax);
      _chambresValues = SfRangeValues(homeBloc.currentFilter.chambresMin,
          homeBloc.currentFilter.chambresMax);
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
                    title: (item.codePostal == null
                            ? item.code
                            : item.codePostal) +
                        " " +
                        item.nom,
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
            value: _value == null ? 0.0 : _value,
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
          _buildCheckBoxTransactions(typeVentes[0]),
          _buildCheckBoxTransactions(typeVentes[1]),
          _buildCheckBoxTransactions(typeVentes[2]),
          _buildCheckBoxTransactions(typeVentes[3]),
          //_buildCheckBoxTransactions(typeVentes[4]),
        ],
      ),
    );
  }

  Widget _buildCheckBoxTransactions(TypeVentesEnumeration type) {
    return Theme(
      data: ThemeData(unselectedWidgetColor: AppColors.defaultColor),
      child: CheckboxListTile(
        contentPadding: EdgeInsets.only(left: 0),
        title: Text(type.label, style: AppStyles.textNormal),
        checkColor: AppColors.white,
        activeColor: AppColors.defaultColor,
        value: listTypesVentes.contains(type),
        onChanged: (newValue) {
          setState(() {
            if (newValue) {
              listTypesVentes.add(type);
            } else {
              listTypesVentes.removeWhere((element) => element == type);
            }
            listTypesVentes.forEach((element) {
              print(element.code + "   ");
            });
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
                Expanded(child: _buildCheckBoxTypeDeBien(typeBiens[1])),
                Expanded(child: _buildCheckBoxTypeDeBien(typeBiens[6])),
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
                Expanded(child: _buildCheckBoxTypeDeBien(typeBiens[0])),
                Expanded(child: _buildCheckBoxTypeDeBien(typeBiens[8])),
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
                Expanded(child: _buildCheckBoxTypeDeBien(typeBiens[9])),
                Expanded(child: _buildCheckBoxTypeDeBien(typeBiens[4])),
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
                Expanded(child: _buildCheckBoxTypeDeBien(typeBiens[7])),
                Expanded(child: _buildCheckBoxTypeDeBien(typeBiens[10])),
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
                Expanded(child: _buildCheckBoxTypeDeBien(typeBiens[5])),
                Expanded(child: _buildCheckBoxTypeDeBien(typeBiens[3])),
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
                Expanded(child: _buildCheckBoxTypeDeBien(typeBiens[2])),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCheckBoxTypeDeBien(TypeBienEnumeration type) {
    return Container(
      height: 80,
      width: 123,
      child: Theme(
        data: ThemeData(unselectedWidgetColor: AppColors.defaultColor),
        child: CheckboxListTile(
          contentPadding: EdgeInsets.only(left: 0),
          title: Text(type.label, style: AppStyles.textNormal),
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
                _minPriceController.text = value.start.toStringAsFixed(0);
                _maxPriceController.text = value.end.toStringAsFixed(0);
              });
            },
          ),
          _priceTextFields(),
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
                _minSurfIntController.text = value.start.toStringAsFixed(0);
                _maxSurfIntController.text = value.end.toStringAsFixed(0);
              });
            },
          ),
          _surfIntTextFields()
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
                _minSurfExtController.text = value.start.toStringAsFixed(0);
                _maxSurfExtController.text = value.end.toStringAsFixed(0);
              });
            },
          ),
          _surfExtTextFields()
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

  Widget _priceTextFields() {
    return Container(
      padding: EdgeInsets.all(10),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Minimum",
                  style: AppStyles.bottomNavTextNotSelectedStyle,
                ),
                Container(
                  padding: EdgeInsets.only(top: 5),
                  alignment: Alignment.center,
                  child: TextField(
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.allow(RegExp(r'(^\d*)')),
                    ],
                    onChanged: (value) {
                      setState(() {
                        if (value.isEmpty) {
                          _priceValues = SfRangeValues(0.0, _priceValues.end);
                        } else if (double.parse(value) > 1000000) {
                          _minPriceController.text = "1000000";
                          _maxPriceController.text = "1000000";
                          _priceValues = SfRangeValues(1000000.0, 1000000.0);
                        } else if (value.isNotEmpty) {
                          _priceValues = SfRangeValues(
                              double.parse(value), _priceValues.end);
                          if (double.parse(value) > _priceValues.end) {
                            _maxPriceController.text = value;
                            _priceValues = SfRangeValues(double.parse(value),
                                double.parse(_minPriceController.text));
                          }
                        }
                      });
                    },
                    textAlign: TextAlign.center,
                    controller: _minPriceController,
                    style: AppStyles.filterSubStyle,
                    cursorColor: AppColors.default_black,
                    decoration: new InputDecoration(
                      enabledBorder: const OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: Colors.grey, width: 0.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                        borderSide:
                            BorderSide(width: 1, color: AppColors.defaultColor),
                      ),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(4)),
                          borderSide: BorderSide(
                              width: 1, color: AppColors.defaultColor)),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Center(child: Text("-")),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Maximum",
                  style: AppStyles.bottomNavTextNotSelectedStyle,
                ),
                Container(
                  padding: EdgeInsets.only(top: 5),
                  alignment: Alignment.center,
                  child: TextField(
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.allow(RegExp(r'(^\d*)')),
                    ],
                    onChanged: (value) {
                      setState(() {
                        setState(() {
                          if (value.isEmpty) {
                            _minPriceController.text = "0";
                            _priceValues = SfRangeValues(0.0, 0.0);
                          } else if (double.parse(value) > 1000000) {
                            _maxPriceController.text = "1000000";
                            _priceValues =
                                SfRangeValues(_priceValues.start, 1000000.0);
                          } else if (value.isNotEmpty) {
                            _priceValues = SfRangeValues(
                                _priceValues.start, double.parse(value));
                            if (double.parse(value) < _priceValues.start) {
                              _minPriceController.text = value;
                              _priceValues = SfRangeValues(
                                  double.parse(value), double.parse(value));
                            }
                          }
                        });
                      });
                    },
                    textAlign: TextAlign.center,
                    controller: _maxPriceController,
                    cursorColor: AppColors.default_black,
                    style: AppStyles.filterSubStyle,
                    decoration: new InputDecoration(
                      enabledBorder: const OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: Colors.grey, width: 0.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                        borderSide:
                            BorderSide(width: 1, color: AppColors.defaultColor),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                        borderSide:
                            BorderSide(width: 1, color: AppColors.defaultColor),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _surfExtTextFields() {
    return Container(
      padding: EdgeInsets.all(10),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Minimum",
                  style: AppStyles.bottomNavTextNotSelectedStyle,
                ),
                Container(
                  padding: EdgeInsets.only(top: 5),
                  alignment: Alignment.center,
                  child: TextField(
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.allow(RegExp(r'(^\d*)')),
                    ],
                    onChanged: (value) {
                      setState(() {
                        if (value.isEmpty) {
                          _surfExterieureValues =
                              SfRangeValues(0.0, _surfExterieureValues.end);
                        } else if (double.parse(value) > 100000) {
                          _minSurfExtController.text = "100000";
                          _maxSurfExtController.text = "100000";
                          _surfExterieureValues =
                              SfRangeValues(100000.0, 100000.0);
                        } else if (value.isNotEmpty) {
                          _surfExterieureValues = SfRangeValues(
                              double.parse(value), _surfExterieureValues.end);
                          if (double.parse(value) > _surfExterieureValues.end) {
                            _maxSurfExtController.text = value;
                            _surfExterieureValues = SfRangeValues(
                                double.parse(value),
                                double.parse(_minSurfExtController.text));
                          }
                        }
                      });
                    },
                    textAlign: TextAlign.center,
                    controller: _minSurfExtController,
                    style: AppStyles.filterSubStyle,
                    cursorColor: AppColors.default_black,
                    decoration: new InputDecoration(
                      enabledBorder: const OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: Colors.grey, width: 0.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                        borderSide:
                            BorderSide(width: 1, color: AppColors.defaultColor),
                      ),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(4)),
                          borderSide: BorderSide(
                              width: 1, color: AppColors.defaultColor)),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Center(child: Text("-")),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Maximum",
                  style: AppStyles.bottomNavTextNotSelectedStyle,
                ),
                Container(
                  padding: EdgeInsets.only(top: 5),
                  alignment: Alignment.center,
                  child: TextField(
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.allow(RegExp(r'(^\d*)')),
                    ],
                    onChanged: (value) {
                      setState(() {
                        setState(() {
                          if (value.isEmpty) {
                            _minSurfExtController.text = "0";
                            _surfExterieureValues = SfRangeValues(0.0, 0.0);
                          } else if (double.parse(value) > 100000) {
                            _maxSurfExtController.text = "100000";
                            _surfExterieureValues = SfRangeValues(
                                _surfExterieureValues.start, 100000.0);
                          } else if (value.isNotEmpty) {
                            _surfExterieureValues = SfRangeValues(
                                _surfExterieureValues.start,
                                double.parse(value));
                            if (double.parse(value) <
                                _surfExterieureValues.start) {
                              _minSurfExtController.text = value;
                              _surfExterieureValues = SfRangeValues(
                                  double.parse(value), double.parse(value));
                            }
                          }
                        });
                      });
                    },
                    textAlign: TextAlign.center,
                    controller: _maxSurfExtController,
                    cursorColor: AppColors.default_black,
                    style: AppStyles.filterSubStyle,
                    decoration: new InputDecoration(
                      enabledBorder: const OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: Colors.grey, width: 0.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                        borderSide:
                            BorderSide(width: 1, color: AppColors.defaultColor),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                        borderSide:
                            BorderSide(width: 1, color: AppColors.defaultColor),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _surfIntTextFields() {
    return Container(
      padding: EdgeInsets.all(10),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Minimum",
                  style: AppStyles.bottomNavTextNotSelectedStyle,
                ),
                Container(
                  padding: EdgeInsets.only(top: 5),
                  alignment: Alignment.center,
                  child: TextField(
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.allow(RegExp(r'(^\d*)')),
                    ],
                    onChanged: (value) {
                      setState(() {
                        if (value.isEmpty) {
                          _surfInterieurValues =
                              SfRangeValues(0.0, _surfInterieurValues.end);
                        } else if (double.parse(value) > 2000) {
                          _minSurfIntController.text = "2000";
                          _maxSurfIntController.text = "2000";
                          _surfInterieurValues = SfRangeValues(2000.0, 2000.0);
                        } else if (value.isNotEmpty) {
                          _surfInterieurValues = SfRangeValues(
                              double.parse(value), _surfInterieurValues.end);
                          if (double.parse(value) > _surfInterieurValues.end) {
                            _maxSurfIntController.text = value;
                            _surfInterieurValues = SfRangeValues(
                                double.parse(value),
                                double.parse(_minSurfIntController.text));
                          }
                        }
                      });
                    },
                    textAlign: TextAlign.center,
                    controller: _minSurfIntController,
                    style: AppStyles.filterSubStyle,
                    cursorColor: AppColors.default_black,
                    decoration: new InputDecoration(
                      enabledBorder: const OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: Colors.grey, width: 0.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                        borderSide:
                            BorderSide(width: 1, color: AppColors.defaultColor),
                      ),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(4)),
                          borderSide: BorderSide(
                              width: 1, color: AppColors.defaultColor)),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Center(child: Text("-")),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Maximum",
                  style: AppStyles.bottomNavTextNotSelectedStyle,
                ),
                Container(
                  padding: EdgeInsets.only(top: 5),
                  alignment: Alignment.center,
                  child: TextField(
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.allow(RegExp(r'(^\d*)')),
                    ],
                    onChanged: (value) {
                      setState(() {
                        setState(() {
                          if (value.isEmpty) {
                            _minSurfIntController.text = "0";
                            _surfInterieurValues = SfRangeValues(0.0, 0.0);
                          } else if (double.parse(value) > 2000) {
                            _maxSurfIntController.text = "2000";
                            _surfInterieurValues = SfRangeValues(
                                _surfInterieurValues.start, 2000.0);
                          } else if (value.isNotEmpty) {
                            _surfInterieurValues = SfRangeValues(
                                _surfInterieurValues.start,
                                double.parse(value));
                            if (double.parse(value) <
                                _surfInterieurValues.start) {
                              _minSurfIntController.text = value;
                              _surfInterieurValues = SfRangeValues(
                                  double.parse(value), double.parse(value));
                            }
                          }
                        });
                      });
                    },
                    textAlign: TextAlign.center,
                    controller: _maxSurfIntController,
                    cursorColor: AppColors.default_black,
                    style: AppStyles.filterSubStyle,
                    decoration: new InputDecoration(
                      enabledBorder: const OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: Colors.grey, width: 0.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                        borderSide:
                            BorderSide(width: 1, color: AppColors.defaultColor),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                        borderSide:
                            BorderSide(width: 1, color: AppColors.defaultColor),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void submitNewFilter() {
    homeBloc.currentFilter.listPlaces.clear();
    homeBloc.currentFilter.listPlaces.addAll(bloc.filterTagsList);
    homeBloc.currentFilter.listTypeVente.clear();
    homeBloc.currentFilter.listTypeVente.addAll(listTypesVentes);
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
    homeBloc.notifChanges();
  }
}
