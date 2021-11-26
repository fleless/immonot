import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:immonot/constants/app_colors.dart';
import 'package:immonot/constants/app_icons.dart';
import 'package:immonot/constants/app_images.dart';
import 'package:immonot/constants/routes.dart';
import 'package:immonot/models/fake/fakeResults.dart';
import 'package:immonot/models/responses/DetailAnnonceResponse.dart';
import 'package:page_indicator/page_indicator.dart';
import 'package:share_plus/share_plus.dart';

class DetailHeaderWidget extends StatefulWidget {
  DetailAnnonceResponse fake;

  DetailHeaderWidget(DetailAnnonceResponse item) {
    this.fake = item;
  }

  @override
  State<StatefulWidget> createState() => _DetailHeaderWidgetState();
}

class _DetailHeaderWidgetState extends State<DetailHeaderWidget> {
  GlobalKey<PageContainerState> key = GlobalKey();
  DetailAnnonceResponse _fakeItem;
  PageController controller =
      PageController(viewportFraction: 1, keepPage: true);

  @override
  void initState() {
    super.initState();
    _fakeItem = widget.fake;
  }

  @override
  Widget build(BuildContext context) {
    return _buildHeader();
  }

  Widget _buildHeader() {
    return Container(
      height: 400,
      child: Stack(
        children: [
          PageIndicatorContainer(
            key: key,
            child: PageView.builder(
                controller: controller,
                scrollDirection: Axis.horizontal,
                itemCount: _fakeItem.photo.galerie.isEmpty
                    ? 1
                    : _fakeItem.photo.galerie.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () => Modular.to
                        .pushNamed(Routes.photoView, arguments: {
                      'image':
                          _fakeItem.photo.galerie.map((e) => e.img).toList(),
                      'index': index
                    }),
                    child: Container(
                      height: double.infinity,
                      width: double.infinity,
                      child: _fakeItem.photo.galerie.isEmpty
                          ? Image.network(
                              "https://www.generationsforpeace.org/wp-content/uploads/2018/03/empty.jpg",
                              fit: BoxFit.cover)
                          : Image.network(_fakeItem.photo.galerie[index].img,
                              fit: BoxFit.cover),
                    ),
                  );
                }),
            align: IndicatorAlign.bottom,
            length: _fakeItem.photo.galerie.length,
            indicatorSpace: 10.0,
            padding: const EdgeInsets.all(10),
            indicatorColor: AppColors.grey,
            indicatorSelectorColor: AppColors.defaultColor,
            shape: IndicatorShape.circle(size: 8),
          ),
          Positioned(
            top: 75.0,
            right: 20.0,
            child: InkWell(
              onTap: () {
                Share.share(
                    'testing the share functionality of immonot the link is https://www.woolha.com/media/2021/04/flutter-set-status-bar-color-brightness-transparency-1200x627.jpg ',
                    subject: 'subject test');
              },
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6.0),
                    color: AppColors.default_black.withOpacity(0.4)),
                child: Center(
                  child: Image.asset(AppIcons.share, color: AppColors.white),
                ),
              ),
            ),
          ),
          Positioned(
            top: 75.0,
            left: 20.0,
            child: InkWell(
              onTap: () {
                Modular.to.pop();
              },
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6.0),
                    color: AppColors.default_black.withOpacity(0.4)),
                child: Center(
                  child: FaIcon(
                    FontAwesomeIcons.times,
                    color: AppColors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
    // shape: IndicatorShape.roundRectangleShape(size: Size.square(12),cornerSize: Size.square(3)),
    // shape: IndicatorShape.oval(size: Size(12, 8)),
  }
}
