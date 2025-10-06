// To parse this JSON data, do
//
//     final bookingPaymentResponse = bookingPaymentResponseFromJson(jsonString);

import 'dart:convert';

BookingPaymentResponse bookingPaymentResponseFromJson(String str) =>
    BookingPaymentResponse.fromJson(json.decode(str));

String bookingPaymentResponseToJson(BookingPaymentResponse data) =>
    json.encode(data.toJson());

class BookingPaymentResponse {
  String? msg;
  BookingPaymentResponseData? data;
  bool? success;

  BookingPaymentResponse({
    this.msg,
    this.data,
    this.success,
  });

  factory BookingPaymentResponse.fromJson(Map<String, dynamic> json) =>
      BookingPaymentResponse(
        msg: json["msg"],
        data: json["data"] == null
            ? null
            : BookingPaymentResponseData.fromJson(json["data"]),
        success: json["success"],
      );

  Map<String, dynamic> toJson() => {
        "msg": msg,
        "data": data?.toJson(),
        "success": success,
      };
}

class BookingPaymentResponseData {
  int? id;
  String? bookingId;
  int? userId;
  int? shopId;
  int? ownerId;
  int? employeeId;
  int? adminPer;
  String? address;
  int? vehicleId;
  DateTime? startTime;
  DateTime? endTime;
  int? serviceType;
  num? amount;
  int? discount;
  dynamic paymentStatus;
  String? paymentToken;
  String? paymentMethod;
  int? status;
  List<String>? service;
  DateTime? updatedAt;
  DateTime? createdAt;
  String? currency;

  BookingPaymentResponseData({
    this.id,
    this.bookingId,
    this.userId,
    this.shopId,
    this.ownerId,
    this.employeeId,
    this.adminPer,
    this.address,
    this.vehicleId,
    this.startTime,
    this.endTime,
    this.serviceType,
    this.amount,
    this.discount,
    this.paymentStatus,
    this.paymentToken,
    this.paymentMethod,
    this.status,
    this.service,
    this.updatedAt,
    this.createdAt,
    this.currency,
  });

  factory BookingPaymentResponseData.fromJson(Map<String, dynamic> json) =>
      BookingPaymentResponseData(
        id: json["id"],
        bookingId: json["booking_id"],
        userId: json["user_id"],
        shopId: json["shop_id"],
        ownerId: json["owner_id"],
        employeeId: json["employee_id"],
        adminPer: json["admin_per"],
        address: json["address"],
        vehicleId: json["vehicle_id"],
        startTime: json["start_time"] == null
            ? null
            : DateTime.parse(json["start_time"]),
        endTime:
            json["end_time"] == null ? null : DateTime.parse(json["end_time"]),
        serviceType: json["service_type"],
        amount: json["amount"],
        discount: json["discount"],
        paymentStatus: json["payment_status"],
        paymentToken: json["payment_token"],
        paymentMethod: json["payment_method"],
        status: json["status"],
        service: json["service"] == null
            ? []
            : List<String>.from(json["service"]!.map((x) => x)),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        currency: json["currency"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "booking_id": bookingId,
        "user_id": userId,
        "shop_id": shopId,
        "owner_id": ownerId,
        "employee_id": employeeId,
        "admin_per": adminPer,
        "address": address,
        "vehicle_id": vehicleId,
        "start_time": startTime?.toIso8601String(),
        "end_time": endTime?.toIso8601String(),
        "service_type": serviceType,
        "amount": amount,
        "discount": discount,
        "payment_status": paymentStatus,
        "payment_token": paymentToken,
        "payment_method": paymentMethod,
        "status": status,
        "service":
            service == null ? [] : List<dynamic>.from(service!.map((x) => x)),
        "updated_at": updatedAt?.toIso8601String(),
        "created_at": createdAt?.toIso8601String(),
        "currency": currency,
      };
}
