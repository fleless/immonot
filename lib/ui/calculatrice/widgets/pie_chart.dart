import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:immonot/constants/app_colors.dart';
import 'package:immonot/constants/styles/app_styles.dart';
import 'package:pie_chart/pie_chart.dart';

class PieChartWidget extends StatefulWidget {
  FilterSearchWidget() {}

  @override
  State<StatefulWidget> createState() => _PieChartWidgetState();
}

class _PieChartWidgetState extends State<PieChartWidget> {
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
        height: MediaQuery.of(context).size.height * 0.8,
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
            "Montant total estimatif acte en main",
            style: AppStyles.titleStyle,
            textAlign: TextAlign.center,
            maxLines: 2,
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
    return PieChart(
      dataMap: dataMap,
      animationDuration: Duration(milliseconds: 800),
      initialAngleInDegree: 240,
      chartType: ChartType.disc,
      colorList: [
        AppColors.firstChartColor,
        AppColors.secondChartColor,
        AppColors.thirdChartColor
      ],
      legendOptions: LegendOptions(
        showLegendsInRow: false,
        legendPosition: LegendPosition.right,
        showLegends: true,
        legendShape: BoxShape.rectangle,
        legendTextStyle: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      chartValuesOptions: ChartValuesOptions(
        showChartValueBackground: false,
        showChartValues: true,
        showChartValuesInPercentage: false,
        showChartValuesOutside: false,
        decimalPlaces: 2,
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
          Text("250 000,00 €", style: AppStyles.textNormal),
          SizedBox(height: 15),
          Text("Évaluation des frais d'acte", style: AppStyles.titleStyleH2),
          Text("18 936,00 €", style: AppStyles.textNormal),
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
                TextSpan(text: " [1] ", style: AppStyles.pinkTextDescriptionStyle),
                TextSpan(
                    text: "propose le calcul estimatif des frais de notaire pour des biens jusqu'à",
                    style: AppStyles.textDescriptionStyle),
                TextSpan(text: " 2 000 000 d'euros ", style: AppStyles.mediumTitleStyle),
                TextSpan(
                    text: "net vendeur. Pour les biens dont le prix de vente est supérieur à cette somme, merci de ",
                    style: AppStyles.textDescriptionStyle),
                TextSpan(text: " consulter votre notaire. ", style: AppStyles.pinkTextDescriptionStyle),
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
                    text: "Le calcul de ces frais reste une estimation. Pour plus de détails, consultez votre notaire. Les frais d'acquisition estimatifs calculés pour des logements anciens de plus de 5 ans sachant que les frais sont différents pour l'achat de logements neufs ainsi que dans certains DOM TOM et dans la région Alsace Lorraine.\n [1] Source :",
                    style: AppStyles.locationAnnonces),
                TextSpan(text: " www.Les-Frais-De-Notaire.fr", style: AppStyles.pinkTwelveNormalStyle),
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
}
