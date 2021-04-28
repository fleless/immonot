import 'package:awesome_loader/awesome_loader.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_tags/flutter_tags.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:immonot/constants/app_colors.dart';
import 'package:immonot/constants/app_constants.dart';
import 'package:immonot/constants/routes.dart';
import 'package:immonot/constants/styles/app_styles.dart';
import 'package:immonot/models/responses/places_response.dart';
import 'package:immonot/ui/home/home_bloc.dart';
import 'package:immonot/ui/home/search_results/filter_bloc.dart';
import 'package:immonot/utils/user_location.dart';

class SearchFilterScreen extends StatefulWidget {
  String address;

  SearchFilterScreen(String address) {
    this.address = address;
  }

  @override
  State<StatefulWidget> createState() => _SearchFilterScreenState();
}

class _SearchFilterScreenState extends State<SearchFilterScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final GlobalKey<TagsState> _tagStateKey = GlobalKey<TagsState>();
  final bloc = Modular.get<FilterBloc>();
  final _searchController = TextEditingController();
  final userLocation = Modular.get<UserLocation>();
  List<PlacesResponse> villesList = <PlacesResponse>[];
  List<PlacesResponse> departementsList = <PlacesResponse>[];
  bool isSearching = false;

  @override
  Future<void> initState() {
    super.initState();
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
    List<PlacesResponse> resp = await bloc.searchPlaces(item);
    setState(() {
      bloc.filterTagsList.forEach((element) {
        resp.removeWhere((element2) =>
        (element.id == element2.id) &&
            (element.type == element2.type) &&
            (element.code == element2.code) &&
            (element.label == element2.label));
      });
      print(resp.length.toString());
      villesList = resp.where((e) => e.type.startsWith("c")).toList();
      departementsList = resp.where((e) => e.type.startsWith("d")).toList();
      isSearching = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomInset: true,
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
                bloc.filterTagsList.length > 0
                    ? Container(color: AppColors.dividerColor, height: 1)
                    : SizedBox.shrink(),
                SizedBox(height: 15),
                Expanded(
                    child: isSearching
                        ? _buildLoader()
                        : villesList.length + departementsList.length == 0
                        ? SizedBox.shrink()
                        : _buildLists()),
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
          "Rechercher une localité",
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
          itemCount: bloc.filterTagsList.length,
          itemBuilder: (int index) {
            final item = bloc.filterTagsList[index];
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
                    bloc.filterTagsList.removeAt(index);
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
                                    text: villesList[index].code,
                                    style: AppStyles.smallTitleStyleBlack),
                                TextSpan(
                                    text: "  " + villesList[index].label,
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
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Départements", style: AppStyles.titleStyleH2),
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
                                    text: "  " + departementsList[index].label,
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

  placeSelected(PlacesResponse place) {
    setState(() {
      if (bloc.filterTagsList.length < 10) {
        _searchController.text = "";
        _clearLists();
        bloc.filterTagsList.add(place);
      } else {
        Fluttertoast.showToast(msg: "Vous pouvez séléctionner 10 au maximum");
      }
    });
  }

  _clearLists() {
    departementsList.clear();
    villesList.clear();
  }
}
