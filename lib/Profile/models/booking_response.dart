// To parse this JSON data, do
//
//     final bookingResponse = bookingResponseFromJson(jsonString);

import 'dart:convert';

BookingResponse bookingResponseFromJson(String str) =>
    BookingResponse.fromJson(json.decode(str));

String bookingResponseToJson(BookingResponse data) =>
    json.encode(data.toJson());

class BookingResponse {
  dynamic msg;
  BookingResponseData? data;
  bool? success;

  BookingResponse({
    this.msg,
    this.data,
    this.success,
  });

  factory BookingResponse.fromJson(Map<String, dynamic> json) =>
      BookingResponse(
        msg: json["msg"],
        data: json["data"] == null
            ? null
            : BookingResponseData.fromJson(json["data"]),
        success: json["success"],
      );

  Map<String, dynamic> toJson() => {
        "msg": msg,
        "data": data?.toJson(),
        "success": success,
      };
}

class BookingResponseData {
  List<BookingStatus>? wait;
  List<BookingStatus>? current;
  List<BookingStatus>? complete;
  List<BookingStatus>? cancel;

  BookingResponseData({
    this.wait,
    this.current,
    this.complete,
    this.cancel,
  });

  factory BookingResponseData.fromJson(Map<String, dynamic> json) =>
      BookingResponseData(
        wait: json["wait"] == null
            ? []
            : List<BookingStatus>.from(
                json["wait"]!.map((x) => BookingStatus.fromJson(x))),
        current: json["current"] == null
            ? []
            : List<BookingStatus>.from(
                json["current"]!.map((x) => BookingStatus.fromJson(x))),
        complete: json["complete"] == null
            ? []
            : List<BookingStatus>.from(
                json["complete"]!.map((x) => BookingStatus.fromJson(x))),
        cancel: json["cancel"] == null
            ? []
            : List<BookingStatus>.from(
                json["cancel"]!.map((x) => BookingStatus.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "wait": wait == null
            ? []
            : List<dynamic>.from(wait!.map((x) => x.toJson())),
        "current": current == null
            ? []
            : List<dynamic>.from(current!.map((x) => x.toJson())),
        "complete": complete == null
            ? []
            : List<dynamic>.from(complete!.map((x) => x.toJson())),
        "cancel": cancel == null
            ? []
            : List<dynamic>.from(cancel!.map((x) => x.toJson())),
      };
}

class BookingStatus {
  int? id;
  DateTime? startTime;
  DateTime? endTime;
  int? status;
  String? address;
  int? shopId;
  int? vehicleId;
  String? bookingId;
  String? currency;
  Shop? shop;
  Model? model;

  BookingStatus({
    this.id,
    this.startTime,
    this.endTime,
    this.status,
    this.address,
    this.shopId,
    this.vehicleId,
    this.bookingId,
    this.currency,
    this.shop,
    this.model,
  });

  factory BookingStatus.fromJson(Map<String, dynamic> json) => BookingStatus(
        id: json["id"],
        startTime: json["start_time"] == null
            ? null
            : DateTime.parse(json["start_time"]),
        endTime:
            json["end_time"] == null ? null : DateTime.parse(json["end_time"]),
        status: json["status"],
        address: json["address"],
        shopId: json["shop_id"],
        vehicleId: json["vehicle_id"],
        bookingId: json["booking_id"],
        currency: json["currency"],
        shop: json["shop"] == null ? null : Shop.fromJson(json["shop"]),
        model: json["model"] == null ? null : Model.fromJson(json["model"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "start_time": startTime?.toIso8601String(),
        "end_time": endTime?.toIso8601String(),
        "status": status,
        "address": address,
        "shop_id": shopId,
        "vehicle_id": vehicleId,
        "booking_id": bookingId,
        "currency": currency,
        "shop": shop?.toJson(),
        "model": model?.toJson(),
      };
}

class Model {
  int? id;
  String? regNumber;

  Model({
    this.id,
    this.regNumber,
  });

  factory Model.fromJson(Map<String, dynamic> json) => Model(
        id: json["id"],
        regNumber: json["reg_number"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "reg_number": regNumber,
      };
}

class Shop {
  int? id;
  String? name;
  dynamic imageUri;
  dynamic avgRating;

  Shop({
    this.id,
    this.name,
    this.imageUri,
    this.avgRating,
  });

  factory Shop.fromJson(Map<String, dynamic> json) => Shop(
        id: json["id"],
        name: json["name"],
        imageUri: json["imageUri"],
        avgRating: json["avg_rating"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "imageUri": imageUri,
        "avg_rating": avgRating,
      };
}
