import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:immonot/constants/app_colors.dart';
import 'package:immonot/constants/styles/app_styles.dart';
import 'package:immonot/models/fake/fakeResults.dart';
import 'package:immonot/models/fake/fake_json_response.dart';
import 'package:immonot/models/fake/fake_list.dart';
import 'package:page_indicator/page_indicator.dart';

class DetailPropAnnoncesWidget extends StatefulWidget {
  FakeResults fake;
  double heightPadding;

  DetailPropAnnoncesWidget(FakeResults item, double heightPadding) {
    this.fake = item;
    this.heightPadding = heightPadding;
  }

  @override
  State<StatefulWidget> createState() => _DetailPropAnnoncesWidgetState();
}

class _DetailPropAnnoncesWidgetState extends State<DetailPropAnnoncesWidget> {
  GlobalKey<PageContainerState> key = GlobalKey();
  FakeResults _fakeItem;
  List<FakeJsonResponse> fakeAnnonces = <FakeJsonResponse>[];

  @override
  void initState() {
    super.initState();
    _fakeItem = widget.fake;
    var res = jsonDecode(annonces.toString()) as List;
    fakeAnnonces = res.map((x) => FakeJsonResponse.fromJson(x)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return _buildContent();
  }

  Widget _buildContent() {
    return Container(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Ces biens peuvent aussi vous intéresser", style: AppStyles.titleStyle),
          _buildList(),
        ],
      ),
    );
  }

  Widget _buildList() {
    return Container(
      height: 330,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: fakeAnnonces.length,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            var item = fakeAnnonces[index];
            return InkWell(
              onTap: () => {},
              child: Container(
                width: 190,
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        height: 222,
                        child: Stack(
                          children: [
                            Container(
                              height: double.infinity,
                              child: Card(
                                clipBehavior: Clip.antiAliasWithSaveLayer,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                elevation: 5,
                                child: Image.network(item.photo,
                                    fit: BoxFit.fitHeight),
                              ),
                            ),
                            Positioned(
                              top: 15.0,
                              right: 15.0,
                              child: CircleAvatar(
                                  child: FaIcon(FontAwesomeIcons.solidHeart,
                                      color: AppColors.default_black, size: 18),
                                  radius: 17.0,
                                  backgroundColor: AppColors.white),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 5, left: 10, right: 10),
                      child: RichText(
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        text: TextSpan(
                          children: <TextSpan>[
                            TextSpan(
                                text: item.genre,
                                style: item.genre == "ACHAT"
                                    ? AppStyles.typeAnnoncesAchat
                                    : item.genre == "LOCATION"
                                    ? AppStyles.typeAnnoncesLocation
                                    : AppStyles
                                    .typeAnnoncesVenteAuxEncheres),
                            TextSpan(
                                text: ' - ',
                                style: AppStyles.genreAnnonces),
                            TextSpan(
                                text: item.type,
                                style: AppStyles.genreAnnonces)
                          ],
                        ),
                      ),
                    ),
                    Padding(
                        padding: EdgeInsets.only(top: 6, left: 10, right: 10),
                        child: Text(
                          item.location,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          style: AppStyles.locationAnnonces,
                        )),
                    Padding(
                        padding: EdgeInsets.only(top: 6, left: 10, right: 10),
                        child: Text(
                          item.prize + " €",
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: AppStyles.titleStyle,
                        )),
                  ],
                ),
              ),
            );
          }),
    );
  }

}
