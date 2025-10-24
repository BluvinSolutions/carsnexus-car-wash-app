// To parse this JSON data, do
//
//     final categoryResponse = categoryResponseFromJson(jsonString);

import 'dart:convert';

import 'package:voyzo/HomeAndOrder/model/home_screen_response.dart';

CategoryResponse categoryResponseFromJson(String str) =>
    CategoryResponse.fromJson(json.decode(str));

String categoryResponseToJson(CategoryResponse data) =>
    json.encode(data.toJson());

class CategoryResponse {
  dynamic msg;
  List<BestShops>? data;
  bool? success;

  CategoryResponse({
    this.msg,
    this.data,
    this.success,
  });

  factory CategoryResponse.fromJson(Map<String, dynamic> json) =>
      CategoryResponse(
        msg: json["msg"],
        data: json["data"] == null
            ? []
            : List<BestShops>.from(
                json["data"]!.map((x) => BestShops.fromJson(x))),
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

// class CategoryData {
//   String? name;
//   int? id;
//   String? image;
//   String? address;
//   String? imageUri;
//   dynamic avgRating;

//   CategoryData({
//     this.name,
//     this.id,
//     this.image,
//     this.address,
//     this.imageUri,
//     this.avgRating,
//   });

//   factory CategoryData.fromJson(Map<String, dynamic> json) => CategoryData(
//         name: json["name"],
//         id: json["id"],
//         image: json["image"],
//         address: json["address"],
//         imageUri: json["imageUri"],
//         avgRating: json["avg_rating"],
//       );

//   Map<String, dynamic> toJson() => {
//         "name": name,
//         "id": id,
//         "image": image,
//         "address": address,
//         "imageUri": imageUri,
//         "avg_rating": avgRating,
//       };
// }
