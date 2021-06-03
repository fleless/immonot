import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:immonot/constants/endpoints.dart';
import 'package:immonot/models/responses/places_response.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class PlacesApiProvider {
  final String searchPlacesEndPoint =
      Endpoints.URL + "suggestionsLocaliteUnifie.do?localite=";
  Dio _dio;

  PlacesApiProvider() {
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
          responseHeader: false,
          error: true,
          compact: true,
          maxWidth: 90));
    }
  }

  Future<List<PlacesResponse>> searchPlaces(String item) async {
    try {
      Response response = await _dio.get(
        searchPlacesEndPoint + item,
        options: Options(responseType: ResponseType.json, headers: {
          HttpHeaders.contentTypeHeader: "application/json",
        }),
      );
      if (response.data.length == 0) {
        List<PlacesResponse> vide = <PlacesResponse>[];
        return vide;
      } else {
        var res = jsonDecode(response.toString()) as List;
        return (res as List).map((x) => PlacesResponse.fromJson(x)).toList();
      }
    } on DioError catch (e) {
      List<PlacesResponse> vide = <PlacesResponse>[];
      return vide;
    } catch (e) {
      throw e.toString();
    }
  }
}
