import 'package:carsnexus_user/Authentication/forgot_password_screen.dart';
import 'package:carsnexus_user/Authentication/provider/auth_provider.dart';
import 'package:carsnexus_user/Authentication/sign_up_screen.dart';
import 'package:carsnexus_user/Localization/localization_constant.dart';
import 'package:carsnexus_user/Theme/colors.dart';
import 'package:carsnexus_user/Theme/theme.dart';
import 'package:carsnexus_user/Widgets/constant_widget.dart';
import 'package:carsnexus_user/lang_const.dart';
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
        backgroundColor: AppColors.white,
        body: SafeArea(
          child: SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            child: Column(
              children: [
                Center(
                  child: Container(
                    color: AppColors.background,
                    width: MediaQuery.of(context).size.width,
                    padding: const EdgeInsets.only(top: 50, bottom: 50),
                    child: Image.asset("assets/app/logo.png"),
                  ),
                ),
                Container(
                  color: AppColors.white,
                  padding: const EdgeInsets.all(Amount.screenMargin),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const HeightBox(10),
                        Text(
                          getTranslated(context, LangConst.loginNow).toString(),
                          style: Theme.of(context)
                              .textTheme
                              .displaySmall!
                              .copyWith(
                                fontWeight: FontWeight.bold,
                                fontSize: 25,
                              ),
                        ),
                        Text(
                          getTranslated(context, LangConst.letGetStarted)
                              .toString(),
                          style:
                              Theme.of(context).textTheme.bodyLarge!.copyWith(
                                    color: AppColors.subText,
                                  ),
                        ),
                        const HeightBox(30),
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
                          decoration: InputDecoration(
                            labelText:
                                getTranslated(context, LangConst.emailAddress)
                                    .toString(),
                            filled: true,
                            floatingLabelBehavior: FloatingLabelBehavior.auto,
                            fillColor: emailFocusNode.hasFocus
                                ? AppColors.primary.withAlpha(40)
                                : Colors.white,
                          ),
                        ),
                        const HeightBox(30),
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
                          decoration: InputDecoration(
                            labelText:
                                getTranslated(context, LangConst.password)
                                    .toString(),
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
                                  ),
                            ),
                          ),
                        ),
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
                                50,
                              ),
                            ),
                          ),
                          child: Text(
                            getTranslated(context, LangConst.loginButton)
                                .toString(),
                            style: Theme.of(context)
                                .textTheme
                                .labelLarge!
                                .copyWith(
                                  color: AppColors.white,
                                ),
                          ),
                        ),
                        const HeightBox(30),
                        Align(
                          alignment: Alignment.center,
                          child: RichText(
                            text: TextSpan(
                              text: getTranslated(
                                      context, LangConst.dontHaveAccount)
                                  .toString(),
                              style: Theme.of(context).textTheme.bodyMedium,
                              children: [
                                TextSpan(
                                  text: getTranslated(
                                          context, LangConst.createAccount)
                                      .toString(),
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(
                                        color: AppColors.primary,
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
