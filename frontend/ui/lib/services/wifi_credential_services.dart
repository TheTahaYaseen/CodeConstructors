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
    final response = await _apiClient.get(endpoint);

    List<WifiCredentialModel> wifiCredentials = [];

    List<dynamic> jsonResponses = jsonDecode(response.body)["data"];

    for (var json in jsonResponses) {
      wifiCredentials.add(WifiCredentialModel.fromJson(json));
    }

    return wifiCredentials;
  }

  Future<http.Response> getWifiCredentials(
      WifiCredentialModel wifiCredential) async {
    String endpoint = ApiConstants.getWifiCredentials;
    Map<String, dynamic> jsonWifiCredential = wifiCredential.toJson();

    return await _apiClient.post(endpoint, jsonWifiCredential);
  }

  Future<http.Response> updateWifiCredentials(
      WifiCredentialModel wifiCredential) async {
    String endpoint = ApiConstants.updateWifiCredentials;
    Map<String, dynamic> jsonWifiCredential = wifiCredential.toJson();

    return await _apiClient.put(endpoint, jsonWifiCredential);
  }
}
