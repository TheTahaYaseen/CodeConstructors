import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ui/api_client/api_client.dart';
import 'package:ui/utils/api_constants.dart';
import 'package:ui/models/device_model.dart';

class DeviceServices {
  final ApiClient _apiClient = ApiClient();

  Future<List<DeviceModel>> devices(DeviceModel device) async {
    String endpoint = ApiConstants.baseDevicesUrl;
    final response = _apiClient.get(endpoint);

    List<DeviceModel> devices = [];

    for (var json in response["data"]) {
      devices.add(DeviceModel.fromJson(json));
    }

    return devices;
  }

  Future<http.Response> addManufacturedDevice(DeviceModel device) async {
    String endpoint = ApiConstants.addManufacturedDevice;
    String jsonDevice = jsonEncode(device.toJson());

    return await _apiClient.post(endpoint, jsonDevice);
  }

  Future<http.Response> validateDevice(DeviceModel device) async {
    String endpoint = ApiConstants.validate;
    String jsonDevice = jsonEncode(device.toJson());

    return await _apiClient.put(endpoint, jsonDevice);
  }

  Future<http.Response> toggleState(DeviceModel device) async {
    String endpoint =
        ApiConstants.toggleState.replaceAll("deviceId", device.id.toString());

    return await _apiClient.put(endpoint, "");
  }

  Future<http.Response> toggleMode(DeviceModel device) async {
    String endpoint =
        ApiConstants.toggleMode.replaceAll("deviceId", device.id.toString());

    return await _apiClient.put(endpoint, "");
  }

  Future<http.Response> removeDevice(DeviceModel device) async {
    String endpoint =
        ApiConstants.removeDevice.replaceAll("deviceId", device.id.toString());

    return await _apiClient.put(endpoint, "");
  }
}
