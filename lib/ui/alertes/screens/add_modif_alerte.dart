import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_tags/flutter_tags.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:immonot/constants/app_colors.dart';
import 'package:immonot/constants/styles/app_styles.dart';
import 'package:immonot/models/enum/type_biens.dart';
import 'package:immonot/models/enum/type_ventes.dart';
import 'package:immonot/models/requests/create_alerte_request.dart';
import 'package:immonot/models/responses/get_alertes_response.dart';
import 'package:immonot/models/responses/places_response.dart';
import 'package:immonot/ui/alertes/alertes_bloc.dart';
import 'package:immonot/ui/alertes/screens/search_places_alertes.dart';
import 'package:immonot/utils/flushbar_utils.dart';
import 'package:immonot/utils/user_location.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

class AddModifAlerteScreen extends StatefulWidget {
  bool isAjout;
  Content item;

  AddModifAlerteScreen(this.isAjout, this.item);

  @override
  State<StatefulWidget> createState() => _AddModifAlerteScreenState();
}

class _AddModifAlerteScreenState extends State<AddModifAlerteScreen> {
  final _formKey = GlobalKey<FormState>();
  final _searchController = TextEditingController();
  final _rayonController = TextEditingController();
  final userLocation = Modular.get<UserLocation>();
  final alertesBloc = Modular.get<AlertesBloc>();
  final GlobalKey<TagsState> _multitagStateKey = GlobalKey<TagsState>();
  double _value = 0;
  List<TypeVentesEnumeration> listTypesVentes = <TypeVentesEnumeration>[];
  List<TypeBienEnumeration> listTypeDeBiens = <TypeBienEnumeration>[];
  List<PlacesResponse> listPlaces = <PlacesResponse>[];
  bool _loading = false;

  bool mailOn = true;
  bool notifOn = true;
  SfRangeValues _priceValues = SfRangeValues(0.0, 1000000.0);
  SfRangeValues _surfInterieurValues = SfRangeValues(0.0, 2000.0);
  SfRangeValues _surfExterieureValues = SfRangeValues(0.0, 100000.0);
  SfRangeValues _piecesValues = SfRangeValues(0.0, 6.0);
  SfRangeValues _chambresValues = SfRangeValues(0.0, 6.0);
  TextEditingController _nomController = TextEditingController();
  TextEditingController _commentaireController = TextEditingController();

