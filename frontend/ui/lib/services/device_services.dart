import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ui/api_client/api_client.dart';
import 'package:ui/utils/api_constants.dart';
import 'package:ui/models/device_model.dart';

class DeviceServices {
  final ApiClient _apiClient = ApiClient();

  Future<List<DeviceModel>> devices() async {
    String endpoint = ApiConstants.baseDevicesUrl;
    final response = await _apiClient.get(endpoint);

    List<dynamic> jsonResponses = jsonDecode(response.body);

    List<DeviceModel> devices = [];

    for (var json in jsonResponses) {
      DeviceModel device = DeviceModel.fromJson(json);
      devices.add(device);
    }

    return devices;
  }

  Future<http.Response> addManufacturedDevice(DeviceModel device) async {
    String endpoint = ApiConstants.addManufacturedDevice;
    Map<String, dynamic> jsonDevice = device.toJson();

    return await _apiClient.post(endpoint, jsonDevice);
  }

  Future<http.Response> validateDevice(DeviceModel device) async {
    String endpoint = ApiConstants.validate;
    Map<String, dynamic> jsonDevice = device.toJson();

    return await _apiClient.put(endpoint, jsonDevice);
  }

  Future<http.Response> toggleState(DeviceModel device) async {
    String endpoint = ApiConstants.toggleState
        .replaceAll("deviceId", device.manufacturingId.toString());

    return await _apiClient.put(endpoint, {});
  }

  Future<http.Response> toggleMode(DeviceModel device) async {
    String endpoint = ApiConstants.toggleMode
        .replaceAll("deviceId", device.manufacturingId.toString());

    return await _apiClient.put(endpoint, {});
  }

  Future<http.Response> removeDevice(DeviceModel device) async {
    String endpoint = ApiConstants.removeDevice
        .replaceAll("deviceId", device.manufacturingId.toString());

    return await _apiClient.put(endpoint, {});
  }
}
