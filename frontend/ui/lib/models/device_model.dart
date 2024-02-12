class DeviceModel {
  String? id;
  String? manufacturingId;
  String? associatedWifiCredentials;
  String? associatedUser;
  String? anyPresence;
  String? state;
  String? isAuto;

  DeviceModel({
    this.id,
    this.manufacturingId,
    this.associatedWifiCredentials,
    this.associatedUser,
    this.anyPresence,
    this.state,
    this.isAuto,
  });

  DeviceModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        manufacturingId = json['manufacturing_id'],
        associatedWifiCredentials = json['associated_wifi_credentials'],
        associatedUser = json['associated_user'],
        anyPresence = json['any_presence'],
        state = json['state'],
        isAuto = json['is_auto'];

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "manufacturing_id": manufacturingId,
      "associated_wifi_credentials": associatedWifiCredentials,
      "associated_user": associatedUser,
      "any_presence": anyPresence,
      "state": state,
      "is_auto": isAuto,
    };
  }
}
