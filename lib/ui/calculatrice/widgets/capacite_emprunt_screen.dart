import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:immonot/constants/app_colors.dart';
import 'package:immonot/constants/styles/app_styles.dart';
import 'package:immonot/utils/formatter_utils.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import '../calculatrice_bloc.dart';
import 'echeancierCapaciteEmpruntDialog.dart';

class CapaciteEmpruntScreenWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _CapaciteEmpruntScreenWidgetState();
}

class _CapaciteEmpruntScreenWidgetState
    extends State<CapaciteEmpruntScreenWidget> {
  final bloc = Modular.get<CalculatriceBloc>();
  final _formatterController = Modular.get<FormatterController>();
  TextEditingController _mensualiteController = TextEditingController();
  bool _mensualiteError = false;
  TextEditingController _tauxController = TextEditingController();
  bool _tauxError = false;
  bool _visibleResults = false;
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: _buildContent(),
    );
  }

  Widget _buildContent() {
    return Container(
      width: double.infinity,
      child: Padding(
        padding: EdgeInsets.only(right: 15, top: 0, bottom: 40, left: 15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              alignment: Alignment.center,
              child: Text("Capacité d'emprunt",
                  style: AppStyles.textNormalTitleStyle,
                  textAlign: TextAlign.center),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
              child: Divider(
                color: AppColors.hint,
              ),
            ),
            Text(
              "Calculer vos capacités d'emprunt",
              maxLines: 1,
              overflow: TextOverflow.clip,
              style: AppStyles.titleStyleH2,
            ),
            SizedBox(height: 5),
            Text(
              "Avant de prendre un crédit, mieux vaut vérifier si vos finances le permettent en calculant le montant d'emprunt possible en fonction des mensualités adaptées à votre capacité. (Tous les champs sont obligatoires)",
              style: AppStyles.textDescriptionStyle,
              maxLines: 20,
            ),
            SizedBox(height: 40),
            Container(
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: AppColors.infoBlocColor,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.only(
                        top: 15, bottom: 15, left: 0, right: 15),
                    child: FaIcon(FontAwesomeIcons.infoCircle,
                        color: AppColors.default_black, size: 22),
                  ),
                  Expanded(
                    child: Text(
                      "Il vous suffit d'entrer un taux d'intérêt (exemple 3.5) sans le % et d'indiquer la mensualité que vous souhaiteriez payer. Vous obtiendrez alors le montant en capital auquel vous pouvez prétendre sur les différentes durées...",
                      style: AppStyles.textDescriptionStyle,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 40),
            _buildForms(),
            SizedBox(height: 40),
            _loading
                ? Center(
                    child: CircularProgressIndicator(
                      color: AppColors.defaultColor,
                    ),
                  )
                : SizedBox.shrink(),
            _visibleResults ? _showResults() : SizedBox.shrink(),
          ],
        ),
      ),
    );
  }

  Widget _buildForms() {
    return Container(
      width: double.infinity,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Container(
                height: 50,
                width: 10,
                padding: EdgeInsets.only(bottom: 6),
                alignment: Alignment.bottomLeft,
                child: FaIcon(FontAwesomeIcons.percent,
                    color: AppColors.defaultColor, size: 20),
              ),
              SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("Taux d'intérêt",
                        style: AppStyles.locationAnnonces,
                        textAlign: TextAlign.left),
                    Flexible(
                      child: Container(
                        height: 50,
                        width: double.infinity,
                        child: Card(
                          shape: RoundedRectangleBorder(
                              side: new BorderSide(
                                  color: AppColors.hint, width: 0.2),
                              borderRadius: BorderRadius.circular(4.0)),
                          elevation: 2,
                          shadowColor: AppColors.hint,
                          color: AppColors.appBackground,
                          child: Center(
                            child: TextFormField(
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.allow(
                                    RegExp(r'(^\d+\.?\d?\d?)')),
                              ],
                              keyboardType: TextInputType.number,
                              onChanged: (value) {
                                setState(() {
                                  _visibleResults = false;
                                  _tauxError = false;
                                });
                              },
                              controller: _tauxController,
                              cursorColor: AppColors.defaultColor,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.only(
                                    bottom: 7.0,
                                    left: 10.0,
                                    right: 0.0,
                                    top: 0.0),
                                hintText: "Saisissez un taux (%)",
                                hintStyle: AppStyles.hintSearch,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    _tauxError
                        ? Text(
                            "Veuillez saisir un taux d'intérêt entre 0,1 et 100 %",
                            style: AppStyles.errorText)
                        : SizedBox.shrink(),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 15),
          Row(
            children: [
              Container(
                height: 50,
                width: 10,
                padding: EdgeInsets.only(bottom: 6),
                alignment: Alignment.bottomLeft,
                child: FaIcon(FontAwesomeIcons.euroSign,
                    color: AppColors.defaultColor, size: 20),
              ),
              SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("Mensualité souhaitée",
                        style: AppStyles.locationAnnonces,
                        textAlign: TextAlign.left),
                    Flexible(
                      child: Container(
                        height: 50,
                        width: double.infinity,
                        child: Card(
                          shape: RoundedRectangleBorder(
                              side: new BorderSide(
                                  color: AppColors.hint, width: 0.2),
                              borderRadius: BorderRadius.circular(4.0)),
                          elevation: 2,
                          shadowColor: AppColors.hint,
                          color: AppColors.appBackground,
                          child: Center(
                            child: TextFormField(
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.allow(
                                    RegExp(r'(^\d+)')),
                              ],
                              onChanged: (value) {
                                setState(() {
                                  _visibleResults = false;
                                  _mensualiteError = false;
                                });
                              },
                              keyboardType: TextInputType.number,
                              controller: _mensualiteController,
                              cursorColor: AppColors.defaultColor,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.only(
                                    bottom: 7.0,
                                    left: 10.0,
                                    right: 0.0,
                                    top: 0.0),
                                hintText: "Mensualité souhaitée (€)",
                                hintStyle: AppStyles.hintSearch,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    _mensualiteError
                        ? Text("Veuillez saisir la mensualité souhaitée",
                            style: AppStyles.errorText)
                        : SizedBox.shrink(),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 25),
          _buildButton(),
        ],
      ),
    );
  }

  Widget _buildButton() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.35,
      decoration: new BoxDecoration(
        color: AppColors.defaultColor,
        borderRadius: BorderRadius.all(Radius.circular(5)),
      ),
      child: ElevatedButton(
        child: Text("CALCULER",
            style: AppStyles.buttonTextWhite,
            overflow: TextOverflow.ellipsis,
            maxLines: 1),
        onPressed: () {
          _goCalcul();
        },
        style: ElevatedButton.styleFrom(
            elevation: 3,
            onPrimary: AppColors.white,
            primary: AppColors.defaultColor,
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
            textStyle: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _showResults() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Résultats de vos données:",
            style: AppStyles.titleStyleH2,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
          SizedBox(height: 20),
          RichText(
            textAlign: TextAlign.left,
            maxLines: 10,
            overflow: TextOverflow.clip,
            text: TextSpan(
              children: [
                TextSpan(
                    text: "Capital sur 10 ans : ",
                    style: AppStyles.mediumTitleStyle),
                TextSpan(
                    text: _formatterController.formatNumberWithSpaces(bloc
                            .capaciteEmpruntResponse.montantsPret
                            .where((element) => element.dureeEnAnnee == 10)
                            .first
                            .montant
                            .toStringAsFixed(2)) +
                        " €",
                    style: AppStyles.textNormal),
              ],
            ),
          ),
          SizedBox(height: 10),
          RichText(
            textAlign: TextAlign.left,
            maxLines: 10,
            overflow: TextOverflow.clip,
            text: TextSpan(
              children: [
                TextSpan(
                    text: "Capital sur 15 ans : ",
                    style: AppStyles.mediumTitleStyle),
                TextSpan(
                    text: _formatterController.formatNumberWithSpaces(bloc
                            .capaciteEmpruntResponse.montantsPret
                            .where((element) => element.dureeEnAnnee == 15)
                            .first
                            .montant
                            .toStringAsFixed(2)) +
                        " €",
                    style: AppStyles.textNormal),
              ],
            ),
          ),
          SizedBox(height: 10),
          RichText(
            textAlign: TextAlign.left,
            maxLines: 10,
            overflow: TextOverflow.clip,
            text: TextSpan(
              children: [
                TextSpan(
                    text: "Capital sur 25 ans : ",
                    style: AppStyles.mediumTitleStyle),
                TextSpan(
                    text: _formatterController.formatNumberWithSpaces(bloc
                            .capaciteEmpruntResponse.montantsPret
                            .where((element) => element.dureeEnAnnee == 25)
                            .first
                            .montant
                            .toStringAsFixed(2)) +
                        " €",
                    style: AppStyles.textNormal),
              ],
            ),
          ),
          SizedBox(height: 20),
          Container(
            width: double.infinity,
            child: Center(
              child: TextButton(
                  style: ButtonStyle(
                    overlayColor: MaterialStateColor.resolveWith(
                      (states) => AppColors.defaultColor.withOpacity(0.2),
                    ),
                  ),
                  onPressed: () {
                    _showEcheancierDialog();
                  },
                  child: Text(
                    "Voir toutes les annualités",
                    style: AppStyles.underlinedBaremeHonoraireStyle,
                  )),
            ),
          ),
        ],
      ),
    );
  }

  _goCalcul() async {
    FocusScope.of(context).requestFocus(new FocusNode());
    setState(() {
      _visibleResults = false;
      _tauxError = false;
      _mensualiteError = false;
    });
    int mens = int.tryParse(_mensualiteController.text) ?? 0;
    double taux = double.tryParse(_tauxController.text) ?? 0.0;
    if ((taux < 0.1) || (taux > 100) || (_tauxController.text.endsWith("."))) {
      setState(() {
        _tauxError = true;
      });
    }
    if ((mens == 0) || (mens < 0)) {
      setState(() {
        _mensualiteError = true;
      });
    }
    if ((!_mensualiteError) && (!_tauxError)) {
      setState(() {
        _loading = true;
      });
      await bloc.calculCapaciteEmprunt(taux, mens);
      setState(() {
        _loading = false;
        _visibleResults = true;
      });
    }
  }

  _showEcheancierDialog() {
    showCupertinoModalBottomSheet(
      context: context,
      expand: false,
      enableDrag: true,
      builder: (context) => EcheancierCapaciteEmpruntDialog(
          bloc.capaciteEmpruntResponse.montantsPret),
    );
  }
}
