// To parse this JSON data, do
//
//     final packageDetailsResponse = packageDetailsResponseFromJson(jsonString);

import 'dart:convert';

PackageDetailsResponse packageDetailsResponseFromJson(String str) =>
    PackageDetailsResponse.fromJson(json.decode(str));

String packageDetailsResponseToJson(PackageDetailsResponse data) =>
    json.encode(data.toJson());

class PackageDetailsResponse {
  dynamic msg;
  PackageDetailsResponseData? data;
  bool? success;

  PackageDetailsResponse({
    this.msg,
    this.data,
    this.success,
  });

  factory PackageDetailsResponse.fromJson(Map<String, dynamic> json) =>
      PackageDetailsResponse(
        msg: json["msg"],
        data: json["data"] == null
            ? null
            : PackageDetailsResponseData.fromJson(json["data"]),
        success: json["success"],
      );

  Map<String, dynamic> toJson() => {
        "msg": msg,
        "data": data?.toJson(),
        "success": success,
      };
}

class PackageDetailsResponseData {
  int? id;
  String? name;
  int? price;
  List<String>? service;
  int? ownerId;
  int? duration;
  int? status;
  String? description;
  String? currency;
  List<ServiceDatum>? serviceData;

  PackageDetailsResponseData({
    this.id,
    this.name,
    this.price,
    this.service,
    this.ownerId,
    this.duration,
    this.status,
    this.description,
    this.currency,
    this.serviceData,
  });

  factory PackageDetailsResponseData.fromJson(Map<String, dynamic> json) =>
      PackageDetailsResponseData(
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
        serviceData: json["serviceData"] == null
            ? []
            : List<ServiceDatum>.from(
                json["serviceData"]!.map((x) => ServiceDatum.fromJson(x))),
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
        "serviceData": serviceData == null
            ? []
            : List<dynamic>.from(serviceData!.map((x) => x.toJson())),
      };
}

class ServiceDatum {
  String? name;
  int? id;
  String? currency;

  ServiceDatum({
    this.name,
    this.id,
    this.currency,
  });

  factory ServiceDatum.fromJson(Map<String, dynamic> json) => ServiceDatum(
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
