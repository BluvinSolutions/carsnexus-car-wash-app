// import 'dart:convert';
//
// import 'package:voyzo/Constants/keys_values.dart';
// import 'package:voyzo/Constants/preference_utility.dart';
// import 'package:voyzo/HomeAndOrder/home_screen.dart';
// import 'package:voyzo/Network/api_service.dart';
// import 'package:voyzo/Network/base_model.dart';
// import 'package:voyzo/Network/retrofit.dart';
// import 'package:voyzo/Network/server_error.dart';
// import 'package:voyzo/Profile/models/booking_payment_response.dart';
// import 'package:voyzo/Profile/models/payment_keys_response.dart';
// import 'package:voyzo/Theme/colors.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_stripe/flutter_stripe.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// // ignore: depend_on_referenced_packages
// import 'package:http/http.dart' as http;
// import 'package:razorpay_flutter/razorpay_flutter.dart';
//
// class PaymentProvider extends ChangeNotifier {
//   bool paymentLoading = false;
//
//   String clientKey = "";
//   String paypalSecret = "";
//   String stripeSecret = "";
//   String stripePublish = "";
//   String razorpayKey = "";
//   String currency = "";
//   String currencyCode = "";
//   int? bookingId;
//   double? paymentAmount;
//   bool isPaypal = false;
//   bool isStripe = false;
//   bool isRazorpay = false;
//
//   Future<BaseModel<PaymentKeysResponse>> getPaymentKeys() async {
//     PaymentKeysResponse response;
//     try {
//       response = await RestClient(RetroApi().dioData()).getPaymentSettings();
//       if (response.success == true) {
//         clientKey = response.data!.pSandboxClientId!;
//         paypalSecret = response.data!.pProductionClientId!;
//         stripePublish = response.data!.stripeKey!;
//         stripeSecret = response.data!.stripeSecret!;
//         razorpayKey = response.data!.razorId!;
//         currency = response.data!.currency!;
//         currencyCode = response.data!.currencySymbol!;
//         response.data!.paypalStatus! == 1 ? isPaypal = true : isPaypal = false;
//         response.data!.stipeStatus! == 1 ? isStripe = true : isStripe = false;
//         response.data!.razorStatus! == 1
//             ? isRazorpay = true
//             : isRazorpay = false;
//
//         if (kDebugMode) {
//           print('DONE');
//         }
//       }
//       paymentLoading = false;
//       notifyListeners();
//     } catch (error) {
//       paymentLoading = false;
//       notifyListeners();
//       return BaseModel()..error = ServerError.withError(error: error);
//     }
//     return BaseModel()..data = response;
//   }
//
//   //*   CASH PAYMENT
//   void cashPayment() {}
//
//   //*   STRIPE PAYMENT
//   Map<String, dynamic> paymentIntent = {};
//
//   void stripePayment(
//       int id, String amount, String currencyCode, BuildContext context) async {
//     try {
//       bookingId = id;
//       paymentAmount = double.parse(amount);
//       paymentIntent = await createPaymentIntent(amount, currencyCode);
//
//       // ignore: use_build_context_synchronously
//       // ignore: use_build_context_synchronously
//
//       //STEP 2: Initialize Payment Sheet
//       await Stripe.instance
//           .initPaymentSheet(
//             paymentSheetParameters: SetupPaymentSheetParameters(
//               paymentIntentClientSecret: paymentIntent['client_secret'],
//               //Gotten from payment intent
//               style: ThemeMode.dark,
//               merchantDisplayName: 'Voyzo',
//             ),
//           )
//           .then((value) {});
//
//       //STEP 3: Display Payment sheet
//       // ignore: use_build_context_synchronously
//       displayPaymentSheet(paymentIntent['id'], context);
//     } catch (err) {
//       throw Exception(err);
//     }
//   }
//
//   displayPaymentSheet(String token, BuildContext context) async {
//     try {
//       await Stripe.instance.presentPaymentSheet().then((value) {
//         showPaymentSheet(token, context);
//         paymentIntent = {};
//       }).onError((error, stackTrace) {
//         throw Exception(error);
//       });
//     } on StripeException catch (e) {
//       if (kDebugMode) {
//         print('Error is:---> $e');
//       }
//       const AlertDialog(
//         surfaceTintColor: AppColors.white,
//         backgroundColor: AppColors.white,
//         shadowColor: AppColors.white,
//         content: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Row(
//               children: [
//                 Icon(
//                   Icons.cancel,
//                   color: Colors.red,
//                 ),
//                 Text("Payment Failed"),
//               ],
//             ),
//           ],
//         ),
//       );
//     } catch (e) {
//       if (kDebugMode) {
//         print('$e');
//       }
//       const AlertDialog(
//         surfaceTintColor: AppColors.white,
//         backgroundColor: AppColors.white,
//         shadowColor: AppColors.white,
//         content: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Row(
//               children: [
//                 Icon(
//                   Icons.cancel,
//                   color: Colors.red,
//                 ),
//                 Text("Payment Failed"),
//               ],
//             ),
//           ],
//         ),
//       );
//     }
//   }
//
//   createPaymentIntent(String amount, String currency) async {
//     try {
//       //Request body
//       Map<String, dynamic> body = {
//         'amount': calculateAmount(amount),
//         'currency': currency,
//       };
//
//       //Make post request to Stripe
//       var response = await http.post(
//         Uri.parse('https://api.stripe.com/v1/payment_intents'),
//         headers: {
//           'Authorization': 'Bearer $stripeSecret',
//           'Content-Type': 'application/x-www-form-urlencoded'
//         },
//         body: body,
//       );
//       return json.decode(response.body);
//     } catch (err) {
//       throw Exception(err.toString());
//     }
//   }
//
//   calculateAmount(String amount) {
//     final calculatedAmount = double.parse(amount) * 100;
//     return calculatedAmount.round().toString();
//   }
//
//   showPaymentSheet(String? paymentId, BuildContext context) {
//     paymentDone(bookingId!, 1, "Stripe", paymentAmount!, paymentId!);
//     showSucessDialog(context, paymentId);
//   }
//
//   //*   RAZORPAY PAYMENT
//   void razorpayPayment(int id, double amount, String? currency) {
//     var options = {
//       'key': razorpayKey,
//       'amount': amount * 100,
//       'name': SharedPreferenceUtil.getString(PrefKey.fullName),
//       'description': 'Package',
//       //widget.pay.currencyCode
//       'currency': currency!,
//       'retry': {'enabled': true, 'max_count': 1},
//       'send_sms_hash': true,
//       'prefill': {
//         'contact':
//             "${SharedPreferenceUtil.getString(PrefKey.country)}${SharedPreferenceUtil.getString(PrefKey.mobile)}",
//         'email': SharedPreferenceUtil.getString(PrefKey.email)
//       },
//     };
//     bookingId = id;
//     paymentAmount = amount;
//     Razorpay razorpay = Razorpay();
//     razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, handleExternalWalletSelected);
//     razorpay.open(options);
//     razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, handlePaymentErrorResponse);
//     razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, handlePaymentSuccessResponse);
//   }
//
//   void handlePaymentErrorResponse(PaymentFailureResponse response) {
//     if (kDebugMode) {
//       print(
//           "Payment Failed ,\nCode: ${response.code}\nDescription: ${response.message}\nMetadata:${response.error.toString()}");
//     }
//   }
//
//   void handleExternalWalletSelected(ExternalWalletResponse response) {
//     debugPrint("External Wallet Selected, ${response.walletName}");
//   }
//
//   void handlePaymentSuccessResponse(
//       int id, PaymentSuccessResponse response, BuildContext context) {
//     showSucessDialog(context, response.paymentId!);
//     paymentDone(bookingId!, 1, "Razorpay", paymentAmount!.toDouble(),
//         response.paymentId!);
//   }
//
//   showSucessDialog(BuildContext context, String paymentToken) {
//     return showDialog(
//       context: context,
//       builder: (context) => SizedBox(
//         height: 100,
//         child: AlertDialog(
//           surfaceTintColor: AppColors.white,
//           backgroundColor: AppColors.white,
//           shadowColor: AppColors.white,
//           title: Text(
//             "Payment Successful!",
//             textAlign: TextAlign.center,
//             style: Theme.of(context)
//                 .textTheme
//                 .titleLarge!
//                 .copyWith(color: AppColors.primary),
//           ),
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               paymentToken.isEmpty
//                   ? const SizedBox.shrink()
//                   : Column(
//                       children: [
//                         Text(
//                           "Transaction ID : ",
//                           maxLines: 2,
//                           textAlign: TextAlign.center,
//                           style: Theme.of(context)
//                               .textTheme
//                               .headlineSmall!
//                               .copyWith(
//                                 color: AppColors.bodyText,
//                                 fontWeight: FontWeight.w500,
//                                 fontSize: 14,
//                               ),
//                         ),
//                         Text(
//                           paymentToken,
//                           maxLines: 2,
//                           textAlign: TextAlign.center,
//                           style: Theme.of(context)
//                               .textTheme
//                               .headlineSmall!
//                               .copyWith(
//                                 color: AppColors.bodyText,
//                                 fontWeight: FontWeight.w500,
//                                 fontSize: 14,
//                               ),
//                         ),
//                       ],
//                     ),
//               Text(
//                 "Amount : $currencyCode$paymentAmount",
//                 maxLines: 2,
//                 textAlign: TextAlign.center,
//                 style: Theme.of(context).textTheme.headlineSmall!.copyWith(
//                       color: AppColors.bodyText,
//                       fontWeight: FontWeight.w500,
//                       fontSize: 14,
//                     ),
//               ),
//             ],
//           ),
//           actionsPadding: const EdgeInsets.all(8.0),
//           actions: [
//             Container(
//               color: AppColors.primary50,
//               child: TextButton(
//                 onPressed: () {
//                   Navigator.of(context).push(
//                     MaterialPageRoute(
//                       builder: (context) => const HomeScreen(),
//                     ),
//                   );
//                 },
//                 child: Text(
//                   "Go to Home",
//                   maxLines: 2,
//                   textAlign: TextAlign.center,
//                   style: Theme.of(context).textTheme.headlineSmall!.copyWith(
//                         color: AppColors.bodyText,
//                         fontWeight: FontWeight.w500,
//                         fontSize: 14,
//                       ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   void paymentDone(
//       int id, int status, String method, double amount, String? token) {
//     Map<String, dynamic> body;
//     if (token != null) {
//       body = {
//         'payment_status': status,
//         'payment_method': method,
//         'amount': amount,
//         'payment_token': token,
//       };
//     }
//     body = {
//       'payment_status': status,
//       'payment_method': method,
//       'amount': amount,
//     };
//
//     paymentAPI(id, body);
//   }
//
//   bool paymentProcess = false;
//
//   Future<BaseModel<BookingPaymentResponse>> paymentAPI(
//       int id, Map<String, dynamic> body) async {
//     BookingPaymentResponse response;
//     try {
//       paymentProcess = true;
//       notifyListeners();
//       response =
//           await RestClient(RetroApi().dioData()).bookingPayment(id, body);
//       if (response.success == true) {
//         Fluttertoast.showToast(msg: response.msg!);
//       }
//       paymentProcess = false;
//       notifyListeners();
//     } catch (error) {
//       paymentProcess = false;
//       notifyListeners();
//       return BaseModel()..error = ServerError.withError(error: error);
//     }
//     return BaseModel()..data = response;
//   }
// }

