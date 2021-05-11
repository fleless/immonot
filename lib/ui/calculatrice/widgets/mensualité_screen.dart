import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:immonot/constants/app_colors.dart';
import 'package:immonot/constants/styles/app_styles.dart';

class MensualiteScreenWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MensualiteScreenWidgetState();
}

class _MensualiteScreenWidgetState extends State<MensualiteScreenWidget> {
  String _dureePret = "15";
  TextEditingController _capitalController = TextEditingController();
  bool _capitalError = false;
  TextEditingController _tauxController = TextEditingController();
  bool _tauxError = false;
  bool _visibleResults = false;

  @override
  Widget build(BuildContext context) {
    return _buildContent();
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
              child: Text('Montant des mensualités',
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
              "Calculer vos mensualités",
              style: AppStyles.titleStyleH2,
            ),
            SizedBox(height: 5),
            Text(
              "Avant de prendre un crédit, mieux vaut vérifier si vos finances le permettent en calculant le montant d'emprunt possible en fonction des mensualités adaptées à votre capacité. (Tous les champs sont obligatoires)",
              style: AppStyles.textDescriptionStyle,
              maxLines: 20,
            ),
            SizedBox(height: 40),
            _buildForms(),
            SizedBox(height: 40),
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
                    Text("Capital emprunté",
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
                                FilteringTextInputFormatter.allow(RegExp(r'(^\d*\.?\d*)')),
                              ],
                              keyboardType: TextInputType.number,
                              onChanged: (value) {
                                setState(() {
                                  _capitalError = false;
                                });
                              },
                              controller: _capitalController,
                              cursorColor: AppColors.defaultColor,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.only(
                                    bottom: 0.0,
                                    left: 10.0,
                                    right: 0.0,
                                    top: 0.0),
                                hintText: "Capital emprunté (€)",
                                hintStyle: AppStyles.hintSearch,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    _capitalError
                        ? Text(
                            "Veuillez saisir un montant entre 1000 et 2 000 000 €",
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
                                FilteringTextInputFormatter.allow(RegExp(r'(^\d*\.?\d*)')),
                              ],
                              keyboardType: TextInputType.number,
                              onChanged: (value) {
                                setState(() {
                                  _tauxError = false;
                                });
                              },
                              controller: _tauxController,
                              cursorColor: AppColors.defaultColor,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.only(
                                    bottom: 0.0,
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
                alignment: Alignment.bottomLeft,
                child: FaIcon(FontAwesomeIcons.hourglassStart,
                    color: AppColors.defaultColor, size: 20),
              ),
              SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("Durée du prêt",
                        style: AppStyles.locationAnnonces,
                        textAlign: TextAlign.left),
                    Flexible(
                      child: Container(
                        height: 50,
                        width: double.infinity,
                        child: Card(
                          clipBehavior: Clip.antiAlias,
                          shape: RoundedRectangleBorder(
                              side: new BorderSide(
                                  color: AppColors.hint, width: 0.2),
                              borderRadius: BorderRadius.circular(4.0)),
                          elevation: 2,
                          shadowColor: AppColors.hint,
                          color: AppColors.appBackground,
                          child: Center(
                            child: DropdownSearch<String>(
                                searchBoxDecoration: null,
                                dropdownSearchDecoration: null,
                                mode: Mode.MENU,
                                showSelectedItem: true,
                                items: ["2", "3", "5", "10", "15", "25"],
                                label: "",
                                hint: "Durée du prêt",
                                onChanged: (value) {
                                  setState(() {
                                    _dureePret = value;
                                  });
                                },
                                selectedItem: _dureePret),
                          ),
                        ),
                      ),
                    ),
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
      decoration: new BoxDecoration(
        color: AppColors.defaultColor,
        borderRadius: BorderRadius.all(Radius.circular(5)),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            _goCalcul();
          },
          child: Container(
            width: MediaQuery.of(context).size.width * 0.35,
            height: 45,
            child: Center(
                child: Text("CACULER",
                    style: AppStyles.buttonTextWhite,
                    overflow: TextOverflow.clip,
                    maxLines: 1)),
          ),
        ),
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
          SizedBox(height: 15),
          RichText(
            textAlign: TextAlign.left,
            text: TextSpan(
              children: [
                TextSpan(
                    text: "Montant du prêt : ", style: AppStyles.textNormal),
                TextSpan(
                    text: _capitalController.text + " €",
                    style: AppStyles.mediumTitleStyle),
              ],
            ),
          ),
          RichText(
            textAlign: TextAlign.left,
            maxLines: 10,
            overflow: TextOverflow.clip,
            text: TextSpan(
              children: [
                TextSpan(
                    text: "Taux d'intérêt : ", style: AppStyles.textNormal),
                TextSpan(
                    text: _tauxController.text + " %",
                    style: AppStyles.mediumTitleStyle),
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
                    text: "Votre remboursement mensuel sera de : \n",
                    style: AppStyles.textNormal),
                TextSpan(
                    text: "969,4" + " € (Mensualité hors assurance)",
                    style: AppStyles.mediumTitleStyle),
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
                TextSpan(text: "Terme du prêt : ", style: AppStyles.textNormal),
                TextSpan(
                    text: _dureePret + " Année(s)",
                    style: AppStyles.mediumTitleStyle),
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
                    text: "Intérêt totaux si le prêt est mené à terme :  \n",
                    style: AppStyles.textNormal),
                TextSpan(
                    text: "38 841,32 €", style: AppStyles.mediumTitleStyle),
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
                    print;
                  },
                  child: Text(
                    "Voir l'échéancier",
                    style: AppStyles.underlinedBaremeHonoraireStyle,
                  )),
            ),
          ),
        ],
      ),
    );
  }

  _goCalcul() {
    setState(() {
      _visibleResults = false;
      _capitalError = false;
      _tauxError = false;
    });
    int cap = int.tryParse(_capitalController.text) ?? 0;
    double taux = double.tryParse(_tauxController.text) ?? 0.0;
    if ((cap < 1000) || (cap > 2000000)) {
      setState(() {
        _capitalError = true;
      });
    }
    if ((taux < 0.1) || (taux > 100)) {
      setState(() {
        _tauxError = true;
      });
    }
    if ((!_capitalError) && (!_tauxError)) {
      setState(() {
        _visibleResults = true;
      });
    }
  }
}
