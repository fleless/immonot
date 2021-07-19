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
import 'package:immonot/models/fake/fake_list.dart';
import 'package:immonot/models/responses/DetailAnnonceResponse.dart';
import 'package:page_indicator/page_indicator.dart';
import 'package:url_launcher/url_launcher.dart';
import "dart:ui" as ui;

class DetailSiretWidget extends StatefulWidget {
  DetailAnnonceResponse fake;
  double heightPadding;

  DetailSiretWidget(DetailAnnonceResponse item, double heightPadding) {
    this.fake = item;
    this.heightPadding = heightPadding;
  }

  @override
  State<StatefulWidget> createState() => _DetailSiretWidgetState();
}

class _DetailSiretWidgetState extends State<DetailSiretWidget> {
  GlobalKey<PageContainerState> key = GlobalKey();
  DetailAnnonceResponse _fakeItem;

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
        children: [
          SizedBox(height: widget.heightPadding),
          Divider(color: AppColors.hint),
          SizedBox(height: widget.heightPadding),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("SIRET \n" +
                  (_fakeItem.contact.siret == null
                      ? "Non communiqué"
                      : _fakeItem.contact.siret)),
              Text("TVA intra-communautaire : \n" +
                  (_fakeItem.contact.tvaIntraCommunautaire == null
                      ? "Non communiqué"
                      : _fakeItem.contact.tvaIntraCommunautaire)),
            ],
          ),
          SizedBox(height: widget.heightPadding),
        ],
      ),
    );
  }
}
