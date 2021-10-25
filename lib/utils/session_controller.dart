import 'package:flutter_modular/flutter_modular.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:immonot/constants/app_constants.dart';
import 'package:immonot/utils/shared_preferences.dart';

class SessionController {
  final sharedPref = Modular.get<SharedPref>();

  Future<Map<String, String>> getHeader() async {
    String token = await sharedPref.read(AppConstants.TOKEN_KEY);
    return {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      "Authorization": "Bearer " + token,
    };
  }

  tokenExpired() async {
    await sharedPref.remove(AppConstants.TOKEN_KEY);
  }

  disconnectUser() async {
    await sharedPref.remove(AppConstants.TOKEN_KEY);
    await sharedPref.remove(AppConstants.PASSWORD_KEY);
    await sharedPref.remove(AppConstants.EMAIL_KEY);
  }

  Future<bool> isSessionConnected() async {
    return ((await sharedPref.read(AppConstants.PASSWORD_KEY) != null) &&
            (await sharedPref.read(AppConstants.EMAIL_KEY) != null) &&
            (await sharedPref.read(AppConstants.TOKEN_KEY) != null))
        ? true
        : false;
  }
}
