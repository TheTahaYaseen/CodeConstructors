import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ui/api_client/api_client.dart';
import 'package:ui/utils/api_constants.dart';
import 'package:ui/models/user_model.dart';

class UserServices {
  final ApiClient _apiClient = ApiClient();

  Future<http.Response> register(UserModel user) async {
    String endpoint = ApiConstants.register;
    String jsonUser = jsonEncode(user.toJson());

    return await _apiClient.post(endpoint, jsonUser);
  }

  Future<http.Response> login(UserModel user) async {
    String endpoint = ApiConstants.login;
    String jsonUser = jsonEncode(user.toJson());

    return await _apiClient.post(endpoint, jsonUser);
  }
}
