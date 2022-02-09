import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:immonot/constants/app_colors.dart';
import 'package:immonot/constants/endpoints.dart';
import 'package:immonot/constants/styles/app_styles.dart';
import 'package:immonot/models/responses/places_response.dart';
import 'package:immonot/ui/home/home_bloc.dart';
import 'package:immonot/utils/user_location.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

class AnnuaireWebView extends StatefulWidget {
  String url;
  PlacesResponse ville;
  String nom;

  AnnuaireWebView(this.url, this.ville, this.nom);

  @override
  State<StatefulWidget> createState() => _AnnuaireWebViewState();
}

class _AnnuaireWebViewState extends State<AnnuaireWebView>
    with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final GlobalKey<ScaffoldState> _key = new GlobalKey<ScaffoldState>();
  TextEditingController _nomController = TextEditingController();
  final userLocation = Modular.get<UserLocation>();
  final bloc = Modular.get<HomeBloc>();
  final _formKey = GlobalKey<FormState>();
  PlacesResponse locationSelected;
  WebViewController controller;
  final _searchController = TextEditingController();

  AnimationController expandController;
  Animation<double> animation;
  bool expand = true;

  @override
  void initState() {
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
    _nomController.text = widget.nom;
    if (widget.ville == null) {
      locationSelected = null;
    } else if (widget.ville.code == null) {
      _searchController.text = widget.ville.nom;
      locationSelected = null;
    } else {
      locationSelected = widget.ville;
      _searchController.text = locationSelected.nom;
    }
    super.initState();
    prepareAnimations();
    _runExpandCheck();
    Future.delayed(Duration(seconds: 1), () {
      setState(() {
        expand = false;
      });
      _runExpandCheck();
    });
  }

  ///Setting up the animation
  void prepareAnimations() {
    expandController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    animation = CurvedAnimation(
      parent: expandController,
      curve: Curves.fastOutSlowIn,
    );
  }

  void _runExpandCheck() {
    if (expand) {
      expandController.forward();
    } else {
      expandController.reverse();
    }
  }

  @override
  void dispose() {
    expandController.dispose();
    super.dispose();
  }

  Future<List<PlacesResponse>> _searchDetails(String item) async {
    List<PlacesResponse> resp = await bloc.searchPlaces(item);
    return resp == null ? PlacesResponse() : resp;
  }

  @override
  Widget build(BuildContext context) {
    return _buildContent();
  }

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Widget _buildContent() {
    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomInset: true,
      backgroundColor: AppColors.appBackground,
      body: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(new FocusNode()),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              Container(
                color: Colors.transparent,
                height: 30,
                child: Center(
                  child: Stack(
                    children: [
                      Center(
                        child: Container(
                          alignment: Alignment.center,
                          height: 2,
                          width: double.infinity,
                          color: AppColors.defaultColor,
                        ),
                      ),
                      Center(
                        child: SizedBox(
                          height: 26,
                          child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                expand = !expand;
                                _runExpandCheck();
                              });
                            },
                            child: FaIcon(
                              expand
                                  ? FontAwesomeIcons.angleDoubleUp
                                  : FontAwesomeIcons.angleDoubleDown,
                              size: 13,
                              color: AppColors.white,
                            ),
                            style: ElevatedButton.styleFrom(
                              shape: CircleBorder(),
                              primary: AppColors.defaultColor,
                              onPrimary: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: WebView(
                  key: _key,
                  javascriptMode: JavascriptMode.unrestricted,
                  initialUrl: widget.url,
                  gestureNavigationEnabled: true,
                  onWebViewCreated: (WebViewController webViewController) {
                    controller = webViewController;
                  },
                  navigationDelegate: (NavigationRequest request) {
                    if (request.url.startsWith(Endpoints.ANNUAIRE_WEB_VIEW) ||
                        (request.url.contains("core-immonot"))) {
                      return NavigationDecision.navigate;
                    } else {
                      _launchURL(request.url);
                      return NavigationDecision.prevent;
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      //LoadingIndicator(loading: _bloc.loading),
      //NetworkErrorMessages(error: _bloc.error),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: EdgeInsets.only(right: 0, top: 20, bottom: 5, left: 15),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ListTile(
            minLeadingWidth: 10,
            contentPadding: EdgeInsets.all(0),
            leading: GestureDetector(
              onTap: () => Modular.to.pop(),
              child: Icon(
                Icons.chevron_left,
                color: AppColors.defaultColor,
              ),
            ),
            title: Text(
              "Annuaire des Notaires",
              textAlign: TextAlign.left,
              style: AppStyles.titleStyle,
              overflow: TextOverflow.clip,
              maxLines: 1,
            ),
          ),
          SizedBox(height: 10),
          SizeTransition(
            axisAlignment: 1.0,
            sizeFactor: animation,
            child: Padding(
                padding: EdgeInsets.only(right: 15), child: _buildForm()),
          ),
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
          SizedBox(height: 10),
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
                _address = await userLocation.getUserAddress();
                List<PlacesResponse> placess = await _searchDetails(_address);
                _searchController.text =
                    placess.isEmpty ? _address : placess.first.nom;
                locationSelected = placess.isEmpty ? null : placess.first;
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
                depCom = ("departements=*" +
                    _searchController.text.trim().replaceAll(" ", "%20"));
              } else {
                depCom = locationSelected.code.length == 2
                    ? "departements=" + locationSelected.code
                    : ("codeInsees=" + locationSelected.code);
              }
            }
            print("url is " +
                Endpoints.ANNUAIRE_WEB_VIEW +
                "?" +
                nom +
                (nom != null ? "&" : "") +
                depCom);
            setState(() {
              controller.loadUrl(Endpoints.ANNUAIRE_WEB_VIEW +
                  "?" +
                  nom +
                  (nom != null ? "&" : "") +
                  depCom);
              expand = false;
              _runExpandCheck();
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
