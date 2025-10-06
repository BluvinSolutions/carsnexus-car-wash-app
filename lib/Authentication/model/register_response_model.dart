// To parse this JSON data, do
//
//     final registerResponse = registerResponseFromJson(jsonString);

import 'dart:convert';

RegisterResponse registerResponseFromJson(String str) =>
    RegisterResponse.fromJson(json.decode(str));

String registerResponseToJson(RegisterResponse data) =>
    json.encode(data.toJson());

class RegisterResponse {
  String? msg;
  RegisterResponseData? data;
  bool? success;
  String? flow;

  RegisterResponse({
    this.msg,
    this.data,
    this.success,
    this.flow,
  });

  factory RegisterResponse.fromJson(Map<String, dynamic> json) =>
      RegisterResponse(
        msg: json["msg"],
        data: json["data"] == null
            ? null
            : RegisterResponseData.fromJson(json["data"]),
        success: json["success"],
        flow: json["flow"],
      );

  Map<String, dynamic> toJson() => {
        "msg": msg,
        "data": data?.toJson(),
        "success": success,
        "flow": flow,
      };
}

class RegisterResponseData {
  String? email;
  String? name;
  String? phoneNo;
  String? otp;
  int? id;
  dynamic imageUri;

  RegisterResponseData({
    this.email,
    this.name,
    this.phoneNo,
    this.otp,
    this.id,
    this.imageUri,
  });

  factory RegisterResponseData.fromJson(Map<String, dynamic> json) =>
      RegisterResponseData(
        email: json["email"],
        name: json["name"],
        phoneNo: json["phone_no"],
        otp: json["otp"],
        id: json["id"],
        imageUri: json["imageUri"],
      );

  Map<String, dynamic> toJson() => {
        "email": email,
        "name": name,
        "phone_no": phoneNo,
        "otp": otp,
        "id": id,
        "imageUri": imageUri,
      };
}
