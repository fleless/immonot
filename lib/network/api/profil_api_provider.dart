import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:immonot/constants/app_constants.dart';
import 'package:immonot/constants/endpoints.dart';
import 'package:immonot/models/requests/create_account_request.dart';
import 'package:immonot/models/responses/get_profile_response.dart';
import 'package:immonot/models/responses/loginResponse.dart';
import 'package:immonot/models/responses/newsletter_response.dart';
import 'package:immonot/models/responses/places_response.dart';
import 'package:immonot/utils/session_controller.dart';
import 'package:immonot/utils/shared_preferences.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class ProfilApiProvider {
  final sessionController = Modular.get<SessionController>();
  final sharedPred = Modular.get<SharedPref>();
  final String newsletterEndPoint =
      Endpoints.CORE_URL + "immonot/newsletters/last";
  final String createAccountEndPoint =
      Endpoints.CORE_URL + "immonot/auth/register";
  final String loginEndPoint = Endpoints.CORE_URL + "immonot/auth/login";
  final String forgottenPasswordEndPoint =
      Endpoints.CORE_URL + "immonot/auth/ask-password-reset";
  final String getProfileInfoEndPoint =
      Endpoints.CORE_URL + "immonot/internaute/profile/info";
  final String resetPasswordEndPoint =
      Endpoints.CORE_URL + "immonot/internaute/profile/password-reset";
  final String editProfileEndPoint =
      Endpoints.CORE_URL + "immonot/internaute/profile/edit";
  final String deleteAccountEndPoint =
      Endpoints.CORE_URL + "immonot/internaute/";
  Dio _dio;

  ProfilApiProvider() {
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

  Future<int> createAccount(CreateAccountRequest request) async {
    // 1 = compte créé, 2 = compte existe déjà, 3 = erreur
    try {
      Response response = await _dio.post(createAccountEndPoint,
          options: Options(responseType: ResponseType.plain, headers: {
            HttpHeaders.contentTypeHeader: "application/json",
          }),
          data: jsonEncode(request));
      if (response.statusCode == 201) {
        return 1;
      } else if (response.statusCode == 409) {
        return 2;
      } else {
        return 3;
      }
    } on DioError catch (e) {
      if (e.response.statusCode == 409) {
        return 2;
      } else {
        return 3;
      }
    } catch (e) {
      throw e.toString();
    }
  }

  Future<LoginResponse> login(String email, String password) async {
    var params = {
      "email": email,
      "password": password,
    };

    try {
      Response response = await _dio.post(loginEndPoint,
          options: Options(responseType: ResponseType.json, headers: {
            'content-Type': 'application/json',
            "Accept": "application/json"
          }),
          data: jsonEncode(params));
      return LoginResponse.fromJson(response.data);
    } on DioError catch (e) {
      return LoginResponse();
    } catch (e) {
      throw e.toString();
    }
  }

  Future<bool> forgottenPassword(String email) async {
    var params = {
      "backlink":
          "https://core-immonot.notariat.services/inbound/password-reset",
      "email": email,
    };

    try {
      Response response = await _dio.post(forgottenPasswordEndPoint,
          options: Options(responseType: ResponseType.json, headers: {
            HttpHeaders.contentTypeHeader: "application/json",
          }),
          data: jsonEncode(params));
      if (response.statusCode == 200) {
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

  Future<GetProfileResponse> getProfileInfos() async {
    Map<String, String> header = await sessionController.getHeader();
    try {
      Response response = await _dio.get(
        getProfileInfoEndPoint,
        options: Options(responseType: ResponseType.json, headers: header),
      );
      return GetProfileResponse.fromJson(response.data);
    } on DioError catch (e) {
      return GetProfileResponse();
    } catch (e) {
      throw e.toString();
    }
  }

  Future<bool> resetPassword(String newPassword, String oldPassword) async {
    var params = {
      "oldPassword": oldPassword,
      "newPassword": newPassword,
      "newPasswordRepeat": newPassword,
    };
    Map<String, String> header = await sessionController.getHeader();
    try {
      Response response = await _dio.post(resetPasswordEndPoint,
          options: Options(responseType: ResponseType.json, headers: header),
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

  Future<bool> editParams(bool newsletterImmonot, bool magazine,
      bool infosPartenairesImmonot, bool infosPartenairesMdn) async {
    var params = {
      "subscribeNewsletterImmonot": newsletterImmonot,
      "subscribeMagazineDesNotaires": magazine,
      "subscribeInfosPartenairesImmonot": infosPartenairesImmonot,
      "subscribeInfosPartenairesMdn": infosPartenairesMdn,
    };
    Map<String, String> header = await sessionController.getHeader();
    try {
      Response response = await _dio.post(editProfileEndPoint,
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

  Future<bool> editProfile(
      String civilite,
      String prenom,
      String nom,
      String email,
      String zip,
      String telephone,
      bool jeSuis,
      String jeSouhaite) async {
    var params = {
      "civilite": civilite,
      "prenom": prenom,
      "nom": nom,
      "mail": email,
      "codePostal": zip,
      "telephone": telephone,
      "estVendeur": jeSuis,
      "souhaite": jeSouhaite,
    };
    Map<String, String> header = await sessionController.getHeader();
    try {
      Response response = await _dio.post(editProfileEndPoint,
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

  Future<bool> deleteAccount(String internauteOid) async {
    Map<String, String> header = await sessionController.getHeader();
    try {
      Response response = await _dio.delete(
          deleteAccountEndPoint + internauteOid,
          options: Options(responseType: ResponseType.plain, headers: header));
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
