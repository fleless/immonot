import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:immonot/constants/endpoints.dart';
import 'package:immonot/models/requests/create_alerte_request.dart';
import 'package:immonot/models/responses/get_alertes_response.dart';
import 'package:immonot/utils/session_controller.dart';
import 'package:immonot/utils/shared_preferences.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class AlertesApiProvider {
  final sessionController = Modular.get<SessionController>();
  final sharedPred = Modular.get<SharedPref>();
  final String getAlertesEndPoint =
      Endpoints.CORE_URL + "immonot/internaute/alertes?page=";
  final String ajouterAlertesEndPoint =
      Endpoints.CORE_URL + "immonot/internaute/alertes";
  final String supprimerAlertesEndPoint =
      Endpoints.CORE_URL + "immonot/internaute/alertes/";
  Dio _dio;

  AlertesApiProvider() {
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

  Future<GetAlertesResponse> getAlertes(int pageId) async {
    Map<String, String> header = await sessionController.getHeader();
    try {
      Response response = await _dio.get(
        getAlertesEndPoint + pageId.toString() + "&size=10",
        options: Options(responseType: ResponseType.json, headers: header),
      );
      return GetAlertesResponse.fromJson(response.data);
    } on DioError catch (e) {
      return GetAlertesResponse();
    } catch (e) {
      throw e.toString();
    }
  }

  Future<bool> ajouterAlertes(CreateAlerteRequest alerte) async {
    Map<String, String> header = await sessionController.getHeader();
    try {
      Response response = await _dio.post(ajouterAlertesEndPoint,
          options: Options(responseType: ResponseType.json, headers: header),
          data: jsonEncode(alerte));
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

  Future<bool> supprimerAlertes(String idAlerte) async {
    Map<String, String> header = await sessionController.getHeader();
    try {
      Response response = await _dio.delete(supprimerAlertesEndPoint + idAlerte,
          options: Options(responseType: ResponseType.plain, headers: header));
      if (response.statusCode < 300) {
        return true;
      } else {
        return false;
      }
    } on DioError catch (e) {
      return false;
    } catch (e) {
      return false;
    }
  }
}
