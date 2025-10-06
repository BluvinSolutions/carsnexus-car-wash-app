// To parse this JSON data, do
//
//     final updatePasswordResponse = updatePasswordResponseFromJson(jsonString);

import 'dart:convert';

UpdatePasswordResponse updatePasswordResponseFromJson(String str) =>
    UpdatePasswordResponse.fromJson(json.decode(str));

String updatePasswordResponseToJson(UpdatePasswordResponse data) =>
    json.encode(data.toJson());

class UpdatePasswordResponse {
  String? msg;
  String? data;
  bool? success;

  UpdatePasswordResponse({
    this.msg,
    this.data,
    this.success,
  });

  factory UpdatePasswordResponse.fromJson(Map<String, dynamic> json) =>
      UpdatePasswordResponse(
        msg: json["msg"],
        data: json["data"],
        success: json["success"],
      );

  Map<String, dynamic> toJson() => {
        "msg": msg,
        "data": data,
        "success": success,
      };
}
