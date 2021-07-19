import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:immonot/constants/endpoints.dart';
import 'package:immonot/models/requests/search_request.dart';
import 'package:immonot/models/responses/DetailAnnonceResponse.dart';
import 'package:immonot/models/responses/SearchResponse.dart';
import 'package:immonot/models/responses/newsletter_response.dart';
import 'package:immonot/models/responses/places_response.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class SearchAnnoncesApiProvider {
  final String searchAnnoncesEndPoint =
      Endpoints.CORE_URL + "immobilier/annonces/search";
  final String detailAnnonceEndPoint =
      Endpoints.CORE_URL + "immobilier/annonces/";
  final String contactNotaireEndPoint =
      Endpoints.CORE_URL + "immonot/contact-annonce";

  Dio _dio;

  SearchAnnoncesApiProvider() {
    if (_dio == null) {
      BaseOptions options = new BaseOptions(
          receiveDataWhenStatusError: true,
          connectTimeout: 2 * 1000, // 5 seconds
          receiveTimeout: 2 * 1000 // 5 seconds
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
      int pageId, SearchRequest header, String sort) async {
    try {
      var params = {};
      Response response = await _dio.post(
          searchAnnoncesEndPoint +
              "?page=" +
              pageId.toString() +
              "&size=10&sort=" +
              (sort == null ? "prix,DESC" : sort),
          options: Options(responseType: ResponseType.json, headers: {
            'content-Type': 'application/json',
            "Accept": "application/json"
          }),
          data: jsonEncode(header));
      return SearchResponse.fromJson(response.data);
    } on DioError catch (e) {
      return SearchResponse();
    } catch (e) {
      throw e.toString();
    }
  }

  Future<DetailAnnonceResponse> getDetailAnnonce(String oidAnnonce) async {
    try {
      Response response = await _dio.get(detailAnnonceEndPoint + oidAnnonce,
          options: Options(responseType: ResponseType.json, headers: {
            'content-Type': 'application/json',
            "Accept": "application/json"
          }));
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
