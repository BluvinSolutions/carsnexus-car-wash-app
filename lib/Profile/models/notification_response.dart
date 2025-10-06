// To parse this JSON data, do
//
//     final notificationResponse = notificationResponseFromJson(jsonString);

import 'dart:convert';

NotificationResponse notificationResponseFromJson(String str) =>
    NotificationResponse.fromJson(json.decode(str));

String notificationResponseToJson(NotificationResponse data) =>
    json.encode(data.toJson());

class NotificationResponse {
  dynamic msg;
  List<Notifications>? data;
  bool? success;

  NotificationResponse({
    this.msg,
    this.data,
    this.success,
  });

  factory NotificationResponse.fromJson(Map<String, dynamic> json) =>
      NotificationResponse(
        msg: json["msg"],
        data: json["data"] == null
            ? []
            : List<Notifications>.from(
                json["data"]!.map((x) => Notifications.fromJson(x))),
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

class Notifications {
  int? id;
  int? bookingId;
  int? userId;
  dynamic ownerId;
  dynamic empId;
  String? title;
  String? subTitle;
  DateTime? createdAt;
  DateTime? updatedAt;

  Notifications({
    this.id,
    this.bookingId,
    this.userId,
    this.ownerId,
    this.empId,
    this.title,
    this.subTitle,
    this.createdAt,
    this.updatedAt,
  });

  factory Notifications.fromJson(Map<String, dynamic> json) => Notifications(
        id: json["id"],
        bookingId: json["booking_id"],
        userId: json["user_id"],
        ownerId: json["owner_id"],
        empId: json["emp_id"],
        title: json["title"],
        subTitle: json["sub_title"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "booking_id": bookingId,
        "user_id": userId,
        "owner_id": ownerId,
        "emp_id": empId,
        "title": title,
        "sub_title": subTitle,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}
