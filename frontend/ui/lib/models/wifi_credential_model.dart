class WifiCredentialModel {
  int? id;
  int? associatedUser;
  String? ssid;
  String? password;

  WifiCredentialModel({this.id, this.associatedUser, this.ssid, this.password});

  WifiCredentialModel.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        associatedUser = json["associated_user"],
        ssid = json["ssid"],
        password = json["password"];

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "ssid": ssid,
      "password": password,
    };
  }
}
