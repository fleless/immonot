import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:immonot/constants/app_colors.dart';
import 'package:immonot/constants/app_images.dart';
import 'package:immonot/constants/routes.dart';
import 'package:immonot/constants/styles/app_styles.dart';
import 'package:immonot/ui/home/widgets/home_annuaire_notaires.dart';
import 'package:immonot/ui/home/widgets/home_header.dart';
import 'package:immonot/ui/home/widgets/home_info_conseils.dart';
import 'package:immonot/widgets/bottom_navbar_widget.dart';

import 'widgets/home_annonces.dart';
import 'home_bloc.dart';

class HomeScreen extends StatefulWidget {
  bool scrollToAnnuaire = false;

  @override
  State<StatefulWidget> createState() => _HomeScreenState();

  HomeScreen(bool scroll) {
    this.scrollToAnnuaire = scroll;
  }
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final bloc = Modular.get<HomeBloc>();
  ScrollController _scrollController = ScrollController();

  @override
  Future<void> initState() {
    super.initState();
    widget.scrollToAnnuaire
        ? _scrollController = ScrollController(initialScrollOffset: 15000.0)
        : null;
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
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: SafeArea(
          child: Container(
            child: SingleChildScrollView(
              controller: _scrollController,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  HomeHeaderWidget(),
                  HomeAnnoncesWidget(),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    child: Container(color: AppColors.dividerColor, height: 1),
                  ),
                  HomeAnnuaireWidget(),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    child: Container(color: AppColors.dividerColor, height: 1),
                  ),
                  HomeInfoConseilWidget(),
                ],
              ),
            ),
          ),
        ),
      ),
      //LoadingIndicator(loading: _bloc.loading),
      //NetworkErrorMessages(error: _bloc.error),
      bottomNavigationBar: const BottomNavbar(route: Routes.home),
    );
  }
}
