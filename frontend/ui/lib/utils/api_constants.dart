class ApiConstants {
  static String baseUrl = "http://127.0.0.1:8000/api/";

  static String register = "register";
  static String login = "login";
  static String logout = "logout";

  static String baseDevicesUrl = "devices";

  static String addManufacturedDevice =
      "$baseDevicesUrl/add_manufactured_device";

  static String validate = "$baseDevicesUrl/";

  static String wifiCredentials = "$baseDevicesUrl/ wifi_credentials";
  static String getWifiCredentials =
      "$baseDevicesUrl/deviceId/get_wifi_credentials";
  static String updateWifiCredentials =
      "$baseDevicesUrl/update_wifi_credentials/update/wifiCredentialsId";

  static String removeDevice = "$baseDevicesUrl/remove/deviceId";
  static String toggleState = "$baseDevicesUrl/deviceId/toggle_state";
  static String toggleMode = "$baseDevicesUrl/deviceId/toggle_state";
}
