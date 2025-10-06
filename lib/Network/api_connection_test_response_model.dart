// ['success' => true,'message'=>'API connection successful']

class ApiConnectionTestResponse {
  ApiConnectionTestResponse({
    required this.success,
    required this.message,
  });

  bool success;
  String message;

  factory ApiConnectionTestResponse.fromJson(Map<String, dynamic> json) =>
      ApiConnectionTestResponse(
        success: json["success"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
      };
}
