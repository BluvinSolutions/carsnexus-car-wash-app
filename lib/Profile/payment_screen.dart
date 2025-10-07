import 'package:carsnexus_user/Localization/localization_constant.dart';
import 'package:carsnexus_user/Profile/providers/payment_provider.dart';
import 'package:carsnexus_user/Theme/colors.dart';
import 'package:carsnexus_user/Widgets/app_bar_back_icon.dart';
import 'package:carsnexus_user/lang_const.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_paypal/flutter_paypal.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';

class PaymentScreen extends StatefulWidget {
  final num amount;
  final int id;

  const PaymentScreen({super.key, required this.amount, required this.id});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  List<String> paymentNames = ['Cash', 'Paypal', 'Stripe', 'Razorpay'];
  List paymentIcon = [
    Icons.payments,
    Icons.paypal,
    'assets/icons/stripe.png',
    'assets/icons/razorpay.png'
  ];
  int _selectedIndex = 0;

  late PaymentProvider paymentProvider;
  bool paypalKeys = false;
  String clientKey = "";
  String secretKey = "";

  @override
  void initState() {
    paymentProvider = Provider.of<PaymentProvider>(context, listen: false);
    paymentProvider.getPaymentKeys().then(
          (value) => [
            paypalKeys = true,
            clientKey = paymentProvider.clientKey,
            secretKey = paymentProvider.paypalSecret,
            Stripe.publishableKey = paymentProvider.stripePublish,
          ],
        );
    paymentProvider.paymentLoading = true;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    paymentProvider = Provider.of<PaymentProvider>(context);
    return ModalProgressHUD(
      inAsyncCall: paymentProvider.paymentLoading,
      opacity: 0.5,
      progressIndicator: const SpinKitPulsingGrid(
        color: AppColors.primary,
        size: 50.0,
      ),
      child: Scaffold(
        backgroundColor: AppColors.white,
        appBar: AppBar(
          leading: const AppBarBack(),
          title: Text(getTranslated(context, LangConst.payment).toString()),
        ),
        body: SingleChildScrollView(
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 20.0,
                      left: 5,
                      bottom: 20,
                    ),
                    child: Text(
                      getTranslated(context, LangConst.paymentMethod)
                          .toString(),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      padding: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: const Color(0xFFA5ACBA),
                        ),
                      ),
                      child: ListTile(
                        onTap: () {
                          setState(() {
                            _selectedIndex = 0;
                          });
                        },
                        contentPadding: EdgeInsets.zero,
                        visualDensity:
                            const VisualDensity(horizontal: -4, vertical: -4),
                        title: Text(
                          paymentNames[0],
                          style:
                              Theme.of(context).textTheme.labelLarge!.copyWith(
                                    color: AppColors.bodyText,
                                    fontWeight: FontWeight.w700,
                                  ),
                        ),
                        selected: _selectedIndex == 0,
                        leading: paymentIcon[0].runtimeType == IconData
                            ? Icon(
                                paymentIcon[0],
                                color: const Color(0xFF4E65FF),
                                size: 30,
                              )
                            : ImageIcon(
                                AssetImage(paymentIcon[0]),
                                color: const Color(0xFF4E65FF),
                                size: 40,
                              ),
                        trailing: Icon(
                          _selectedIndex == 0
                              ? Icons.check_box
                              : Icons.check_box_outline_blank,
                          color: _selectedIndex == 0 ? AppColors.primary : null,
                        ),
                      ),
                    ),
                  ),
                  paymentProvider.isPaypal
                      ? Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            padding: const EdgeInsets.all(8.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: const Color(0xFFA5ACBA),
                              ),
                            ),
                            child: ListTile(
                              onTap: () {
                                setState(() {
                                  _selectedIndex = 1;
                                });
                              },
                              contentPadding: EdgeInsets.zero,
                              visualDensity: const VisualDensity(
                                  horizontal: -4, vertical: -4),
                              title: Text(
                                paymentNames[1],
                                style: Theme.of(context)
                                    .textTheme
                                    .labelLarge!
                                    .copyWith(
                                      color: AppColors.bodyText,
                                      fontWeight: FontWeight.w700,
                                    ),
                              ),
                              selected: _selectedIndex == 1,
                              leading: paymentIcon[1].runtimeType == IconData
                                  ? Icon(
                                      paymentIcon[1],
                                      color: const Color(0xFF4E65FF),
                                      size: 30,
                                    )
                                  : ImageIcon(
                                      AssetImage(paymentIcon[1]),
                                      color: const Color(0xFF4E65FF),
                                      size: 40,
                                    ),
                              trailing: Icon(
                                _selectedIndex == 1
                                    ? Icons.check_box
                                    : Icons.check_box_outline_blank,
                                color: _selectedIndex == 1
                                    ? AppColors.primary
                                    : null,
                              ),
                            ),
                          ),
                        )
                      : const SizedBox(),
                  paymentProvider.isStripe
                      ? Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            padding: const EdgeInsets.all(8.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: const Color(0xFFA5ACBA),
                              ),
                            ),
                            child: ListTile(
                              onTap: () {
                                setState(() {
                                  _selectedIndex = 2;
                                });
                              },
                              contentPadding: EdgeInsets.zero,
                              visualDensity: const VisualDensity(
                                  horizontal: -4, vertical: -4),
                              title: Text(
                                paymentNames[2],
                                style: Theme.of(context)
                                    .textTheme
                                    .labelLarge!
                                    .copyWith(
                                      color: AppColors.bodyText,
                                      fontWeight: FontWeight.w700,
                                    ),
                              ),
                              selected: _selectedIndex == 2,
                              leading: paymentIcon[2].runtimeType == IconData
                                  ? Icon(
                                      paymentIcon[2],
                                      color: const Color(0xFF4E65FF),
                                      size: 30,
                                    )
                                  : ImageIcon(
                                      AssetImage(paymentIcon[2]),
                                      color: const Color(0xFF4E65FF),
                                      size: 40,
                                    ),
                              trailing: Icon(
                                _selectedIndex == 2
                                    ? Icons.check_box
                                    : Icons.check_box_outline_blank,
                                color: _selectedIndex == 2
                                    ? AppColors.primary
                                    : null,
                              ),
                            ),
                          ),
                        )
                      : const SizedBox(),
                  paymentProvider.isRazorpay
                      ? Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            padding: const EdgeInsets.all(8.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: const Color(0xFFA5ACBA),
                              ),
                            ),
                            child: ListTile(
                              onTap: () {
                                setState(() {
                                  _selectedIndex = 3;
                                });
                              },
                              contentPadding: EdgeInsets.zero,
                              visualDensity: const VisualDensity(
                                  horizontal: -4, vertical: -4),
                              title: Text(
                                paymentNames[3],
                                style: Theme.of(context)
                                    .textTheme
                                    .labelLarge!
                                    .copyWith(
                                      color: AppColors.bodyText,
                                      fontWeight: FontWeight.w700,
                                    ),
                              ),
                              selected: _selectedIndex == 3,
                              leading: paymentIcon[3].runtimeType == IconData
                                  ? Icon(
                                      paymentIcon[3],
                                      color: const Color(0xFF4E65FF),
                                      size: 30,
                                    )
                                  : ImageIcon(
                                      AssetImage(paymentIcon[3]),
                                      color: const Color(0xFF4E65FF),
                                      size: 40,
                                    ),
                              trailing: Icon(
                                _selectedIndex == 3
                                    ? Icons.check_box
                                    : Icons.check_box_outline_blank,
                                color: _selectedIndex == 3
                                    ? AppColors.primary
                                    : null,
                              ),
                            ),
                          ),
                        )
                      : const SizedBox(),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: ElevatedButton(
                      onPressed: () async {
                        ///   CASH PAYMENT
                        if (_selectedIndex == 0) {
                          paymentProvider.paymentDone(widget.id, 1, "CASH",
                              widget.amount.toDouble(), null);
                          setState(() {
                            paymentProvider.paymentAmount =
                                widget.amount.toDouble();
                            paymentProvider.showSucessDialog(context, "");
                          });
                        }

                        ///   PAYPAL PAYMENT
                        if (_selectedIndex == 1) {
                          try {
                            if (paypalKeys) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => UsePaypal(
                                    sandboxMode: true,
                                    clientId: clientKey,
                                    secretKey: secretKey,
                                    returnURL: "https://samplesite.com/return",
                                    cancelURL: "https://samplesite.com/cancel",
                                    transactions: [
                                      {
                                        "amount": {
                                          "total": '${widget.amount}',
                                          //!TOTAL
                                          "currency": paymentProvider.currency,
                                          //! CURRENCY CODE
                                          "details": {
                                            "subtotal": '${widget.amount}',
                                            //! SUBTOTAL
                                            "shipping": '0',
                                            "shipping_discount": 0
                                          }
                                        },
                                        "description":
                                            "The payment transaction description.",
                                        "item_list": {
                                          "items": [
                                            {
                                              "name": "A demo product",
                                              "quantity": 1,
                                              "price": '${widget.amount}',
                                              //!TOTAL
                                              "currency":
                                                  paymentProvider.currency,
                                              //! CURRENCY CODE
                                            }
                                          ],
                                        }
                                      }
                                    ],
                                    note:
                                        "Contact us for any questions on your order.",
                                    onSuccess: (params) {
                                      debugPrint("onSuccess: $params");
                                      if (kDebugMode) {
                                        print("${params['token']}");
                                      }
                                      paymentProvider.paymentDone(
                                        widget.id,
                                        1,
                                        "Paypal",
                                        widget.amount.toDouble(),
                                        params['token'],
                                      );
                                    },
                                    onError: (error) {
                                      debugPrint("onError: $error");
                                    },
                                    onCancel: (params) {
                                      debugPrint('cancelled: $params');
                                    },
                                  ),
                                ),
                              );
                            }
                          } catch (err) {
                            if (kDebugMode) {
                              print(err);
                            }
                          }
                        }

                        ///   STRIPE PAYMENT
                        else if (_selectedIndex == 2) {
                          paymentProvider.stripePayment(
                              widget.id,
                              "${widget.amount}",
                              paymentProvider.currency,
                              context);
                        }

                        ///   RAZORPAY PAYMENT
                        else if (_selectedIndex == 3) {
                          paymentProvider.razorpayPayment(
                              widget.id,
                              widget.amount.toDouble(),
                              paymentProvider.currency);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: MediaQuery.sizeOf(context).width * 0.27,
                        ),
                      ),
                      child: Text(
                        getTranslated(context, LangConst.proceedToPay)
                            .toString(),
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
