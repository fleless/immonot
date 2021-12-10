import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:immonot/constants/endpoints.dart';
import 'package:immonot/models/responses/places_response.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class PlacesApiProvider {
  final String searchPlacesEndPoint =
      Endpoints.CORE_URL + "geo/communes/autocomplete?input=";
  final String searchDepartementEndPoint =
      Endpoints.CORE_URL + "geo/departements/";
  final String searchCommuneEndPoint = Endpoints.CORE_URL + "geo/communes/";
  Dio _dio;

  PlacesApiProvider() {
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

  Future<List<PlacesResponse>> searchPlaces(String item) async {
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      "Accept": "application/json",
      'Charset': 'utf-8'
    };

    try {
      Response response = await _dio.get(
        searchPlacesEndPoint + item + "*",
        options: Options(responseType: ResponseType.plain, headers: headers),
      );
      if (response.data.length == 0) {
        List<PlacesResponse> vide = <PlacesResponse>[];
        return vide;
      } else {
        var res = jsonDecode(response.toString()) as List;
        return (res).map((x) => PlacesResponse.fromJson(x)).toList();
      }
    } on DioError catch (e) {
      List<PlacesResponse> vide = <PlacesResponse>[];
      return vide;
    } catch (e) {
      throw e.toString();
    }
  }

  Future<PlacesResponse> searchDepartment(String codeDep) async {
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      "Accept": "application/json",
      'Charset': 'utf-8'
    };

    try {
      Response response = await _dio.get(
        searchDepartementEndPoint + codeDep,
        options: Options(responseType: ResponseType.json, headers: headers),
      );
      if (response.data.length == 0) {
        PlacesResponse vide = PlacesResponse();
        return vide;
      } else {
        return PlacesResponse.fromJson(response.data);
      }
    } on DioError catch (e) {
      PlacesResponse vide = PlacesResponse();
      return vide;
    } catch (e) {
      throw e.toString();
    }
  }

  Future<PlacesResponse> searchCommune(String oidCommune) async {
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      "Accept": "application/json",
      'Charset': 'utf-8'
    };

    try {
      Response response = await _dio.get(
        searchCommuneEndPoint + oidCommune,
        options: Options(responseType: ResponseType.json, headers: headers),
      );
      if (response.data.length == 0) {
        PlacesResponse vide = PlacesResponse();
        return vide;
      } else {
        return PlacesResponse.fromJson(response.data);
      }
    } on DioError catch (e) {
      PlacesResponse vide = PlacesResponse();
      return vide;
    } catch (e) {
      throw e.toString();
    }
  }
}
