// To parse this JSON data, do
//
//     final addAddressResponse = addAddressResponseFromJson(jsonString);

import 'dart:convert';

import 'package:voyzo/HomeAndOrder/model/address_list_response.dart';

AddAddressResponse addAddressResponseFromJson(String str) =>
    AddAddressResponse.fromJson(json.decode(str));

String addAddressResponseToJson(AddAddressResponse data) =>
    json.encode(data.toJson());

class AddAddressResponse {
  String? msg;
  AddressListData? data;
  bool? success;

  AddAddressResponse({
    this.msg,
    this.data,
    this.success,
  });

  factory AddAddressResponse.fromJson(Map<String, dynamic> json) =>
      AddAddressResponse(
        msg: json["msg"],
        data: json["data"] == null
            ? null
            : AddressListData.fromJson(json["data"]),
        success: json["success"],
      );

  Map<String, dynamic> toJson() => {
        "msg": msg,
        "data": data?.toJson(),
        "success": success,
      };
}
