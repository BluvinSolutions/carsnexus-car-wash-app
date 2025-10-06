// To parse this JSON data, do
//
//     final shopDetails = shopDetailsFromJson(jsonString);

import 'dart:convert';

ShopDetails shopDetailsFromJson(String str) =>
    ShopDetails.fromJson(json.decode(str));

String shopDetailsToJson(ShopDetails data) => json.encode(data.toJson());

class ShopDetails {
  dynamic msg;
  ShopDetailsData? data;
  bool? success;

  ShopDetails({
    this.msg,
    this.data,
    this.success,
  });

  factory ShopDetails.fromJson(Map<String, dynamic> json) => ShopDetails(
        msg: json["msg"],
        data: json["data"] == null
            ? null
            : ShopDetailsData.fromJson(json["data"]),
        success: json["success"],
      );

  Map<String, dynamic> toJson() => {
        "msg": msg,
        "data": data?.toJson(),
        "success": success,
      };
}

class ShopDetailsData {
  int? id;
  int? ownerId;
  List<String>? serviceId;
  List<String>? packageId;
  List<String>? employeeId;
  String? name;
  String? address;
  String? image;
  String? phoneNo;
  int? isPopular;
  int? isBest;
  String? startTime;
  String? endTime;
  int? serviceType;
  int? status;
  List<Cate>? cate;
  String? imageUri;
  String? avgRating;
  List<PackageData>? packageData;
  List<ShopServiceData>? serviceData;

  ShopDetailsData({
    this.id,
    this.ownerId,
    this.serviceId,
    this.packageId,
    this.employeeId,
    this.name,
    this.address,
    this.image,
    this.phoneNo,
    this.isPopular,
    this.isBest,
    this.startTime,
    this.endTime,
    this.serviceType,
    this.status,
    this.cate,
    this.imageUri,
    this.avgRating,
    this.packageData,
    this.serviceData,
  });

  factory ShopDetailsData.fromJson(Map<String, dynamic> json) =>
      ShopDetailsData(
        id: json["id"],
        ownerId: json["owner_id"],
        serviceId: json["service_id"] == null
            ? []
            : List<String>.from(json["service_id"]!.map((x) => x)),
        packageId: json["package_id"] == null
            ? []
            : List<String>.from(json["package_id"]!.map((x) => x)),
        employeeId: json["employee_id"] == null
            ? []
            : List<String>.from(json["employee_id"]!.map((x) => x)),
        name: json["name"],
        address: json["address"],
        image: json["image"],
        phoneNo: json["phone_no"],
        isPopular: json["is_popular"],
        isBest: json["is_best"],
        startTime: json["start_time"],
        endTime: json["end_time"],
        serviceType: json["service_type"],
        status: json["status"],
        cate: json["cate"] == null
            ? []
            : List<Cate>.from(json["cate"]!.map((x) => Cate.fromJson(x))),
        imageUri: json["imageUri"],
        avgRating: json["avg_rating"].toString(),
        packageData: json["packageData"] == null
            ? []
            : List<PackageData>.from(
                json["packageData"]!.map((x) => PackageData.fromJson(x))),
        serviceData: json["serviceData"] == null
            ? []
            : List<ShopServiceData>.from(
                json["serviceData"]!.map((x) => ShopServiceData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "owner_id": ownerId,
        "service_id": serviceId == null
            ? []
            : List<dynamic>.from(serviceId!.map((x) => x)),
        "package_id": packageId == null
            ? []
            : List<dynamic>.from(packageId!.map((x) => x)),
        "employee_id": employeeId == null
            ? []
            : List<dynamic>.from(employeeId!.map((x) => x)),
        "name": name,
        "address": address,
        "image": image,
        "phone_no": phoneNo,
        "is_popular": isPopular,
        "is_best": isBest,
        "start_time": startTime,
        "end_time": endTime,
        "service_type": serviceType,
        "status": status,
        "cate": cate == null
            ? []
            : List<dynamic>.from(cate!.map((x) => x.toJson())),
        "imageUri": imageUri,
        "avg_rating": avgRating,
        "packageData": packageData == null
            ? []
            : List<dynamic>.from(packageData!.map((x) => x.toJson())),
        "serviceData": serviceData == null
            ? []
            : List<dynamic>.from(serviceData!.map((x) => x.toJson())),
      };
}

class Cate {
  int? id;
  String? name;
  String? icon;
  String? imageUri;

  Cate({
    this.id,
    this.name,
    this.icon,
    this.imageUri,
  });

  factory Cate.fromJson(Map<String, dynamic> json) => Cate(
        id: json["id"],
        name: json["name"],
        icon: json["icon"],
        imageUri: json["imageUri"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "icon": icon,
        "imageUri": imageUri,
      };
}

class PackageData {
  int? id;
  String? name;
  int? price;
  List<String>? service;
  int? ownerId;
  int? duration;
  int? status;
  String? description;
  String? currency;
  List<ShopPackageData>? packageServiceData;

  PackageData({
    this.id,
    this.name,
    this.price,
    this.service,
    this.ownerId,
    this.duration,
    this.status,
    this.description,
    this.currency,
    this.packageServiceData,
  });

  factory PackageData.fromJson(Map<String, dynamic> json) => PackageData(
        id: json["id"],
        name: json["name"],
        price: json["price"],
        service: json["service"] == null
            ? []
            : List<String>.from(json["service"]!.map((x) => x)),
        ownerId: json["owner_id"],
        duration: json["duration"],
        status: json["status"],
        description: json["description"],
        currency: json["currency"],
        packageServiceData: json["serviceData"] == null
            ? []
            : List<ShopPackageData>.from(
                json["serviceData"]!.map((x) => ShopPackageData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "price": price,
        "service":
            service == null ? [] : List<dynamic>.from(service!.map((x) => x)),
        "owner_id": ownerId,
        "duration": duration,
        "status": status,
        "description": description,
        "currency": currency,
        "serviceData": packageServiceData == null
            ? []
            : List<dynamic>.from(packageServiceData!.map((x) => x.toJson())),
      };
}

class ShopPackageData {
  String? name;
  int? id;
  String? currency;

  ShopPackageData({
    this.name,
    this.id,
    this.currency,
  });

  factory ShopPackageData.fromJson(Map<String, dynamic> json) =>
      ShopPackageData(
        name: json["name"],
        id: json["id"],
        currency: json["currency"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "id": id,
        "currency": currency,
      };
}

class ShopServiceData {
  String? name;
  int? id;
  String? description;
  int? duration;
  int? price;
  String? currency;
  bool isSelected = false;

  ShopServiceData({
    this.name,
    this.id,
    this.description,
    this.duration,
    this.price,
    this.currency,
  });

  factory ShopServiceData.fromJson(Map<String, dynamic> json) =>
      ShopServiceData(
        name: json["name"],
        id: json["id"],
        description: json["description"],
        duration: json["duration"],
        price: json["price"],
        currency: json["currency"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "id": id,
        "description": description,
        "duration": duration,
        "price": price,
        "currency": currency,
      };
}
