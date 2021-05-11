import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:immonot/constants/app_colors.dart';
import 'package:immonot/constants/styles/app_styles.dart';
import 'package:immonot/ui/calculatrice/widgets/pie_chart.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class FraisNotairesScreenWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _FraisNotairesScreenWidgetState();
}

class _FraisNotairesScreenWidgetState extends State<FraisNotairesScreenWidget> {
  TextEditingController _amountController = TextEditingController();
  bool _amountError = false;
  String _departement;
  bool _visibleResults = false;
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
                  "Comment calculer les frais de notaire ?",
                  style: AppStyles.underlinedBaremeHonoraireStyle,
                ),
              ),
            ),
            SizedBox(height: 15),
            Container(
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
                  "Qui paie les frais de notaire ?",
                  style: AppStyles.underlinedBaremeHonoraireStyle,
                ),
              ),
            ),
            SizedBox(height: 15),
            Container(
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
                  "Comment faire baisser les frais de notaire ?",
                  style: AppStyles.underlinedBaremeHonoraireStyle,
                ),
              ),
            ),
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
                                    RegExp(r'(^\d*\.?\d*)')),
                              ],
                              keyboardType: TextInputType.number,
                              onChanged: (value) {
                                setState(() {
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
                                    _departement = value;
                                  });
                                },
                                selectedItem: _departement),
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
                TextSpan(text: "18 432" + " €", style: AppStyles.textNormal),
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
                      builder: (context) => PieChartWidget(),
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

  _goCalcul() {
    setState(() {
      _visibleResults = false;
      _amountError = false;
    });
    double amount = double.tryParse(_amountController.text) ?? 0.0;
    if ((amount < 1000) || (amount > 2000000)) {
      setState(() {
        _amountError = true;
      });
    }
    if (!_amountError) {
      setState(() {
        _visibleResults = true;
      });
    }
  }
}
