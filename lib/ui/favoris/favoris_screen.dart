import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:immonot/constants/app_colors.dart';
import 'package:immonot/constants/app_constants.dart';
import 'package:immonot/constants/app_images.dart';
import 'package:immonot/constants/routes.dart';
import 'package:immonot/constants/styles/app_styles.dart';
import 'package:immonot/ui/favoris/widgets/list_annonce_favoris.dart';
import 'package:immonot/utils/session_controller.dart';
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
  final sessionController = Modular.get<SessionController>();
  final SharedPref sharedPref = SharedPref();
  bool showAnnonceGuide;

  @override
  Future<void> initState() {
    super.initState();
    showAnnonceGuide = false;
    loadSharedPrefsForShowingAnnonceGuide();
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
                    Divider(color: AppColors.hint),
                    SizedBox(height: 15),
                    Expanded(
                      child: _buildContent(),
                    ),
                  ],
                ),
              ),
            ),
            showAnnonceGuide ? _buildShowAnnoceGuide() : SizedBox.shrink(),
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

  /*Widget _buildShowSearchGuide() {
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
              Text("une recherche sauvegard??e",
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
  }*/

  Widget _buildContent() {
    return Container(
        width: double.infinity,
        height: double.infinity,
        child: ListAnnoncesFavorisWidget());
  }
}
