// To parse this JSON data, do
//
//     final shopCountResponse = shopCountResponseFromJson(jsonString);

import 'dart:convert';

ShopCountResponse shopCountResponseFromJson(String str) =>
    ShopCountResponse.fromJson(json.decode(str));

String shopCountResponseToJson(ShopCountResponse data) =>
    json.encode(data.toJson());

class ShopCountResponse {
  dynamic msg;
  ShopCountResponseData? data;
  bool? success;

  ShopCountResponse({
    this.msg,
    this.data,
    this.success,
  });

  factory ShopCountResponse.fromJson(Map<String, dynamic> json) =>
      ShopCountResponse(
        msg: json["msg"],
        data: json["data"] == null
            ? null
            : ShopCountResponseData.fromJson(json["data"]),
        success: json["success"],
      );

  Map<String, dynamic> toJson() => {
        "msg": msg,
        "data": data?.toJson(),
        "success": success,
      };
}

class ShopCountResponseData {
  int? booking;
  int? review;
  int? vehicle;

  ShopCountResponseData({
    this.booking,
    this.review,
    this.vehicle,
  });

  factory ShopCountResponseData.fromJson(Map<String, dynamic> json) =>
      ShopCountResponseData(
        booking: json["booking"],
        review: json["review"],
        vehicle: json["vehicle"],
      );

  Map<String, dynamic> toJson() => {
        "booking": booking,
        "review": review,
        "vehicle": vehicle,
      };
}
