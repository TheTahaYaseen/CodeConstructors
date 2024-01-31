import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ui/api_client/api_client.dart';
import 'package:ui/utils/api_constants.dart';
import 'package:ui/models/wifi_credential_model.dart';

class WifiCredentialServices {
  final ApiClient _apiClient = ApiClient();

  Future<List<WifiCredentialModel>> wifiCredentials(
      WifiCredentialModel wifiCredential) async {
    String endpoint = ApiConstants.wifiCredentials;
    final response = _apiClient.get(endpoint);

    List<WifiCredentialModel> wifiCredentials = [];

    for (var json in response["data"]) {
      wifiCredentials.add(WifiCredentialModel.fromJson(json));
    }

    return wifiCredentials;
  }

  Future<http.Response> getWifiCredentials(
      WifiCredentialModel wifiCredential) async {
    String endpoint = ApiConstants.getWifiCredentials;
    String jsonWifiCredential = jsonEncode(wifiCredential.toJson());

    return await _apiClient.post(endpoint, jsonWifiCredential);
  }

  Future<http.Response> updateWifiCredentials(
      WifiCredentialModel wifiCredential) async {
    String endpoint = ApiConstants.updateWifiCredentials;
    String jsonWifiCredential = jsonEncode(wifiCredential.toJson());

    return await _apiClient.put(endpoint, jsonWifiCredential);
  }
}
