// To parse this JSON data, do
//
//     final vehicalBrandResponse = vehicalBrandResponseFromJson(jsonString);

import 'dart:convert';

VehicalBrandResponse vehicalBrandResponseFromJson(String str) =>
    VehicalBrandResponse.fromJson(json.decode(str));

String vehicalBrandResponseToJson(VehicalBrandResponse data) =>
    json.encode(data.toJson());

class VehicalBrandResponse {
  dynamic msg;
  List<VehicalBrandName>? data;
  bool? success;

  VehicalBrandResponse({
    this.msg,
    this.data,
    this.success,
  });

  factory VehicalBrandResponse.fromJson(Map<String, dynamic> json) =>
      VehicalBrandResponse(
        msg: json["msg"],
        data: json["data"] == null
            ? []
            : List<VehicalBrandName>.from(
                json["data"]!.map((x) => VehicalBrandName.fromJson(x))),
        success: json["success"],
      );

  Map<String, dynamic> toJson() => {
        "msg": msg,
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
        "success": success,
      };
}

class VehicalBrandName {
  int? id;
  String? name;
  String? icon;

  // int? status;
  String? imageUri;

  VehicalBrandName({
    this.id,
    this.name,
    this.icon,
    // this.status,
    this.imageUri,
  });

  factory VehicalBrandName.fromJson(Map<String, dynamic> json) =>
      VehicalBrandName(
        id: json["id"],
        name: json["name"],
        icon: json["icon"],
        // status: json["status"],
        imageUri: json["imageUri"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "icon": icon,
        // "status": status,
        "imageUri": imageUri,
      };
}
