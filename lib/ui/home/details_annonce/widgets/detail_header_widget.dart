import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:immonot/constants/app_colors.dart';
import 'package:immonot/constants/app_icons.dart';
import 'package:immonot/constants/routes.dart';
import 'package:immonot/constants/styles/app_styles.dart';
import 'package:immonot/models/enum/bookmark_params_model.dart';
import 'package:immonot/models/responses/DetailAnnonceResponse.dart';
import 'package:immonot/ui/home/details_annonce/widgets/send_contact_message.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:page_indicator/page_indicator.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

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
  GlobalKey _key = GlobalKey();
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
                    ? 2
                    : _fakeItem.photo.galerie.length + 1,
                itemBuilder: (context, index) {
                  return index ==
                          (_fakeItem.photo.galerie.isEmpty
                              ? 1
                              : _fakeItem.photo.galerie.length)
                      ? (_addPictureWithButtons(_fakeItem.photo.galerie.isEmpty
                          ? (_fakeItem.photo.principale == null
                              ? "https://www.generationsforpeace.org/wp-content/uploads/2018/03/empty.jpg"
                              : _fakeItem.photo.principale)
                          : _fakeItem.photo.galerie[0].img))
                      : GestureDetector(
                          onTap: () => Modular.to.pushNamed(Routes.photoView,
                              arguments: {
                                'image': _fakeItem.photo.galerie
                                    .map((e) => e.img)
                                    .toList(),
                                'index': index
                              }),
                          child: Container(
                            height: double.infinity,
                            width: double.infinity,
                            child: _fakeItem.photo.galerie.isEmpty
                                ? Image.network(
                                    _fakeItem.photo.principale == null
                                        ? "https://www.generationsforpeace.org/wp-content/uploads/2018/03/empty.jpg"
                                        : _fakeItem.photo.principale,
                                    fit: BoxFit.cover)
                                : Image.network(
                                    _fakeItem.photo.galerie[index].img,
                                    fit: BoxFit.cover),
                          ),
                        );
                }),
            align: IndicatorAlign.bottom,
            length: _fakeItem.photo.galerie.isEmpty
                ? 2
                : _fakeItem.photo.galerie.length + 1,
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
                Share.share(_fakeItem.lienImmonot,
                    subject:
                        'Un ami vous envoie une annonce depuis immonot.com');
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
        ],
      ),
    );
    // shape: IndicatorShape.roundRectangleShape(size: Size.square(12),cornerSize: Size.square(3)),
    // shape: IndicatorShape.oval(size: Size(12, 8)),
  }

  Widget _addPictureWithButtons(String imageUrl) {
    return Stack(
      children: [
        Container(
          foregroundDecoration: BoxDecoration(
            color: AppColors.default_black.withOpacity(0.7),
          ),
          height: double.infinity,
          width: double.infinity,
          child: Image.network(imageUrl, fit: BoxFit.cover),
        ),
        Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton.icon(
                key: _key,
                style: ElevatedButton.styleFrom(
                    elevation: 3,
                    onPrimary: AppColors.defaultColor,
                    primary: AppColors.defaultColor,
                    side: BorderSide(color: AppColors.defaultColor),
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    textStyle:
                        TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
                onPressed: () {
                  if (_fakeItem.contact.tel == null) {
                    return;
                  }
                  // We have to calculate the position of the widget that call this function
                  RenderBox box = _key.currentContext.findRenderObject();
                  Offset position = box.localToGlobal(Offset.zero);
                  showMenu(
                    context: context,
                    position: RelativeRect.fromLTRB(position.dx,
                        position.dy + 50, position.dx + 1, position.dy + 1),
                    items: [
                      PopupMenuItem(
                        child: GestureDetector(
                          onTap: () {
                            _callPhone(_fakeItem.contact.tel);
                          },
                          child: Center(
                            child: Text(
                              _fakeItem.contact.tel,
                              style: AppStyles.textDescriptionBoldStyle,
                            ),
                          ),
                        ),
                      ),
                    ],
                    elevation: 8.0,
                  );
                },
                icon: Icon(
                  Icons.phone,
                  color: AppColors.white,
                  size: 15,
                ),
                label: Text(
                  "Afficher le téléphone",
                  style: AppStyles.whiteTitleStyle,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                    elevation: 3,
                    onPrimary: AppColors.defaultColor,
                    primary: AppColors.defaultColor,
                    side: BorderSide(color: AppColors.defaultColor),
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    textStyle:
                        TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
                onPressed: () {
                  showCupertinoModalBottomSheet(
                    context: context,
                    expand: false,
                    enableDrag: true,
                    builder: (context) =>
                        SendContactMessageDialog(_fakeItem.oidAnnonce),
                  );
                },
                icon: Icon(
                  Icons.send,
                  color: AppColors.white,
                  size: 15,
                ),
                label: Text(
                  "Envoyer un mail",
                  style: AppStyles.whiteTitleStyle,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _callPhone(String phone) async => await canLaunch("tel:" + phone)
      ? await launch("tel:" + phone)
      : throw 'Could not launch';
}
