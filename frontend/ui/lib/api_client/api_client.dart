import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ui/storage.dart';
import 'package:ui/utils/api_constants.dart';

class ApiClient {
  final SecureStorage _secureStorage = SecureStorage();

  Future<Map<String, String>> _getHeaders() async {
    final token = await _secureStorage.getToken();
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  Future<http.Response> get(String endpoint) async {
    String url = ApiConstants.baseUrl + endpoint;
    var headers = await _getHeaders();
    return http.get(Uri.parse(url), headers: headers);
  }

  Future<http.Response> post(String endpoint, dynamic body) async {
    String url = ApiConstants.baseUrl + endpoint;
    var headers = await _getHeaders();
    return http.post(
      Uri.parse(url),
      headers: headers,
      body: jsonEncode(body),
    );
  }

  Future<http.Response> put(String endpoint, Map<String, dynamic> jsonDevice,
      {required Map<String, dynamic> data}) async {
    String url = ApiConstants.baseUrl + endpoint;
    var headers = await _getHeaders();
    return http.put(
      Uri.parse(url),
      headers: headers,
      body: jsonEncode(data),
    );
  }
}
