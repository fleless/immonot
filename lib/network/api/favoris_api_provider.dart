import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:immonot/constants/endpoints.dart';
import 'package:immonot/models/responses/get_favoris_response.dart';
import 'package:immonot/utils/session_controller.dart';
import 'package:immonot/utils/shared_preferences.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class FavorisApiProvider {
  final sessionController = Modular.get<SessionController>();
  final sharedPred = Modular.get<SharedPref>();
  final String getFavorisEndPoint =
      Endpoints.CORE_URL + "immonot/internaute/favoris?page=";
  final String deleteFavorisEndPoint =
      Endpoints.CORE_URL + "immonot/internaute/favoris/annonces/";
  final String addFavorisEndPoint =
      Endpoints.CORE_URL + "immonot/internaute/favoris/";
  final String deleteFavorisWithIdFavorisEndPoint =
      Endpoints.CORE_URL + "immonot/internaute/favoris/";
  Dio _dio;

  FavorisApiProvider() {
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

  Future<GetFavorisResponse> getFavoris(int pageId) async {
    Map<String, String> header = await sessionController.getHeader();
    try {
      Response response = await _dio.get(
        getFavorisEndPoint + pageId.toString() + "&size=20",
        options: Options(responseType: ResponseType.json, headers: header),
      );
      return GetFavorisResponse.fromJson(response.data);
    } on DioError catch (e) {
      return GetFavorisResponse();
    } catch (e) {
      throw e.toString();
    }
  }

  Future<bool> deleteFavoris(String idAnnonce) async {
    Map<String, String> header = await sessionController.getHeader();
    try {
      Response response = await _dio.delete(
        deleteFavorisEndPoint + idAnnonce,
        options: Options(responseType: ResponseType.plain, headers: header),
      );
      if (response.statusCode < 300) {
        return true;
      } else {
        return false;
      }
    } on DioError catch (e) {
      return false;
    } catch (e) {
      throw e.toString();
    }
  }

  Future<bool> deleteFavorisWithIdFavoris(String idFavoris) async {
    Map<String, String> header = await sessionController.getHeader();
    try {
      Response response = await _dio.delete(
        deleteFavorisWithIdFavorisEndPoint + idFavoris,
        options: Options(responseType: ResponseType.plain, headers: header),
      );
      if (response.statusCode < 300) {
        return true;
      } else {
        return false;
      }
    } on DioError catch (e) {
      return false;
    } catch (e) {
      throw e.toString();
    }
  }

  Future<bool> addFavoris(String idAnnonce, bool suivrePrix) async {
    Map<String, String> header = await sessionController.getHeader();
    var params = {
      "idAnnonce": idAnnonce,
      "alertePrix": suivrePrix,
    };
    try {
      Response response = await _dio.post(addFavorisEndPoint,
          options: Options(responseType: ResponseType.plain, headers: header),
          data: jsonEncode(params));
      if (response.statusCode < 300) {
        return true;
      } else {
        return false;
      }
    } on DioError catch (e) {
      return false;
    } catch (e) {
      throw e.toString();
    }
  }
}
