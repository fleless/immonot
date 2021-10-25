import 'package:immonot/models/requests/create_alerte_request.dart';
import 'package:immonot/models/requests/search_request.dart';
import 'package:immonot/models/responses/DetailAnnonceResponse.dart';
import 'package:immonot/models/responses/SearchResponse.dart';
import 'package:immonot/network/api/search_annonces_api_provider.dart';

class SearchAnnoncesRepository {
  SearchAnnoncesApiProvider _apiProvider = new SearchAnnoncesApiProvider();

  Future<SearchResponse> searchAnnonces(
      int pageId, SearchRequest request, String sort, Recherche recherche) {
    return _apiProvider.searchAnnonces(pageId, request, sort, recherche);
  }

  Future<DetailAnnonceResponse> getDetailAnnonce(String oidAnnonce) async {
    return _apiProvider.getDetailAnnonce(oidAnnonce);
  }

  Future<String> contactAnnonce(String oidAnnonce, String nom, String prenom,
      int phone, String email, String message) async {
    return _apiProvider.contactAnnonce(
        oidAnnonce, nom, prenom, phone, email, message);
  }
}
