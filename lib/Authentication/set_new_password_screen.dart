import 'package:carsnexus_user/Authentication/provider/auth_provider.dart';
import 'package:carsnexus_user/Localization/localization_constant.dart';
import 'package:carsnexus_user/Theme/colors.dart';
import 'package:carsnexus_user/Theme/theme.dart';
import 'package:carsnexus_user/Widgets/app_bar_back_icon.dart';
import 'package:carsnexus_user/Widgets/constant_widget.dart';
import 'package:carsnexus_user/lang_const.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';

class SetNewPasswordScreen extends StatefulWidget {
  const SetNewPasswordScreen({super.key});

  @override
  State<SetNewPasswordScreen> createState() => _SetNewPasswordScreenState();
}

class _SetNewPasswordScreenState extends State<SetNewPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController passwordController = TextEditingController();
  late FocusNode passwordFocusNode;
  bool _isObscureText = true;

  TextEditingController confirmPasswordController = TextEditingController();
  late FocusNode confirmFocusNode;
  bool _isObscureConfirmText = true;

  late AuthProvider authProvider;

  @override
  void initState() {
    super.initState();
    passwordFocusNode = FocusNode();
    confirmFocusNode = FocusNode();
  }

  @override
  void dispose() {
    passwordFocusNode.dispose();
    passwordController.dispose();

    confirmFocusNode.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    authProvider = Provider.of<AuthProvider>(context);
    return ModalProgressHUD(
      inAsyncCall: authProvider.changePasswordLoading,
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
                  getTranslated(context, LangConst.setPassword).toString(),
                  style: Theme.of(context).textTheme.displaySmall!.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 25,
                      ),
                ),
                Text(
                  getTranslated(
                          context, LangConst.enterTheVerificationCodeBelow)
                      .toString(),
                  maxLines: 2,
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        color: AppColors.subText,
                      ),
                ),
                const HeightBox(30),
                TextFormField(
                  focusNode: passwordFocusNode,
                  controller: passwordController,
                  obscureText: _isObscureText,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter new password';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    labelText: getTranslated(context, LangConst.newPassword)
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
                const HeightBox(15),
                TextFormField(
                  focusNode: confirmFocusNode,
                  controller: confirmPasswordController,
                  obscureText: _isObscureConfirmText,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter confirm password';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    labelText: getTranslated(
                            context, LangConst.reEnterToConfirmPassword)
                        .toString(),
                    filled: true,
                    fillColor: confirmFocusNode.hasFocus
                        ? AppColors.primary.withAlpha(40)
                        : Colors.white,
                    suffixIcon: InkWell(
                      onTap: () {
                        setState(() {
                          _isObscureConfirmText = !_isObscureConfirmText;
                        });
                      },
                      child: Icon(
                        _isObscureConfirmText
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                      ),
                    ),
                  ),
                ),
                const HeightBox(40),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      if (passwordController.text ==
                          confirmPasswordController.text) {
                        Map<String, dynamic> body = {
                          'password': passwordController.text,
                        };
                        authProvider.changePassword(context, body);
                      }
                    }
                  },
                  style: AppButtonStyle.filledMedium.copyWith(
                    minimumSize: MaterialStatePropertyAll(
                      Size(MediaQuery.of(context).size.width, 50),
                    ),
                  ),
                  child: Text(
                    getTranslated(context, LangConst.updatePassword).toString(),
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
    );
  }
}
