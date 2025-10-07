import 'package:carsnexus_user/HomeAndOrder/model/home_screen_response.dart';

class ShopListResponse {
  dynamic msg;
  List<BestShops>? data;
  bool? success;

  ShopListResponse({this.msg, this.data, this.success});

  ShopListResponse.fromJson(Map<String, dynamic> json) {
    msg = json["msg"];
    if (json["data"] is List) {
      data = json["data"] == null
          ? null
          : (json["data"] as List).map((e) => BestShops.fromJson(e)).toList();
    }
    if (json["success"] is bool) {
      success = json["success"];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = <String, dynamic>{};
    map["msg"] = msg;
    if (data != null) {
      map["data"] = data?.map((e) => e.toJson()).toList();
    }
    map["success"] = success;
    return map;
  }
}
