// To parse this JSON data, do
//
//     final vehicleModelsResponse = vehicleModelsResponseFromJson(jsonString);

import 'dart:convert';

VehicleModelsResponse vehicleModelsResponseFromJson(String str) =>
    VehicleModelsResponse.fromJson(json.decode(str));

String vehicleModelsResponseToJson(VehicleModelsResponse data) =>
    json.encode(data.toJson());

class VehicleModelsResponse {
  dynamic msg;
  List<VehicleModelsResponseData>? data;
  bool? success;

  VehicleModelsResponse({
    this.msg,
    this.data,
    this.success,
  });

  factory VehicleModelsResponse.fromJson(Map<String, dynamic> json) =>
      VehicleModelsResponse(
        msg: json["msg"],
        data: json["data"] == null
            ? []
            : List<VehicleModelsResponseData>.from(json["data"]!
                .map((x) => VehicleModelsResponseData.fromJson(x))),
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

class VehicleModelsResponseData {
  int? id;
  String? name;

  VehicleModelsResponseData({
    this.id,
    this.name,
  });

  factory VehicleModelsResponseData.fromJson(Map<String, dynamic> json) =>
      VehicleModelsResponseData(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}
