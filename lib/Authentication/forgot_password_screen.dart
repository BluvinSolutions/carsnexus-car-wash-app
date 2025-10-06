import 'package:carq_user/Authentication/provider/auth_provider.dart';
import 'package:carq_user/Localization/localization_constant.dart';
import 'package:carq_user/Theme/colors.dart';
import 'package:carq_user/Theme/theme.dart';
import 'package:carq_user/Widgets/app_bar_back_icon.dart';
import 'package:carq_user/Widgets/constant_widget.dart';
import 'package:carq_user/lang_const.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  TextEditingController phoneNumberController = TextEditingController();
  late FocusNode phoneNumberFocusNode;
  late AuthProvider authProvider;

  @override
  void initState() {
    super.initState();
    phoneNumberFocusNode = FocusNode();
  }

  @override
  void dispose() {
    phoneNumberController.dispose();

    phoneNumberFocusNode.dispose();
    super.dispose();
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    authProvider = Provider.of<AuthProvider>(context);
    return ModalProgressHUD(
      inAsyncCall: authProvider.otpLoading,
      opacity: 0.5,
      progressIndicator: const SpinKitPulsingGrid(
        color: AppColors.primary,
        size: 50.0,
      ),
      child: Scaffold(
        backgroundColor: AppColors.white,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          leading: const AppBarBack(),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(Amount.screenMargin),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const HeightBox(25),
                Text(
                  getTranslated(context, LangConst.forgotPassword).toString(),
                  style: Theme.of(context).textTheme.displaySmall!.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 25,
                      ),
                ),
                Text(
                  getTranslated(
                          context,
                          LangConst
                              .enterYourRegisteredPhoneNumberWeWillSendAnOTP)
                      .toString(),
                  maxLines: 2,
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        color: AppColors.subText,
                      ),
                ),
                const HeightBox(30),
                TextFormField(
                  focusNode: phoneNumberFocusNode,
                  controller: phoneNumberController,
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter phone number';
                    }
                    return null;
                  },
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                  ],
                  maxLength: 10,
                  decoration: InputDecoration(
                    labelText: getTranslated(context, LangConst.phoneNumber)
                        .toString(),
                    filled: true,
                    counterText: "",
                    floatingLabelBehavior: FloatingLabelBehavior.auto,
                    fillColor: phoneNumberFocusNode.hasFocus
                        ? AppColors.primary.withAlpha(40)
                        : Colors.white,
                  ),
                ),
                const HeightBox(40),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      Map<String, dynamic> body = {
                        'phone_no': phoneNumberController.text,
                        'type': '3AppUsers',
                      };
                      authProvider.requestForOTP(context, body, true);
                    }
                  },
                  style: AppButtonStyle.filledMedium.copyWith(
                    minimumSize: MaterialStatePropertyAll(
                      Size(
                        MediaQuery.of(context).size.width,
                        50,
                      ),
                    ),
                  ),
                  child: Text(
                    getTranslated(context, LangConst.sendOTPLabel).toString(),
                    style: Theme.of(context).textTheme.labelLarge!.copyWith(
                          color: AppColors.white,
                        ),
                  ),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Align(
              alignment: Alignment.center,
              child: RichText(
                text: TextSpan(
                  text: getTranslated(context, LangConst.rememberYourPassword)
                      .toString(),
                  style: Theme.of(context).textTheme.bodyMedium,
                  children: [
                    TextSpan(
                      text: getTranslated(context, LangConst.login).toString(),
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            color: AppColors.primary,
                          ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Navigator.of(context).pop();
                        },
                    ),
                  ],
                ),
              ),
            ),
            const HeightBox(15),
          ],
        ),
      ),
    );
  }
}
