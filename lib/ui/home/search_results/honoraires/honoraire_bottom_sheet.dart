import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:immonot/constants/app_colors.dart';
import 'package:immonot/constants/app_icons.dart';
import 'package:immonot/constants/app_images.dart';
import 'package:immonot/constants/endpoints.dart';
import 'package:immonot/constants/routes.dart';
import 'package:immonot/constants/styles/app_styles.dart';
import "dart:ui" as ui;

import 'package:immonot/models/responses/DetailAnnonceResponse.dart';
import 'package:immonot/ui/favoris/favoris_bloc.dart';
import 'package:immonot/ui/home/home_bloc.dart';
import 'package:immonot/ui/profil/auth/auth_screen.dart';
import 'package:immonot/utils/session_controller.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class HonorairesBottomSheetWidget extends StatefulWidget {
  String ligne1;
  String ligne2;
  String ligne3;
  String typeVente;
  String nomNotaire;
  bool prixEnBaisse;
  String oidNotaire;
  DetailAnnonceResponse annonce;

  HonorairesBottomSheetWidget(
      this.annonce,
      this.ligne1,
      this.ligne2,
      this.ligne3,
      this.typeVente,
      this.nomNotaire,
      this.prixEnBaisse,
      this.oidNotaire);

  @override
  State<StatefulWidget> createState() => _HonorairesBottomSheetWidgetState();
}

class _HonorairesBottomSheetWidgetState
    extends State<HonorairesBottomSheetWidget> {
  final favorisBloc = Modular.get<FavorisBloc>();
  final sessionController = Modular.get<SessionController>();
  final bloc = Modular.get<HomeBloc>();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 30),
        child: Container(
          child: widget.typeVente == "Achat"
              ? _vente()
              : widget.typeVente == "Location"
                  ? _vente()
                  : widget.typeVente == "Viager"
                      ? _vente()
                      : widget.typeVente == "Vente aux ench??res"
                          ? SizedBox.shrink()
                          : SizedBox.shrink(),
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
            Text(
                widget.ligne1 != null
                    ? widget.ligne1.toString().replaceAll("&euro;", "???")
                    : "Nous Consulter",
                style: AppStyles.titleStyle),
            widget.prixEnBaisse
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
        widget.ligne2 == null
            ? SizedBox.shrink()
            : Text(widget.ligne2.toString().replaceAll("&euro;", "???"),
                style: AppStyles.smallTitleStyleBlack,
                overflow: TextOverflow.clip,
                maxLines: 3),
        SizedBox(height: 8),
        widget.ligne3 == null
            ? SizedBox.shrink()
            : Text(widget.ligne3.toString().replaceAll("&euro;", "???"),
                style: AppStyles.locationAnnonces,
                overflow: TextOverflow.clip,
                maxLines: 3),
        SizedBox(height: 25),
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
              child: GestureDetector(
                onTap: () {
                  if (widget.oidNotaire != null)
                    Modular.to.pushNamed(Routes.annuaireWebView, arguments: {
                      "url": Endpoints.ANNUAIRE_WEB_VIEW_DETAIL +
                          "/" +
                          widget.oidNotaire.trim().replaceAll(" ", "%20"),
                      "ville": null,
                      "nom": widget.nomNotaire.trim()
                    });
                },
                child: Text(widget.nomNotaire,
                    maxLines: 7,
                    overflow: TextOverflow.ellipsis,
                    style: AppStyles.underlinedNotaireText),
              ),
            ),
          ],
        ),
        SizedBox(height: 25),
        if (widget.annonce.contact.hasBareme)
          GestureDetector(
            onTap: () {
              if (widget.oidNotaire != null)
                Modular.to.pushNamed(Routes.annuaireWebView, arguments: {
                  "url": Endpoints.ANNUAIRE_WEB_VIEW_DETAIL +
                      "/" +
                      widget.oidNotaire.trim().replaceAll(" ", "%20") +
                      "#info-baremes",
                  "ville": null,
                  "nom": widget.nomNotaire.trim()
                });
            },
            child: Text("Bar??me des honoraires de n??gociation",
                maxLines: 7,
                overflow: TextOverflow.ellipsis,
                style: AppStyles.underlinedBaremeHonoraireStyle),
          ),
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
                onTap: () async {
                  if (widget.annonce.suiviPrix) {
                    Fluttertoast.showToast(
                        msg: "Vous suivez d??j?? le prix de cette annonce");
                  } else {
                    await sessionController.isSessionConnected()
                        ? _suivrePrix(widget.annonce)
                        : _showConnectionDialog();
                  }
                },
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

  _suivrePrix(DetailAnnonceResponse item) async {
    bool resp = await favorisBloc.editFavoris(item.oidAnnonce, !item.suiviPrix);
    if (resp) {
      Modular.to.pop();
      bloc.detailChangesNotifier.add(!item.suiviPrix);
      bloc.suiviPrixnotifier(item.oidAnnonce);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Une erreur est survenue"),
      ));
    }
  }

  _showConnectionDialog() {
    return showCupertinoModalBottomSheet(
      context: context,
      expand: false,
      enableDrag: true,
      builder: (context) => AuthScreen(true),
    );
  }
}
