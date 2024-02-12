import "dart:convert";
import "package:http/http.dart" as http;
import "package:shared_preferences/shared_preferences.dart";
import "package:ui/utils/api_constants.dart";

class ApiClient {
  Future<String> _loadUsername() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("user") ?? "Unauthenticated";
  }

  Future<http.Response> get(String endpoint) async {
    final username = await _loadUsername();
    final url = Uri.parse(ApiConstants.baseUrl + endpoint);
    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode({"user": username}),
    );
    return response;
  }

  Future<http.Response> post(String endpoint, Map<String, dynamic> body) async {
    final username = await _loadUsername();
    body["user"] = username;
    final url = Uri.parse(ApiConstants.baseUrl + endpoint);
    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode(body),
    );
    return response;
  }

  Future<http.Response> put(String endpoint, Map<String, dynamic> body) async {
    final username = await _loadUsername();
    body["user"] = username;
    final url = Uri.parse("${ApiConstants.baseUrl}$endpoint");
    final response = await http.put(
      url,
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode(body),
    );
    return response;
  }
}
