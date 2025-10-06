// To parse this JSON data, do
//
//     final vehicalResponse = vehicalResponseFromJson(jsonString);

import 'dart:convert';

VehicleResponse vehicalResponseFromJson(String str) =>
    VehicleResponse.fromJson(json.decode(str));

String vehicalResponseToJson(VehicleResponse data) =>
    json.encode(data.toJson());

class VehicleResponse {
  dynamic msg;
  List<VehicalResponseData>? data;
  bool? success;

  VehicleResponse({
    this.msg,
    this.data,
    this.success,
  });

  factory VehicleResponse.fromJson(Map<String, dynamic> json) =>
      VehicleResponse(
        msg: json["msg"],
        data: json["data"] == null
            ? []
            : List<VehicalResponseData>.from(
                json["data"]!.map((x) => VehicalResponseData.fromJson(x))),
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

class VehicalResponseData {
  int? id;
  int? userId;
  int? modelId;
  String? regNumber;
  String? color;
  Model? model;

  VehicalResponseData({
    this.id,
    this.userId,
    this.modelId,
    this.regNumber,
    this.color,
    this.model,
  });

  factory VehicalResponseData.fromJson(Map<String, dynamic> json) =>
      VehicalResponseData(
        id: json["id"],
        userId: json["user_id"],
        modelId: json["model_id"],
        regNumber: json["reg_number"],
        color: json["color"],
        model: json["model"] == null ? null : Model.fromJson(json["model"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "model_id": modelId,
        "reg_number": regNumber,
        "color": color,
        "model": model?.toJson(),
      };
}

class Model {
  int? id;
  int? brandId;
  String? name;
  Brand? brand;

  Model({
    this.id,
    this.brandId,
    this.name,
    this.brand,
  });

  factory Model.fromJson(Map<String, dynamic> json) => Model(
        id: json["id"],
        brandId: json["brand_id"],
        name: json["name"],
        brand: json["brand"] == null ? null : Brand.fromJson(json["brand"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "brand_id": brandId,
        "name": name,
        "brand": brand?.toJson(),
      };
}

class Brand {
  int? id;
  String? name;
  String? icon;
  int? status;
  String? imageUri;

  Brand({
    this.id,
    this.name,
    this.icon,
    this.status,
    this.imageUri,
  });

  factory Brand.fromJson(Map<String, dynamic> json) => Brand(
        id: json["id"],
        name: json["name"],
        icon: json["icon"],
        status: json["status"],
        imageUri: json["imageUri"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "icon": icon,
        "status": status,
        "imageUri": imageUri,
      };
}
