import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:immonot/constants/app_colors.dart';
import 'package:page_indicator/page_indicator.dart';

class PhotoViewScreenWidget extends StatefulWidget {
  List<String> image;
  int index;

  PhotoViewScreenWidget(List<String> image, int index) {
    this.image = image;
    this.index = index;
  }

  @override
  State<StatefulWidget> createState() => _PhotoViewScreenWidgetState();
}

class _PhotoViewScreenWidgetState extends State<PhotoViewScreenWidget> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  List<String> _image;
  GlobalKey<PageContainerState> key = GlobalKey();
  PageController controller =
      PageController(viewportFraction: 1, keepPage: true);

  @override
  void initState() {
    super.initState();
    _image = widget.image;
    controller = PageController(initialPage: widget.index);
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
      backgroundColor: AppColors.default_black,
      //drawer: DrawerWidget(),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        child: _buildContent(),
      ),
    );
  }

  Widget _buildContent() {
    return Stack(
      children: [
        Container(
          padding: EdgeInsets.symmetric(vertical: 130),
          child: PageIndicatorContainer(
            key: key,
            child: PageView.builder(
                controller: controller,
                scrollDirection: Axis.horizontal,
                itemCount: _image.isEmpty ? 1 : _image.length,
                itemBuilder: (context, index) {
                  return Container(
                    height: double.infinity,
                    width: double.infinity,
                    child: _image.isEmpty
                        ? Image.network(
                            "https://www.generationsforpeace.org/wp-content/uploads/2018/03/empty.jpg",
                            fit: BoxFit.cover)
                        : Image.network(_image[index], fit: BoxFit.cover),
                  );
                }),
            align: IndicatorAlign.bottom,
            length: _image.length,
            indicatorSpace: 10.0,
            padding: const EdgeInsets.all(10),
            indicatorColor: AppColors.grey,
            indicatorSelectorColor: AppColors.defaultColor,
            shape: IndicatorShape.circle(size: 8),
          ),
        ),
        Positioned(
          top: 75.0,
          right: 30.0,
          child: InkWell(
            onTap: () => Modular.to.pop(),
            child: FaIcon(
              FontAwesomeIcons.times,
              color: AppColors.white,
            ),
          ),
        ),
      ],
    );
    /*Stack(
      children: [
        // wecan show all photos and swipe wih this library
        PhotoView(
          imageProvider: NetworkImage(_image),
        ),
        Positioned(
          top: 75.0,
          right: 30.0,
          child: InkWell(
            onTap: () => Modular.to.pop(),
            child: FaIcon(
              FontAwesomeIcons.times,
              color: AppColors.white,
            ),
          ),
        ),
      ],
    );*/
  }
}
