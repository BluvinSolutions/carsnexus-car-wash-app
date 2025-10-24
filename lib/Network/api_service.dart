import 'package:voyzo/Authentication/model/forgot_password_screen_response.dart';
import 'package:voyzo/Authentication/model/login_response_model.dart';
import 'package:voyzo/Authentication/model/new_password_response.dart';
import 'package:voyzo/Authentication/model/notification_keys_response.dart';
import 'package:voyzo/Authentication/model/register_response_model.dart';
import 'package:voyzo/Authentication/model/validate_otp_response.dart';
import 'package:voyzo/HomeAndOrder/model/add_address_response.dart';
import 'package:voyzo/HomeAndOrder/model/add_vehicle_response.dart';
import 'package:voyzo/HomeAndOrder/model/address_list_response.dart';
import 'package:voyzo/HomeAndOrder/model/book_slot_response.dart';
import 'package:voyzo/HomeAndOrder/model/category_response.dart';
import 'package:voyzo/HomeAndOrder/model/home_screen_response.dart';
import 'package:voyzo/HomeAndOrder/model/package_details_response.dart';
import 'package:voyzo/HomeAndOrder/model/shop_count_response.dart';
import 'package:voyzo/HomeAndOrder/model/shop_details_response.dart';
import 'package:voyzo/HomeAndOrder/model/shop_list_response.dart';
import 'package:voyzo/HomeAndOrder/model/vehical_response.dart';
import 'package:voyzo/HomeAndOrder/model/vehicle_brand_response.dart';
import 'package:voyzo/HomeAndOrder/model/vehicle_model_response.dart';
import 'package:voyzo/Network/api_connection_test_response_model.dart';
import 'package:voyzo/Network/apis.dart';
import 'package:voyzo/Profile/models/booking_details_response.dart';
import 'package:voyzo/Profile/models/booking_payment_response.dart';
import 'package:voyzo/Profile/models/booking_response.dart';
import 'package:voyzo/Profile/models/faq_response.dart';
import 'package:voyzo/Profile/models/notification_response.dart';
import 'package:voyzo/Profile/models/payment_keys_response.dart';
import 'package:voyzo/Profile/models/privacy_response.dart';
import 'package:voyzo/Profile/models/profile_response.dart';
import 'package:voyzo/Profile/models/review_response.dart';
import 'package:voyzo/Profile/models/update_password_response.dart';
import 'package:voyzo/Profile/models/update_profile_response.dart';
// ignore: depend_on_referenced_packages
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'api_service.g.dart';

@RestApi(baseUrl: ApiKeys.siteUrl)
abstract class RestClient {
  factory RestClient(Dio dio, {String baseUrl}) = _RestClient;

  @POST(ApiKeys.login)
  Future<LoginResponse> login(@Body() Map<String, dynamic> body);

  @POST(ApiKeys.register)
  Future<RegisterResponse> register(@Body() Map<String, dynamic> body);

  @POST(ApiKeys.forgotPassword)
  Future<ForgotPasswordResponse> getOTP(@Body() Map<String, dynamic> body);

  @POST(ApiKeys.forgotOtpValidate)
  Future<ValidateOtpResponse> validateOtp(@Body() Map<String, dynamic> body);

  @POST(ApiKeys.newPassword)
  Future<NewPasswordResponse> newPassword(@Body() Map<String, dynamic> body);

  @GET(ApiKeys.getBookings)
  Future<BookingResponse> getBookingList();

  @GET(ApiKeys.getBookingDetails)
  Future<BookingDetailsResponse> getBookingDetails(@Path() int id);

  @GET(ApiKeys.getProfile)
  Future<ProfileResponse> getProfileSettings();

  @GET(ApiKeys.getFaq)
  Future<FaqResponse> getFaq();

  @GET(ApiKeys.getPrivacy)
  Future<PrivacyResponse> privacy();

  @GET(ApiKeys.notification)
  Future<NotificationResponse> getNotification();

  @GET(ApiKeys.getShops)
  Future<ShopListResponse> getShopList();

  @GET(ApiKeys.getShopDetails)
  Future<ShopDetails> getShopDetails(@Path() int id);

  @GET(ApiKeys.getShopNumbers)
  Future<ShopCountResponse> shopCounting();

  @GET(ApiKeys.getHomeScreen)
  Future<HomeScreenResponse> getHomeScreen();

  @GET(ApiKeys.getPackageDetails)
  Future<PackageDetailsResponse> getPackageDetails(@Path() int id);

  @GET(ApiKeys.getServiceDetails)
  Future<CategoryResponse> getServiceDetails(@Path() int id);

  @GET(ApiKeys.getVehical)
  Future<VehicleResponse> getVehicles();

  @GET(ApiKeys.getVehicalDetails)
  Future<VehicalResponseData> getVehicleDetail(@Path() int id);

  @POST(ApiKeys.addVehicle)
  Future<VehicalAddResponse> addVehicle(@Body() Map<String, dynamic> body);

  @GET(ApiKeys.getVehicleBrands)
  Future<VehicalBrandResponse> getVehicleBrands();

  @GET(ApiKeys.getVehicalModels)
  Future<VehicleModelsResponse> getVehicleModel(@Path() int id);

  @GET(ApiKeys.notificationKey)
  Future<NotificationKeysResponse> notificationKeys();

  @GET(ApiKeys.getAddress)
  Future<AddressListResponse> showAddressList();

  @POST(ApiKeys.addAddress)
  Future<AddAddressResponse> addAddress(@Body() Map<String, dynamic> body);

  @POST(ApiKeys.getBookings)
  Future<BookSlot> booking(@Body() Map<String, dynamic> body);

  @GET(ApiKeys.paymentSettings)
  Future<PaymentKeysResponse> getPaymentSettings();

  @POST(ApiKeys.bookPayment)
  Future<BookingPaymentResponse> bookingPayment(
      @Path() int id, @Body() Map<String, dynamic> body);

  @POST(ApiKeys.profileUpdate)
  Future<UpdateProfileResponse> updateProfileDetails(
      @Body() Map<String, dynamic> body);

  @POST(ApiKeys.profilePictureUpdate)
  Future<UpdateProfileResponse> updatePicture(
      @Body() Map<String, dynamic> body);

  @POST(ApiKeys.updatePassword)
  Future<UpdatePasswordResponse> updatePassword(
      @Body() Map<String, dynamic> body);

  @POST(ApiKeys.review)
  Future<ReviewResponse> sendReview(@Body() Map<String, dynamic> body);

  @GET(ApiKeys.apiConnectionTest)
  Future<ApiConnectionTestResponse> apiConnectionTest();
}
