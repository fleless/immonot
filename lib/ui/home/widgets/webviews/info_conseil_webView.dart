import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:immonot/constants/app_colors.dart';
import 'package:immonot/constants/endpoints.dart';
import 'package:immonot/constants/routes.dart';
import 'package:immonot/constants/styles/app_styles.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../home_bloc.dart';

class InfoConseilWebView extends StatefulWidget {
  String url;
  String tag;

  InfoConseilWebView(this.url, this.tag);

  @override
  State<StatefulWidget> createState() => _InfoConseilWebViewState();
}

class _InfoConseilWebViewState extends State<InfoConseilWebView>
    with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  WebViewController controller;
  final bloc = Modular.get<HomeBloc>();
  final GlobalKey<ScaffoldState> _key = new GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  TextEditingController _rechercheController = TextEditingController();
  AnimationController expandController;
  Animation<double> animation;
  bool expand = true;

  @override
  void initState() {
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
    _rechercheController.text = widget.tag;
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
  Widget build(BuildContext context) {
    return _buildContent();
  }

  @override
  void dispose() {
    expandController.dispose();
    super.dispose();
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
      body: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            _buildHeader(),
            _buildSeperator(),
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
      ), //LoadingIndicator(loading: _bloc.loading),
      //NetworkErrorMessages(error: _bloc.error),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: EdgeInsets.only(right: 0, top: 20, bottom: 0, left: 15),
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
              "Infos et conseils",
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
            child: _buildExpandableWidget(),
          ),
        ],
      ),
    );
  }

  Widget _buildExpandableWidget() {
    return Column(
      children: [
        Padding(padding: EdgeInsets.only(right: 15), child: _buildForm()),
        _buildHashTags(),
      ],
    );
  }

  Widget _buildSeperator() {
    return Container(
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
                        "titres=*" +
                        _rechercheController.text
                            .trim()
                            .replaceAll(" ", "%20") +
                        "*");
                    setState(() {
                      expand = false;
                      _runExpandCheck();
                    });
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

  Widget _buildHashTags() {
    return Container(
      height: 50,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: bloc.themesList.length,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () => {
                FocusScope.of(context).requestFocus(FocusNode()),
                controller.loadUrl((Endpoints.INFO_CONSEIL_WEB_VIEW +
                        "themes=" +
                        bloc.themesList[index].id.toString())
                    .replaceAll(" ", "%20")),
                _rechercheController.text = "",
                setState(() {
                  expand = false;
                  _runExpandCheck();
                }),
              },
              child: Center(
                child: Container(
                  height: 33,
                  margin: const EdgeInsets.symmetric(horizontal: 5.0),
                  padding: const EdgeInsets.all(8.0),
                  decoration: new BoxDecoration(
                    color: AppColors.defaultColor,
                    borderRadius: BorderRadius.circular(5.0),
                    border: Border.all(color: AppColors.defaultColor),
                  ),
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      "#" + bloc.themesList[index].libelle.toLowerCase(),
                      style: AppStyles.selectionedItemText,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            );
          }),
    );
  }
}
