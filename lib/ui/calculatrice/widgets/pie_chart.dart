import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:immonot/constants/app_colors.dart';
import 'package:immonot/constants/routes.dart';
import 'package:immonot/constants/styles/app_styles.dart';
import 'package:immonot/models/responses/frais_notaires_response.dart';
import 'package:immonot/utils/formatter_utils.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:url_launcher/url_launcher.dart';

class PieChartWidget extends StatefulWidget {
  FraisNotairesResponse fraisNotaires;

  PieChartWidget(FraisNotairesResponse fraisNotaires) {
    this.fraisNotaires = fraisNotaires;
  }

  @override
  State<StatefulWidget> createState() => _PieChartWidgetState();
}

class _PieChartWidgetState extends State<PieChartWidget> {
  final _formatterController = Modular.get<FormatterController>();

  Map<String, double> dataMap = {
    "Trésor public ": 15148,
    "Débours ": 1893.6,
    "Notaire ": 1893.6,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Container(
        height: MediaQuery.of(context).size.height * 1,
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(25),
            child: Column(
              children: [
                _buildHeader(),
                SizedBox(height: 15),
                _buildChart(),
                SizedBox(height: 15),
                _buildTexts(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Stack(children: [
      Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 50),
          child: Text(
            "Montant total estimatif acte en main\n\n\n",
            style: AppStyles.titleStyle,
            textAlign: TextAlign.center,
            maxLines: 3,
          ),
        ),
      ),
      Positioned(
          top: -5,
          right: -25,
          child: MaterialButton(
            padding: EdgeInsets.all(0),
            onPressed: () => Modular.to.pop(),
            child: Container(
              width: 40,
              alignment: Alignment.centerRight,
              child: FaIcon(
                FontAwesomeIcons.times,
                color: AppColors.default_black.withOpacity(0.7),
                size: 25,
              ),
            ),
          )),
    ]);
  }

  Widget _buildChart() {
    return Container(
      height: 300,
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 1,
            child: PieChart(
              dataMap: dataMap,
              animationDuration: Duration(milliseconds: 800),
              initialAngleInDegree: 270,
              chartType: ChartType.disc,
              colorList: [
                AppColors.firstChartColor,
                AppColors.secondChartColor,
                AppColors.thirdChartColor
              ],
              legendOptions: LegendOptions(
                showLegendsInRow: false,
                legendPosition: LegendPosition.right,
                showLegends: false,
                legendShape: BoxShape.rectangle,
                legendTextStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              chartValuesOptions: ChartValuesOptions(
                showChartValueBackground: false,
                showChartValues: true,
                chartValueStyle: AppStyles.selectionedItemText,
                showChartValuesInPercentage: true,
                showChartValuesOutside: false,
                decimalPlaces: 0,
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: Container(
                width: double.infinity,
                height: 170,
                alignment: Alignment.center,
                padding: EdgeInsets.only(left: 15),
                child: Column(
                  children: [
                    _buildIndicator(
                        AppColors.firstChartColor,
                        "Trésor public :",
                        widget.fraisNotaires.fraisTresorPublic),
                    _buildIndicator(AppColors.secondChartColor, "Débours :",
                        widget.fraisNotaires.fraisDebours),
                    _buildIndicator(AppColors.thirdChartColor, "Notaire :",
                        widget.fraisNotaires.fraisNotaire),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIndicator(Color couleur, String name, double prize) {
    return Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Flexible(
            child: Column(
              children: [
                Container(
                  color: couleur,
                  padding: EdgeInsets.all(20),
                  height: 17,
                  width: 30,
                ),
              ],
            ),
          ),
          SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(name,
                      style: AppStyles.smallTitleStyleBlack,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.start,
                      maxLines: 1),
                ),
                Expanded(
                  child: Text(
                      _formatterController.formatNumberWithSpaces(
                              prize.toStringAsFixed(2).replaceAll('.', ',')) +
                          " €",
                      style: AppStyles.subTitleStyle,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.start,
                      maxLines: 1),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTexts() {
    return Container(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Montant de l'acquisition", style: AppStyles.titleStyleH2),
          Text(
              _formatterController.formatNumberWithSpaces(
                      widget.fraisNotaires.prix.toStringAsFixed(2).replaceAll('.', ',')) +
                  " €",
              style: AppStyles.textNormal),
          SizedBox(height: 15),
          Text("Évaluation des frais d'acte", style: AppStyles.titleStyleH2),
          Text(
              _formatterController.formatNumberWithSpaces(
                      widget.fraisNotaires.fraisActe.toStringAsFixed(2).replaceAll('.', ',')) +
                  " €",
              style: AppStyles.textNormal),
          SizedBox(height: 40),
          RichText(
            textAlign: TextAlign.left,
            maxLines: 10,
            overflow: TextOverflow.clip,
            text: TextSpan(
              children: [
                TextSpan(
                    text: "Le barème Calcul-Frais-de-Notaire",
                    style: AppStyles.textDescriptionStyle),
                TextSpan(
                    text: " [1] ",
                    style: AppStyles.pinkTextDescriptionStyle,
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        _launchUrl("https://www.les-frais-de-notaire.fr/");
                      }),
                TextSpan(
                    text:
                        "propose le calcul estimatif des frais de notaire pour des biens jusqu'à",
                    style: AppStyles.textDescriptionStyle),
                TextSpan(
                    text: " 2 000 000 d'euros ",
                    style: AppStyles.mediumTitleStyle),
                TextSpan(
                    text:
                        "net vendeur. Pour les biens dont le prix de vente est supérieur à cette somme, merci de ",
                    style: AppStyles.textDescriptionStyle),
                TextSpan(
                    text: " consulter votre notaire. ",
                    style: AppStyles.pinkTextDescriptionStyle,
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        Modular.to.pushNamed(Routes.home,
                            arguments: {'scroll': true});
                      }),
              ],
            ),
          ),
          SizedBox(height: 20),
          RichText(
            textAlign: TextAlign.left,
            maxLines: 10,
            overflow: TextOverflow.clip,
            text: TextSpan(
              children: [
                TextSpan(
                    text:
                        "Le calcul de ces frais reste une estimation. Pour plus de détails, consultez votre notaire. Les frais d'acquisition estimatifs calculés pour des logements anciens de plus de 5 ans sachant que les frais sont différents pour l'achat de logements neufs ainsi que dans certains DOM TOM et dans la région Alsace Lorraine.\n [1] Source :",
                    style: AppStyles.locationAnnonces),
                TextSpan(
                    text: " www.Les-Frais-De-Notaire.fr",
                    style: AppStyles.pinkTwelveNormalStyle,
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        _launchUrl("https://www.les-frais-de-notaire.fr/");
                      }),
                TextSpan(
                    text: "® - Barème Février 2020",
                    style: AppStyles.locationAnnonces),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _launchUrl(String url) async {
    if (await canLaunch(url))
      await launch(url);
    else
      // can't launch url, there is some error
      throw "Could not launch $url";
  }
}
