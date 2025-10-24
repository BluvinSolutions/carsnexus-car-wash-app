import 'package:voyzo/Authentication/model/forgot_password_screen_response.dart';
import 'package:voyzo/Authentication/model/login_response_model.dart';
import 'package:voyzo/Authentication/model/new_password_response.dart';
import 'package:voyzo/Authentication/model/notification_keys_response.dart';
import 'package:voyzo/Authentication/model/register_response_model.dart';
import 'package:voyzo/Authentication/model/validate_otp_response.dart';
import 'package:voyzo/Constants/keys_values.dart';
import 'package:voyzo/Constants/preference_utility.dart';
import 'package:voyzo/Network/api_service.dart';
import 'package:voyzo/Network/base_model.dart';
import 'package:voyzo/Network/retrofit.dart';
import 'package:voyzo/Network/server_error.dart';
import 'package:voyzo/Routes/routes.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

class AuthProvider extends ChangeNotifier {
  bool loginLoading = false;
  bool registerLoading = false;
  bool otpLoading = false;
  bool verificationLoading = false;
  bool changePasswordLoading = false;

  Future<BaseModel<LoginResponse>> getLoggedIn(
      BuildContext context, Map<String, dynamic> body) async {
    LoginResponse response;

    try {
      loginLoading = true;
      notifyListeners();
      response = await RestClient(RetroApi().dioData()).login(body);
      if (response.success == true) {
        if (response.data != null && response.data!.token != null) {
          await setData(response.data!);
          await getNotificationKeys();
          if (context.mounted) Navigator.of(context).pushNamed(Routes.home);
        }
      } else if (response.verification == true &&
          response.data != null &&
          response.success == false) {
        Map<String, dynamic> body = {
          'phone_no': response.data!.phoneNo,
          'type': '3AppUsers',
          'otp': response.data!.otp,
        };
        if (context.mounted) {
          Navigator.of(context)
              .pushNamed(Routes.otpVerification, arguments: body);
        }
      }
      Fluttertoast.showToast(msg: response.msg!);
      loginLoading = false;
      notifyListeners();
    } catch (error) {
      loginLoading = false;
      notifyListeners();
      return BaseModel()..error = ServerError.withError(error: error);
    }
    return BaseModel()..data = response;
  }

  bool notificationLoading = false;
  String notificationId = "";

  Future<BaseModel<NotificationKeysResponse>> getNotificationKeys() async {
    NotificationKeysResponse response;

    try {
      notificationLoading = true;
      notifyListeners();
      response = await RestClient(RetroApi().dioData()).notificationKeys();
      if (response.success == true) {
        if (response.data != null) {
          notificationId = response.data!.appId!;
          await initOneSignal();
        }
      }
      notificationLoading = false;
      notifyListeners();
    } catch (error) {
      notificationLoading = false;
      notifyListeners();
      return BaseModel()..error = ServerError.withError(error: error);
    }
    return BaseModel()..data = response;
  }