import 'dart:convert';
import 'package:voyzo/Constants/keys_values.dart';
import 'package:voyzo/Constants/preference_utility.dart';
import 'package:voyzo/HomeAndOrder/home_screen.dart'; // Keep for context, but navigation removed from dialog
import 'package:voyzo/Network/api_service.dart';
import 'package:voyzo/Network/base_model.dart';
import 'package:voyzo/Network/retrofit.dart';
import 'package:voyzo/Network/server_error.dart';
import 'package:voyzo/Profile/models/booking_payment_response.dart';
import 'package:voyzo/Profile/models/payment_keys_response.dart';
import 'package:voyzo/Theme/colors.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:razorpay_flutter/razorpay_flutter.dart';

class PaymentProvider extends ChangeNotifier {
  bool paymentLoading = false;

  String clientKey = "";
  String paypalSecret = "";
  String stripeSecret = "";
  String stripePublish = "";
  String razorpayKey = "";
  String currency = "USD";
  String currencyCode = "\$";
  int? bookingId;
  double? paymentAmount;
  bool isPaypal = false;
  bool isStripe = false;
  bool isRazorpay = false;

  Future<BaseModel<PaymentKeysResponse>> getPaymentKeys() async {
    try {
      final response = await RestClient(RetroApi().dioData()).getPaymentSettings();
      if (response.success == true) {
        clientKey = response.data!.pSandboxClientId ?? "";
        paypalSecret = response.data!.pProductionClientId ?? "";
        stripePublish = response.data!.stripeKey ?? "";
        stripeSecret = response.data!.stripeSecret ?? "";
        razorpayKey = response.data!.razorId ?? "";
        currency = response.data!.currency ?? "USD";
        currencyCode = response.data!.currencySymbol ?? "\$";
        isPaypal = response.data!.paypalStatus == 1;
        isStripe = response.data!.stipeStatus == 1;
        isRazorpay = response.data!.razorStatus == 1;
      }
      paymentLoading = false;
      notifyListeners();
      return BaseModel()..data = response;
    } catch (error) {
      paymentLoading = false;
      notifyListeners();
      return BaseModel()..error = ServerError.withError(error: error);
    }
  }

