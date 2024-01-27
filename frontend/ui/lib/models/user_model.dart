class UserModel {
  int? id;
  String? username;
  String? password;

  UserModel({this.id, this.username, this.password});

  UserModel.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        username = json["username"],
        password = json["password"];
}
