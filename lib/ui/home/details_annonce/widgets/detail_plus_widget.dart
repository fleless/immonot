import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:immonot/constants/app_colors.dart';
import 'package:immonot/constants/styles/app_styles.dart';
import 'package:immonot/models/fake/fakeResults.dart';

Widget buildPlusDetail(FakeResults item) {
  return Wrap(
    alignment: WrapAlignment.center,
    crossAxisAlignment: WrapCrossAlignment.center,
    runAlignment: WrapAlignment.center,
    spacing: 30,
    runSpacing: 25,
    children: [
      _buildColumn(FontAwesomeIcons.home, "CENTRE VILLE"),
      _buildColumn(FontAwesomeIcons.bus, "BUS"),
      _buildColumn(FontAwesomeIcons.shoppingBag, "COMMERCES"),
      _buildColumn(FontAwesomeIcons.university, "ÉCOLE"),
    ],
  );
}

Widget _buildColumn(IconData icon, String data) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      FaIcon(icon, color: AppColors.default_black, size: 15),
      SizedBox(height: 5),
      Text(data,
          style: AppStyles.filterSubStyle,
          maxLines: 1,
          overflow: TextOverflow.ellipsis)
    ],
  );
}
