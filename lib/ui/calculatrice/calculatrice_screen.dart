import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:immonot/constants/app_colors.dart';
import 'package:immonot/constants/routes.dart';
import 'package:immonot/ui/calculatrice/calculatrice_bloc.dart';
import 'package:immonot/ui/calculatrice/widgets/capacite_emprunt_screen.dart';
import 'package:immonot/ui/calculatrice/widgets/frais_notaires_screen.dart';
import 'package:immonot/ui/calculatrice/widgets/mensualit%C3%A9_screen.dart';
import 'package:immonot/widgets/bottom_navbar_widget.dart';

class CalculatriceScreen extends StatefulWidget {
  int index;

  CalculatriceScreen(int index) {
    this.index = index;
  }

  @override
  State<StatefulWidget> createState() => _CalculatriceScreenState();
}

class _CalculatriceScreenState extends State<CalculatriceScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final bloc = Modular.get<CalculatriceBloc>();
  PageController _pageController = PageController();

  @override
  Future<void> initState() {
    super.initState();
    _pageController = PageController(initialPage: widget.index);
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
            child: Container(
              height: double.infinity,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(height: 50),
                  _buildHeader(),
                  SizedBox(height: 15),
                  Expanded(
                    child: Container(
                        height: double.infinity,
                        child: PageView(
                          controller: _pageController,
                          onPageChanged: (val) {
                            setState(() {
                              widget.index = val;
                            });
                          },
                          children: [
                            MensualiteScreenWidget(),
                            CapaciteEmpruntScreenWidget(),
                            FraisNotairesScreenWidget(),
                          ],
                        ),
                      ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      //LoadingIndicator(loading: _bloc.loading),
      //NetworkErrorMessages(error: _bloc.error),
      bottomNavigationBar: const BottomNavbar(route: Routes.calculatrice),
    );
  }

  Widget _buildHeader() {
    return Center(
      child: Card(
        clipBehavior: Clip.antiAlias,
        elevation: 5,
        shape: RoundedRectangleBorder(
          side: BorderSide(color: Colors.white70, width: 1),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Container(
          color: AppColors.white,
          width: MediaQuery.of(context).size.width * 0.4,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: InkWell(
                  onTap: () {
                    setState(() {
                      _pageController.animateToPage(0,
                          curve: Curves.easeIn, duration: Duration(milliseconds: 250)).then((value) => widget.index = 0);
                    });
                  },
                  child: Container(
                    color: widget.index == 0
                        ? AppColors.defaultColor
                        : AppColors.white,
                    alignment: Alignment.center,
                    padding: EdgeInsets.all(10),
                    child: Center(
                      child: FaIcon(FontAwesomeIcons.calculator,
                          color: widget.index == 0
                              ? AppColors.white
                              : AppColors.defaultColor,
                          size: 20),
                    ),
                  ),
                ),
              ),
              Container(width: 1, color: AppColors.hint),
              Expanded(
                child: InkWell(
                  onTap: () {
                    setState(() {
                      _pageController.animateToPage(1,
                          curve: Curves.easeIn, duration: Duration(milliseconds: 125)).then((value) => widget.index = 1);
                    });
                  },
                  child: Container(
                    color: widget.index == 1
                        ? AppColors.defaultColor
                        : AppColors.white,
                    alignment: Alignment.center,
                    padding: EdgeInsets.all(10),
                    child: FaIcon(FontAwesomeIcons.euroSign,
                        color: widget.index == 1
                            ? AppColors.white
                            : AppColors.defaultColor,
                        size: 20),
                  ),
                ),
              ),
              Container(width: 1, color: AppColors.hint),
              Expanded(
                child: InkWell(
                  onTap: () {
                    setState(() {
                      _pageController
                          .animateToPage(2,
                              curve: Curves.easeIn,
                              duration: Duration(milliseconds: 250))
                          .then((value) => widget.index = 2);
                    });
                  },
                  child: Container(
                    color: widget.index == 2
                        ? AppColors.defaultColor
                        : AppColors.white,
                    alignment: Alignment.center,
                    padding: EdgeInsets.all(10),
                    child: FaIcon(FontAwesomeIcons.ticketAlt,
                        color: widget.index == 2
                            ? AppColors.white
                            : AppColors.defaultColor,
                        size: 20),
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