  TextEditingController _minPriceController = TextEditingController();
  TextEditingController _maxPriceController = TextEditingController();
  TextEditingController _minSurfExtController = TextEditingController();
  TextEditingController _maxSurfExtController = TextEditingController();
  TextEditingController _minSurfIntController = TextEditingController();
  TextEditingController _maxSurfIntController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _rayonController.text = "0";
    _minPriceController.text = "0";
    _maxPriceController.text = "1000000";
    _minSurfExtController.text = "0";
    _maxSurfExtController.text = "2000";
    _minSurfIntController.text = "0";
    _maxSurfIntController.text = "100000";
    if (!widget.isAjout) if (widget.item != null) initData();
  }

  initData() {
    setState(() {
      if (widget.item.nom != null) _nomController.text = widget.item.nom;
      if (widget.item.commentaire != null)
        _commentaireController.text = widget.item.commentaire;
      if (widget.item.push != null) notifOn = widget.item.push ? true : false;
      if (widget.item.mail != null) mailOn = widget.item.mail ? true : false;
      if (widget.item.recherche.departements != null) {
        widget.item.recherche.departements.forEach((element) {
          listPlaces.add(PlacesResponse(codePostal: element));
        });
      }
      if (widget.item.recherche.oidCommunes != null) {
        widget.item.recherche.oidCommunes.forEach((element) {
          listPlaces.add(PlacesResponse(codePostal: element, code: element));
        });
      }
      if (widget.item.recherche.rayons != null) {
        _value = widget.item.recherche.rayons[0];
        _rayonController.text = widget.item.recherche.rayons[0].toString();
      }
      if (widget.item.recherche.prix != null) {
        _priceValues = SfRangeValues(
            widget.item.recherche.prix[0], widget.item.recherche.prix[1]);
        _minPriceController.text =
            widget.item.recherche.prix[0].toStringAsFixed(0);
        _maxPriceController.text =
            widget.item.recherche.prix[1].toStringAsFixed(0);
      }
      if (widget.item.recherche.surfaceExterieure != null) {
        _surfExterieureValues = SfRangeValues(
            widget.item.recherche.surfaceExterieure[0],
            widget.item.recherche.surfaceExterieure[1]);
        _minSurfExtController.text =
            widget.item.recherche.surfaceExterieure[0].toStringAsFixed(0);
        _maxSurfExtController.text =
            widget.item.recherche.surfaceExterieure[1].toStringAsFixed(0);
      }
      if (widget.item.recherche.surfaceInterieure != null) {
        _surfInterieurValues = SfRangeValues(
            widget.item.recherche.surfaceInterieure[0],
            widget.item.recherche.surfaceInterieure[1]);
        _minSurfIntController.text =
            widget.item.recherche.surfaceInterieure[0].toStringAsFixed(0);
        _maxSurfIntController.text =
            widget.item.recherche.surfaceInterieure[1].toStringAsFixed(0);
      }
      if (widget.item.recherche.nbPieces != null) {
        _piecesValues = SfRangeValues(
            double.parse(widget.item.recherche.nbPieces[0].toString()),
            double.parse(widget.item.recherche.nbPieces[1].toString()));
      }
      if (widget.item.recherche.nbChambres != null) {
        _chambresValues = SfRangeValues(
            double.parse(widget.item.recherche.nbChambres[0].toString()),
            double.parse(widget.item.recherche.nbChambres[1].toString()));
      }
      if (widget.item.recherche.typeVentes != null) {
        widget.item.recherche.typeVentes.forEach((element) {
          listTypesVentes
              .add(TypeVentesEnumeration.findTypeVenteByCode(element));
        });
      }
      if (widget.item.recherche.typeBiens != null) {
        widget.item.recherche.typeBiens.forEach((element) {
          listTypeDeBiens.add(TypeBienEnumeration.findTypeBienByCode(element));
        });
      }
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
                            _buildNomRecherche(),
                            SizedBox(height: 40),
                            _buildCommentaire(),
                            SizedBox(height: 40),
                            _buildNotificationSouhaite(),
                            SizedBox(height: 40),
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
            widget.isAjout ? "Créer une alerte" : "Modifier l'alerte",
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
                      onTap: () async {
                        FocusScope.of(context).requestFocus(new FocusNode());
                        final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    SearchPlacesAlertesScreen(listPlaces, "")));
                        setState(() {
                          if (result != null) {
                            listPlaces.clear();
                            listPlaces.addAll(result);
                          }
                        });
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
                      final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SearchPlacesAlertesScreen(
                                  listPlaces, _address)));
                      setState(() {
                        if (result != null) {
                          listPlaces.clear();
                          listPlaces.addAll(result);
                        }
                      });
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
                itemCount: listPlaces.length,
                itemBuilder: (int index) {
                  final item = listPlaces[index];
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
                            ? (item.code == null ? "" : item.code)
                            : item.codePostal) +
                        " " +
                        (item.nom == null ? "" : item.nom),
                    removeButton: ItemTagsRemoveButton(
                      backgroundColor: AppColors.white,
                      color: AppColors.default_black,
                      size: 16,
                      onRemoved: () {
                        setState(() {
                          listPlaces.removeAt(index);
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

  Widget _buildNomRecherche() {
    return Form(
      key: _formKey,
      child: Material(
        color: AppColors.white,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Nom de la recherche",
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
                  controller: _nomController,
                  cursorColor: AppColors.defaultColor,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: AppColors.hint, width: 1),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: AppColors.hint, width: 1),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: AppColors.alert, width: 1),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: AppColors.defaultColor, width: 1),
                    ),
                    contentPadding: EdgeInsets.only(
                        bottom: 0.0, left: 10.0, right: 0.0, top: 0.0),
                    hintText: "Nom de la recherche",
                    hintStyle: AppStyles.hintSearch,
                    errorStyle: TextStyle(height: 0),
                  ),
                  validator: (value) {
                    return value.isEmpty ? "" : null;
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildCommentaire() {
    return Material(
      color: AppColors.white,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Commentaire",
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
              child: Container(
                height: 100,
                child: TextFormField(
                  controller: _commentaireController,
                  cursorColor: AppColors.defaultColor,
                  keyboardType: TextInputType.multiline,
                  expands: true,
                  maxLines: null,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.only(
                        bottom: 10.0, left: 10.0, right: 10.0, top: 10.0),
                    hintText: "Commentaire",
                    hintStyle: AppStyles.hintSearch,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildNotificationSouhaite() {
    return Material(
      color: AppColors.white,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Notification souhaitée",
              style: AppStyles.titleStyleH2, textAlign: TextAlign.left),
          SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Notification push",
                  style: AppStyles.textNormal,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1),
              Switch(
                  activeColor: AppColors.defaultColor,
                  value: notifOn,
                  onChanged: (value) {
                    setState(() {
                      notifOn = value;
                    });
                  })
            ],
          ),
          SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("E-mail",
                  style: AppStyles.textNormal,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1),
              Switch(
                  activeColor: AppColors.defaultColor,
                  value: mailOn,
                  onChanged: (value) {
                    setState(() {
                      mailOn = value;
                    });
                  })
            ],
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
            if (!_loading) if (_formKey.currentState.validate()) {
              widget.isAjout ? _goSaveAlerte() : _goModifAlerte();
            } else {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text("Le nom de la recherche est requis"),
              ));
            }
          },
          child: Container(
            width: MediaQuery.of(context).size.width * 0.7,
            height: 55,
            child: Center(
              child: _loading
                  ? Center(
                      child: CircularProgressIndicator(color: AppColors.white))
                  : (Text(
                      widget.isAjout
                          ? "SAUVEGARDER L'ALERTE"
                          : "SAUVEGARDER LES MODIFICATIONS",
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

  _goSaveAlerte() async {
    setState(() {
      _loading = true;
    });
    CreateAlerteRequest req = _parseToContent();
    bool resp = await alertesBloc.addAlerte(req);
    if (resp) {
      Modular.to.pop();
      alertesBloc.changesNotifier.add(true);
      showSuccessToast(context, "Votre alerte a été sauvegardé");
    } else {
      showErrorToast(context, 'Une erreur est survenue');
    }
    setState(() {
      _loading = false;
    });
  }

  _goModifAlerte() async {
    setState(() {
      _loading = true;
    });
    CreateAlerteRequest req = _parseToContent();
    bool resp = await alertesBloc.modifierAlertes(req, widget.item.id);
    if (resp) {
      Modular.to.pop();
      alertesBloc.changesNotifier.add(true);
      showSuccessToast(context, "Votre alerte a été sauvegardé");
    } else {
      showErrorToast(context, 'Une erreur est survenue');
    }
    setState(() {
      _loading = false;
    });
  }

  CreateAlerteRequest _parseToContent() {
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
    req.push = notifOn;
    req.mail = mailOn;
    req.nom = _nomController.text;
    req.token = "";
    req.commentaire = _commentaireController.text;
    contenu.rayons.add(_value);
    contenu.prix.add(_priceValues.start);
    contenu.prix.add(_priceValues.end);
    contenu.surfaceInterieure.add(_surfInterieurValues.start);
    contenu.surfaceInterieure.add(_surfInterieurValues.end);
    contenu.surfaceExterieure.add(_surfExterieureValues.start);
    contenu.surfaceExterieure.add(_surfExterieureValues.end);
    contenu.nbPieces.add(double.parse(_piecesValues.start.toString()));
    contenu.nbPieces.add(double.parse(_piecesValues.end.toString()));
    contenu.nbChambres.add(_chambresValues.start);
    contenu.nbChambres.add(_chambresValues.end);
    listPlaces.forEach((element) {
      if (element.code != null) {
        element.code.length == 2
            ? contenu.departements.add(element.code)
            : contenu.oidCommunes.add(element.code);
      } else if (element.codePostal != null) {
        element.codePostal.length == 2
            ? contenu.departements.add(element.codePostal)
            : contenu.oidCommunes.add(element.codePostal);
      }
    });
    listTypesVentes.forEach((element) {
      contenu.typeVentes.add(element.code);
    });
    listTypeDeBiens.forEach((element) {
      contenu.typeBiens.add(element.code);
    });
    req.recherche = contenu;
    return req;
  }
}
