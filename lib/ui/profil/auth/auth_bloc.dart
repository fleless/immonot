import 'dart:async';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:immonot/models/responses/newsletter_response.dart';
import 'package:immonot/network/api/profil_api_provider.dart';
import 'package:immonot/network/repository/profil_repository.dart';

class AuthBloc extends Disposable {
  final controller = StreamController();
  final ProfilRepository _profilRepository = ProfilRepository();

  Future<NewsLetterResponse> getLastNewsLetter() async {
    NewsLetterResponse response =
        await _profilRepository.getLastNewsletterUrl();
    return response;
  }

  dispose() {
    controller.close();
  }
}
