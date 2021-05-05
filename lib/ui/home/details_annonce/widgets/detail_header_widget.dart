import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:immonot/constants/app_colors.dart';
import 'package:immonot/constants/app_icons.dart';
import 'package:immonot/constants/routes.dart';
import 'package:immonot/models/fake/fakeResults.dart';
import 'package:page_indicator/page_indicator.dart';

class DetailHeaderWidget extends StatefulWidget {
  FakeResults fake;

  DetailHeaderWidget(FakeResults item) {
    this.fake = item;
  }

  @override
  State<StatefulWidget> createState() => _DetailHeaderWidgetState();
}

class _DetailHeaderWidgetState extends State<DetailHeaderWidget> {
  GlobalKey<PageContainerState> key = GlobalKey();
  FakeResults _fakeItem;

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
                scrollDirection: Axis.horizontal,
                itemCount: _fakeItem.numberPictures,
                itemBuilder: (context, index) {
                  return Container(
                    height: double.infinity,
                    width: double.infinity,
                    child: Image.network(_fakeItem.picture, fit: BoxFit.fill),
                  );
                }),
            align: IndicatorAlign.bottom,
            length: _fakeItem.numberPictures,
            indicatorSpace: 10.0,
            padding: const EdgeInsets.all(10),
            indicatorColor: AppColors.grey,
            indicatorSelectorColor: AppColors.defaultColor,
            shape: IndicatorShape.circle(size: 10),
          ),
          Positioned(
            top: 75.0,
            right: 20.0,
            child: InkWell(
              onTap: () {
                //bug to select first image without swiping first time controller null
                /*print(double.parse(
                    key.currentState.currentPage.toStringAsFixed(0)));
                int ind =
                    int.parse(key.currentState.currentPage.toStringAsFixed(0));*/
                Modular.to.pushNamed(Routes.photoView,
                    arguments: {'image': _fakeItem.picture});
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
