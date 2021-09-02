import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:immonot/constants/app_colors.dart';
import 'package:immonot/constants/styles/app_styles.dart';
import 'package:immonot/ui/calculatrice/widgets/pie_chart.dart';
import 'package:immonot/utils/launchUrl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:url_launcher/url_launcher.dart';

import '../calculatrice_bloc.dart';

class FraisNotairesScreenWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _FraisNotairesScreenWidgetState();
}

class _FraisNotairesScreenWidgetState extends State<FraisNotairesScreenWidget> {
  final bloc = Modular.get<CalculatriceBloc>();
  TextEditingController _amountController = TextEditingController();
  bool _amountError = false;
  String _departement;
  bool _visibleResults = false;
  bool _loading = false;
  int _openedQuestion = 0;
  final List<String> listDepartements = [
    '01 Ain',
    '02 Aisne',
    '03 Allier',
    '04 Alpes-de-Haute-Provence',
    '05 Hautes-Alpes',
    '06 Alpes-Maritimes',
    '07 Ardèche',
    '08 Ardennes',
    '09 Ariège',
    '10 Aube',
    '11 Aude',
    '12 Aveyron',
    '13 Bouches-du-Rhône',
    '14 Calvados',
    '15 Cantal',
    '16 Charente',
    '17 Charente-Maritime',
    '18 Cher',
    '19 Corrèze',
    '2A Corse-du-Sud',
    '2B Haute-Corse',
    '21 Côte-d\'Or',
    '22 Côtes-d\'Armor',
    '23 Creuse',
    '24 Dordogne',
    '25 Doubs',
    '26 Drôme',
    '27 Eure',
    '28 Eure-et-Loir',
    '29 Finistère',
    '30 Gard',
    '31 Haute-Garonne',
    '32 Gers',
    '33 Gironde',
    '34 Hérault',
    '35 Ille-et-Vilaine',
    '36 Indre',
    '37 Indre-et-Loire',
    '38 Isère',
    '39 Jura',
    '40 Landes',
    '41 Loir-et-Cher',
    '42 Loire',
    '43 Haute-Loire',
    '44 Loire-Atlantique',
    '45 Loiret',
    '46 Lot',
    '47 Lot-et-Garonne',
    '48 Lozère',
    '49 Maine-et-Loire',
    '50 Manche',
    '51 Marne',
    '52 Haute-Marne',
    '53 Mayenne',
    '54 Meurthe-et-Moselle',
    '55 Meuse',
    '56 Morbihan',
    '57 Moselle',
    '58 Nièvre',
    '59 Nord',
    '60 Oise',
    '61 Orne',
    '62 Pas-de-Calais',
    '63 Puy-de-Dôme',
    '64 Pyrénées-Atlantiques',
    '65 Hautes-Pyrénées',
    '66 Pyrénées-Orientales',
    '67 Bas-Rhin',
    '68 Haut-Rhin',
    '69 Rhône',
    '70 Haute-Saône',
    '71 Saône-et-Loire',
    '72 Sarthe',
    '73 Savoie',
    '74 Haute-Savoie',
    '75 Paris',
    '76 Seine-Maritime',
    '77 Seine-et-Marne',
    '78 Yvelines',
    '79 Deux-Sèvres',
    '80 Somme',
    '81 Tarn',
    '82 Tarn-et-Garonne',
    '83 Var',
    '84 Vaucluse',
    '85 Vendée',
    '86 Vienne',
    '87 Haute-Vienne',
    '88 Vosges',
    '89 Yonne',
    '90 Territoire de Belfort',
    '91 Essonne',
    '92 Hauts-de-Seine',
    '93 Seine-Saint-Denis',
    '94 Val-de-Marne',
    '95 Val-d\'Oise',
    '971 Guadeloupe',
    '972 Martinique',
    '973 Guyane',
    '974 La Réunion',
    '976 Mayotte',
  ];

