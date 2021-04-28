import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:group_radio_button/group_radio_button.dart';
import 'package:immonot/constants/app_colors.dart';
import 'package:immonot/constants/styles/app_styles.dart';

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
                      value: "date",
                      groupValue: _singleValue,
                      onChanged: (value) => setState(
                        () => _singleValue = value,
                      ),
                      textPosition: RadioButtonTextPosition.left,
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Prix(croissant)", style: AppStyles.filterSubStyle),
                    RadioButton(
                      description: "",
                      value: "prix croissant",
                      groupValue: _singleValue,
                      onChanged: (value) => setState(
                        () => _singleValue = value,
                      ),
                      textPosition: RadioButtonTextPosition.left,
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Prix(décroissant)", style: AppStyles.filterSubStyle),
                    RadioButton(
                      description: "",
                      value: "prix décroissant",
                      groupValue: _singleValue,
                      onChanged: (value) => setState(
                        () => _singleValue = value,
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
                      value: "commune",
                      groupValue: _singleValue,
                      onChanged: (value) => setState(
                        () => _singleValue = value,
                      ),
                      textPosition: RadioButtonTextPosition.left,
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Code Postal(croissant)",
                        style: AppStyles.filterSubStyle),
                    RadioButton(
                      description: "",
                      value: "code postal croissant",
                      groupValue: _singleValue,
                      onChanged: (value) => setState(
                        () => _singleValue = value,
                      ),
                      textPosition: RadioButtonTextPosition.left,
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Code Postal(décroissant)",
                        style: AppStyles.filterSubStyle),
                    RadioButton(
                      description: "",
                      value: "code postal décroissant",
                      groupValue: _singleValue,
                      onChanged: (value) => setState(
                        () => _singleValue = value,
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
                      value: "type de bien",
                      groupValue: _singleValue,
                      onChanged: (value) => setState(
                        () => _singleValue = value,
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
}
