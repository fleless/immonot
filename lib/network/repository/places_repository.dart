import 'package:immonot/models/responses/places_response.dart';
import 'package:immonot/network/api/places_api_provider.dart';

class PlacesRepository {
  PlacesApiProvider _apiProvider = new PlacesApiProvider();

  Future<List<PlacesResponse>> searchPlaces(String item) {
    return _apiProvider.searchPlaces(item);
  }

  Future<PlacesResponse> searchDepartment(String codeDep) async {
    return _apiProvider.searchDepartment(codeDep);
  }

  Future<PlacesResponse> searchCommune(String oidCommune) async {
    return _apiProvider.searchCommune(oidCommune);
  }
}
