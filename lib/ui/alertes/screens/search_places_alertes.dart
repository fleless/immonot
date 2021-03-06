import 'package:awesome_loader/awesome_loader.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_tags/flutter_tags.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:immonot/constants/app_colors.dart';
import 'package:immonot/constants/styles/app_styles.dart';
import 'package:immonot/models/responses/places_response.dart';
import 'package:immonot/ui/home/home_bloc.dart';
import 'package:immonot/utils/user_location.dart';

class SearchPlacesAlertesScreen extends StatefulWidget {
  List<PlacesResponse> places;
  String address;

  SearchPlacesAlertesScreen(this.places, this.address);

  @override
  State<StatefulWidget> createState() => _SearchPlacesAlertesScreenState();
}

class _SearchPlacesAlertesScreenState extends State<SearchPlacesAlertesScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final GlobalKey<TagsState> _tagStateKey = GlobalKey<TagsState>();
  final _searchController = TextEditingController();
  final userLocation = Modular.get<UserLocation>();
  final homeBloc = Modular.get<HomeBloc>();
  List<PlacesResponse> villesList = <PlacesResponse>[];
  List<PlacesResponse> departementsList = <PlacesResponse>[];
  bool isSearching = false;
  final _rayonController = TextEditingController();
  final List<PlacesResponse> currentList = <PlacesResponse>[];

  @override
  Future<void> initState() {
    super.initState();
    currentList.addAll(widget.places);
    _changeSearchToCurrentPosition(widget.address);
  }

  @override
  void dispose() {
    super.dispose();
  }

  _changeSearchToCurrentPosition(String address) {
    _searchController.text = address;
    _searchDetails(address);
  }

  _searchDetails(String item) async {
    setState(() {
      isSearching = true;
      _clearLists();
    });
    List<PlacesResponse> resp = await homeBloc.searchPlaces(item);
    setState(() {
      currentList.forEach((element) {
        resp.removeWhere((element2) =>
            (element.type == element2.type) &&
            (element.code == element2.code) &&
            (element.nom == element2.nom));
      });
      villesList = resp.where((e) => e.type.startsWith("C")).toList();
      departementsList = resp.where((e) => e.type.startsWith("D")).toList();
      isSearching = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.appBackground,
      //drawer: DrawerWidget(),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 30),
          child: Container(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildTitle(),
                SizedBox(height: 15),
                _buildSearch(),
                SizedBox(height: 5),
                _buildTags(),
                SizedBox(height: 15),
                currentList.length > 0
                    ? Container(color: AppColors.dividerColor, height: 1)
                    : SizedBox.shrink(),
                SizedBox(height: 15),
                Expanded(
                    child: isSearching
                        ? _buildLoader()
                        : villesList.length + departementsList.length == 0
                            ? SizedBox.shrink()
                            : _buildLists()),
                SizedBox(height: 15),
                _buildBValidationutton(),
                SizedBox(height: 15),
              ],
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
    return Padding(
      padding: EdgeInsets.only(right: 0),
      child: Card(
        elevation: 4,
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            // If you want align text to left
            mainAxisSize: MainAxisSize.max,
            children: [
              Flexible(
                child: GestureDetector(
                  onTap: () => {},
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
                        onChanged: (item) {
                          _searchDetails(item);
                        },
                        autofocus: true,
                        enabled: true,
                        style: AppStyles.textNormal,
                        textAlign: TextAlign.left,
                        textAlignVertical: TextAlignVertical.center,
                        cursorColor: AppColors.defaultColor,
                        decoration: InputDecoration(
                          hintText: "Ville, d??partements, code postal",
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
              borderRadius: BorderRadius.circular(7),
              color: AppColors.white,
              activeColor: AppColors.white,
              textActiveColor: AppColors.default_black,
              textColor: AppColors.default_black,
              splashColor: AppColors.defaultColor,
              highlightColor: AppColors.defaultColor,
              textStyle: AppStyles.subTitleStyle,
              active: true,
              title: (item.codePostal == null ? item.code : item.codePostal) +
                  " " +
                  (item.nom == null ? "" : item.nom),
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

  Widget _buildLoader() {
    return Container(
      height: 133,
      child: Center(
        child: AwesomeLoader(
          loaderType: AwesomeLoader.AwesomeLoader3,
          color: AppColors.defaultColor,
        ),
      ),
    );
  }

  Widget _buildLists() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        departementsList.length == 0
            ? SizedBox.shrink()
            : Flexible(child: _buildDepartementsList()),
        departementsList.length == 0 ? SizedBox.shrink() : SizedBox(height: 20),
        villesList.length == 0
            ? SizedBox.shrink()
            : Flexible(child: _buildVillesList())
      ],
    );
  }

  Widget _buildVillesList() {
    return Container(
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Villes", style: AppStyles.titleStyleH2),
          SizedBox(height: 15),
          Flexible(
            child: ListView.separated(
                separatorBuilder: (context, index) => Divider(
                      color: AppColors.dividerColor,
                      height: 30,
                    ),
                itemCount: villesList.length,
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () => placeSelected(villesList[index]),
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RichText(
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            text: TextSpan(
                              children: <TextSpan>[
                                TextSpan(
                                    text: villesList[index].codePostal,
                                    style: AppStyles.smallTitleStyleBlack),
                                TextSpan(
                                    text: "  " + villesList[index].nom,
                                    style: AppStyles.subTitleStyle),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
          ),
        ],
      ),
    );
  }

  Widget _buildDepartementsList() {
    return Container(
      width: double.infinity,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("D??partements", style: AppStyles.titleStyleH2),
          SizedBox(height: 15),
          Flexible(
            child: ListView.separated(
                separatorBuilder: (context, index) => Divider(
                      color: AppColors.dividerColor,
                      height: 30,
                    ),
                itemCount: departementsList.length,
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () => placeSelected(departementsList[index]),
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RichText(
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            text: TextSpan(
                              children: <TextSpan>[
                                TextSpan(
                                    text: departementsList[index].code,
                                    style: AppStyles.smallTitleStyleBlack),
                                TextSpan(
                                    text: "  " + departementsList[index].nom,
                                    style: AppStyles.subTitleStyle),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
          ),
        ],
      ),
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
    Navigator.pop(context, currentList);
  }

  placeSelected(PlacesResponse place) {
    setState(() {
      if (currentList.length < 10) {
        _searchController.text = "";
        _clearLists();
        currentList.add(place);
      } else {
        Fluttertoast.showToast(msg: "Vous pouvez s??l??ctionner 10 au maximum");
      }
    });
  }

  _clearLists() {
    departementsList.clear();
    villesList.clear();
  }
}
