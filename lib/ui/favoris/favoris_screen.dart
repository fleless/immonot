import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:immonot/constants/app_colors.dart';
import 'package:immonot/constants/app_constants.dart';
import 'package:immonot/constants/app_images.dart';
import 'package:immonot/constants/routes.dart';
import 'package:immonot/constants/styles/app_styles.dart';
import 'package:immonot/ui/favoris/widgets/list_annonce_favoris.dart';
import 'package:immonot/ui/favoris/widgets/list_search_favoris.dart';
import 'package:immonot/utils/shared_preferences.dart';
import 'package:immonot/widgets/bottom_navbar_widget.dart';
import "dart:ui" as ui;

import 'favoris_bloc.dart';

class FavorisScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _FavorisScreenState();
}

class _FavorisScreenState extends State<FavorisScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final bloc = Modular.get<FavorisBloc>();
  int selectedPage = 0;
  final SharedPref sharedPref = SharedPref();
  bool showAnnonceGuide;
  bool showSearchGuide;

  @override
  Future<void> initState() {
    super.initState();
    showAnnonceGuide = false;
    showSearchGuide = false;
    loadSharedPrefsForShowingAnnonceGuide();
    loadSharedPrefsForShowingSearchGuide();
    selectedPage = 0;
  }

  loadSharedPrefsForShowingAnnonceGuide() async {
    try {
      bool resp = await sharedPref.read(AppConstants.SHOW_ANNONCE_GUIDE);
      print(resp);
      if (resp == null) {
        setState(() {
          showAnnonceGuide = true;
        });
      }
    } catch (Exception) {
      setState(() {
        showAnnonceGuide = true;
      });
    }
  }

  loadSharedPrefsForShowingSearchGuide() async {
    try {
      bool resp = await sharedPref.read(AppConstants.SHOW_SEARCH_GUIDE);
      print(resp);
      if (resp == null) {
        setState(() {
          showSearchGuide = true;
        });
      }
    } catch (Exception) {
      setState(() {
        showSearchGuide = true;
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomInset: true,
      backgroundColor: AppColors.appBackground,
      //drawer: DrawerWidget(),
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              height: double.infinity,
              width: double.infinity,
              child: Padding(
                padding: EdgeInsets.only(top: 50, right: 15, left: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("Mes favoris", style: AppStyles.titleStyle),
                    SizedBox(height: 15),
                    Expanded(
                      child: _buildContent(),
                    ),
                  ],
                ),
              ),
            ),
            showAnnonceGuide ? _buildShowAnnoceGuide() : SizedBox.shrink(),
            ((showSearchGuide) && (selectedPage == 1))
                ? _buildShowSearchGuide()
                : SizedBox.shrink(),
          ],
        ),
      ),
      //LoadingIndicator(loading: _bloc.loading),
      //NetworkErrorMessages(error: _bloc.error),
      bottomNavigationBar: const BottomNavbar(route: Routes.favoris),
    );
  }

  Widget _buildShowAnnoceGuide() {
    return Container(
      color: AppColors.default_black.withOpacity(0.9),
      child: Center(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(AppImages.leftArrow,
                  color: AppColors.white, height: 100),
              Image.asset(AppImages.handIcon,
                  color: AppColors.white, height: 100),
              SizedBox(height: 15),
              Text("Swipez une tuile vers la gauche",
                  style: AppStyles.normalTextWhite),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  children: [
                    TextSpan(text: "pour ", style: AppStyles.normalTextWhite),
                    TextSpan(
                        text: "supprimer", style: AppStyles.buttonTextWhite),
                  ],
                ),
              ),
              Text("une annoce favorite", style: AppStyles.normalTextWhite),
              SizedBox(height: 30),
              GestureDetector(
                onTap: () {
                  setState(() {
                    showAnnonceGuide = false;
                    sharedPref.save(AppConstants.SHOW_ANNONCE_GUIDE, false);
                  });
                },
                child: Text("J'ai compris",
                    style: AppStyles.underlinedButtonWhiteStyle),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildShowSearchGuide() {
    return Container(
      color: AppColors.default_black.withOpacity(0.9),
      child: Center(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(AppImages.leftArrow,
                  color: AppColors.white, height: 100),
              Image.asset(AppImages.handIcon,
                  color: AppColors.white, height: 100),
              SizedBox(height: 15),
              Text("Swipez une tuile vers la gauche",
                  style: AppStyles.normalTextWhite),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  children: [
                    TextSpan(text: "pour ", style: AppStyles.normalTextWhite),
                    TextSpan(
                        text: "modifier ", style: AppStyles.buttonTextWhite),
                    TextSpan(text: "ou ", style: AppStyles.normalTextWhite),
                    TextSpan(
                        text: "supprimer", style: AppStyles.buttonTextWhite),
                  ],
                ),
              ),
              Text("une recherche sauvegardée",
                  style: AppStyles.normalTextWhite),
              SizedBox(height: 30),
              GestureDetector(
                onTap: () {
                  setState(() {
                    showSearchGuide = false;
                    sharedPref.save(AppConstants.SHOW_SEARCH_GUIDE, false);
                  });
                },
                child: Text("J'ai compris",
                    style: AppStyles.underlinedButtonWhiteStyle),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContent() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildTitle(),
          SizedBox(height: 15),
          Expanded(
            child: selectedPage == 0
                ? ListAnnoncesFavorisWidget()
                : ListSearchFavorisWidget(),
          ),
        ],
      ),
    );
  }

  Widget _buildTitle() {
    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 5,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: Colors.white70, width: 1),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Container(
        height: 40,
        width: double.infinity,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            Flexible(
              child: InkWell(
                onTap: () {
                  setState(() {
                    selectedPage = 0;
                  });
                },
                child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  color: selectedPage == 0
                      ? AppColors.defaultColor
                      : AppColors.white,
                  child: Center(
                    child: Text("Annonces",
                        style: selectedPage == 0
                            ? AppStyles.whiteTitleStyle
                            : AppStyles.pinkTitleStyle,
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.clip,
                        maxLines: 1),
                  ),
                ),
              ),
            ),
            Flexible(
              child: InkWell(
                onTap: () {
                  setState(() {
                    selectedPage = 1;
                  });
                },
                child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  color: selectedPage == 1
                      ? AppColors.defaultColor
                      : AppColors.white,
                  child: Center(
                    child: Text("Recherches sauvegardées",
                        style: selectedPage == 1
                            ? AppStyles.whiteTitleStyle
                            : AppStyles.pinkTitleStyle,
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.clip,
                        maxLines: 1),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
