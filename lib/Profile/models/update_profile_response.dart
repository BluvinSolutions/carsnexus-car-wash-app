// To parse this JSON data, do
//
//     final updateProfileResponse = updateProfileResponseFromJson(jsonString);

import 'dart:convert';

UpdateProfileResponse updateProfileResponseFromJson(String str) =>
    UpdateProfileResponse.fromJson(json.decode(str));

String updateProfileResponseToJson(UpdateProfileResponse data) =>
    json.encode(data.toJson());

class UpdateProfileResponse {
  String? msg;
  Data? data;
  bool? success;

  UpdateProfileResponse({
    this.msg,
    this.data,
    this.success,
  });

  factory UpdateProfileResponse.fromJson(Map<String, dynamic> json) =>
      UpdateProfileResponse(
        msg: json["msg"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
        success: json["success"],
      );

  Map<String, dynamic> toJson() => {
        "msg": msg,
        "data": data?.toJson(),
        "success": success,
      };
}

class Data {
  int? id;
  String? name;
  String? email;
  String? phoneNo;
  String? image;
  dynamic address;
  dynamic deviceToken;
  int? status;
  dynamic otp;
  int? noti;
  int? verified;
  String? imageUri;

  Data({
    this.id,
    this.name,
    this.email,
    this.phoneNo,
    this.image,
    this.address,
    this.deviceToken,
    this.status,
    this.otp,
    this.noti,
    this.verified,
    this.imageUri,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        name: json["name"],
        email: json["email"],
        phoneNo: json["phone_no"],
        image: json["image"],
        address: json["address"],
        deviceToken: json["device_token"],
        status: json["status"],
        otp: json["otp"],
        noti: json["noti"],
        verified: json["verified"],
        imageUri: json["imageUri"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "email": email,
        "phone_no": phoneNo,
        "image": image,
        "address": address,
        "device_token": deviceToken,
        "status": status,
        "otp": otp,
        "noti": noti,
        "verified": verified,
        "imageUri": imageUri,
      };
}
