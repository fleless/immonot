import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:immonot/constants/app_colors.dart';
import 'package:photo_view/photo_view.dart';

class PhotoViewScreenWidget extends StatefulWidget {
  String image;

  PhotoViewScreenWidget(String image) {
    this.image = image;
  }

  @override
  State<StatefulWidget> createState() => _PhotoViewScreenWidgetState();
}

class _PhotoViewScreenWidgetState extends State<PhotoViewScreenWidget> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  String _image;

  @override
  void initState() {
    super.initState();
    _image = widget.image;
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
    );
  }
}
