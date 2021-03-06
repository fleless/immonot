import 'package:awesome_loader/awesome_loader.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_tags/flutter_tags.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:immonot/constants/app_colors.dart';
import 'package:immonot/constants/styles/app_styles.dart';
import 'package:immonot/models/responses/places_response.dart';
import 'package:immonot/ui/home/home_bloc.dart';
import 'package:immonot/utils/user_location.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

class SearchScreen extends StatefulWidget {
  String address;

  SearchScreen(String address) {
    this.address = address;
  }

  @override
  State<StatefulWidget> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final GlobalKey<TagsState> _tagStateKey = GlobalKey<TagsState>();
  final _searchController = TextEditingController();
  final userLocation = Modular.get<UserLocation>();
  final bloc = Modular.get<HomeBloc>();
  final _rayonController = TextEditingController();
  double _value = 0.0;
  final List<PlacesResponse> currentList = <PlacesResponse>[];

  @override
  Future<void> initState() {
    super.initState();
    currentList.addAll(bloc.currentFilter.listPlaces);
    _changeSearchToCurrentPosition(widget.address);
    _rayonController.text = bloc.currentFilter.rayon.toStringAsFixed(0) ?? "0";
    setState(() {
      _value = bloc.currentFilter.rayon ?? 0;
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  _changeSearchToCurrentPosition(String address) {
    _searchController.text = address;
    _searchDetails(address);
  }

  Future<List<PlacesResponse>> _searchDetails(String item) async {
    List<PlacesResponse> resp = await bloc.searchPlaces(item);
    List<PlacesResponse> filteredSearch = <PlacesResponse>[];
    resp.forEach((element) {
      List<String> lista = currentList.map((e) => e.code).toList();
      if (!lista.contains(element.code)) {
        filteredSearch.add(element);
      }
    });
    return filteredSearch == null ? null : filteredSearch;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.appBackground,
      //drawer: DrawerWidget(),
      body: SingleChildScrollView(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).requestFocus(new FocusNode()),
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 30),
              child: Container(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildTitle(),
                    SizedBox(height: 15),
                    _buildSearch(),
                    SizedBox(height: 10),
                    _buildTags(),
                    SizedBox(height: 15),
                    _buildRayon(),
                    SizedBox(height: 5),
                    currentList.length > 0
                        ? Container(color: AppColors.dividerColor, height: 1)
                        : SizedBox.shrink(),
                    SizedBox(height: 15),
                    _buildBValidationutton(),
                    SizedBox(height: 15),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return ListTile(
      title: Center(
        child: Text(
          "Rechercher une localit??",
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
          size: 20,
          color: AppColors.default_black,
        ),
      ),
    );
  }

  Widget _buildSearch() {
    return Card(
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
                child: TypeAheadField<PlacesResponse>(
                  textFieldConfiguration: TextFieldConfiguration(
                      controller: _searchController,
                      cursorColor: AppColors.defaultColor,
                      autofocus: true,
                      style: AppStyles.textNormal,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Villes, d??partements, codes postaux',
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
                      child: Text("Aucune adresse trouv??e",
                          style: AppStyles.hintSearch),
                    );
                  },
                  onSuggestionSelected: (suggestion) {
                    placeSelected(suggestion);
                    setState(() {
                      _searchController.text = "";
                    });
                  },
                ),
              ),
            ),
            InkWell(
              onTap: () async {
                String _address;
                _address = await userLocation.getUserAddress();
                _changeSearchToCurrentPosition(_address);
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

  Widget _buildRayon() {
    return Material(
      color: AppColors.appBackground,
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
                    child: Container(
                      height: double.infinity,
                      width: double.infinity,
                      alignment: Alignment.center,
                      padding: EdgeInsets.only(bottom: 5),
                      child: TextField(
                        textAlign: TextAlign.center,
                        enabled: false,
                        decoration: InputDecoration(border: InputBorder.none),
                        controller: _rayonController,
                        style: AppStyles.textNormal,
                      ),
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

  Widget _buildTags() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Tags(
          key: _tagStateKey,
          alignment: WrapAlignment.start,
          itemCount: currentList.length,
          itemBuilder: (int index) {
            final item = currentList[index];
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
                    currentList.removeAt(index);
                    _searchDetails(_searchController.text);
                  });
                  return true;
                },
              ), // OR null,
            );
          }),
    );
  }

  _buildBValidationutton() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.35,
      decoration: new BoxDecoration(
        color: AppColors.defaultColor,
        borderRadius: BorderRadius.all(Radius.circular(5)),
      ),
      child: ElevatedButton(
        child: Text("Valider",
            style: AppStyles.buttonTextWhite,
            overflow: TextOverflow.ellipsis,
            maxLines: 1),
        onPressed: () {
          _goValidate();
        },
        style: ElevatedButton.styleFrom(
            elevation: 3,
            onPrimary: AppColors.white,
            primary: AppColors.defaultColor,
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
            textStyle: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
      ),
    );
  }

  _goValidate() {
    bloc.currentFilter.rayon = _value;
    bloc.currentFilter.listPlaces.clear();
    bloc.currentFilter.listPlaces.addAll(currentList);
    Modular.to.pop();
  }

  placeSelected(PlacesResponse place) {
    setState(() {
      if (currentList.length < 10) {
        _searchController.text = "";
        currentList.add(place);
      } else {
        Fluttertoast.showToast(msg: "Vous pouvez s??l??ctionner 10 au maximum");
      }
    });
  }
}
