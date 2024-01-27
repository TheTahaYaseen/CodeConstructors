class WifiCredentialModel {
  int? id;
  String? ssid;
  String? password;

  WifiCredentialModel({this.id, this.ssid, this.password});

  WifiCredentialModel.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        ssid = json["ssid"],
        password = json["password"];
}
