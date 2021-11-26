import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:immonot/constants/app_colors.dart';
import 'package:immonot/constants/endpoints.dart';
import 'package:immonot/constants/styles/app_styles.dart';
import 'package:webview_flutter/webview_flutter.dart';

class InfoConseilWebView extends StatefulWidget {
  String url;
  String tag;

  InfoConseilWebView(this.url, this.tag);

  @override
  State<StatefulWidget> createState() => _InfoConseilWebViewState();
}

class _InfoConseilWebViewState extends State<InfoConseilWebView> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  WebViewController controller;
  final GlobalKey<ScaffoldState> _key = new GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  TextEditingController _rechercheController = TextEditingController();

  @override
  void initState() {
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
    _rechercheController.text = widget.tag;
    super.initState();
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
                    })),
          ],
        ),
      ), //LoadingIndicator(loading: _bloc.loading),
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
              "Infos et conseils",
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
    return Container(
      height: 55,
      width: double.infinity,
      child: Form(
        key: _formKey,
        child: Padding(
          padding: EdgeInsets.only(right: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            // If you want align text to left
            children: [
              Flexible(
                child: Card(
                  shape: RoundedRectangleBorder(
                      side: new BorderSide(color: AppColors.hint, width: 0.2),
                      borderRadius: BorderRadius.circular(4.0)),
                  elevation: 2,
                  shadowColor: AppColors.hint,
                  color: AppColors.appBackground,
                  child: Center(
                    child: TextFormField(
                      controller: _rechercheController,
                      cursorColor: AppColors.defaultColor,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.only(
                            bottom: 0.0, left: 10.0, right: 0.0, top: 0.0),
                        hintText: "Tapez votre recherche..",
                        hintStyle: AppStyles.hintSearch,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 55,
                child: InkWell(
                  splashColor: AppColors.white,
                  onTap: () {
                    FocusScope.of(context).requestFocus(FocusNode());
                    controller.loadUrl(Endpoints.INFO_CONSEIL_WEB_VIEW +
                        _rechercheController.text
                            .trim()
                            .replaceAll(" ", "%20"));
                  },
                  child: Card(
                    shape: RoundedRectangleBorder(
                        side: new BorderSide(color: AppColors.hint, width: 0.2),
                        borderRadius: BorderRadius.circular(4.0)),
                    elevation: 2,
                    shadowColor: AppColors.hint,
                    color: AppColors.defaultColor,
                    child: Center(
                      child: FaIcon(
                        FontAwesomeIcons.search,
                        color: AppColors.white,
                        size: 18,
                      ),
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
}
