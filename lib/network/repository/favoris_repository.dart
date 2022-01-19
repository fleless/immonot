import 'package:immonot/models/responses/get_favoris_response.dart';
import 'package:immonot/network/api/favoris_api_provider.dart';

class FavorisRepository {
  FavorisApiProvider _apiProvider = new FavorisApiProvider();

  Future<GetFavorisResponse> getFavoris(int pageId) {
    return _apiProvider.getFavoris(pageId);
  }

  Future<bool> deleteFavorisWithIdFavoris(String idFavoris) async {
    return _apiProvider.deleteFavorisWithIdFavoris(idFavoris);
  }

  Future<bool> deleteFavoris(String idAnnonce) async {
    return _apiProvider.deleteFavoris(idAnnonce);
  }

  Future<bool> addFavoris(String idAnnonce) async {
    return _apiProvider.addFavoris(idAnnonce);
  }

  Future<bool> editFavoris(String idAnnonce, bool suivrePrix) async {
    return _apiProvider.editFavoris(idAnnonce, suivrePrix);
  }

}
