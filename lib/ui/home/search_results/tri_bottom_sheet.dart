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
  String _singleValue = "";
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
  final bloc = Modular.get<HomeBloc>();

  @override
  void initState() {
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Date de publication",
                        style: AppStyles.filterSubStyle),
                    RadioButton(
                      description: "",
                      value: "dateAnn,ASC",
                      groupValue: _singleValue,
                      onChanged: (value) => setState(
                        () => _goChange(value),
                      ),
                      textPosition: RadioButtonTextPosition.left,
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Prix croissant", style: AppStyles.filterSubStyle),
                    RadioButton(
                      description: "",
                      value: "prix,ASC",
                      groupValue: _singleValue,
                      onChanged: (value) => setState(
                        () => _goChange(value),
                      ),
                      textPosition: RadioButtonTextPosition.left,
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Prix décroissant", style: AppStyles.filterSubStyle),
                    RadioButton(
                      description: "",
                      value: "prix,DESC",
                      groupValue: _singleValue,
                      onChanged: (value) => setState(
                        () => _goChange(value),
                      ),
                      textPosition: RadioButtonTextPosition.left,
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Commune", style: AppStyles.filterSubStyle),
                    RadioButton(
                      description: "",
                      value: "commune,ASC",
                      groupValue: _singleValue,
                      onChanged: (value) => setState(
                        () => _goChange(value),
                      ),
                      textPosition: RadioButtonTextPosition.left,
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Type de bien", style: AppStyles.filterSubStyle),
                    RadioButton(
                      description: "",
                      value: "typeBien,ASC",
                      groupValue: _singleValue,
                      onChanged: (value) => setState(
                        () => _goChange(value),
                      ),
                      textPosition: RadioButtonTextPosition.left,
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Surface croissant", style: AppStyles.filterSubStyle),
                    RadioButton(
                      description: "",
                      value: "surfaceHabitable,ASC",
                      groupValue: _singleValue,
                      onChanged: (value) => setState(
                        () => _goChange(value),
                      ),
                      textPosition: RadioButtonTextPosition.left,
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Surface décroissant",
                        style: AppStyles.filterSubStyle),
                    RadioButton(
                      description: "",
                      value: "surfaceHabitable,DESC",
                      groupValue: _singleValue,
                      onChanged: (value) => setState(
                        () => _goChange(value),
                      ),
                      textPosition: RadioButtonTextPosition.left,
                    ),
                  ],
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
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
