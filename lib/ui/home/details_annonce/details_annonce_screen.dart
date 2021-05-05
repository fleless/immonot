import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:immonot/constants/app_colors.dart';
import 'package:immonot/constants/app_icons.dart';
import 'package:immonot/constants/app_images.dart';
import 'package:immonot/constants/styles/app_styles.dart';
import 'package:immonot/models/fake/fakeResults.dart';
import 'package:immonot/ui/home/details_annonce/widgets/detail_bottom_widget.dart';
import 'package:immonot/ui/home/details_annonce/widgets/detail_caracteristique_widget.dart';
import 'package:immonot/ui/home/details_annonce/widgets/detail_contact_widget.dart';
import 'package:immonot/ui/home/details_annonce/widgets/detail_dpe_widget.dart';
import 'package:immonot/ui/home/details_annonce/widgets/detail_enchere_horaires.dart';
import 'package:immonot/ui/home/details_annonce/widgets/detail_ges_widget.dart';
import 'package:immonot/ui/home/details_annonce/widgets/detail_header_widget.dart';
import 'package:immonot/ui/home/details_annonce/widgets/detail_plus_widget.dart';
import 'package:immonot/ui/home/details_annonce/widgets/detail_proposition_annonces.dart';
import 'package:immonot/ui/home/details_annonce/widgets/detail_siret_widget.dart';
import 'package:immonot/ui/home/search_results/honoraires/honoraire_bottom_sheet.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:readmore/readmore.dart';

class DetailAnnonceWidget extends StatefulWidget {
  //For now wee pass type to static values until we get endpoint and change this with int id
  FakeResults idAnnonce;

  DetailAnnonceWidget(FakeResults id) {
    this.idAnnonce = id;
  }

  @override
  State<StatefulWidget> createState() => _DetailAnnonceWidgetState();
}

class _DetailAnnonceWidgetState extends State<DetailAnnonceWidget> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  FakeResults _fakeItem;
  final double heightPadding = 15;

  @override
  void initState() {
    super.initState();
    _fakeItem = widget.idAnnonce;
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
      body: Container(
        child: Stack(
          children: [
            SingleChildScrollView(
              child: _buildContent(),
            ),
            DetailBotttomWidget(_fakeItem),
          ],
        ),
      ),
    );
  }

  Widget _buildContent() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          DetailHeaderWidget(_fakeItem),
          SizedBox(height: heightPadding),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: _buildDescription(),
          ),
          DetailContactWidget(_fakeItem),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: DetailSiretWidget(_fakeItem, heightPadding),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: DetailPropAnnoncesWidget(_fakeItem, heightPadding),
          ),
          SizedBox(height: 90),
        ],
      ),
    );
  }

  Widget _buildDescription() {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
              "Titre de l'annonce exemple Maison à vendre à Bordeaux en Gironde (33200)",
              style: AppStyles.titleNormal),
          SizedBox(height: heightPadding),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _fakeItem.prize + " ",
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: AppStyles.titleStyle,
              ),
              _fakeItem.down
                  ? Container(
                      alignment: Alignment.topLeft,
                      child: FaIcon(
                        FontAwesomeIcons.arrowDown,
                        color: AppColors.greenColor,
                        size: 10,
                      ),
                    )
                  : SizedBox.shrink(),
              SizedBox(width: 5),
              InkWell(
                onTap: () {
                  _showHonoraire(_fakeItem);
                },
                child: Image(
                  image: AssetImage(AppIcons.info),
                  color: AppColors.defaultColor,
                  alignment: Alignment.center,
                ),
              ),
            ],
          ),
          _fakeItem.genre == "VENTE AUX ENCHÈRES EN LIGNE"
              ? Text("1er offre possible", style: AppStyles.locationAnnonces)
              : _fakeItem.genre == "E-VENTE"
                  ? Text("1er offre possible",
                      style: AppStyles.locationAnnonces)
                  : SizedBox.shrink(),
          SizedBox(height: heightPadding),
          Divider(color: AppColors.hint),
          SizedBox(height: heightPadding),
          Text("Caractéristiques", style: AppStyles.titleStyle),
          SizedBox(height: heightPadding),
          buildCaracteristiqueDetail(_fakeItem),
          SizedBox(height: heightPadding),
          Divider(color: AppColors.hint),
          SizedBox(height: heightPadding),
          Text("Les +", style: AppStyles.titleStyle),
          SizedBox(height: heightPadding),
          buildPlusDetail(_fakeItem),
          SizedBox(height: heightPadding),
          Divider(color: AppColors.hint),
          _bienCopropriete(),
          SizedBox(height: heightPadding),
          Text("Description", style: AppStyles.titleStyle),
          SizedBox(height: heightPadding),
          Text("Caudéran Centre", style: AppStyles.titleNormal),
          SizedBox(height: 5),
          ReadMoreText(
            'CAUDERAN Coup de cœur assuré pour cette belle maison offrant une grande pièce à vivre avec cuisine ouverte donnant sur un extérieur tout en intimité pour pouvoir profiter du jacuzzi,Quatre chambres avec placards ou dressing, une salle d\'eau, une salle de bains, un wc à chaque niveauMaison très fonctionnelle et idéalement placée, Garage, arrière cuisine avec coin buanderie, stationnement d\'une autre voiture sur la parcelle, portail automatique et visiophone.Nous contacter pour les visites au 06.62.39.84.44',
            trimLines: 5,
            style: AppStyles.textDescriptionStyle,
            colorClickableText: AppColors.defaultColor,
            trimMode: TrimMode.Line,
            trimCollapsedText: 'En savoir plus',
            trimExpandedText: 'Moins',
            moreStyle: AppStyles.smallTitleStylePink,
          ),
          SizedBox(height: heightPadding),
          Divider(color: AppColors.hint),
          SizedBox(height: heightPadding),
          Text("Localisation", style: AppStyles.titleStyle),
          SizedBox(height: heightPadding),
          Container(
            height: 200,
            width: double.infinity,
            child: Image.asset(AppImages.map, fit: BoxFit.fill),
          ),
          SizedBox(height: heightPadding),
          Divider(color: AppColors.hint),
          SizedBox(height: heightPadding),
          Text("Diagnostics", style: AppStyles.titleStyle),
          SizedBox(height: heightPadding),
          SizedBox(height: heightPadding),
          DetailDpeWidget(_fakeItem),
          SizedBox(height: heightPadding),
          DetailGesWidget(_fakeItem),
          _fakeItem.genre == "VENTE AUX ENCHÈRES EN LIGNE"
              ? DetailEnchereHorairesWidget(_fakeItem, heightPadding)
              : _fakeItem.genre == "E-VENTE"
                  ? DetailEnchereHorairesWidget(_fakeItem, heightPadding)
                  : SizedBox.shrink(),
        ]);
  }

  _showHonoraire(FakeResults item) {
    showBarModalBottomSheet(
        context: context,
        expand: false,
        enableDrag: true,
        builder: (context) => HonorairesBottomSheetWidget(item));
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
                Text("22",
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
                Text("2400.0 €",
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
