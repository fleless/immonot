import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:immonot/constants/app_colors.dart';
import 'package:immonot/constants/app_icons.dart';
import 'package:immonot/constants/routes.dart';
import 'package:immonot/constants/styles/app_styles.dart';
import 'package:immonot/models/fake/fakeResults.dart';
import 'package:page_indicator/page_indicator.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailBotttomWidget extends StatefulWidget {
  FakeResults fake;

  DetailBotttomWidget(FakeResults item) {
    this.fake = item;
  }

  @override
  State<StatefulWidget> createState() => _DetailBotttomWidgetState();
}

class _DetailBotttomWidgetState extends State<DetailBotttomWidget> {
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
                  _fakeItem.genre == "ACHAT"
                      ? _phoneCall()
                      : _fakeItem.genre == "LOCATION"
                          ? _phoneCall()
                          : _fakeItem.genre == "VIAGER"
                              ? _phoneCall()
                              : _biddingWidget(),
                  InkWell(
                    splashColor: AppColors.white,
                    onTap: () {
                      _sendMail();
                    },
                    child: Column(
                      children: [
                        FaIcon(FontAwesomeIcons.solidPaperPlane,
                            color: AppColors.white),
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
      onTap: () {
      },
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
      splashColor: AppColors.white,
      onTap: () {
        _callPhone();
      },
      child: Column(
        children: [
          FaIcon(FontAwesomeIcons.phone, color: AppColors.white),
          Text("Contacter", style: AppStyles.detailsBottomStyle)
        ],
      ),
    );
  }

  void _callPhone() async => await canLaunch("tel:06295544332")
      ? await launch("tel:06295544332")
      : throw 'Could not launch';

  void _sendMail() async => await canLaunch("mailto:fahmi.barguellil@esprit.tn")
      ? await launch("mailto:fahmi.barguellil@esprit.tn")
      : throw 'Could not launch';
}
