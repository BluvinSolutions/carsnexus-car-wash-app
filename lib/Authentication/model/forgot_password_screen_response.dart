// To parse this JSON data, do
//
//     final forgotPasswordResponse = forgotPasswordResponseFromJson(jsonString);

import 'dart:convert';

ForgotPasswordResponse forgotPasswordResponseFromJson(String str) =>
    ForgotPasswordResponse.fromJson(json.decode(str));

String forgotPasswordResponseToJson(ForgotPasswordResponse data) =>
    json.encode(data.toJson());

class ForgotPasswordResponse {
  String? msg;
  dynamic data;
  bool? success;

  ForgotPasswordResponse({
    this.msg,
    this.data,
    this.success,
  });

  factory ForgotPasswordResponse.fromJson(Map<String, dynamic> json) =>
      ForgotPasswordResponse(
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
