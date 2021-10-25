import 'package:immonot/models/requests/create_account_request.dart';
import 'package:immonot/models/responses/get_profile_response.dart';
import 'package:immonot/models/responses/loginResponse.dart';
import 'package:immonot/models/responses/newsletter_response.dart';
import 'package:immonot/network/api/profil_api_provider.dart';

class ProfilRepository {
  ProfilApiProvider _apiProvider = new ProfilApiProvider();

  Future<NewsLetterResponse> getLastNewsletterUrl() {
    return _apiProvider.getLastNewsletterUrl();
  }

  Future<int> createAccount(CreateAccountRequest request) async {
    return _apiProvider.createAccount(request);
  }

  Future<LoginResponse> login(String email, String password) async {
    return _apiProvider.login(email, password);
  }

  Future<bool> forgottenPassword(String email) async {
    return _apiProvider.forgottenPassword(email);
  }

  Future<GetProfileResponse> getProfileInfos() async {
    return _apiProvider.getProfileInfos();
  }

  Future<bool> resetPassword(String newPassword, String oldPassword) async {
    return _apiProvider.resetPassword(newPassword, oldPassword);
  }

  Future<bool> editParams(bool newsletterImmonot, bool magazine,
      bool infosPartenairesImmonot, bool infosPartenairesMdn) async {
    return _apiProvider.editParams(newsletterImmonot, magazine,
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
    return _apiProvider.editProfile(
        civilite, prenom, nom, email, zip, telephone, jeSuis, jeSouhaite);
  }

  Future<bool> deleteAccount(String internauteOid) async {
    return _apiProvider.deleteAccount(internauteOid);
  }
}
