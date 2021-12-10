import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:immonot/constants/app_colors.dart';
import 'package:immonot/constants/styles/app_styles.dart';
import 'package:immonot/models/responses/montant_mensualite_response.dart';
import 'package:immonot/utils/formatter_utils.dart';

class EcheancierMontantMensualiteDialog extends StatefulWidget {
  List<TableauAmortissement> lista = <TableauAmortissement>[];

  EcheancierMontantMensualiteDialog(List<TableauAmortissement> lista) {
    this.lista = lista;
  }

  @override
  State<StatefulWidget> createState() =>
      _EcheancierMontantMensualiteDialogState();
}

class _EcheancierMontantMensualiteDialogState
    extends State<EcheancierMontantMensualiteDialog> {
  final _formatterController = Modular.get<FormatterController>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Container(
          height: MediaQuery.of(context).size.height * 0.92,
          // scrolling width depending of smartphone resolution
          width: MediaQuery.of(context).size.width < 400
              ? MediaQuery.of(context).size.width * 1.3
              : MediaQuery.of(context).size.width < 500
                  ? MediaQuery.of(context).size.width * 1.2
                  : MediaQuery.of(context).size.width,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Container(
                padding: EdgeInsets.symmetric(vertical: 3),
                color: AppColors.white,
                child: _buildTitle(),
              ),
              Expanded(
                child: Container(
                  height: double.infinity,
                  width: double.infinity,
                  child: _buildList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return Material(
      child: ListTile(
        tileColor: AppColors.white,
        title: Center(
          child: Text(
            "Échéancier",
            style: AppStyles.titleStyle,
            textAlign: TextAlign.center,
            overflow: TextOverflow.clip,
            maxLines: 2,
          ),
        ),
        trailing: InkWell(
          onTap: () {
            Modular.to.pop();
          },
          child: FaIcon(
            FontAwesomeIcons.times,
            size: 22,
            color: AppColors.default_black,
          ),
        ),
      ),
    );
  }

  Widget _buildList() {
    return ListView.builder(
      itemCount: widget.lista.length + 1,
      itemBuilder: (context, i) {
        return i == 0 ? _buildTableHeader() : _buildTableRow(i - 1);
      },
    );
  }

  Widget _buildTableHeader() {
    return Container(
      height: 65,
      width: double.infinity,
      color: AppColors.headerTableColor,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Flexible(
            flex: 1,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 2),
              alignment: Alignment.center,
              child: Text(
                "Échéance",
                textAlign: TextAlign.center,
                style: AppStyles.whiteTitleStyle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          Flexible(
            flex: 1,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 2),
              alignment: Alignment.center,
              child: Text(
                "Mensualité",
                textAlign: TextAlign.center,
                style: AppStyles.whiteTitleStyle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          Flexible(
            flex: 1,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 2),
              alignment: Alignment.center,
              child: Text(
                "Capital",
                textAlign: TextAlign.center,
                style: AppStyles.whiteTitleStyle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          Flexible(
            flex: 1,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 2),
              alignment: Alignment.center,
              child: Text(
                "Intérêts",
                textAlign: TextAlign.center,
                style: AppStyles.whiteTitleStyle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          Flexible(
            flex: 1,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 2),
              alignment: Alignment.center,
              child: Text(
                "Restant dû",
                textAlign: TextAlign.center,
                style: AppStyles.whiteTitleStyle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTableRow(int index) {
    return index % 2 == 1
        ? Container(
            height: 45,
            width: double.infinity,
            color: AppColors.white,
            child: _buildRowDetails(index),
          )
        : Container(
            height: 45,
            width: double.infinity,
            color: AppColors.rowTableColor,
            child: _buildRowDetails(index),
          );
  }

  Widget _buildRowDetails(int index) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Flexible(
          flex: 1,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 2),
            alignment: Alignment.center,
            child: Text(
              "N°" +
                  _formatterController.formatNumberWithSpaces(
                      widget.lista[index].echeance.toString()),
              textAlign: TextAlign.center,
              style: AppStyles.smallTitleStyleBlack,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
        Flexible(
          flex: 1,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 2),
            alignment: Alignment.center,
            child: Text(
              _formatterController.formatNumberWithSpaces(
                      widget.lista[index].mensualite.toStringAsFixed(2).replaceAll('.', ',')) +
                  " €",
              textAlign: TextAlign.center,
              style: AppStyles.filterSubStyle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
        Flexible(
          flex: 1,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 2),
            alignment: Alignment.center,
            child: Text(
              _formatterController.formatNumberWithSpaces(
                      widget.lista[index].capitalRembourse.toStringAsFixed(2).replaceAll('.', ',')) +
                  " €",
              textAlign: TextAlign.center,
              style: AppStyles.filterSubStyle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
        Flexible(
          flex: 1,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 2),
            alignment: Alignment.center,
            child: Text(
              _formatterController.formatNumberWithSpaces(
                      widget.lista[index].interet.toStringAsFixed(2).replaceAll('.', ',')) +
                  " €",
              textAlign: TextAlign.center,
              style: AppStyles.filterSubStyle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
        Flexible(
          flex: 1,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 2),
            alignment: Alignment.center,
            child: Text(
              _formatterController.formatNumberWithSpaces(
                      widget.lista[index].capitalRestant.toStringAsFixed(2).replaceAll('.', ',')) +
                  " €",
              textAlign: TextAlign.center,
              style: AppStyles.filterSubStyle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      ],
    );
  }
}
