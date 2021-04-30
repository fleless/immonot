import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:immonot/constants/app_colors.dart';
import 'package:immonot/constants/app_icons.dart';
import 'package:immonot/constants/app_images.dart';
import 'package:immonot/constants/styles/app_styles.dart';
import 'package:immonot/models/fake/fakeResults.dart';
import "dart:ui" as ui;

class HonorairesBottomSheetWidget extends StatefulWidget {
  FakeResults item;

  HonorairesBottomSheetWidget(FakeResults item) {
    this.item = item;
  }

  @override
  State<StatefulWidget> createState() => _HonorairesBottomSheetWidgetState();
}

class _HonorairesBottomSheetWidgetState
    extends State<HonorairesBottomSheetWidget> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 30),
        child: Container(
          child: widget.item.genre.toUpperCase() == "ACHAT"
              ? _vente()
              : widget.item.genre.toUpperCase() == "LOCATION"
                  ? _location()
                  : widget.item.genre.toUpperCase() == "VIAGER"
              ? _viager()
              : widget.item.genre.toUpperCase() == "VENTE AUX ENCHÈRES"
              ? _venteAuxEncheres()
              : _eVente(),
        ),
      ),
    );
  }

  Widget _vente() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.item.prize, style: AppStyles.titleStyle),
            widget.item.down
                ? Container(
                    alignment: Alignment.topLeft,
                    child: FaIcon(
                      FontAwesomeIcons.arrowDown,
                      color: AppColors.greenColor,
                      size: 10,
                    ),
                  )
                : SizedBox.shrink(),
          ],
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 15),
          child: Divider(
            color: AppColors.hint,
          ),
        ),
        Text(
            widget.item.prixHonoraire +
                " + Honoraires de négociation : " +
                widget.item.honoraireNegociation,
            style: AppStyles.smallTitleStyleBlack,
            overflow: TextOverflow.clip,
            maxLines: 3),
        SizedBox(height: 8),
        Text(
            "Soit " +
                widget.item.chargeHonoraire +
                " à la charge de l'acquéreur",
            style: AppStyles.locationAnnonces,
            overflow: TextOverflow.clip,
            maxLines: 3),
        SizedBox(height: 25),
        _commonWidgets(),
        SizedBox(height: 5),
      ],
    );
  }

  Widget _location() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.item.prize, style: AppStyles.titleStyle),
            widget.item.down
                ? Container(
              alignment: Alignment.topLeft,
              child: FaIcon(
                FontAwesomeIcons.arrowDown,
                color: AppColors.greenColor,
                size: 10,
              ),
            )
                : SizedBox.shrink(),
          ],
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 15),
          child: Divider(
            color: AppColors.hint,
          ),
        ),
        Text(
                " Dépot de garantie : " +
                widget.item.garantie,
            style: AppStyles.smallTitleStyleBlack,
            overflow: TextOverflow.clip,
            maxLines: 3),
        SizedBox(height: 8),
        Text(
            "Honoraires Charge Locataire : " +
                widget.item.honoraireChargeLocataire,
            style: AppStyles.smallTitleStyleBlack,
            overflow: TextOverflow.clip,
            maxLines: 3),
        SizedBox(height: 25),
        _commonWidgets(),
        SizedBox(height: 5),
      ],
    );
  }

  Widget _viager() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.item.prize, style: AppStyles.titleStyle),
            widget.item.down
                ? Container(
              alignment: Alignment.topLeft,
              child: FaIcon(
                FontAwesomeIcons.arrowDown,
                color: AppColors.greenColor,
                size: 10,
              ),
            )
                : SizedBox.shrink(),
          ],
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 15),
          child: Divider(
            color: AppColors.hint,
          ),
        ),
        Text(
            widget.item.prixHonoraire +
                " + Honoraires de négociation : " +
                widget.item.honoraireNegociation,
            style: AppStyles.smallTitleStyleBlack,
            overflow: TextOverflow.clip,
            maxLines: 3),
        SizedBox(height: 8),
        Text(
            "Soit " +
                widget.item.chargeHonoraire +
                " à la charge de l'acquéreur",
            style: AppStyles.locationAnnonces,
            overflow: TextOverflow.clip,
            maxLines: 3),
        SizedBox(height: 25),
        _commonWidgets(),
        SizedBox(height: 5),
      ],
    );
  }

  Widget _eVente() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.item.prize, style: AppStyles.titleStyle),
            widget.item.down
                ? Container(
              alignment: Alignment.topLeft,
              child: FaIcon(
                FontAwesomeIcons.arrowDown,
                color: AppColors.greenColor,
                size: 10,
              ),
            )
                : SizedBox.shrink(),
          ],
        ),
        SizedBox(height: 5),
        Text("1er offre possible", style: AppStyles.locationAnnonces),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 15),
          child: Divider(
            color: AppColors.hint,
          ),
        ),
        SizedBox(height: 15),
        Text(
                "Honoraires à la charge du vendeur",
            style: AppStyles.textNormal,
            overflow: TextOverflow.clip,
            maxLines: 3),
        SizedBox(height: 25),
        _commonWidgets(),
        SizedBox(height: 5),
      ],
    );
  }

  Widget _venteAuxEncheres() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Mise à prix : "+widget.item.prize, style: AppStyles.titleStyle),
            widget.item.down
                ? Container(
              alignment: Alignment.topLeft,
              child: FaIcon(
                FontAwesomeIcons.arrowDown,
                color: AppColors.greenColor,
                size: 10,
              ),
            )
                : SizedBox.shrink(),
          ],
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 15),
          child: Divider(
            color: AppColors.hint,
          ),
        ),
        SizedBox(height: 15),
        _commonWidgets(),
        SizedBox(height: 5),
      ],
    );
  }

  Widget _commonWidgets() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Row(
          children: [
            Center(
              child: Image.asset(
                AppImages.notaire,
                height: 50,
                width: 50,
              ),
            ),
            SizedBox(width: 20),
            Expanded(
              child: Text(widget.item.notaire,
                  maxLines: 7,
                  overflow: TextOverflow.ellipsis,
                  style: AppStyles.underlinedNotaireText),
            ),
          ],
        ),
        SizedBox(height: 25),
        Text("Barème des honoraires de négociation",
            maxLines: 7,
            overflow: TextOverflow.ellipsis,
            style: AppStyles.underlinedBaremeHonoraireStyle),
        SizedBox(height: 25),
        Center(
          child: Container(
            decoration: new BoxDecoration(
              color: AppColors.defaultColor,
              borderRadius: BorderRadius.all(Radius.circular(5)),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {},
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.65,
                  height: 45,
                  child: Center(
                    child: RichText(
                      overflow: TextOverflow.clip,
                      maxLines: 1,
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        children: [
                          WidgetSpan(
                            alignment: ui.PlaceholderAlignment.middle,
                            child: Image.asset(AppIcons.trending,
                                color: AppColors.white),
                          ),
                          TextSpan(
                              text: "  SUIVRE LE PRIX DE CE BIEN",
                              style: AppStyles.buttonTextWhite),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
