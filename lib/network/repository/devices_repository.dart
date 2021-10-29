import 'package:immonot/network/api/devices_api_provider.dart';

class DevicesRepository {
  DevicesApiProvider _apiProvider = new DevicesApiProvider();

  Future<bool> addDevice() async {
    return _apiProvider.addDevice();
  }

  Future<bool> deleteDevice() async {
    return _apiProvider.deleteDevice();
  }
}
