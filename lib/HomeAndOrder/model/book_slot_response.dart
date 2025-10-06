// To parse this JSON data, do
//
//     final bookSlot = bookSlotFromJson(jsonString);

import 'dart:convert';

BookSlot bookSlotFromJson(String str) => BookSlot.fromJson(json.decode(str));

String bookSlotToJson(BookSlot data) => json.encode(data.toJson());

class BookSlot {
  String msg;
  dynamic data;
  bool success;

  BookSlot({
    required this.msg,
    this.data,
    required this.success,
  });

  factory BookSlot.fromJson(Map<String, dynamic> json) => BookSlot(
        msg: json["msg"],
        data: json["data"],
        success: json["success"],
      );

  Map<String, dynamic> toJson() => {
        "msg": msg,
        "data": data,
        "success": success,
      };
}
