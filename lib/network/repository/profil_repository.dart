import 'package:immonot/models/responses/newsletter_response.dart';
import 'package:immonot/network/api/profil_api_provider.dart';

class ProfilRepository {
  ProfilApiProvider _apiProvider = new ProfilApiProvider();

  Future<NewsLetterResponse> getLastNewsletterUrl() {
    return _apiProvider.getLastNewsletterUrl();
  }
}
