import 'dart:io';
import 'package:dio/dio.dart';
import 'package:immonot/constants/endpoints.dart';
import 'package:immonot/models/responses/capacite_emprunt_response.dart';
import 'package:immonot/models/responses/frais_notaires_response.dart';
import 'package:immonot/models/responses/montant_mensualite_response.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class CalculatriceApiProvider {
  final String montantMensualiteEndPoint =
      Endpoints.CORE_URL + "calc/montant-mensualite?";
  final String capaciteEmpruntEndPoint =
      Endpoints.CORE_URL + "calc/capacite-emprunt?";
  final String fraisNotairesEndPoint =
      Endpoints.CORE_URL + "calc/frais-notaire?";

  Dio _dio;

  CalculatriceApiProvider() {
    if (_dio == null) {
      BaseOptions options = new BaseOptions(
          receiveDataWhenStatusError: true,
          connectTimeout: 60 * 1000, // 5 seconds
          receiveTimeout: 60 * 1000 // 5 seconds
          );

      _dio = new Dio(options);
      _dio.interceptors.add(PrettyDioLogger(
          requestHeader: false,
          requestBody: false,
          responseBody: false,
          responseHeader: false,
          error: true,
          compact: true,
          maxWidth: 90));
    }
  }

  Future<MontantMensualiteResponse> calculMontantMensualite(
      double capital, double interet, int duree) async {
    try {
      Response response = await _dio.get(
        montantMensualiteEndPoint +
            "capital=" +
            capital.toString() +
            "&interet=" +
            interet.toString() +
            "&duree=" +
            duree.toString(),
        options: Options(responseType: ResponseType.json, headers: {
          HttpHeaders.contentTypeHeader: "application/json",
        }),
      );
      return MontantMensualiteResponse.fromJson(response.data);
    } on DioError catch (e) {
      return MontantMensualiteResponse();
    } catch (e) {
      throw e;
    }
  }

  Future<CapaciteEmpruntResponse> calculCapaciteEmprunt(
      double interet, double mensualite) async {
    try {
      Response response = await _dio.get(
        capaciteEmpruntEndPoint +
            "interet=" +
            interet.toString() +
            "&mensualite=" +
            mensualite.toString(),
        options: Options(responseType: ResponseType.json, headers: {
          HttpHeaders.contentTypeHeader: "application/json",
        }),
      );
      return CapaciteEmpruntResponse.fromJson(response.data);
    } on DioError catch (e) {
      return CapaciteEmpruntResponse();
    } catch (e) {
      throw e;
    }
  }

  Future<FraisNotairesResponse> calculFraisNotaires(
      double prix, String departement) async {
    try {
      Response response = await _dio.get(
        fraisNotairesEndPoint +
            "prix=" +
            prix.toString() +
            "&departement=" +
            departement,
        options: Options(responseType: ResponseType.json, headers: {
          HttpHeaders.contentTypeHeader: "application/json",
        }),
      );
      return FraisNotairesResponse.fromJson(response.data);
    } on DioError catch (e) {
      return FraisNotairesResponse();
    } catch (e) {
      throw e;
    }
  }
}
