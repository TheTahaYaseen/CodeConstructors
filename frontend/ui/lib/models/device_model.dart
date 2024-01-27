class DeviceModel {
  int? id;
  String? manufacturingId;
  int? associatedWifiCredentials;
  int? associatedUser;
  bool? anyPresence;
  bool? state;
  bool? isAuto;

  DeviceModel(
      {this.id,
      this.manufacturingId,
      this.associatedWifiCredentials,
      this.associatedUser,
      this.anyPresence,
      this.state,
      this.isAuto});

  DeviceModel.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        manufacturingId = json["manufacturing_id"],
        associatedWifiCredentials = json["associated_wifi_credentials"],
        associatedUser = json["associated_user"],
        anyPresence = json["any_presence"],
        state = json["state"],
        isAuto = json["is_auto"];
}
