import 'dart:convert';
import 'dart:io';
import 'package:device_info/device_info.dart';
import 'package:dio/dio.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:immonot/constants/app_constants.dart';
import 'package:immonot/constants/endpoints.dart';
import 'package:immonot/utils/session_controller.dart';
import 'package:immonot/utils/shared_preferences.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class DevicesApiProvider {
  final sessionController = Modular.get<SessionController>();
  final sharedPred = Modular.get<SharedPref>();
  final String addDeviceEndPoint = Endpoints.CORE_URL + "immonot/devices";
  final String deleteDeviceEndPoint =
      Endpoints.CORE_URL + "immonot/devices/tokens/";
  Dio _dio;

  DevicesApiProvider() {
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

  Future<bool> addDevice() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    Map<String, String> header = await sessionController.getHeader();
    String model = Platform.isAndroid
        ? await deviceInfo.androidInfo.then((value) => value.model)
        : await deviceInfo.iosInfo.then((value) => value.model);
    String version = Platform.isAndroid
        ? await deviceInfo.androidInfo.then((value) => value.version.codename)
        : await deviceInfo.iosInfo.then((value) => value.systemVersion);
    String identifier = Platform.isAndroid
        ? await deviceInfo.androidInfo.then((value) => value.id)
        : await deviceInfo.iosInfo.then((value) => value.identifierForVendor);
    var params = {
      "name": model,
      "version": version,
      "identifier": identifier,
      "token": await sharedPred.read(AppConstants.TOKEN_KEY)
    };
    try {
      Response response = await _dio.post(addDeviceEndPoint,
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

  Future<bool> deleteDevice() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    Map<String, String> header = await sessionController.getHeader();
    String id = Platform.isAndroid
        ? await deviceInfo.androidInfo.then((value) => value.id)
        : await deviceInfo.iosInfo.then((value) => value.identifierForVendor);

    try {
      Response response = await _dio.delete(deleteDeviceEndPoint + id,
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