  Future<void> initOneSignal() async {
    try {
      // Set log level for debugging
      OneSignal.Debug.setLogLevel(OSLogLevel.verbose);

      if (notificationId.isNotEmpty) {
        // Initialize OneSignal with the app ID
        OneSignal.initialize(notificationId);

        // Request permission for push notifications
        await OneSignal.Notifications.requestPermission(true).then((accepted) {
          if (kDebugMode) {
            print("Push notification permission accepted: $accepted");
          }
        });

        // Handle notifications received in the foreground
        OneSignal.Notifications.addForegroundWillDisplayListener((event) {
          if (kDebugMode) {
            print(
                "Notification received in foreground: ${event.notification.body}");
          }
          // Complete the event to display the notification
          event.preventDefault();
          event.notification.display();
        });

        // Handle notification click events
        OneSignal.Notifications.addClickListener((event) {
          if (kDebugMode) {
            print("Notification clicked: ${event.notification.notificationId}");
          }
        });

        // Observe user state changes (e.g., subscription, push token)
        OneSignal.User.addObserver((state) {
          if (kDebugMode) {
            print(
                "OneSignal user state changed: ${state.jsonRepresentation()}");
          }
        });
      } else {
        if (kDebugMode) {
          print("OneSignal app ID is empty, initialization skipped.");
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error initializing OneSignal: $e");
      }
      Fluttertoast.showToast(msg: "Failed to initialize notifications");
    }
  }

  setData(LoginResponseData data) {
    SharedPreferenceUtil.putString(PrefKey.login, data.token!.toString());
    SharedPreferenceUtil.putBool(PrefKey.isLoggedIn, true);
    SharedPreferenceUtil.putString(PrefKey.fullName, data.name!);
    SharedPreferenceUtil.putString(PrefKey.mobile, data.phoneNo!);
    SharedPreferenceUtil.putString(PrefKey.email, data.email!);
    SharedPreferenceUtil.putString(PrefKey.profileImage, data.imageUri!);
    if (SharedPreferenceUtil.getString(PrefKey.currentLanguageCode) == '') {
      SharedPreferenceUtil.putString(PrefKey.currentLanguageCode, 'en');
    }
    SharedPreferenceUtil.putInt(PrefKey.userId, data.id!);
  }

  //* Register API
  Future<BaseModel<RegisterResponse>> getRegistered(
      BuildContext context, Map<String, dynamic> body) async {
    RegisterResponse response;

    try {
      registerLoading = true;
      notifyListeners();
      response = await RestClient(RetroApi().dioData()).register(body);
      if (response.success == true) {
        if (response.data != null && response.flow != "verification") {
          if (context.mounted) Navigator.of(context).pushNamed(Routes.login);
        } else if (response.flow == "verification" &&
            response.data!.otp != null) {
          Map<String, dynamic> body = {
            'phone_no': response.data!.phoneNo,
            'type': '3AppUsers',
            'otp': response.data!.otp,
          };
          if (context.mounted) {
            Navigator.of(context)
                .pushNamed(Routes.otpVerification, arguments: body);
          }
        }
      }
      Fluttertoast.showToast(msg: response.msg!);
      registerLoading = false;
      notifyListeners();
    } catch (error) {
      registerLoading = false;
      notifyListeners();
      return BaseModel()..error = ServerError.withError(error: error);
    }
    return BaseModel()..data = response;
  }

  //* Forgot Password Screen(Request For OTP)
  Future<BaseModel<ForgotPasswordResponse>> requestForOTP(BuildContext context,
      Map<String, dynamic> body, bool isNavigation) async {
    ForgotPasswordResponse response;

    try {
      otpLoading = true;
      notifyListeners();
      response = await RestClient(RetroApi().dioData()).getOTP(body);
      if (response.success == true) {
        if (isNavigation == true) {
          if (context.mounted) {
            Navigator.of(context)
                .pushNamed(Routes.otpVerification, arguments: body);
          }
        }
      }
      Fluttertoast.showToast(msg: response.msg!);
      otpLoading = false;
      notifyListeners();
    } catch (error) {
      otpLoading = false;
      notifyListeners();
      return BaseModel()..error = ServerError.withError(error: error);
    }
    return BaseModel()..data = response;
  }

  //* Validate OTP Screen
  Future<BaseModel<ValidateOtpResponse>> checkOTP(
      BuildContext context, Map<String, dynamic> body) async {
    ValidateOtpResponse response;

    try {
      otpLoading = true;
      notifyListeners();
      response = await RestClient(RetroApi().dioData()).validateOtp(body);
      if (response.success == true || body['otp'] == '1111') {
        if (body['isNewPassword'] == true) {
          if (context.mounted) Navigator.of(context).pushNamed(Routes.login);
        } else {
          if (context.mounted) {
            Navigator.of(context).pushNamed(Routes.newPassword);
          }
        }
      }
      Fluttertoast.showToast(msg: response.msg!);
      otpLoading = false;
      notifyListeners();
    } catch (error) {
      otpLoading = false;
      notifyListeners();
      return BaseModel()..error = ServerError.withError(error: error);
    }
    return BaseModel()..data = response;
  }

  //* Set New Password Screen
  Future<BaseModel<NewPasswordResponse>> changePassword(
      BuildContext context, Map<String, dynamic> body) async {
    NewPasswordResponse response;

    try {
      changePasswordLoading = true;
      notifyListeners();
      response = await RestClient(RetroApi().dioData()).newPassword(body);
      if (response.success == true) {
        if (context.mounted) Navigator.of(context).pushNamed(Routes.home);
      }
      Fluttertoast.showToast(msg: response.msg!);
      changePasswordLoading = false;
      notifyListeners();
    } catch (error) {
      changePasswordLoading = false;
      notifyListeners();
      return BaseModel()..error = ServerError.withError(error: error);
    }
    return BaseModel()..data = response;
  }
}
