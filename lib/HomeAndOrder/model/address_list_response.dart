// To parse this JSON data, do
//
//     final addressListResponse = addressListResponseFromJson(jsonString);

import 'dart:convert';

AddressListResponse addressListResponseFromJson(String str) =>
    AddressListResponse.fromJson(json.decode(str));

String addressListResponseToJson(AddressListResponse data) =>
    json.encode(data.toJson());

class AddressListResponse {
  dynamic msg;
  List<AddressListData>? data;
  bool? success;

  AddressListResponse({
    this.msg,
    this.data,
    this.success,
  });

  factory AddressListResponse.fromJson(Map<String, dynamic> json) =>
      AddressListResponse(
        msg: json["msg"],
        data: json["data"] == null
            ? []
            : List<AddressListData>.from(
                json["data"]!.map((x) => AddressListData.fromJson(x))),
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

class AddressListData {
  int? id;
  int? userId;
  String? line1;
  String? city;
  String? pinCode;
  int? type;

  AddressListData({
    this.id,
    this.userId,
    this.line1,
    this.city,
    this.pinCode,
    this.type,
  });

  factory AddressListData.fromJson(Map<String, dynamic> json) =>
      AddressListData(
        id: json["id"],
        userId: json["user_id"],
        line1: json["line_1"],
        city: json["city"],
        pinCode: json["pincode"],
        type: json["type"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "line_1": line1,
        "city": city,
        "pincode": pinCode,
        "type": type,
      };
}
