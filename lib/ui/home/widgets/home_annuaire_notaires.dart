import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:immonot/constants/app_colors.dart';
import 'package:immonot/constants/endpoints.dart';
import 'package:immonot/constants/routes.dart';
import 'package:immonot/constants/styles/app_styles.dart';
import 'package:immonot/models/responses/places_response.dart';
import 'package:immonot/ui/home/home_bloc.dart';
import 'package:immonot/utils/user_location.dart';

class HomeAnnuaireWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HomeAnnuaireWidgetState();
}

class _HomeAnnuaireWidgetState extends State<HomeAnnuaireWidget> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _nomController = TextEditingController();
  final userLocation = Modular.get<UserLocation>();
  PlacesResponse locationSelected;
  final bloc = Modular.get<HomeBloc>();
  final _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return _buildContent();
  }

  Future<List<PlacesResponse>> _searchDetails(String item) async {
    List<PlacesResponse> resp = await bloc.searchPlaces(item);
    return resp == null ? PlacesResponse() : resp;
  }

  Widget _buildContent() {
    return Padding(
      padding: EdgeInsets.only(right: 15, top: 40, bottom: 40, left: 15),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            "Annuaire des Notaires",
            textAlign: TextAlign.left,
            style: AppStyles.titleStyle,
            overflow: TextOverflow.clip,
            maxLines: 1,
          ),
          SizedBox(height: 5),
          Text(
              "Trouvez votre Notaire parmi près de 9 000 notaires et plus de 4 500 offices notariaux répartis sur l’ensemble du territoire.",
              overflow: TextOverflow.ellipsis,
              maxLines: 5,
              style: AppStyles.subTitleStyle),
          Padding(padding: EdgeInsets.only(top: 20)),
          _buildForm(),
        ],
      ),
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          _buildNomTextField(),
          SizedBox(height: 10),
          _buildVilleTextField(),
          SizedBox(height: 30),
          _buildButton()
        ],
      ),
    );
  }

  Widget _buildNomTextField() {
    return Card(
      shape: RoundedRectangleBorder(
          side: new BorderSide(color: AppColors.hint, width: 0.2),
          borderRadius: BorderRadius.circular(4.0)),
      elevation: 2,
      shadowColor: AppColors.hint,
      color: AppColors.appBackground,
      child: TextFormField(
        controller: _nomController,
        cursorColor: AppColors.defaultColor,
        decoration: const InputDecoration(
          border: InputBorder.none,
          contentPadding:
              EdgeInsets.only(bottom: 15.0, left: 10.0, right: 10.0, top: 13.0),
          hintText: "Nom de votre notaire",
          hintStyle: AppStyles.hintSearch,
        ),
      ),
    );
  }

  Widget _buildVilleTextField() {
    return Card(
      shape: RoundedRectangleBorder(
          side: new BorderSide(color: AppColors.hint, width: 0.2),
          borderRadius: BorderRadius.circular(4.0)),
      color: AppColors.appBackground,
      elevation: 4,
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          // If you want align text to left
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                color: AppColors.appBackground,
                child: TypeAheadField<PlacesResponse>(
                  textFieldConfiguration: TextFieldConfiguration(
                      controller: _searchController,
                      cursorColor: AppColors.defaultColor,
                      autofocus: false,
                      style: AppStyles.textNormal,
                      onChanged: (value) => locationSelected = null,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Ville, département, code postal',
                          hintStyle: AppStyles.hintSearch)),
                  suggestionsCallback: (pattern) => _searchDetails(pattern),
                  loadingBuilder: (context) {
                    return Container(
                      child: Center(
                        child: CircularProgressIndicator.adaptive(
                          valueColor: AlwaysStoppedAnimation<Color>(
                              AppColors.defaultColor),
                        ),
                      ),
                    );
                  },
                  suggestionsBoxDecoration: SuggestionsBoxDecoration(
                    constraints: BoxConstraints(maxHeight: 300),
                  ),
                  itemBuilder: (context, suggestion) {
                    return Container(
                      padding: EdgeInsets.all(10),
                      child: Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              color:
                                  AppColors.firstChartColor.withOpacity(0.15),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5)),
                            ),
                            child: Text(
                                suggestion.codePostal == null
                                    ? suggestion.code ?? ""
                                    : suggestion.codePostal ?? "",
                                style: AppStyles.smallTitleStyleBlack),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                              child: Text(suggestion.nom ?? "",
                                  style: AppStyles.subTitleStyle))
                        ],
                      ),
                    );
                  },
                  noItemsFoundBuilder: (value) {
                    return Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      child: Text("Aucune adresse trouvée",
                          style: AppStyles.hintSearch),
                    );
                  },
                  onSuggestionSelected: (suggestion) {
                    locationSelected = suggestion;
                    setState(() {
                      _searchController.text = suggestion.nom;
                    });
                  },
                ),
              ),
            ),
            InkWell(
              onTap: () async {
                String _address;
                _address = await userLocation.getUserDepartmentCode();
                List<PlacesResponse> placess = await _searchDetails(_address);
                _searchController.text =
                    placess.isEmpty ? _address : placess.first.nom;
                locationSelected = placess.isEmpty ? null : placess.first;
                //_searchController.text = _address;
              },
              child: Container(
                decoration: new BoxDecoration(
                  color: AppColors.appBackground,
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(5),
                      bottomRight: Radius.circular(5)),
                  border: Border.all(color: Colors.transparent),
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
            FocusScope.of(context).requestFocus(FocusNode());
            // Format nom and communes or departements to send with url
            String nom = "";
            if (_nomController.text.trim() == "") {
              nom = "";
            } else {
              nom = "noms=" +
                  "*" +
                  _nomController.text.trim().replaceAll(" ", "%20") +
                  "*";
            }
            String depCom = "";
            if (_searchController.text.trim() == "") {
              depCom = "";
            } else {
              if (locationSelected == null) {
                depCom = ("codeInsees=" +
                    _searchController.text.trim().replaceAll(" ", "%20") +
                    "&rayons=10");
              } else {
                depCom = locationSelected.code.length == 2
                    ? "departements=" + locationSelected.code
                    : ("codeInsees=" + locationSelected.code + "&rayons=10");
              }
            }

            Modular.to.pushNamed(Routes.annuaireWebView, arguments: {
              "url": Endpoints.ANNUAIRE_WEB_VIEW +
                  "?" +
                  nom +
                  (nom != null ? "&" : "") +
                  depCom,
              "ville": locationSelected == null
                  ? PlacesResponse(nom: _searchController.text.trim())
                  : locationSelected,
              "nom": _nomController.text.trim()
            });
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
}