  Future<bool> stripePayment(int id, String amount, String currencyCode, BuildContext context) async {
    try {
      bookingId = id;
      paymentAmount = double.parse(amount);
      final intent = await createPaymentIntent(amount, currencyCode);

      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: intent['client_secret'],
          style: ThemeMode.dark,
          merchantDisplayName: 'Voyzo',
        ),
      );

      await Stripe.instance.presentPaymentSheet();
      await paymentDone(id, 1, "Stripe", paymentAmount!, intent['id']);
      // showSucessDialog(context, intent['id']); // <-- REMOVED: Success dialog and navigation handled in ServiceDetailsScreen
      return true;
    } on StripeException {
      _showError(context);
      return false;
    } catch (e) {
      if (kDebugMode) print(e);
      _showError(context);
      return false;
    }
  }

  void _showError(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        surfaceTintColor: AppColors.white,
        backgroundColor: AppColors.white,
        content: const Row(children: [Icon(Icons.cancel, color: Colors.red), SizedBox(width: 8), Text("Payment Failed")]),
      ),
    );
  }

  Future<Map<String, dynamic>> createPaymentIntent(String amount, String currency) async {
    final body = {'amount': (double.parse(amount) * 100).round().toString(), 'currency': currency};
    final response = await http.post(
      Uri.parse('https://api.stripe.com/v1/payment_intents'),
      headers: {'Authorization': 'Bearer $stripeSecret', 'Content-Type': 'application/x-www-form-urlencoded'},
      body: body,
    );
    return json.decode(response.body);
  }

  late Razorpay _razorpay;

  Future<bool> razorpayPayment(int id, double amount, String currency) async {
    bookingId = id;
    paymentAmount = amount;
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handleRazorpaySuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handleRazorpayError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, (_) {});

    final options = {
      'key': razorpayKey,
      'amount': amount * 100,
      'name': SharedPreferenceUtil.getString(PrefKey.fullName),
      'description': 'Package',
      'currency': currency,
      'retry': {'enabled': true, 'max_count': 1},
      'send_sms_hash': true,
      'prefill': {
        'contact': "${SharedPreferenceUtil.getString(PrefKey.country)}${SharedPreferenceUtil.getString(PrefKey.mobile)}",
        'email': SharedPreferenceUtil.getString(PrefKey.email)
      },
    };

    _razorpay.open(options);
    return true;
  }

  void _handleRazorpaySuccess(PaymentSuccessResponse response) {
    final ctx = navigatorKey.currentContext!;
    paymentDone(bookingId!, 1, "Razorpay", paymentAmount!, response.paymentId!);
    // showSucessDialog(ctx, response.paymentId!); // <-- REMOVED: Success dialog and navigation handled in ServiceDetailsScreen
    _razorpay.clear();
    Navigator.of(ctx).pop(true);
  }

  void _handleRazorpayError(PaymentFailureResponse response) {
    _razorpay.clear();
    final ctx = navigatorKey.currentContext;
    if (ctx != null) Navigator.of(ctx).pop(false);
  }

  // Modified to remove 'Go to Home' action and rely on ServiceDetailsScreen for navigation
  void showSucessDialog(BuildContext context, String token) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        surfaceTintColor: AppColors.white,
        backgroundColor: AppColors.white,
        title: const Text("Payment Successful!", textAlign: TextAlign.center, style: TextStyle(color: AppColors.primary)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (token.isNotEmpty)
              Column(children: [
                const Text("Transaction ID:", style: TextStyle(fontSize: 14)),
                Text(token, style: const TextStyle(fontSize: 14)),
              ]),
            Text("Amount: $currencyCode$paymentAmount", style: const TextStyle(fontSize: 14)),
          ],
        ),
      ),
    );
  }

  Future<void> paymentDone(int id, int status, String method, double amount, String? token) async {
    final body = {
      'payment_status': status,
      'payment_method': method,
      'amount': amount,
      if (token != null) 'payment_token': token,
    };
    await paymentAPI(id, body);
  }

  bool paymentProcess = false;

  Future<BaseModel<BookingPaymentResponse>> paymentAPI(int id, Map<String, dynamic> body) async {
    try {
      paymentProcess = true;
      notifyListeners();
      final response = await RestClient(RetroApi().dioData()).bookingPayment(id, body);
      if (response.success == true) Fluttertoast.showToast(msg: response.msg!);
      paymentProcess = false;
      notifyListeners();
      return BaseModel()..data = response;
    } catch (error) {
      paymentProcess = false;
      notifyListeners();
      return BaseModel()..error = ServerError.withError(error: error);
    }
  }
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
