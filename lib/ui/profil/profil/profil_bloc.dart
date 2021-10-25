import 'dart:async';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:immonot/models/requests/create_account_request.dart';
import 'package:immonot/models/responses/get_profile_response.dart';
import 'package:immonot/models/responses/loginResponse.dart';
import 'package:immonot/network/repository/profil_repository.dart';

class ProfilBloc extends Disposable {
  final controller = StreamController();
  final ProfilRepository _profilRepository = ProfilRepository();

  Future<int> createAccount(CreateAccountRequest request) async {
    return _profilRepository.createAccount(request);
  }

  Future<GetProfileResponse> getProfileInfos() async {
    return _profilRepository.getProfileInfos();
  }

  Future<bool> resetPassword(String newPassword, String oldPassword) async {
    return _profilRepository.resetPassword(newPassword, oldPassword);
  }

  Future<bool> editParams(bool newsletterImmonot, bool magazine,
      bool infosPartenairesImmonot, bool infosPartenairesMdn) async {
    return _profilRepository.editParams(newsletterImmonot, magazine,
        infosPartenairesImmonot, infosPartenairesMdn);
  }

  Future<bool> editProfile(
      String civilite,
      String prenom,
      String nom,
      String email,
      String zip,
      String telephone,
      bool jeSuis,
      String jeSouhaite) async {
    return _profilRepository.editProfile(
        civilite, prenom, nom, email, zip, telephone, jeSuis, jeSouhaite);
  }

  Future<bool> deleteAccount(String internauteOid) async {
    return _profilRepository.deleteAccount(internauteOid);
  }

  dispose() {
    controller.close();
  }
}
