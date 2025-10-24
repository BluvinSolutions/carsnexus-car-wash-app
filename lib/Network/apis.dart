class ApiKeys {
  // BASE URL
  // After you have entered/edited your base url, run the command:
  // flutter pub run build_runner build --delete-conflicting-outputs
  // to generate the api_services.g.dart file
  // Every time you change the base url, you need to run the above command
  static const String siteUrl = "https://voyzo.in/api/user/";

  // API CONNECTION CHECK
  static const String apiConnectionTest = "apiConnectionTest";

  //AUTHENTICATION APIS
  static const String login = "login";
  static const String register = "register";
  static const String forgotPassword = "forgot";
  static const String forgotOtpValidate = "forgot/validate";
  static const String newPassword = "newpassword";

  //HOMESCREEN APIS
  static const String getShops = "shop";
  static const String getShopDetails = "shop/{id}";
  static const String getShopNumbers = "simpleState";
  static const String getHomeScreen = "home";
  static const String getPackageDetails = "package/{id}";
  static const String getServiceDetails = "category/{id}";

  //PROFILE SCREEN APIS
  static const String getProfile = "profile";
  static const String getFaq = "faq";
  static const String getPrivacy = "privacy";
  static const String notification = "notification";
  static const String review = "review";

  static const String profileUpdate = "profile/update";
  static const String profilePictureUpdate = "profile/picture/update";
  static const String updatePassword = "profile/password/update";
  static const String notificationKey = "noti/setting";

  //BOOKING API
  static const String getBookings = "booking";
  static const String getBookingDetails = "booking/{id}";
  static const String getVehical = "vehicle";
  static const String getVehicalDetails = "vehicle/{id}";
  static const String addVehicle = "vehicle";
  static const String getVehicleBrands = "vehicleBrand";
  static const String getVehicalModels = "vehicleModel/{id}";
  static const String getAddress = "address";
  static const String addAddress = "address";
  static const String bookSlot = "booking";
  static const String paymentSettings = "payment/setting";
  static const String bookPayment = "booking/{id}/payment";
}
