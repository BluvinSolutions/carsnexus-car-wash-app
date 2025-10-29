import 'dart:convert';
import 'dart:io';

import 'package:voyzo/Constants/keys_values.dart';
import 'package:voyzo/Constants/preference_utility.dart';
import 'package:voyzo/Network/api_service.dart';
import 'package:voyzo/Network/base_model.dart';
import 'package:voyzo/Network/retrofit.dart';
import 'package:voyzo/Network/server_error.dart';
import 'package:voyzo/Profile/models/booking_details_response.dart';
import 'package:voyzo/Profile/models/booking_response.dart';
import 'package:voyzo/Profile/models/faq_response.dart';
import 'package:voyzo/Profile/models/notification_response.dart';
import 'package:voyzo/Profile/models/privacy_response.dart';
import 'package:voyzo/Profile/models/profile_response.dart';
import 'package:voyzo/Profile/models/review_response.dart';
import 'package:voyzo/Profile/models/update_password_response.dart';
import 'package:voyzo/Profile/models/update_profile_response.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart' as p;

import '../../Theme/colors.dart';

class ProfileProvider extends ChangeNotifier {
  bool bookingLoading = false;
  bool bookingDetailsLoading = false;
  bool settingsLoading = false;
  bool faqLoading = false;
  bool privacyLoading = false;
  bool notificationLoading = false;

  bool isNotification = false;

  List<BookingStatus> pendingList = [];
  List<BookingStatus> currentList = [];
  List<BookingStatus> completeList = [];
  List<BookingStatus> cancelList = [];

  BookingDetailsResponseData? details;
  List<FaqResponseData> faqList = [];
  List<Notifications> notification = [];

  String policy = '';

  //*   Get All Bookings
  Future<BaseModel<BookingResponse>> loadBookings() async {
    BookingResponse response;
    try {
      pendingList.clear();
      currentList.clear();
      completeList.clear();
      cancelList.clear();
      response = await RestClient(RetroApi().dioData()).getBookingList();
      if (response.success == true) {
        if (response.data != null) {
          pendingList.addAll(response.data!.wait!);
          currentList.addAll(response.data!.current!);
          completeList.addAll(response.data!.complete!);
          cancelList.addAll(response.data!.cancel!);
        }
      }
      bookingLoading = false;
      notifyListeners();
    } catch (error) {
      bookingLoading = false;
      notifyListeners();
      return BaseModel()..error = ServerError.withError(error: error);
    }
    return BaseModel()..data = response;
  }

  //*   Get Details Of Booking By ID
  Future<BaseModel<BookingDetailsResponse>> bookingDetails(int id) async {
    BookingDetailsResponse response;
    try {
      details = null;
      response = await RestClient(RetroApi().dioData()).getBookingDetails(id);
      if (response.success == true) {
        if (response.data != null) {
          details = response.data!;
        }
      }
      // Fluttertoast.showToast(msg: response.msg.toString());
      bookingDetailsLoading = false;
      notifyListeners();
    } catch (error) {
      bookingDetailsLoading = false;
      notifyListeners();
      return BaseModel()..error = ServerError.withError(error: error);
    }
    return BaseModel()..data = response;
  }

  //*   Get Settings
  Future<BaseModel<ProfileResponse>> getSettings() async {
    ProfileResponse response;
    try {
      settingsLoading = true;
      notifyListeners();
      response = await RestClient(RetroApi().dioData()).getProfileSettings();
      if (response.success == true) {
        if (response.data!.noti! == 1) {
          isNotification = true;
        }
      }
      settingsLoading = false;
      notifyListeners();
    } catch (error) {
      settingsLoading = false;
      notifyListeners();
      return BaseModel()..error = ServerError.withError(error: error);
    }
    return BaseModel()..data = response;
  }

  //*   Get Faq Questions
  Future<BaseModel<FaqResponse>> getFaq() async {
    FaqResponse response;
    try {
      faqLoading = true;
      notifyListeners();
      response = await RestClient(RetroApi().dioData()).getFaq();
      if (response.success == true) {
        faqList.clear();
        if (response.data != null) {
          faqList.addAll(response.data!);
        }
      }
      faqLoading = false;
      notifyListeners();
    } catch (error) {
      faqLoading = false;
      notifyListeners();
      return BaseModel()..error = ServerError.withError(error: error);
    }
    return BaseModel()..data = response;
  }

  //*   Get Privacy Policy
  Future<BaseModel<PrivacyResponse>> getPolicy() async {
    PrivacyResponse response;
    try {
      privacyLoading = true;
      notifyListeners();
      response = await RestClient(RetroApi().dioData()).privacy();
      if (response.success == true) {
        if (response.data != null) {
          policy = response.data!;
        }
      }
      privacyLoading = false;
      notifyListeners();
    } catch (error) {
      privacyLoading = false;
      notifyListeners();
      return BaseModel()..error = ServerError.withError(error: error);
    }
    return BaseModel()..data = response;
  }

