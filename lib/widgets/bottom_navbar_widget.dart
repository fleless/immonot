import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:immonot/constants/app_colors.dart';
import 'package:immonot/constants/routes.dart';
import 'package:immonot/constants/styles/app_styles.dart';
import 'package:immonot/widgets/show_calculatrice_modal_widget.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'dart:ui' as ui;

class BottomNavbar extends StatefulWidget {
  final String route;

  const BottomNavbar({this.route});

  @override
  _BottomNavbarState createState() => _BottomNavbarState();
}

class _BottomNavbarState extends State<BottomNavbar> {
  final double iconSize = 22;

  void _navigateTo(String route, [Object args]) {
    if (ModalRoute.of(context).settings.name != route) {
      Modular.to.pushNamed(route, arguments: args);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: Colors.transparent,
      child: Material(
        child: Container(
          height: 70,
          padding: const EdgeInsets.only(bottom: 10),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10), topRight: Radius.circular(10)),
            boxShadow: [
              BoxShadow(
                blurRadius: 15.0,
                offset: Offset(0, 10),
              )
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _buildHomeIcon(widget.route == Routes.home),
                  Text(
                    'Accueil',
                    style: widget.route == Routes.home
                        ? AppStyles.bottomNavTextStyle
                        : AppStyles.bottomNavTextNotSelectedStyle,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _buildBookmarkIcon(widget.route == Routes.favoris),
                  Text(
                    'Favoris',
                    style: widget.route == Routes.favoris
                        ? AppStyles.bottomNavTextStyle
                        : AppStyles.bottomNavTextNotSelectedStyle,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _builCalculatriceIcon(widget.route == Routes.calculatrice),
                  Text(
                    'Calculatrices',
                    style: widget.route == Routes.calculatrice
                        ? AppStyles.bottomNavTextStyle
                        : AppStyles.bottomNavTextNotSelectedStyle,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _buildNotifIcon(widget.route == "not"),
                  Text(
                    'Alertes',
                    style: widget.route == "d"
                        ? AppStyles.bottomNavTextStyle
                        : AppStyles.bottomNavTextNotSelectedStyle,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _buildProfileIcon(widget.route == Routes.auth),
                  Text(
                    'Mon compte',
                    style: widget.route == Routes.auth
                        ? AppStyles.bottomNavTextStyle
                        : AppStyles.bottomNavTextNotSelectedStyle,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHomeIcon(bool selected) => IconButton(
        iconSize: iconSize,
        icon: ConstrainedBox(
          constraints: const BoxConstraints(minWidth: 50.0),
          child: Center(
            child: FaIcon(
              FontAwesomeIcons.home,
              color:
                  selected ? AppColors.defaultColor : AppColors.default_black,
            ),
          ),
        ),
        onPressed: () => _navigateTo(Routes.home, {'scroll': false}),
      );

  Widget _buildBookmarkIcon(bool selected) => IconButton(
        iconSize: iconSize,
        icon: ConstrainedBox(
          constraints: const BoxConstraints(minWidth: 50.0),
          child: Center(
            child: FaIcon(
              FontAwesomeIcons.heart,
              color:
                  selected ? AppColors.defaultColor : AppColors.default_black,
            ), //AppIcons.home(color: selected ? AppColors.green : AppColors.iconDefault),
          ),
        ),
        onPressed: () => _navigateTo(Routes.favoris),
      );

  Widget _builCalculatriceIcon(bool selected) => IconButton(
        iconSize: iconSize,
        icon: ConstrainedBox(
          constraints: const BoxConstraints(minWidth: 50.0),
          child: Center(
            child: FaIcon(
              FontAwesomeIcons.calculator,
              color:
                  selected ? AppColors.defaultColor : AppColors.default_black,
            ), //AppIcons.home(color: selected ? AppColors.green : AppColors.iconDefault),
          ),
        ),
        onPressed: () => _navigateToCalculatrice(),
      );

  _navigateToCalculatrice() {
    showModalBottomSheet(
      context: context,
      enableDrag: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ShowCalculatriceModalWidget(),
    );
  }

  Widget _buildNotifIcon(bool selected) => IconButton(
        iconSize: iconSize,
        icon: ConstrainedBox(
          constraints: const BoxConstraints(minWidth: 50.0),
          child: Center(
            child: FaIcon(
              FontAwesomeIcons.bell,
              color:
                  selected ? AppColors.defaultColor : AppColors.default_black,
            ), //AppIcons.home(color: selected ? AppColors.green : AppColors.iconDefault),
          ),
        ),
        onPressed: () => _navigateTo(Routes.home, {'scroll': false}),
      );

  Widget _buildProfileIcon(bool selected) => IconButton(
        iconSize: iconSize,
        icon: ConstrainedBox(
          constraints: const BoxConstraints(minWidth: 50.0),
          child: Center(
            child: FaIcon(
              FontAwesomeIcons.user,
              color:
                  selected ? AppColors.defaultColor : AppColors.default_black,
            ), //AppIcons.home(color: selected ? AppColors.green : AppColors.iconDefault),
          ),
        ),
        onPressed: () => _navigateTo(Routes.auth),
      );
}
