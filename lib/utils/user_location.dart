import 'package:flutter_modular/flutter_modular.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:immonot/constants/app_colors.dart';

class UserLocation extends Disposable {
  Position _currentPosition;
  String _currentAddress;
  final Geolocator geolocator = Geolocator();
  bool serviceEnabled;

  /// Determine the current position of the device.
  ///
  /// When the location services are not enabled or permissions
  /// are denied the `Future` will return an error.
  Future<Position> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      Geolocator.openLocationSettings();
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      Geolocator.openAppSettings();
       Fluttertoast.showToast(
          msg:
              "Vous avez refusez de nous fournir la permission de vous localiser.Vous pouvez changer les paramètres dans la section autorisation",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: AppColors.default_black,
          textColor: AppColors.white,
          fontSize: 16.0);
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.

    //Geolocator.getCurrentPosition().then((value) => showPosition(value));

    return await Geolocator.getCurrentPosition();
  }

  showPosition(Position pos) {
    Fluttertoast.showToast(
        msg: "user location is \n latitude: " +
            pos.latitude.toString() +
            " \n longitude: " +
            pos.longitude.toString(),
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: AppColors.default_black,
        textColor: AppColors.white,
        fontSize: 16.0);
  }

  Future<String> getUserAddress() async {
    Position position = await determinePosition();
    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    String address =
        placemarks.first.postalCode;
    print(address);
    return address;
  }

  @override
  void dispose() {}
}