  //*   Get All Notification
  Future<BaseModel<NotificationResponse>> getNotifications() async {
    NotificationResponse response;
    try {
      response = await RestClient(RetroApi().dioData()).getNotification();
      if (response.success == true) {
        if (response.data != null) {
          notification = response.data!;
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

  /// Update Profile
  bool updateProfile = false;

  Future<BaseModel<UpdateProfileResponse>> updateProfileMethod(
      Map<String, dynamic> body) async {
    UpdateProfileResponse response;
    try {
      updateProfile = true;
      notifyListeners();
      response =
          await RestClient(RetroApi().dioData()).updateProfileDetails(body);
      if (response.success == true) {
        if (response.data != null) {
          SharedPreferenceUtil.putString(
              PrefKey.fullName, response.data!.name ?? "");
          SharedPreferenceUtil.putString(
              PrefKey.email, response.data!.email ?? "");
          SharedPreferenceUtil.putString(
              PrefKey.mobile, response.data!.phoneNo ?? "");
          if (response.msg! != "null") {
            Fluttertoast.showToast(msg: response.msg!);
          }
        }
      }
      updateProfile = false;
      notifyListeners();
    } catch (error) {
      updateProfile = false;
      notifyListeners();
      return BaseModel()..error = ServerError.withError(error: error);
    }
    return BaseModel()..data = response;
  }

  bool updateProfilePic = false;

  Future<BaseModel<UpdateProfileResponse>> updateProfilePicture(
      Map<String, dynamic> body) async {
    UpdateProfileResponse response;
    try {
      updateProfilePic = true;
      notifyListeners();
      response = await RestClient(RetroApi().dioData()).updatePicture(body);
      if (response.success == true) {
        if (response.data != null) {
          SharedPreferenceUtil.putString(
              PrefKey.profileImage, response.data!.imageUri ?? "");
          if (response.msg! != "null") {
            Fluttertoast.showToast(msg: response.msg!);
          }
        }
      }
      updateProfilePic = false;
      notifyListeners();
    } catch (error) {
      updateProfilePic = false;
      notifyListeners();
      return BaseModel()..error = ServerError.withError(error: error);
    }
    return BaseModel()..data = response;
  }

  //  Before Updating Profile
  File? image;
  String? base64String;

  Future pickImg(String src) async {
    try {
      final image = await ImagePicker().pickImage(
          source: src == "Gallery" ? ImageSource.gallery : ImageSource.camera);
      if (image == null) return;
      final imageTemp = File(image.path);
      imgBase64(imageTemp);
      this.image = imageTemp;
      notifyListeners();
    } on PlatformException catch (err) {
      debugPrint("Failed to Pick Image $err");
    }
  }

  imgBase64(File imgPath) async {
    Uint8List bytes = await imgPath.readAsBytes();
    String img = imgPath.toString();
    final String ext = p.extension(img);
    String first = "";
    if (ext == ".png'") {
      first += "data:image/png;base64,";
    } else if (ext == '.jpg\'') {
      first += "data:image/jpg;base64,";
    } else {
      first += "data:image/jpeg;base64,";
    }
    String base64String = base64.encode(bytes);

    base64String = first + base64String;
    Map<String, dynamic> body = {'image': base64String};
    updateProfilePicture(body);
    notifyListeners();
  }

  Future<void> showImageSource(BuildContext context) async {
    if (Platform.isIOS) {
      return showCupertinoModalPopup(
        context: context,
        builder: (context) => CupertinoActionSheet(
          actions: [
            CupertinoActionSheetAction(
              onPressed: () {
                pickImg('Camera');
                Navigator.of(context).pop();
              },
              child: const Text('Camera'),
            ),
            CupertinoActionSheetAction(
              onPressed: () {
                pickImg('Gallery');
                Navigator.of(context).pop();
              },
              child: const Text('Gallery'),
            ),
          ],
        ),
      );
    } else if (Platform.isAndroid) {
      return showModalBottomSheet(
        context: context, backgroundColor: AppColors.white,
        builder: (context) => Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
                leading: const Icon(Icons.camera_alt_outlined),
                title: const Text('Camera'),
                onTap: () {
                  pickImg('Camera');
                  Navigator.of(context).pop();
                }),
            ListTile(
              leading: const Icon(Icons.collections),
              title: const Text('Gallery'),
              onTap: () {
                pickImg('Gallery');
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      );
    }
  }

  bool passwordLoading = false;

  Future<BaseModel<UpdatePasswordResponse>> changePassword(
      Map<String, dynamic> body) async {
    UpdatePasswordResponse response;
    try {
      passwordLoading = true;
      notifyListeners();
      response = await RestClient(RetroApi().dioData()).updatePassword(body);
      if (response.success == true) {
        if (response.data != null) {
          if (response.msg! != "null") {
            Fluttertoast.showToast(msg: response.msg!);
          }
        }
      }
      passwordLoading = false;
      notifyListeners();
    } catch (error) {
      passwordLoading = false;
      notifyListeners();
      return BaseModel()..error = ServerError.withError(error: error);
    }
    return BaseModel()..data = response;
  }

  bool reviewLoader = false;

  Future<BaseModel<ReviewResponse>> review(Map<String, dynamic> body) async {
    ReviewResponse response;
    try {
      reviewLoader = true;
      notifyListeners();
      response = await RestClient(RetroApi().dioData()).sendReview(body);
      if (response.success == true) {
        Fluttertoast.showToast(msg: 'Thanks For Review !');
        details!.isReviewed = true;
        if (response.data != null) {
          details!.review = Review(
            bookingId: response.data!.bookingId!,
            cmt: response.data!.cmt!,
            createdAt: response.data!.createdAt!,
            updatedAt: response.data!.updatedAt!,
            employeeId: response.data!.employeeId!,
            id: response.data!.id!,
            shopId: response.data!.shopId!,
            star: response.data!.star!,
            userId: response.data!.userId!,
            user: response.data!.user!,
          );
        }
      }
      reviewLoader = false;
      notifyListeners();
    } catch (error) {
      reviewLoader = false;
      notifyListeners();
      return BaseModel()..error = ServerError.withError(error: error);
    }
    return BaseModel()..data = response;
  }
}