  @override
  void initState() {
    super.initState();
    _departement = listDepartements[0];
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(new FocusNode());
      },
      child: SingleChildScrollView(
        child: _buildContent(),
      ),
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
              child: Text("Frais de notaire",
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
              "Estimation des frais de notaire pour une vente non négociée.",
              maxLines: 2,
              overflow: TextOverflow.clip,
              style: AppStyles.titleStyleH2,
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
            SizedBox(height: 40),
            Text(
              "Les frais de notaire",
              maxLines: 2,
              overflow: TextOverflow.clip,
              style: AppStyles.titleStyleH2,
            ),
            SizedBox(height: 5),
            Text(
              "Comment calculer et estimer les frais de notaire ou frais d’acquisition pour un achat immobilier ? Qui doit payer les frais de notaire ? \n \n L'achat d’un bien immobilier s’accompagne, en plus du prix d’achat et de la rémunération du professionnel, de frais d’acquisition dits « frais de notaire ». Pour un bien ancien, ils représentent 7 à 8 % du prix du bien. Collectés par le notaire, ces frais représentent pour 80 % des impôts et taxes qui sont reversés à l’État tandis que les 20 % restant comprennent les émoluments et débours perçus par le notaire au titre de sa rémunération. À quoi servent-ils ? Les réponses à toutes vos questions…",
              maxLines: 20,
              overflow: TextOverflow.clip,
              style: AppStyles.textDescriptionStyle,
            ),
            SizedBox(height: 15),
            Container(
              alignment: Alignment.centerLeft,
              width: double.infinity,
              padding: EdgeInsets.all(6),
              decoration: BoxDecoration(
                  color: AppColors.rowTableColor.withOpacity(0.1),
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10)),
                  border: Border.all(color: AppColors.hint.withOpacity(0.2))),
              child: TextButton(
                style: ButtonStyle(
                  overlayColor: MaterialStateColor.resolveWith(
                    (states) => AppColors.defaultColor.withOpacity(0.2),
                  ),
                ),
                onPressed: () {
                  setState(() {
                    _openedQuestion == 1
                        ? _openedQuestion = 0
                        : _openedQuestion = 1;
                  });
                },
                child: Text(
                  "Comment calculer les frais de notaire ?",
                  style: AppStyles.underlinedBaremeHonoraireStyle,
                ),
              ),
            ),
            _openedQuestion == 1
                ? _buildFirstQuestionText()
                : SizedBox.shrink(),
            Container(
              alignment: Alignment.centerLeft,
              width: double.infinity,
              padding: EdgeInsets.all(6),
              decoration: BoxDecoration(
                  color: AppColors.rowTableColor.withOpacity(0.1),
                  border: Border.all(color: AppColors.hint.withOpacity(0.2))),
              child: TextButton(
                style: ButtonStyle(
                  overlayColor: MaterialStateColor.resolveWith(
                    (states) => AppColors.defaultColor.withOpacity(0.2),
                  ),
                ),
                onPressed: () {
                  setState(() {
                    _openedQuestion == 2
                        ? _openedQuestion = 0
                        : _openedQuestion = 2;
                  });
                },
                child: Text(
                  "Qui paie les frais de notaire ?",
                  style: AppStyles.underlinedBaremeHonoraireStyle,
                ),
              ),
            ),
            _openedQuestion == 2
                ? _buildSecondQuestionText()
                : SizedBox.shrink(),
            Container(
              alignment: Alignment.centerLeft,
              width: double.infinity,
              padding: EdgeInsets.all(6),
              decoration: BoxDecoration(
                  color: AppColors.rowTableColor.withOpacity(0.1),
                  borderRadius: _openedQuestion != 3
                      ? BorderRadius.only(
                          bottomLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10))
                      : null,
                  border: Border.all(color: AppColors.hint.withOpacity(0.2))),
              child: TextButton(
                style: ButtonStyle(
                  overlayColor: MaterialStateColor.resolveWith(
                    (states) => AppColors.defaultColor.withOpacity(0.2),
                  ),
                ),
                onPressed: () {
                  setState(() {
                    _openedQuestion == 3
                        ? _openedQuestion = 0
                        : _openedQuestion = 3;
                  });
                },
                child: Text(
                  "Comment faire baisser les frais de notaire ?",
                  style: AppStyles.underlinedBaremeHonoraireStyle,
                ),
              ),
            ),
            _openedQuestion == 3
                ? _buildThirdQuestionText()
                : SizedBox.shrink(),
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
                    Text("Montant d'acquisition",
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
                                  _amountError = false;
                                });
                              },
                              controller: _amountController,
                              cursorColor: AppColors.defaultColor,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.only(
                                    bottom: 0.0,
                                    left: 10.0,
                                    right: 0.0,
                                    top: 0.0),
                                hintText: "Saisissez un montant",
                                hintStyle: AppStyles.hintSearch,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    _amountError
                        ? Text(
                            "Veuillez saisir un montant entre 1 000 et 2 000 000 €.",
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
                child: FaIcon(FontAwesomeIcons.mapMarkerAlt,
                    color: AppColors.defaultColor, size: 20),
              ),
              SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("Département du bien",
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
                            child: Theme(
                              // Create a unique theme with "ThemeData"
                              data: ThemeData(
                                primarySwatch: AppColors.defaultColorMaterial,
                              ),
                              child: DropdownSearch<String>(
                                  searchBoxDecoration: null,
                                  dropdownSearchDecoration: null,
                                  mode: Mode.MENU,
                                  showSelectedItem: true,
                                  items: listDepartements,
                                  label: "",
                                  hint: "Département du bien",
                                  onChanged: (value) {
                                    setState(() {
                                      _visibleResults = false;
                                      _departement = value;
                                    });
                                  },
                                  selectedItem: _departement),
                            ),
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
                    text: "Montant de l'acquisiton : ",
                    style: AppStyles.mediumTitleStyle),
                TextSpan(
                    text: _amountController.text + " €",
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
                    text: "Évaluation des frais d'acte : ",
                    style: AppStyles.mediumTitleStyle),
                TextSpan(
                    text: bloc.fraisNotairesResponse.fraisActe
                            .toStringAsFixed(2) +
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
                    FocusScope.of(context).requestFocus(new FocusNode());
                    showCupertinoModalBottomSheet(
                      context: context,
                      expand: false,
                      enableDrag: true,
                      builder: (context) =>
                          PieChartWidget(bloc.fraisNotairesResponse),
                    );
                  },
                  child: Text(
                    "Voir le détail des frais",
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
      _amountError = false;
    });
    double amount = double.tryParse(_amountController.text) ?? 0.0;
    if ((amount < 1000) ||
        (amount > 2000000) ||
        (_amountController.text.endsWith("."))) {
      setState(() {
        _amountError = true;
      });
    }
    String departement = _departement.substring(0, _departement.indexOf(' '));
    if (!_amountError) {
      setState(() {
        _loading = true;
      });
      await bloc.calculFraisNotaires(amount, departement);
      setState(() {
        _loading = false;
        _visibleResults = true;
      });
    }
  }

  Widget _buildFirstQuestionText() {
    return Container(
      constraints: BoxConstraints(
          minHeight: 0, minWidth: double.infinity, maxHeight: 400),
      padding: EdgeInsets.all(15),
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.white,
        border: Border(
          right: BorderSide(width: 1.0, color: AppColors.hint.withOpacity(0.2)),
          left: BorderSide(width: 1.0, color: AppColors.hint.withOpacity(0.2)),
        ),
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            RichText(
              textAlign: TextAlign.left,
              maxLines: 1000,
              overflow: TextOverflow.clip,
              text: TextSpan(
                children: [
                  TextSpan(
                      text:
                          "Les frais de notaire ou frais d’acquisition correspondent à l’ensemble des sommes réglées au notaire pour ses prestations et celles de tiers, ses démarches, la rédaction d’acte ainsi que pour les taxes et impôts dus à l’État.\n\nLes frais de notaire dépendent d’un barème régit par ",
                      style: AppStyles.textDescriptionStyle),
                  TextSpan(
                      text: "le décret du 8 mars 1978",
                      style: AppStyles.textDescriptionDefaultColorStyle,
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          launchUrl(
                              "https://www.legifrance.gouv.fr/loda/id/JORFTEXT000000702304/");
                        }),
                  TextSpan(
                      text:
                          ". Les taux sont proportionnels au prix de la transaction et dégressif.\n\nLes frais d’acquisition dits « frais de notaire » se décomposent en quatre parties :\n\n",
                      style: AppStyles.textDescriptionStyle),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 25),
              child: RichText(
                textAlign: TextAlign.left,
                maxLines: 1000,
                overflow: TextOverflow.clip,
                text: TextSpan(children: [
                  WidgetSpan(
                    alignment: PlaceholderAlignment.middle,
                    child: FaIcon(FontAwesomeIcons.solidCircle, size: 8),
                  ),
                  TextSpan(
                      text: "    - Les droits de mutation : ",
                      style: AppStyles.textDescriptionBoldStyle),
                  TextSpan(
                      text:
                          "il s’agit de droits perçus par le fisc qui s’établissent à 5, 80 % du prix de vente dans la plupart des départements.\n\n",
                      style: AppStyles.textDescriptionStyle),
                  WidgetSpan(
                    alignment: PlaceholderAlignment.middle,
                    child: FaIcon(FontAwesomeIcons.solidCircle, size: 8),
                  ),
                  TextSpan(
                      text: "    - La rémunération du notaire : ",
                      style: AppStyles.textDescriptionBoldStyle),
                  TextSpan(
                      text:
                          "les émoluments qui reviennent au notaire pour une vente immobilière sont calculés à l’aide d’un tarif qui est proportionnel au prix de vente du bien (de 0,814 % au-dessus d’un prix de vente de 60 000 €).\n\n",
                      style: AppStyles.textDescriptionStyle),
                ]),
              ),
            ),
            Text(
                "Taux par tranches applicables à partir du 1er mai 2020 jusqu’au 28 février 2022 :\n",
                style: AppStyles.textDescriptionStyle),
            Container(color: AppColors.grey, height: 2),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
              child: IntrinsicHeight(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                        flex: 1,
                        child: Text(
                          "Prix",
                          style: AppStyles.textDescriptionBoldStyle,
                          textAlign: TextAlign.start,
                        )),
                    SizedBox(width: 15),
                    Expanded(
                        flex: 1,
                        child: Text(
                          "Pourcentage",
                          style: AppStyles.textDescriptionBoldStyle,
                        )),
                  ],
                ),
              ),
            ),
            Container(color: AppColors.grey, height: 2),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
              child: IntrinsicHeight(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                        flex: 1,
                        child: Text(
                          "De 0 à 6.500 euros	",
                          style: AppStyles.textDescriptionStyle,
                          textAlign: TextAlign.start,
                        )),
                    SizedBox(width: 15),
                    Expanded(
                        flex: 1,
                        child: Text(
                          "3,870%",
                          style: AppStyles.textDescriptionStyle,
                        )),
                  ],
                ),
              ),
            ),
            Container(color: AppColors.grey, height: 2),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
              child: IntrinsicHeight(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                        flex: 1,
                        child: Text(
                          "De 6.501 à 17.000 euros",
                          style: AppStyles.textDescriptionStyle,
                          textAlign: TextAlign.start,
                        )),
                    SizedBox(width: 15),
                    Expanded(
                        flex: 1,
                        child: Text(
                          "1,596%",
                          style: AppStyles.textDescriptionStyle,
                        )),
                  ],
                ),
              ),
            ),
            Container(color: AppColors.grey, height: 2),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
              child: IntrinsicHeight(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                        flex: 1,
                        child: Text(
                          "De 17.001 à 60.000 euros	",
                          style: AppStyles.textDescriptionStyle,
                          textAlign: TextAlign.start,
                        )),
                    SizedBox(width: 15),
                    Expanded(
                      flex: 1,
                      child: Text(
                        "1,064%",
                        style: AppStyles.textDescriptionStyle,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(color: AppColors.grey, height: 2),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
              child: IntrinsicHeight(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                        flex: 1,
                        child: Text(
                          "60.001 euros et plus	",
                          style: AppStyles.textDescriptionStyle,
                          textAlign: TextAlign.start,
                        )),
                    SizedBox(width: 15),
                    Expanded(
                        flex: 1,
                        child: Text(
                          "0,799%",
                          style: AppStyles.textDescriptionStyle,
                        )),
                  ],
                ),
              ),
            ),
            SizedBox(height: 15),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 25),
              child: RichText(
                textAlign: TextAlign.left,
                maxLines: 1000,
                overflow: TextOverflow.clip,
                text: TextSpan(children: [
                  WidgetSpan(
                    alignment: PlaceholderAlignment.middle,
                    child: FaIcon(FontAwesomeIcons.solidCircle, size: 8),
                  ),
                  TextSpan(
                      text:
                          "    - Les émoluments de formalités et frais divers : ",
                      style: AppStyles.textDescriptionBoldStyle),
                  TextSpan(
                      text:
                          "cela correspond aux démarches de formalités que le notaire effectue en vue de la transaction.\n\n",
                      style: AppStyles.textDescriptionStyle),
                  WidgetSpan(
                    alignment: PlaceholderAlignment.middle,
                    child: FaIcon(FontAwesomeIcons.solidCircle, size: 8),
                  ),
                  TextSpan(
                      text: "    - La contribution de sécurité immobilière : ",
                      style: AppStyles.textDescriptionBoldStyle),
                  TextSpan(
                      text:
                          "cette contribution est due à l’État pour l’accomplissement des formalités d’enregistrement et de publicité foncière.",
                      style: AppStyles.textDescriptionStyle),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSecondQuestionText() {
    return Container(
      padding: EdgeInsets.all(15),
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.white,
        border: Border(
          right: BorderSide(width: 1.0, color: AppColors.hint.withOpacity(0.2)),
          left: BorderSide(width: 1.0, color: AppColors.hint.withOpacity(0.2)),
        ),
      ),
      child: Text(
          'Sauf mention contraire, les frais de notaire sont à la charge de l’acquéreur.',
          style: AppStyles.textDescriptionStyle),
    );
  }

  Widget _buildThirdQuestionText() {
    return Container(
      constraints: BoxConstraints(
          minHeight: 0, minWidth: double.infinity, maxHeight: 400),
      padding: EdgeInsets.all(15),
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10)),
        border: Border(
          right: BorderSide(width: 1.0, color: AppColors.hint.withOpacity(0.2)),
          left: BorderSide(width: 1.0, color: AppColors.hint.withOpacity(0.2)),
          bottom:
              BorderSide(width: 1.0, color: AppColors.hint.withOpacity(0.2)),
          top: BorderSide(width: 1.0, color: AppColors.hint.withOpacity(0.2)),
        ),
      ),
      child: SingleChildScrollView(
        child: RichText(
          textAlign: TextAlign.left,
          maxLines: 1000,
          overflow: TextOverflow.clip,
          text: TextSpan(
            children: [
              TextSpan(
                  text:
                      "Pour les biens dont le prix de vente dépasse 150 000 €, le notaire peut accorder une remise sur ses émoluments dans la limite de 10 %.\n\nExemple : pour un bien de 250 000 €, les émoluments du notaire s’élèvent à : 250 000 € x 0,814 % = 2 035 € auxquels il faut ajouter 405,41 € soit 2 440,41 €.\n\nLes émoluments du notaire s’élèvent donc à 2 928,50 € TTC\n\nLe notaire peut accorder une remise sur ses émoluments calculés sur la part de prix comprise au-delà de 150 000 €, soit sur 100 000 € (250 000 – 150 000 €).\n\nLe calcul de ses émoluments sur cette tranche est le suivant : 100 000 X 0.814% = 814 €, soit 976,80 € TTC. Le notaire peut donc accorder une remise maximale de 976,80 € x 10 %, soit de 98 € TTC.\n\n",
                  style: AppStyles.textDescriptionStyle),
              TextSpan(
                  text:
                      "L’application de cette réduction est strictement encadrée par l'",
                  style: AppStyles.textDescriptionStyle),
              TextSpan(
                  text: "article A444-174 du Code de commerce ",
                  style: AppStyles.textDescriptionDefaultColorStyle,
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      launchUrl(
                          "https://www.legifrance.gouv.fr/codes/article_lc/LEGIARTI000041684677/");
                    }),
              TextSpan(
                  text: "créé par l'", style: AppStyles.textDescriptionStyle),
              TextSpan(
                  text: "article 2 de l’arrêté du 26 février 2016",
                  style: AppStyles.textDescriptionDefaultColorStyle,
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      launchUrl(
                          "https://www.legifrance.gouv.fr/loda/id/JORFTEXT000032115547/");
                    }),
              TextSpan(text: ".", style: AppStyles.textDescriptionStyle),
            ],
          ),
        ),
      ),
    );
  }

}
