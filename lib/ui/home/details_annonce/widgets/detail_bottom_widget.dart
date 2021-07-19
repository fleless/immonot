import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:immonot/constants/app_colors.dart';
import 'package:immonot/constants/app_icons.dart';
import 'package:immonot/constants/routes.dart';
import 'package:immonot/constants/styles/app_styles.dart';
import 'package:immonot/models/fake/fakeResults.dart';
import 'package:immonot/models/responses/DetailAnnonceResponse.dart';
import 'package:immonot/ui/home/details_annonce/widgets/send_contact_message.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:page_indicator/page_indicator.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailBotttomWidget extends StatefulWidget {
  DetailAnnonceResponse fake;

  DetailBotttomWidget(DetailAnnonceResponse item) {
    this.fake = item;
  }

  @override
  State<StatefulWidget> createState() => _DetailBotttomWidgetState();
}

class _DetailBotttomWidgetState extends State<DetailBotttomWidget> {
  GlobalKey<PageContainerState> key = GlobalKey();
  DetailAnnonceResponse _item;

  @override
  void initState() {
    _item = widget.fake;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _buildContent();
  }

  Widget _buildContent() {
    return _buildBottom();
  }

  Widget _buildBottom() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        height: 70,
        color: AppColors.defaultColor,
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                children: [
                  _item.typeVente == "Location"
                      ? _phoneCall()
                      : _item.typeVente == "Viager"
                          ? _phoneCall()
                          : _item.typeVente == "Achat"
                              ? _phoneCall()
                              : _biddingWidget(),
                  InkWell(
                    splashColor: AppColors.white,
                    onTap: () {
                      showCupertinoModalBottomSheet(
                        context: context,
                        expand: false,
                        enableDrag: true,
                        builder: (context) =>
                            SendContactMessageDialog(_item.oidAnnonce),
                      );
                    },
                    child: Column(
                      children: [
                        FaIcon(FontAwesomeIcons.solidPaperPlane,
                            color: _item.contact != null
                                ? AppColors.white
                                : AppColors.white.withOpacity(0.5)),
                        Text("Envoyer un e-mail",
                            style: AppStyles.detailsBottomStyle)
                      ],
                    ),
                  ),
                  InkWell(
                    splashColor: AppColors.white,
                    onTap: () {},
                    child: Column(
                      children: [
                        FaIcon(FontAwesomeIcons.solidHeart,
                            color: AppColors.white.withOpacity(0.6)),
                        Text("Sauvegarder", style: AppStyles.detailsBottomStyle)
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _biddingWidget() {
    return InkWell(
      splashColor: AppColors.white,
      onTap: () {},
      child: Column(
        children: [
          FaIcon(FontAwesomeIcons.hammer, color: AppColors.white),
          Text("Participer à la vente", style: AppStyles.detailsBottomStyle)
        ],
      ),
    );
  }

  Widget _phoneCall() {
    return InkWell(
      splashColor:
          _item.contact.tel == null ? AppColors.white : AppColors.white,
      onTap: () {
        _item.contact.tel != null ? _callPhone(_item.contact.tel) : null;
      },
      child: Column(
        children: [
          FaIcon(FontAwesomeIcons.phone,
              color: _item.contact.tel == null
                  ? AppColors.white.withOpacity(0.5)
                  : AppColors.white),
          Text("Contacter", style: AppStyles.detailsBottomStyle)
        ],
      ),
    );
  }

  void _callPhone(String phone) async => await canLaunch("tel:" + phone)
      ? await launch("tel:" + phone)
      : throw 'Could not launch';
}
