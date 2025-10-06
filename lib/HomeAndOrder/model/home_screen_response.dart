class HomeScreenResponse {
  dynamic msg;
  Data? data;
  bool? success;

  HomeScreenResponse({this.msg, this.data, this.success});

  HomeScreenResponse.fromJson(Map<String, dynamic> json) {
    msg = json["msg"];
    if (json["data"] is Map) {
      data = json["data"] == null ? null : Data.fromJson(json["data"]);
    }
    if (json["success"] is bool) {
      success = json["success"];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = <String, dynamic>{};
    map["msg"] = msg;
    if (data != null) {
      map["data"] = data?.toJson();
    }
    map["success"] = success;
    return map;
  }
}

class Data {
  List<Services>? category;
  List<PopularServices>? popular;
  List<BestShops>? best;

  Data({this.category, this.popular, this.best});

  Data.fromJson(Map<String, dynamic> json) {
    if (json["category"] is List) {
      category = json["category"] == null
          ? null
          : (json["category"] as List)
              .map((e) => Services.fromJson(e))
              .toList();
    }
    if (json["popular"] is List) {
      popular = json["popular"] == null
          ? null
          : (json["popular"] as List)
              .map((e) => PopularServices.fromJson(e))
              .toList();
    }
    if (json["best"] is List) {
      best = json["best"] == null
          ? null
          : (json["best"] as List).map((e) => BestShops.fromJson(e)).toList();
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = <String, dynamic>{};
    if (category != null) {
      map["category"] = category?.map((e) => e.toJson()).toList();
    }
    if (popular != null) {
      map["popular"] = popular?.map((e) => e.toJson()).toList();
    }
    if (best != null) {
      map["best"] = best?.map((e) => e.toJson()).toList();
    }
    return map;
  }
}

class BestShops {
  String? name;
  int? id;
  String? image;
  String? address;
  String? imageUri;
  String? avgRating;

  BestShops(
      {this.name,
      this.id,
      this.image,
      this.address,
      this.imageUri,
      this.avgRating});

  BestShops.fromJson(Map<String, dynamic> json) {
    if (json["name"] is String) {
      name = json["name"];
    }
    if (json["id"] is int) {
      id = json["id"];
    }
    if (json["image"] is String) {
      image = json["image"];
    }
    if (json["address"] is String) {
      address = json["address"];
    }
    if (json["imageUri"] is String) {
      imageUri = json["imageUri"];
    }
    if (json["avg_rating"] is String) {
      avgRating = json["avg_rating"];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = <String, dynamic>{};
    map["name"] = name;
    map["id"] = id;
    map["image"] = image;
    map["address"] = address;
    map["imageUri"] = imageUri;
    map["avg_rating"] = avgRating;
    return map;
  }
}

class PopularServices {
  String? name;
  int? id;
  String? image;
  String? imageUri;
  String? avgRating;

  PopularServices(
      {this.name, this.id, this.image, this.imageUri, this.avgRating});

  PopularServices.fromJson(Map<String, dynamic> json) {
    if (json["name"] is String) {
      name = json["name"];
    }
    if (json["id"] is int) {
      id = json["id"];
    }
    if (json["image"] is String) {
      image = json["image"];
    }
    if (json["imageUri"] is String) {
      imageUri = json["imageUri"];
    }
    if (json["avg_rating"] is String) {
      avgRating = json["avg_rating"];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = <String, dynamic>{};
    map["name"] = name;
    map["id"] = id;
    map["image"] = image;
    map["imageUri"] = imageUri;
    map["avg_rating"] = avgRating;
    return map;
  }
}

class Services {
  int? id;
  String? name;
  String? icon;
  int? isTrending;
  int? status;
  String? imageUri;

  Services(
      {this.id,
      this.name,
      this.icon,
      this.isTrending,
      this.status,
      this.imageUri});

  Services.fromJson(Map<String, dynamic> json) {
    if (json["id"] is int) {
      id = json["id"];
    }
    if (json["name"] is String) {
      name = json["name"];
    }
    if (json["icon"] is String) {
      icon = json["icon"];
    }
    if (json["is_trending"] is int) {
      isTrending = json["is_trending"];
    }
    if (json["status"] is int) {
      status = json["status"];
    }
    if (json["imageUri"] is String) {
      imageUri = json["imageUri"];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = <String, dynamic>{};
    map["id"] = id;
    map["name"] = name;
    map["icon"] = icon;
    map["is_trending"] = isTrending;
    map["status"] = status;
    map["imageUri"] = imageUri;
    return map;
  }
}
