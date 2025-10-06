// To parse this JSON data, do
//
//     final settingsResponse = settingsResponseFromJson(jsonString);

import 'dart:convert';

ProfileResponse settingsResponseFromJson(String str) =>
    ProfileResponse.fromJson(json.decode(str));

String settingsResponseToJson(ProfileResponse data) =>
    json.encode(data.toJson());

class ProfileResponse {
  bool? success;
  ProfileResponseData? data;

  ProfileResponse({
    this.success,
    this.data,
  });

  factory ProfileResponse.fromJson(Map<String, dynamic> json) =>
      ProfileResponse(
        success: json["success"],
        data: json["data"] == null
            ? null
            : ProfileResponseData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "data": data?.toJson(),
      };
}

class ProfileResponseData {
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

  ProfileResponseData({
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

  factory ProfileResponseData.fromJson(Map<String, dynamic> json) =>
      ProfileResponseData(
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
