// To parse this JSON data, do
//
//     final review = reviewFromJson(jsonString);

import 'dart:convert';

import 'package:carq_user/Profile/models/booking_details_response.dart';

ReviewResponse reviewFromJson(String str) =>
    ReviewResponse.fromJson(json.decode(str));

String reviewToJson(ReviewResponse data) => json.encode(data.toJson());

class ReviewResponse {
  String? msg;
  ReviewResponseData? data;
  bool? success;

  ReviewResponse({
    this.msg,
    this.data,
    this.success,
  });

  factory ReviewResponse.fromJson(Map<String, dynamic> json) => ReviewResponse(
        msg: json["msg"],
        data: json["data"] == null
            ? null
            : ReviewResponseData.fromJson(json["data"]),
        success: json["success"],
      );

  Map<String, dynamic> toJson() => {
        "msg": msg,
        "data": data?.toJson(),
        "success": success,
      };
}

class ReviewResponseData {
  int? shopId;
  int? employeeId;
  int? bookingId;
  dynamic star;
  String? cmt;
  int? userId;
  DateTime? updatedAt;
  DateTime? createdAt;
  int? id;
  User? user;

  ReviewResponseData({
    this.shopId,
    this.employeeId,
    this.bookingId,
    this.star,
    this.cmt,
    this.userId,
    this.updatedAt,
    this.createdAt,
    this.id,
    this.user,
  });

  factory ReviewResponseData.fromJson(Map<String, dynamic> json) =>
      ReviewResponseData(
        shopId: json["shop_id"],
        employeeId: json["employee_id"],
        bookingId: json["booking_id"],
        star: json["star"],
        cmt: json["cmt"],
        userId: json["user_id"],
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        id: json["id"],
        user: json["user"] == null ? null : User.fromJson(json["user"]),
      );

  Map<String, dynamic> toJson() => {
        "shop_id": shopId,
        "employee_id": employeeId,
        "booking_id": bookingId,
        "star": star,
        "cmt": cmt,
        "user_id": userId,
        "updated_at": updatedAt?.toIso8601String(),
        "created_at": createdAt?.toIso8601String(),
        "id": id,
        "user": user?.toJson(),
      };
}
