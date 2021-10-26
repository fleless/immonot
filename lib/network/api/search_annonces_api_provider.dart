import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:immonot/constants/endpoints.dart';
import 'package:immonot/models/requests/create_alerte_request.dart';
import 'package:immonot/models/requests/search_request.dart';
import 'package:immonot/models/responses/DetailAnnonceResponse.dart';
import 'package:immonot/models/responses/SearchResponse.dart';
import 'package:immonot/models/responses/newsletter_response.dart';
import 'package:immonot/models/responses/places_response.dart';
import 'package:immonot/utils/session_controller.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class SearchAnnoncesApiProvider {
  final sessionController = Modular.get<SessionController>();
  final String searchAnnoncesEndPoint =
      Endpoints.CORE_URL + "immobilier/annonces/";
  final String detailAnnonceEndPoint =
      Endpoints.CORE_URL + "immobilier/annonces/";
  final String searchAnnoncesConnectedEndPoint =
      Endpoints.CORE_URL + "immonot/connect/annonces/";
  final String detailAnnonceConnectedEndPoint =
      Endpoints.CORE_URL + "immonot/connect/annonces/";
  final String contactNotaireEndPoint =
      Endpoints.CORE_URL + "immonot/contact-annonce";

  Dio _dio;

  SearchAnnoncesApiProvider() {
    if (_dio == null) {
      BaseOptions options = new BaseOptions(
          receiveDataWhenStatusError: true,
          connectTimeout: 60 * 1000, // 5 seconds
          receiveTimeout: 60 * 1000 // 5 seconds
          );

      _dio = new Dio(options);
      _dio.interceptors.add(PrettyDioLogger(
          requestHeader: true,
          requestBody: true,
          responseBody: true,
          responseHeader: true,
          error: true,
          compact: true,
          maxWidth: 90));
    }
  }

  Future<SearchResponse> searchAnnonces(
      int pageId, Recherche body, String sort) async {
    //Hack refeerences bug from backend
    if (body.references != null) if (body.references.isNotEmpty) {
      if (body.references[0] == "") {
        body.references.clear();
      }
    }
    try {
      bool connected = await sessionController.isSessionConnected();
      Map<String, String> header = connected
          ? await sessionController.getHeader()
          : {'content-Type': 'application/json', "Accept": "application/json"};
      Response response = await _dio.post(
          (connected
                  ? searchAnnoncesConnectedEndPoint
                  : searchAnnoncesEndPoint) +
              "?page=" +
              pageId.toString() +
              "&size=10&sort=" +
              (sort == null ? "prix,DESC" : sort),
          options: Options(responseType: ResponseType.json, headers: header),
          data: jsonEncode(body));
      return SearchResponse.fromJson(response.data);
    } on DioError catch (e) {
      return SearchResponse();
    } catch (e) {
      print(e.toString());
      throw e.toString();
    }
  }

  Future<DetailAnnonceResponse> getDetailAnnonce(String oidAnnonce) async {
    bool connected = await sessionController.isSessionConnected();
    Map<String, String> header = connected
        ? await sessionController.getHeader()
        : {'content-Type': 'application/json', "Accept": "application/json"};
    try {
      Response response = await _dio.get(
          (connected ? detailAnnonceConnectedEndPoint : detailAnnonceEndPoint) +
              oidAnnonce,
          options: Options(responseType: ResponseType.json, headers: header));
      return DetailAnnonceResponse.fromJson(response.data);
    } on DioError catch (e) {
      return DetailAnnonceResponse();
    } catch (e) {
      throw e.toString();
    }
  }

  Future<String> contactAnnonce(String oidAnnonce, String nom, String prenom,
      int phone, String email, String message) async {
    var params = {
      "test": true,
      "testDestinataire": "test@email.destinataire",
      "oidAnnonce": oidAnnonce,
      "prenom": prenom,
      "nom": nom,
      "tel": phone,
      "email": email,
      "message": message
    };

    try {
      Response response = await _dio.post(contactNotaireEndPoint,
          options: Options(responseType: ResponseType.json, headers: {
            'content-Type': 'application/json',
            "Accept": "application/json"
          }),
          data: jsonEncode(params));
      return response.data;
    } on DioError catch (e) {
      return null;
    } catch (e) {
      throw e.toString();
    }
  }
}
