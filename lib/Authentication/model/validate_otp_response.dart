// To parse this JSON data, do
//
//     final validateOtpResponse = validateOtpResponseFromJson(jsonString);

import 'dart:convert';

ValidateOtpResponse validateOtpResponseFromJson(String str) =>
    ValidateOtpResponse.fromJson(json.decode(str));

String validateOtpResponseToJson(ValidateOtpResponse data) =>
    json.encode(data.toJson());

class ValidateOtpResponse {
  String? msg;
  dynamic data;
  bool? success;

  ValidateOtpResponse({
    this.msg,
    this.data,
    this.success,
  });

  factory ValidateOtpResponse.fromJson(Map<String, dynamic> json) =>
      ValidateOtpResponse(
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
