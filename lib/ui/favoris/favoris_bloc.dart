import 'dart:async';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:immonot/models/responses/get_favoris_response.dart';
import 'package:immonot/network/repository/favoris_repository.dart';

class FavorisBloc extends Disposable {
  final controller = StreamController();
  final _favorisRepository = FavorisRepository();

  Future<GetFavorisResponse> getFavoris(int pageId) async {
    return await _favorisRepository.getFavoris(pageId);
  }

  Future<bool> deleteFavoris(String idAnnonce) async {
    return _favorisRepository.deleteFavoris(idAnnonce);
  }

  Future<bool> deleteFavorisWithIdFavoris(String idFavoris) async {
    return _favorisRepository.deleteFavorisWithIdFavoris(idFavoris);
  }

  Future<bool> addFavoris(String idAnnonce) async {
    return _favorisRepository.addFavoris(idAnnonce);
  }

  dispose() {
    controller.close();
  }
}
