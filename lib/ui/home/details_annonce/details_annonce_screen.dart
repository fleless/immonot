import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:immonot/constants/app_colors.dart';
import 'package:immonot/constants/app_icons.dart';
import 'package:immonot/constants/styles/app_styles.dart';
import 'package:immonot/models/responses/DetailAnnonceResponse.dart';
import 'package:immonot/ui/favoris/favoris_bloc.dart';
import 'package:immonot/ui/home/details_annonce/widgets/detail_bottom_widget.dart';
import 'package:immonot/ui/home/details_annonce/widgets/detail_caracteristique_widget.dart';
import 'package:immonot/ui/home/details_annonce/widgets/detail_contact_widget.dart';
import 'package:immonot/ui/home/details_annonce/widgets/detail_dpe_widget.dart';
import 'package:immonot/ui/home/details_annonce/widgets/detail_ges_widget.dart';
import 'package:immonot/ui/home/details_annonce/widgets/detail_header_widget.dart';
import 'package:immonot/ui/home/details_annonce/widgets/detail_plus_widget.dart';
import 'package:immonot/ui/home/details_annonce/widgets/detail_proposition_annonces.dart';
import 'package:immonot/ui/home/details_annonce/widgets/detail_siret_widget.dart';
import 'package:immonot/ui/home/search_results/honoraires/honoraire_bottom_sheet.dart';
import 'package:immonot/utils/session_controller.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:latlong2/latlong.dart';
import 'package:html/parser.dart' as htmlparser;
import 'package:readmore/readmore.dart';

import '../home_bloc.dart';

class DetailAnnonceWidget extends StatefulWidget {
  String idAnnonce;

  DetailAnnonceWidget(String id) {
    this.idAnnonce = id;
  }

  @override
  State<StatefulWidget> createState() => _DetailAnnonceWidgetState();
}

