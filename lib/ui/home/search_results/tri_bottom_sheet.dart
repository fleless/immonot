import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:group_radio_button/group_radio_button.dart';
import 'package:immonot/constants/app_colors.dart';
import 'package:immonot/constants/styles/app_styles.dart';

import '../home_bloc.dart';

class TriBottomSheetWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _TriBottomSheetWidgetState();
}

class _TriBottomSheetWidgetState extends State<TriBottomSheetWidget> {
  final bloc = Modular.get<HomeBloc>();
  String _singleValue;
  final MaterialColor kPrimaryColor = const MaterialColor(
    0xFFC91773,
    const <int, Color>{
      50: const Color(0xFFC91773),
      100: const Color(0xFFC91773),
      200: const Color(0xFFC91773),
      300: const Color(0xFFC91773),
      400: const Color(0xFFC91773),
      500: const Color(0xFFC91773),
      600: const Color(0xFFC91773),
      700: const Color(0xFFC91773),
      800: const Color(0xFFC91773),
      900: const Color(0xFFC91773),
    },
  );

  @override
  void initState() {
    _singleValue = bloc.tri;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 35, vertical: 20),
          child: Theme(
            data: ThemeData(
              unselectedWidgetColor: kPrimaryColor,
              primarySwatch: kPrimaryColor,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Trier par", style: AppStyles.titleStyleH2),
                SizedBox(height: 20),
                _buildRow("Date de publication", "dateAnn,ASC"),
                _buildRow("Prix croissant", "prix,ASC"),
                _buildRow("Prix décroissant", "prix,DESC"),
                _buildRow("Commune", "commune,ASC"),
                _buildRow("Type de bien", "typeBien,ASC"),
                _buildRow("Surface croissant", "surfaceHabitable,ASC"),
                _buildRow("Surface décroissant", "surfaceHabitable,DESC"),
                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _buildRow(String text, String value) {
    return InkWell(
      onTap: () => _goChange(value),
      splashColor: AppColors.defaultColor.withOpacity(0.3),
      highlightColor: AppColors.defaultColor.withOpacity(0.1),
      child: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(text, style: AppStyles.filterSubStyle),
            RadioButton(
              activeColor: AppColors.defaultColor,
              description: "",
              value: value,
              groupValue: _singleValue,
              onChanged: (value) => setState(
                () => _goChange(value),
              ),
              textPosition: RadioButtonTextPosition.left,
            ),
          ],
        ),
      ),
    );
  }

  _goChange(String value) {
    setState(() {
      _singleValue = value;
    });
    bloc.tri = _singleValue;
    bloc.notifTri(_singleValue);
    Modular.to.pop();
  }
}
