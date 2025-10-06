// To parse this JSON data, do
//
//     final faqResponse = faqResponseFromJson(jsonString);

import 'dart:convert';

FaqResponse faqResponseFromJson(String str) =>
    FaqResponse.fromJson(json.decode(str));

String faqResponseToJson(FaqResponse data) => json.encode(data.toJson());

class FaqResponse {
  dynamic msg;
  List<FaqResponseData>? data;
  bool? success;

  FaqResponse({
    this.msg,
    this.data,
    this.success,
  });

  factory FaqResponse.fromJson(Map<String, dynamic> json) => FaqResponse(
        msg: json["msg"],
        data: json["data"] == null
            ? []
            : List<FaqResponseData>.from(
                json["data"]!.map((x) => FaqResponseData.fromJson(x))),
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

class FaqResponseData {
  int? id;
  String? question;
  String? answer;
  DateTime? createdAt;
  DateTime? updatedAt;

  FaqResponseData({
    this.id,
    this.question,
    this.answer,
    this.createdAt,
    this.updatedAt,
  });

  factory FaqResponseData.fromJson(Map<String, dynamic> json) =>
      FaqResponseData(
        id: json["id"],
        question: json["question"],
        answer: json["answer"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "question": question,
        "answer": answer,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}
