// To parse this JSON data, do
//
//     final newPasswordResponse = newPasswordResponseFromJson(jsonString);

import 'dart:convert';

NewPasswordResponse newPasswordResponseFromJson(String str) =>
    NewPasswordResponse.fromJson(json.decode(str));

String newPasswordResponseToJson(NewPasswordResponse data) =>
    json.encode(data.toJson());

class NewPasswordResponse {
  String? msg;
  NewPasswordResponseData? data;
  bool? success;

  NewPasswordResponse({
    this.msg,
    this.data,
    this.success,
  });

  factory NewPasswordResponse.fromJson(Map<String, dynamic> json) =>
      NewPasswordResponse(
        msg: json["msg"],
        data: json["data"] == null
            ? null
            : NewPasswordResponseData.fromJson(json["data"]),
        success: json["success"],
      );

  Map<String, dynamic> toJson() => {
        "msg": msg,
        "data": data?.toJson(),
        "success": success,
      };
}

class NewPasswordResponseData {
  String? token;

  NewPasswordResponseData({
    this.token,
  });

  factory NewPasswordResponseData.fromJson(Map<String, dynamic> json) =>
      NewPasswordResponseData(
        token: json["token"],
      );

  Map<String, dynamic> toJson() => {
        "token": token,
      };
}
