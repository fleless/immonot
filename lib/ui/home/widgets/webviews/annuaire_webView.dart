import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:immonot/constants/app_colors.dart';
import 'package:immonot/constants/endpoints.dart';
import 'package:immonot/constants/styles/app_styles.dart';
import 'package:immonot/ui/home/widgets/home_annuaire_notaires.dart';
import 'package:immonot/utils/user_location.dart';
import 'package:webview_flutter/webview_flutter.dart';

class AnnuaireWebView extends StatefulWidget {
  String url;
  String ville;
  String nom;

  AnnuaireWebView(this.url, this.ville, this.nom);

  @override
  State<StatefulWidget> createState() => _AnnuaireWebViewState();
}

class _AnnuaireWebViewState extends State<AnnuaireWebView> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final GlobalKey<ScaffoldState> _key = new GlobalKey<ScaffoldState>();
  TextEditingController _villeController = TextEditingController();
  TextEditingController _nomController = TextEditingController();
  final userLocation = Modular.get<UserLocation>();
  final _formKey = GlobalKey<FormState>();
  WebViewController controller;

  @override
  void initState() {
    print(widget.url);
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
    super.initState();
    _nomController.text = widget.nom;
    _villeController.text = widget.ville;
  }

  @override
  Widget build(BuildContext context) {
    return _buildContent();
  }

  Widget _buildContent() {
    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomInset: true,
      backgroundColor: AppColors.appBackground,
      body: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            _buildHeader(),
            Expanded(
              child: WebView(
                  key: _key,
                  javascriptMode: JavascriptMode.unrestricted,
                  initialUrl: widget.url,
                  gestureNavigationEnabled: true,
                  onWebViewCreated: (WebViewController webViewController) {
                    controller = webViewController;
                  }),
            ),
          ],
        ),
      ),
      //LoadingIndicator(loading: _bloc.loading),
      //NetworkErrorMessages(error: _bloc.error),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: EdgeInsets.only(right: 0, top: 40, bottom: 20, left: 15),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ListTile(
            leading: GestureDetector(
              onTap: () => Modular.to.pop(),
              child: Icon(
                Icons.arrow_back,
                color: AppColors.default_black,
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
          Padding(padding: EdgeInsets.only(right: 15), child: _buildForm()),
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
              EdgeInsets.only(bottom: 15.0, left: 10.0, right: 10.0, top: 15.0),
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
      elevation: 2,
      shadowColor: AppColors.hint,
      color: AppColors.appBackground,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            child: TextFormField(
              controller: _villeController,
              cursorColor: AppColors.defaultColor,
              decoration: const InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(
                    bottom: 15.0, left: 10.0, right: 10.0, top: 15.0),
                hintText: "Ville, département, code postal",
                hintStyle: AppStyles.hintSearch,
              ),
            ),
          ),
          InkWell(
            onTap: () async {
              _villeController.text = await userLocation.getUserAddress();
            },
            child: Container(
              decoration: new BoxDecoration(
                color: Colors.transparent,
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
            setState(() {
              controller.loadUrl(Endpoints.ANNUAIRE_WEB_VIEW +
                  "?nom=" +
                  _nomController.text +
                  "&ville=" +
                  _villeController.text);
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
