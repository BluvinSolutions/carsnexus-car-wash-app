// To parse this JSON data, do
//
//     final bookingDetailsResponse = bookingDetailsResponseFromJson(jsonString);

import 'dart:convert';

BookingDetailsResponse bookingDetailsResponseFromJson(String str) =>
    BookingDetailsResponse.fromJson(json.decode(str));

String bookingDetailsResponseToJson(BookingDetailsResponse data) =>
    json.encode(data.toJson());

class BookingDetailsResponse {
  dynamic msg;
  BookingDetailsResponseData? data;
  bool? success;

  BookingDetailsResponse({
    this.msg,
    this.data,
    this.success,
  });

  factory BookingDetailsResponse.fromJson(Map<String, dynamic> json) =>
      BookingDetailsResponse(
        msg: json["msg"],
        data: json["data"] == null
            ? null
            : BookingDetailsResponseData.fromJson(json["data"]),
        success: json["success"],
      );

  Map<String, dynamic> toJson() => {
        "msg": msg,
        "data": data?.toJson(),
        "success": success,
      };
}

class BookingDetailsResponseData {
  int? id;
  String? bookingId;
  int? userId;
  int? shopId;
  int? ownerId;
  dynamic employeeId;
  int? adminPer;
  String? address;
  int? vehicleId;
  DateTime? startTime;
  DateTime? endTime;
  int? serviceType;
  int? amount;
  int? discount;
  int? paymentStatus;
  String? paymentToken;
  String? paymentMethod;
  int? status;
  List<String>? service;
  DateTime? updatedAt;
  DateTime? createdAt;
  List<ServiceDatum>? serviceData;
  String? currency;
  Shop? shop;
  CarModel? model;
  Review? review;
  bool? isReviewed = false;

  BookingDetailsResponseData({
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
    this.serviceData,
    this.currency,
    this.shop,
    this.model,
    this.review,
    this.isReviewed,
  });

  factory BookingDetailsResponseData.fromJson(Map<String, dynamic> json) =>
      BookingDetailsResponseData(
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
        serviceData: json["serviceData"] == null
            ? []
            : List<ServiceDatum>.from(
                json["serviceData"]!.map((x) => ServiceDatum.fromJson(x))),
        currency: json["currency"],
        shop: json["shop"] == null ? null : Shop.fromJson(json["shop"]),
        model: json["model"] == null ? null : CarModel.fromJson(json["model"]),
        review: json["review"] == null ? null : Review.fromJson(json["review"]),
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
        "serviceData": serviceData == null
            ? []
            : List<dynamic>.from(serviceData!.map((x) => x.toJson())),
        "currency": currency,
        "shop": shop?.toJson(),
        "model": model?.toJson(),
        "review": review,
      };
}

class ServiceDatum {
  String? name;
  int? id;
  int? price;
  String? currency;

  ServiceDatum({
    this.name,
    this.id,
    this.price,
    this.currency,
  });

  factory ServiceDatum.fromJson(Map<String, dynamic> json) => ServiceDatum(
        name: json["name"],
        id: json["id"],
        price: json["price"],
        currency: json["currency"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "id": id,
        "price": price,
        "currency": currency,
      };
}

class Shop {
  int? id;
  String? name;
  String? image;
  String? address;
  String? imageUri;
  String? avgRating;

  Shop({
    this.id,
    this.name,
    this.image,
    this.address,
    this.imageUri,
    this.avgRating,
  });

  factory Shop.fromJson(Map<String, dynamic> json) => Shop(
        id: json["id"],
        name: json["name"],
        image: json["image"],
        address: json["address"],
        imageUri: json["imageUri"],
        avgRating: json["avg_rating"].toString(),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "image": image,
        "address": address,
        "imageUri": imageUri,
        "avg_rating": avgRating,
      };
}

class CarModel {
  int? id;
  int? userId;
  int? modelId;
  String? regNumber;
  String? color;
  ModelModel? model;

  CarModel({
    this.id,
    this.userId,
    this.modelId,
    this.regNumber,
    this.color,
    this.model,
  });

  factory CarModel.fromJson(Map<String, dynamic> json) => CarModel(
        id: json["id"],
        userId: json["user_id"],
        modelId: json["model_id"],
        regNumber: json["reg_number"],
        color: json["color"],
        model:
            json["model"] == null ? null : ModelModel.fromJson(json["model"]),
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

class ModelModel {
  int? id;
  int? brandId;
  String? name;
  Brand? brand;

  ModelModel({
    this.id,
    this.brandId,
    this.name,
    this.brand,
  });

  factory ModelModel.fromJson(Map<String, dynamic> json) => ModelModel(
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

class Review {
  int? id;
  int? userId;
  int? employeeId;
  int? shopId;
  int? bookingId;
  int? star;
  String? cmt;
  DateTime? createdAt;
  DateTime? updatedAt;
  User? user;

  Review({
    this.id,
    this.userId,
    this.employeeId,
    this.shopId,
    this.bookingId,
    this.star,
    this.cmt,
    this.createdAt,
    this.updatedAt,
    this.user,
  });

  factory Review.fromJson(Map<String, dynamic> json) => Review(
        id: json["id"],
        userId: json["user_id"],
        employeeId: json["employee_id"],
        shopId: json["shop_id"],
        bookingId: json["booking_id"],
        star: json["star"],
        cmt: json["cmt"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        user: json["user"] == null ? null : User.fromJson(json["user"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "employee_id": employeeId,
        "shop_id": shopId,
        "booking_id": bookingId,
        "star": star,
        "cmt": cmt,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "user": user?.toJson(),
      };
}

class User {
  String? name;
  int? id;
  String? image;
  String? imageUri;

  User({
    this.name,
    this.id,
    this.image,
    this.imageUri,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        name: json["name"],
        id: json["id"],
        image: json["image"],
        imageUri: json["imageUri"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "id": id,
        "image": image,
        "imageUri": imageUri,
      };
}
