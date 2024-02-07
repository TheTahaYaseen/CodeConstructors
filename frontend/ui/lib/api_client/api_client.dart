import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:ui/utils/api_constants.dart';

class ApiClient {
  get(endpoint) {
    http.get(Uri.parse(ApiConstants.baseUrl + endpoint));
  }

  Future<http.Response> post(String endpoint, String body) async {
    String url = ApiConstants.baseUrl + endpoint;
    return await http.post(Uri.parse(url), body: body, headers: {
      'Content-Type': 'application/json',
    });
  }

  Future<http.Response> put(String url, String s,
      {Map<String, dynamic>? data}) async {
    var response = await http.put(
      Uri.parse(url),
      headers: <String, String>{
        "Content-Type": "application/json",
      },
      body: data != null ? jsonEncode(data) : null,
    );
    return response;
  }
}
