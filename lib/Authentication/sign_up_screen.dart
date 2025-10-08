import 'package:carsnexus_user/Authentication/provider/auth_provider.dart';
import 'package:carsnexus_user/Localization/localization_constant.dart';
import 'package:carsnexus_user/Theme/colors.dart';
import 'package:carsnexus_user/Theme/theme.dart';
import 'package:carsnexus_user/Widgets/app_bar_back_icon.dart';
import 'package:carsnexus_user/Widgets/constant_widget.dart';
import 'package:carsnexus_user/lang_const.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();

  ///user name controller & Focus node
  TextEditingController userNameController = TextEditingController();
  late FocusNode userNameFocusNode;

  ///email controller & Focus Node
  TextEditingController emailController = TextEditingController();
  late FocusNode emailFocusNode;

  ///Phone number Controller & Focus Node
  TextEditingController phoneNumberController = TextEditingController();
  late FocusNode phoneNumberFocusNode;

  ///password Controller & Focus Node
  TextEditingController passwordController = TextEditingController();
  late FocusNode passwordFocusNode;
  bool _isObscureText = true;

  late AuthProvider authProvider;
  bool readOnly = false;

  @override
  void initState() {
    userNameFocusNode = FocusNode();
    emailFocusNode = FocusNode();
    phoneNumberFocusNode = FocusNode();
    passwordFocusNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    userNameController.dispose();
    emailController.dispose();
    phoneNumberController.dispose();
    passwordController.dispose();

    emailFocusNode.dispose();
    userNameFocusNode.dispose();
    phoneNumberFocusNode.dispose();
    passwordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    authProvider = Provider.of<AuthProvider>(context);
    return ModalProgressHUD(
      inAsyncCall: authProvider.registerLoading,
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
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(Amount.screenMargin),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const HeightBox(25),
                  Text(
                    getTranslated(context, LangConst.createAccount).toString(),
                    style: Theme.of(context).textTheme.displaySmall!.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                        ),
                  ),
                  Text(
                    getTranslated(context, LangConst.letsGetStarted).toString(),
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          color: AppColors.subText,
                        ),
                  ),
                  const HeightBox(30),
                  TextFormField(
                    focusNode: userNameFocusNode,
                    controller: userNameController,
                    keyboardType: TextInputType.name,
                    readOnly: readOnly,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter user name';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      labelText:
                          getTranslated(context, LangConst.userName).toString(),
                      filled: true,
                      floatingLabelBehavior: FloatingLabelBehavior.auto,
                      fillColor: userNameFocusNode.hasFocus
                          ? AppColors.primary.withAlpha(40)
                          : Colors.white,
                    ),
                  ),
                  const HeightBox(15),
                  TextFormField(
                    focusNode: emailFocusNode,
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    readOnly: readOnly,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter valid email';
                      }
                      return null;
                    },
                    inputFormatters: [
                      FilteringTextInputFormatter.deny(RegExp(r"\s")),
                      // To prevent space
                      FilteringTextInputFormatter.allow(
                          RegExp(r"[a-zA-Z0-9@.]+")),
                      // To allow only email valid characters
                    ],
                    decoration: InputDecoration(
                      labelText:
                          getTranslated(context, LangConst.email).toString(),
                      filled: true,
                      floatingLabelBehavior: FloatingLabelBehavior.auto,
                      fillColor: emailFocusNode.hasFocus
                          ? AppColors.primary.withAlpha(40)
                          : Colors.white,
                    ),
                  ),
                  const HeightBox(15),
                  TextFormField(
                    focusNode: phoneNumberFocusNode,
                    controller: phoneNumberController,
                    keyboardType: TextInputType.phone,
                    readOnly: readOnly,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter phone number';
                      }
                      return null;
                    },
                    inputFormatters: const [],
                    decoration: InputDecoration(
                      labelText: getTranslated(context, LangConst.phoneNumber)
                          .toString(),
                      filled: true,
                      floatingLabelBehavior: FloatingLabelBehavior.auto,
                      fillColor: phoneNumberFocusNode.hasFocus
                          ? AppColors.primary.withAlpha(40)
                          : Colors.white,
                    ),
                  ),
                  const HeightBox(15),
                  TextFormField(
                    focusNode: passwordFocusNode,
                    controller: passwordController,
                    obscureText: _isObscureText,
                    readOnly: readOnly,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your password';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      labelText:
                          getTranslated(context, LangConst.password).toString(),
                      filled: true,
                      fillColor: passwordFocusNode.hasFocus
                          ? AppColors.primary.withAlpha(40)
                          : Colors.white,
                      suffixIcon: InkWell(
                        onTap: () {
                          setState(() {
                            _isObscureText = !_isObscureText;
                          });
                        },
                        child: Icon(
                          _isObscureText
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                        ),
                      ),
                    ),
                  ),
                  const HeightBox(45),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        Map<String, dynamic> body = {
                          'name': userNameController.text,
                          'email': emailController.text,
                          'password': passwordController.text,
                          'phone_no': phoneNumberController.text,
                        };
                        authProvider.getRegistered(context, body);
                      }
                      return;
                    },
                    style: AppButtonStyle.filledMedium.copyWith(
                      minimumSize: WidgetStatePropertyAll(
                        Size(MediaQuery.of(context).size.width, 50),
                      ),
                    ),
                    child: Text(
                      getTranslated(context, LangConst.createAccount)
                          .toString(),
                      style: Theme.of(context).textTheme.labelLarge!.copyWith(
                            color: AppColors.white,
                          ),
                    ),
                  ),
                ],
              ),
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
                  text: getTranslated(context, LangConst.alreadyHaveAnAccount)
                      .toString(),
                  style: Theme.of(context).textTheme.bodyMedium,
                  children: [
                    TextSpan(
                      text: getTranslated(context, LangConst.login).toString(),
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium!
                          .copyWith(color: AppColors.primary),
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
