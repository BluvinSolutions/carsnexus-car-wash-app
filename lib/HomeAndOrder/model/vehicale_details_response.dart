// To parse this JSON data, do
//
//     final oneVehicleResponse = oneVehicleResponseFromJson(jsonString);

import 'dart:convert';

import 'package:carsnexus_user/HomeAndOrder/model/vehical_response.dart';

OneVehicleResponse oneVehicleResponseFromJson(String str) =>
    OneVehicleResponse.fromJson(json.decode(str));

String oneVehicleResponseToJson(OneVehicleResponse data) =>
    json.encode(data.toJson());

class OneVehicleResponse {
  dynamic msg;
  VehicalResponseData? data;
  bool? success;

  OneVehicleResponse({
    this.msg,
    this.data,
    this.success,
  });

  factory OneVehicleResponse.fromJson(Map<String, dynamic> json) =>
      OneVehicleResponse(
        msg: json["msg"],
        data: json["data"] == null
            ? null
            : VehicalResponseData.fromJson(json["data"]),
        success: json["success"],
      );

  Map<String, dynamic> toJson() => {
        "msg": msg,
        "data": data?.toJson(),
        "success": success,
      };
}

// class Data {
//     int? id;
//     int? userId;
//     int? modelId;
//     String? regNumber;
//     String? color;
//     Model? model;

//     Data({
//         this.id,
//         this.userId,
//         this.modelId,
//         this.regNumber,
//         this.color,
//         this.model,
//     });

//     factory Data.fromJson(Map<String, dynamic> json) => Data(
//         id: json["id"],
//         userId: json["user_id"],
//         modelId: json["model_id"],
//         regNumber: json["reg_number"],
//         color: json["color"],
//         model: json["model"] == null ? null : Model.fromJson(json["model"]),
//     );

//     Map<String, dynamic> toJson() => {
//         "id": id,
//         "user_id": userId,
//         "model_id": modelId,
//         "reg_number": regNumber,
//         "color": color,
//         "model": model?.toJson(),
//     };
// }

// class Model {
//     int? id;
//     int? brandId;
//     String? name;
//     Brand? brand;

//     Model({
//         this.id,
//         this.brandId,
//         this.name,
//         this.brand,
//     });

//     factory Model.fromJson(Map<String, dynamic> json) => Model(
//         id: json["id"],
//         brandId: json["brand_id"],
//         name: json["name"],
//         brand: json["brand"] == null ? null : Brand.fromJson(json["brand"]),
//     );

//     Map<String, dynamic> toJson() => {
//         "id": id,
//         "brand_id": brandId,
//         "name": name,
//         "brand": brand?.toJson(),
//     };
// }

// class Brand {
//     int? id;
//     String? name;
//     String? icon;
//     int? status;
//     String? imageUri;

//     Brand({
//         this.id,
//         this.name,
//         this.icon,
//         this.status,
//         this.imageUri,
//     });

//     factory Brand.fromJson(Map<String, dynamic> json) => Brand(
//         id: json["id"],
//         name: json["name"],
//         icon: json["icon"],
//         status: json["status"],
//         imageUri: json["imageUri"],
//     );

//     Map<String, dynamic> toJson() => {
//         "id": id,
//         "name": name,
//         "icon": icon,
//         "status": status,
//         "imageUri": imageUri,
//     };
// }
