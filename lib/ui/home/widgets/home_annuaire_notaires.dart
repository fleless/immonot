import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:immonot/constants/app_colors.dart';
import 'package:immonot/constants/endpoints.dart';
import 'package:immonot/constants/routes.dart';
import 'package:immonot/constants/styles/app_styles.dart';
import 'package:immonot/utils/user_location.dart';

class HomeAnnuaireWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HomeAnnuaireWidgetState();
}

class _HomeAnnuaireWidgetState extends State<HomeAnnuaireWidget> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _villeController = TextEditingController();
  TextEditingController _nomController = TextEditingController();
  final userLocation = Modular.get<UserLocation>();

  @override
  Widget build(BuildContext context) {
    return _buildContent();
  }

  Widget _buildContent() {
    return Padding(
      padding: EdgeInsets.only(right: 0, top: 40, bottom: 40, left: 15),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            "Annuaire des Notaires",
            textAlign: TextAlign.left,
            style: AppStyles.titleStyle,
            overflow: TextOverflow.clip,
            maxLines: 1,
          ),
          SizedBox(height: 5),
          Text(
              "Trouvez votre Notaire parmi près de 9 000 notaires et plus de 4 500 offices notariaux répartis sur l’ensemble du térritoire.",
              overflow: TextOverflow.ellipsis,
              maxLines: 5,
              style: AppStyles.subTitleStyle),
          Padding(padding: EdgeInsets.only(top: 20)),
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
          SizedBox(height: 30),
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
            Modular.to.pushNamed(Routes.annuaireWebView, arguments: {
              "url": Endpoints.ANNUAIRE_WEB_VIEW +
                  "?nom=" +
                  _nomController.text +
                  "&ville=" +
                  _villeController.text,
              "ville": _villeController.text,
              "nom": _nomController.text
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
