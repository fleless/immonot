import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:immonot/constants/endpoints.dart';
import 'package:immonot/models/responses/newsletter_response.dart';
import 'package:immonot/models/responses/places_response.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class ProfilApiProvider {
  final String newsletterEndPoint =
      Endpoints.CORE_URL + "immonot/newsletters/last";
  Dio _dio;

  ProfilApiProvider() {
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

  Future<NewsLetterResponse> getLastNewsletterUrl() async {
    try {
      Response response = await _dio.get(
        newsletterEndPoint,
        options: Options(responseType: ResponseType.json, headers: {
          HttpHeaders.contentTypeHeader: "application/json",
        }),
      );
        return NewsLetterResponse.fromJson(response.data);
    } on DioError catch (e) {
      return NewsLetterResponse();
    } catch (e) {
      throw e.toString();
    }
  }
}