class _DetailAnnonceWidgetState extends State<DetailAnnonceWidget> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final double heightPadding = 15;
  final bloc = Modular.get<HomeBloc>();
  final sessionController = Modular.get<SessionController>();
  final favorisBloc = Modular.get<FavorisBloc>();
  DetailAnnonceResponse annonce = DetailAnnonceResponse();
  bool loading = false;
  bool _suivi = false;

  @override
  void initState() {
    _getAnnonceInfo();
    super.initState();
  }

  Future<DetailAnnonceResponse> _getAnnonceInfo() async {
    setState(() {
      loading = true;
    });
    DetailAnnonceResponse resp = await bloc.getDetailAnnonce(widget.idAnnonce);
    setState(() {
      annonce = resp;
      loading = false;
    });
    return resp;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomInset: true,
      backgroundColor: AppColors.appBackground,
      //drawer: DrawerWidget(),
      body: loading
          ? Center(
              child: Container(
                height: 50,
                width: 50,
                child: CircularProgressIndicator(
                  color: AppColors.defaultColor,
                ),
              ),
            )
          : Container(
              child: Stack(
                children: [
                  SingleChildScrollView(
                    child: _buildContent(annonce),
                  ),
                  DetailBotttomWidget(annonce),
                ],
              ),
            ),
    );
  }

  Widget _buildContent(DetailAnnonceResponse annonce) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          DetailHeaderWidget(annonce),
          SizedBox(height: heightPadding),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: _buildDescription(),
          ),
          annonce.contact != null
              ? DetailContactWidget(annonce)
              : SizedBox.shrink(),
          ((annonce.contact.tvaIntraCommunautaire != null) &&
                  (annonce.contact.siret != null))
              ? Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: DetailSiretWidget(annonce, heightPadding),
                )
              : SizedBox.shrink(),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: DetailPropAnnoncesWidget(annonce, heightPadding),
          ),
          SizedBox(height: 90),
        ],
      ),
    );
  }

  Widget _buildDescription() {
    var document;
    if (annonce.descriptif != null) {
      document = htmlparser.parse(annonce.descriptif).firstChild.text;
    }
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(annonce.titre ?? "", style: AppStyles.titleNormal),
          SizedBox(height: heightPadding),
          annonce.affichePrix ? _showPrize() : SizedBox.shrink(),
          Row(
            children: [
              Switch(
                  activeColor: AppColors.defaultColor,
                  value: _suivi,
                  onChanged: (value) {
                    setState(() {
                      _suivi = value;
                    });
                  }),
              SizedBox(width: 10),
              Text(
                "Suivre le prix de ce bien",
                style: AppStyles.textNormal,
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
              ),
            ],
          ),
          _buildCaracteristiques(),
          _containsCommodity() ? _buildCommodity() : SizedBox.shrink(),
          Divider(color: AppColors.hint),
          annonce.copropriete != null ? _buildCoproprio() : SizedBox.shrink(),
          Text("Description", style: AppStyles.titleStyle),
          (document != null)
              ? SizedBox(height: heightPadding)
              : SizedBox.shrink(),
          (document != null)
              ? ReadMoreText(
                  document ?? "",
                  trimLines: 5,
                  style: AppStyles.textDescriptionStyle,
                  colorClickableText: AppColors.defaultColor,
                  trimMode: TrimMode.Line,
                  trimCollapsedText: 'En savoir plus',
                  trimExpandedText: 'Moins',
                  moreStyle: AppStyles.smallTitleStylePink,
                )
              : SizedBox.shrink(),
          ((annonce.commune.latitude != null) &&
                  (annonce.commune.latitude != null))
              ? _buildLocalization()
              : SizedBox.shrink(),
          SizedBox(height: heightPadding),
          Divider(color: AppColors.hint),
          SizedBox(height: heightPadding),
          Text("Diagnostics", style: AppStyles.titleStyle),
          SizedBox(height: heightPadding),
          SizedBox(height: heightPadding),
          DetailDpeWidget(annonce),
          SizedBox(height: heightPadding),
          DetailGesWidget(annonce),
          //TODO: Add this think when we get VENC and everything about bidding clear
          /*_fakeItem.genre == "VENTE AUX ENCHÈRES EN LIGNE"
              ? DetailEnchereHorairesWidget(_fakeItem, heightPadding)
              : _fakeItem.genre == "E-VENTE"
                  ? DetailEnchereHorairesWidget(_fakeItem, heightPadding)
                  : SizedBox.shrink(),*/
        ]);
  }

  Widget _buildLocalization() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: heightPadding),
        Divider(color: AppColors.hint),
        SizedBox(height: heightPadding),
        Text("Localisation", style: AppStyles.titleStyle),
        SizedBox(height: heightPadding),
        Container(
          height: 200,
          width: double.infinity,
          child: FlutterMap(
            options: MapOptions(
              interactiveFlags: InteractiveFlag.pinchZoom,
              center:
                  LatLng(annonce.commune.latitude, annonce.commune.longitude),
              enableMultiFingerGestureRace: false,
              adaptiveBoundaries: false,
              allowPanning: false,
              slideOnBoundaries: false,
              zoom: 13.0,
            ),
            layers: [
              TileLayerOptions(
                urlTemplate:
                    "https://tiles.notariat.services/osm/{z}/{x}/{y}.png",
              ),
              MarkerLayerOptions(
                markers: [
                  Marker(
                    point: LatLng(
                        annonce.commune.latitude, annonce.commune.longitude),
                    builder: (ctx) => Container(
                      child: FaIcon(
                        FontAwesomeIcons.mapMarkerAlt,
                        color: AppColors.defaultColor,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _showPrize() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              annonce.prixLigne1 == null
                  ? ""
                  : annonce.prixLigne1.replaceAll("&euro;", "€"),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: AppStyles.titleStyle,
            ),
            annonce.prixEnBaisse == null
                ? SizedBox.shrink()
                : (annonce.prixEnBaisse
                    ? Container(
                        alignment: Alignment.topLeft,
                        child: FaIcon(
                          FontAwesomeIcons.arrowDown,
                          color: AppColors.greenColor,
                          size: 10,
                        ),
                      )
                    : SizedBox.shrink()),
            SizedBox(width: 5),
            InkWell(
              onTap: () {
                _showHonoraire(
                    annonce.prixLigne1,
                    annonce.prixLigne2,
                    annonce.prixLigne3,
                    annonce.typeVente,
                    annonce.contact.nom,
                    annonce.prixEnBaisse == null
                        ? false
                        : annonce.prixEnBaisse);
              },
              child: Image(
                image: AssetImage(AppIcons.info),
                color: AppColors.defaultColor,
                alignment: Alignment.center,
              ),
            ),
          ],
        ),
        (annonce.typeVenteCode == "VENC") ||
                (annonce.typeVente == "E-Vente") ||
                (annonce.typeVente == "Vente aux enchères en ligne")
            ? annonce.prixLigne3 == null
                ? SizedBox.shrink()
                : Text(annonce.prixLigne3, style: AppStyles.locationAnnonces)
            : SizedBox.shrink(),
        SizedBox(height: heightPadding),
      ],
    );
  }

  Widget _buildCaracteristiques() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Divider(color: AppColors.hint),
        SizedBox(height: heightPadding),
        Text("Caractéristiques", style: AppStyles.titleStyle),
        SizedBox(height: heightPadding),
        buildCaracteristiqueDetail(annonce),
        SizedBox(height: heightPadding),
      ],
    );
  }

  //check if api return provide commodities for annonce
  bool _containsCommodity() {
    bool valid = false;
    if (annonce.caracteristiques.complements.isEmpty) {
      valid = false;
    } else {
      annonce.caracteristiques.complements.forEach((element) {
        if (element.key == "COMMODITE_COMMERCES") {
          valid = true;
        }
        if (element.key == "COMMODITE_ECOLE") {
          valid = true;
        }
        if (element.key == "COMMODITE_SERVICES") {
          valid = true;
        }
        if (element.key == "COMMODITE_CENTRE_VILLE") {
          valid = true;
        }
        if (element.key == "COMMODITE_GARE") {
          valid = true;
        }
        if (element.key == "COMMODITE_METRO") {
          valid = true;
        }
      });
    }
    return valid;
  }

  Widget _buildCommodity() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Divider(color: AppColors.hint),
        SizedBox(height: heightPadding),
        Text("Les +", style: AppStyles.titleStyle),
        SizedBox(height: heightPadding),
        buildPlusDetail(annonce),
        SizedBox(height: heightPadding),
      ],
    );
  }

  Widget _buildCoproprio() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _bienCopropriete(),
        SizedBox(height: heightPadding),
      ],
    );
  }

  _showHonoraire(String ligne1, String ligne2, String ligne3, String type,
      String nom, bool prixEnBaisse) {
    showBarModalBottomSheet(
        context: context,
        expand: false,
        enableDrag: true,
        builder: (context) => HonorairesBottomSheetWidget(
            ligne1, ligne2, ligne3, type, nom, prixEnBaisse));
  }

  Widget _bienCopropriete() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: heightPadding),
          Text("Bien en copropriété",
              style: AppStyles.titleStyle,
              maxLines: 2,
              overflow: TextOverflow.ellipsis),
          SizedBox(height: 20),
          Padding(
            padding: EdgeInsets.only(right: 25, left: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text("Bien soumis à copropriété",
                      style: AppStyles.hintSearch,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis),
                ),
                Text("Oui", style: AppStyles.textNormal),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(right: 25, left: 15),
            child: Divider(color: AppColors.hint.withOpacity(0.6)),
          ),
          Padding(
            padding: EdgeInsets.only(right: 25, left: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text("Nbre de lots de la copropriété",
                      style: AppStyles.hintSearch,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis),
                ),
                Text(annonce.copropriete.nbLot.toString(),
                    style: AppStyles.textNormal,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(right: 25, left: 15),
            child: Divider(
              color: AppColors.hint.withOpacity(0.6),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(right: 25, left: 15),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(
                      "Montant des charges prévisionnelles annuelles moyen",
                      style: AppStyles.hintSearch,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis),
                ),
                Text(annonce.copropriete.montantCharge.toString() + " €",
                    style: AppStyles.textNormal,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(right: 25, left: 15),
            child: Divider(
              color: AppColors.hint.withOpacity(0.6),
            ),
          ),
          SizedBox(height: heightPadding),
          Divider(color: AppColors.hint),
        ],
      ),
    );
  }
}
