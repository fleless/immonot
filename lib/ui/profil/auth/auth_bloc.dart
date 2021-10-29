import 'dart:async';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:immonot/models/responses/loginResponse.dart';
import 'package:immonot/models/responses/newsletter_response.dart';
import 'package:immonot/network/repository/devices_repository.dart';
import 'package:immonot/network/repository/profil_repository.dart';

class AuthBloc extends Disposable {
  final controller = StreamController();
  final ProfilRepository _profilRepository = ProfilRepository();
  final DevicesRepository _devicesRepository = DevicesRepository();

  Future<NewsLetterResponse> getLastNewsLetter() async {
    NewsLetterResponse response =
        await _profilRepository.getLastNewsletterUrl();
    return response;
  }

  Future<LoginResponse> login(String email, String password) async {
    return _profilRepository.login(email, password);
  }

  Future<bool> forgottenPassword(String email) async {
    return _profilRepository.forgottenPassword(email);
  }

  Future<bool> addDevice() async {
    return _devicesRepository.addDevice();
  }

  Future<bool> deleteDevice() async {
    return _devicesRepository.deleteDevice();
  }

  dispose() {
    controller.close();
  }
}
