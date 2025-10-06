// To parse this JSON data, do
//
//     final privacyResponse = privacyResponseFromJson(jsonString);

import 'dart:convert';

PrivacyResponse privacyResponseFromJson(String str) =>
    PrivacyResponse.fromJson(json.decode(str));

String privacyResponseToJson(PrivacyResponse data) =>
    json.encode(data.toJson());

class PrivacyResponse {
  dynamic msg;
  String? data;
  bool? success;

  PrivacyResponse({
    this.msg,
    this.data,
    this.success,
  });

  factory PrivacyResponse.fromJson(Map<String, dynamic> json) =>
      PrivacyResponse(
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
