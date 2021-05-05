import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:immonot/constants/app_colors.dart';
import 'package:immonot/constants/app_icons.dart';
import 'package:immonot/constants/app_images.dart';
import 'package:immonot/constants/routes.dart';
import 'package:immonot/constants/styles/app_styles.dart';
import 'package:immonot/models/fake/fakeResults.dart';
import 'package:page_indicator/page_indicator.dart';
import 'package:url_launcher/url_launcher.dart';
import "dart:ui" as ui;

class DetailEnchereHorairesWidget extends StatefulWidget {
  FakeResults fake;
  double heightPadding;

  DetailEnchereHorairesWidget(FakeResults item, double heightPadding) {
    this.fake = item;
    this.heightPadding = heightPadding;
  }

  @override
  State<StatefulWidget> createState() => _DetailEnchereHorairesWidgetState();
}

class _DetailEnchereHorairesWidgetState
    extends State<DetailEnchereHorairesWidget> {
  GlobalKey<PageContainerState> key = GlobalKey();
  FakeResults _fakeItem;

  @override
  void initState() {
    super.initState();
    _fakeItem = widget.fake;
  }

  @override
  Widget build(BuildContext context) {
    return _buildContent();
  }

  Widget _buildContent() {
    return Container(
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Divider(color: AppColors.hint),
          SizedBox(height: 15),
          Container(
            width: 150,
            child: Image.asset(
              AppImages.logoImmo,
            ),
          ),
          SizedBox(height: 8),
          Container(
            child: ListTile(
              minLeadingWidth: 20,
              leading: Container(
                width: 20,
                height: double.infinity,
                child: Center(
                  child: FaIcon(FontAwesomeIcons.clock, color: AppColors.defaultColor),
                ),
              ),
              title: RichText(
                textAlign: TextAlign.left,
                maxLines: 2,
                overflow: TextOverflow.clip,
                text: TextSpan(
                  children: [
                    TextSpan(text: "Début des offres le ", style: AppStyles.pinkTwelveNormalStyle),
                    TextSpan(text: "06/05/2021 09:00", style: AppStyles.smallTitleStylePink),
                  ],
                ),
              ),
              //Text("Début des offres le 06/05/2021 09:00", style: AppStyles.,),
              subtitle: RichText(
                textAlign: TextAlign.left,
                maxLines: 2,
                overflow: TextOverflow.clip,
                text: TextSpan(
                  children: [
                    TextSpan(text: "Fin des offres : ", style: AppStyles.locationAnnonces),
                    TextSpan(text: "07/05/2021 21:00", style: AppStyles.smallTitleStyleBlack),
                  ],
                ),
              ),
            ),
          ),
          Container(
            child: ListTile(
              minLeadingWidth: 20,
              leading: Container(
                width: 20,
                height: double.infinity,
                child: Center(
                  child: FaIcon(FontAwesomeIcons.moneyBillAlt, color: AppColors.defaultColor),
                ),
              ),
              title: Text("1 800 000 €", style: AppStyles.titleStylePink),
              subtitle: Text("1er offre possible", style: AppStyles.locationAnnonces),
            ),
          ),
        ],
      ),
    );
  }
}
