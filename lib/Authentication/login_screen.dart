import 'package:voyzo/Authentication/forgot_password_screen.dart';
import 'package:voyzo/Authentication/provider/auth_provider.dart';
import 'package:voyzo/Authentication/sign_up_screen.dart';
import 'package:voyzo/Localization/localization_constant.dart';
import 'package:voyzo/Theme/colors.dart';
import 'package:voyzo/Theme/theme.dart';
import 'package:voyzo/Widgets/constant_widget.dart';
import 'package:voyzo/lang_const.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isObscureText = true;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  late FocusNode emailFocusNode;
  late FocusNode passwordFocusNode;
  late AuthProvider authProvider;
  final _formKey = GlobalKey<FormState>();
  bool isCredentialsReadOnly = false;

  @override
  void initState() {
    emailFocusNode = FocusNode();
    passwordFocusNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    emailFocusNode.dispose();
    passwordFocusNode.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    authProvider = Provider.of<AuthProvider>(
      context,
    );
    return ModalProgressHUD(
      inAsyncCall: authProvider.loginLoading,
      opacity: 0.5,
      progressIndicator: const SpinKitPulsingGrid(
        color: AppColors.primary,
        size: 50.0,
      ),
      child: Scaffold(
        backgroundColor: AppColors.background, // Use background color for the entire screen
        body: SafeArea(
          child: SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            child: Column(
              children: [
                // 1. LOGO HEADER (Using primary color accent)
                Container(
                  width: MediaQuery.of(context).size.width,
                  // Use a slightly softer color for the logo background if AppColors.background is too white
                  color: AppColors.primary50.withOpacity(0.5),
                  padding: const EdgeInsets.symmetric(vertical: 50),
                  child: Image.asset(
                    "assets/app/logo.png",
                    height: 120,
                  ),
                ),

                // 2. LOGIN FORM AREA
                Container(
                  color: AppColors.white,
                  padding: const EdgeInsets.all(Amount.screenMargin),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const HeightBox(20),
                        Text(
                          getTranslated(context, LangConst.loginNow).toString(),
                          style: Theme.of(context)
                              .textTheme
                              .displaySmall!
                              .copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 32, // Slightly larger
                            color: AppColors.bodyText,
                          ),
                        ),
                        Text(
                          getTranslated(context, LangConst.letGetStarted)
                              .toString(),
                          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            color: AppColors.subText,
                            fontSize: 16,
                          ),
                        ),
                        const HeightBox(40),

                        // EMAIL FIELD
                        TextFormField(
                          focusNode: emailFocusNode,
                          controller: emailController,
                          keyboardType: TextInputType.emailAddress,
                          readOnly: isCredentialsReadOnly,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter valid email';
                            }
                            return null;
                          },
                          // Modern InputDecoration Styling
                          decoration: InputDecoration(
                            labelText:
                            getTranslated(context, LangConst.emailAddress)
                                .toString(),
                            floatingLabelBehavior: FloatingLabelBehavior.auto,
                            // Removed filled: true and fillColor for a cleaner look
                            border: OutlineInputBorder(
                              borderRadius: AppBorderRadius.k12,
                              borderSide: const BorderSide(color: AppColors.stroke),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: AppBorderRadius.k12,
                              borderSide: const BorderSide(color: AppColors.primary, width: 2), // Primary accent on focus
                            ),
                          ),
                        ),
                        const HeightBox(20),

                        // PASSWORD FIELD
                        TextFormField(
                          focusNode: passwordFocusNode,
                          controller: passwordController,
                          obscureText: _isObscureText,
                          readOnly: isCredentialsReadOnly,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter your password';
                            }
                            return null;
                          },
                          // Modern InputDecoration Styling
                          decoration: InputDecoration(
                            labelText:
                            getTranslated(context, LangConst.password)
                                .toString(),
                            // Removed filled: true and fillColor
                            border: OutlineInputBorder(
                              borderRadius: AppBorderRadius.k12,
                              borderSide: const BorderSide(color: AppColors.stroke),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: AppBorderRadius.k12,
                              borderSide: const BorderSide(color: AppColors.primary, width: 2), // Primary accent on focus
                            ),
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
                                color: AppColors.subText,
                              ),
                            ),
                          ),
                        ),

                        // FORGOT PASSWORD
                        Align(
                          alignment: Alignment.topRight,
                          child: TextButton(
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) =>
                                  const ForgotPasswordScreen(),
                                ),
                              );
                            },
                            child: Text(
                              getTranslated(context, LangConst.forgotPassword)
                                  .toString(),
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(
                                color: AppColors.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),

                        // LOGIN BUTTON
                        ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              Map<String, dynamic> body = {
                                'email': emailController.text,
                                'password': passwordController.text,
                              };
                              authProvider.getLoggedIn(context, body);
                            }
                            return;
                          },
                          style: AppButtonStyle.filledMedium.copyWith(
                            minimumSize: WidgetStatePropertyAll(
                              Size(
                                MediaQuery.of(context).size.width,
                                55, // Slightly taller button
                              ),
                            ),
                          ),
                          child: Text(
                            getTranslated(context, LangConst.loginButton)
                                .toString(),
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .copyWith(
                              color: AppColors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),

                        const HeightBox(30),

                        // SIGN UP LINK
                        Align(
                          alignment: Alignment.center,
                          child: RichText(
                            text: TextSpan(
                              text: getTranslated(
                                  context, LangConst.dontHaveAccount)
                                  .toString(),
                              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                color: AppColors.bodyText,
                              ),
                              children: [
                                TextSpan(
                                  text: ' ${getTranslated(context, LangConst.createAccount).toString()}',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      Navigator.of(context).pushReplacement(
                                        MaterialPageRoute(
                                          builder: (context) =>
                                          const SignUpScreen(),
                                        ),
                                      );
                                    },
                                ),
                              ],
                            ),
                          ),
                        ),
                        const HeightBox(20),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}