import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:immonot/constants/app_colors.dart';
import 'package:immonot/constants/app_constants.dart';
import 'package:immonot/constants/app_icons.dart';
import 'package:immonot/constants/routes.dart';
import 'package:immonot/constants/styles/app_styles.dart';
import 'package:immonot/ui/profil/auth/auth_bloc.dart';
import 'package:immonot/ui/profil/profil/profil_bloc.dart';
import 'package:immonot/widgets/bottom_navbar_widget.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';

class ProfilScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ProfilScreenState();
}

class _ProfilScreenState extends State<ProfilScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final bloc = Modular.get<ProfilBloc>();
  int selectedPage = 0;

  @override
  Future<void> initState() {
    super.initState();
    selectedPage = 0;
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
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(new FocusNode());
          },
          child: SingleChildScrollView(
            child: Container(
              width: double.infinity,
              child: Padding(
                padding: EdgeInsets.only(top: 50, right: 15, left: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("Mon compte", style: AppStyles.titleStyle),
                    SizedBox(height: 15),
                    _buildContent(),
                    SizedBox(height: 15),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      //LoadingIndicator(loading: _bloc.loading),
      //NetworkErrorMessages(error: _bloc.error),
      bottomNavigationBar: const BottomNavbar(route: Routes.auth),
    );
  }

  Widget _buildContent() {
    return Container(
      width: double.infinity,
      height: 150,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildTitle(),
          SizedBox(height: 15),
          Expanded(
            child: selectedPage == 0 ? SizedBox.shrink() : SizedBox.shrink(),
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
                    child: Text("Mon profil",
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
                    child: Text("Mes paramètres",
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
