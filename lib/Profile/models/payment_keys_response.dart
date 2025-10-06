// To parse this JSON data, do
//
//     final paymentKeysResponse = paymentKeysResponseFromJson(jsonString);

import 'dart:convert';

PaymentKeysResponse paymentKeysResponseFromJson(String str) =>
    PaymentKeysResponse.fromJson(json.decode(str));

String paymentKeysResponseToJson(PaymentKeysResponse data) =>
    json.encode(data.toJson());

class PaymentKeysResponse {
  dynamic msg;
  Data? data;
  bool? success;

  PaymentKeysResponse({
    this.msg,
    this.data,
    this.success,
  });

  factory PaymentKeysResponse.fromJson(Map<String, dynamic> json) =>
      PaymentKeysResponse(
        msg: json["msg"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
        success: json["success"],
      );

  Map<String, dynamic> toJson() => {
        "msg": msg,
        "data": data?.toJson(),
        "success": success,
      };
}

class Data {
  int? offlinePayment;
  int? stipeStatus;
  int? paypalStatus;
  int? razorStatus;
  String? currency;
  String? currencySymbol;
  String? stripeSecret;
  String? stripeKey;
  String? pProductionClientId;
  String? pProductionSecret;
  String? pSandboxClientId;
  String? razorId;

  Data({
    this.offlinePayment,
    this.stipeStatus,
    this.paypalStatus,
    this.razorStatus,
    this.currency,
    this.currencySymbol,
    this.stripeSecret,
    this.stripeKey,
    this.pProductionClientId,
    this.pProductionSecret,
    this.pSandboxClientId,
    this.razorId,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        offlinePayment: json["offline_payment"],
        stipeStatus: json["stipe_status"],
        paypalStatus: json["paypal_status"],
        razorStatus: json["razor_status"],
        currency: json["currency"],
        currencySymbol: json["currency_symbol"],
        stripeSecret: json["STRIPE_SECRET"],
        stripeKey: json["STRIPE_KEY"],
        pProductionClientId: json["P_PRODUCTION_CLIENT_ID"],
        pProductionSecret: json["P_PRODUCTION_SECRET"],
        pSandboxClientId: json["P_SANDBOX_CLIENT_ID"],
        razorId: json["RAZOR_ID"],
      );

  Map<String, dynamic> toJson() => {
        "offline_payment": offlinePayment,
        "stipe_status": stipeStatus,
        "paypal_status": paypalStatus,
        "razor_status": razorStatus,
        "currency": currency,
        "currency_symbol": currencySymbol,
        "STRIPE_SECRET": stripeSecret,
        "STRIPE_KEY": stripeKey,
        "P_PRODUCTION_CLIENT_ID": pProductionClientId,
        "P_PRODUCTION_SECRET": pProductionSecret,
        "P_SANDBOX_CLIENT_ID": pSandboxClientId,
        "RAZOR_ID": razorId,
      };
}
