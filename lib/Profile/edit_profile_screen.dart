import 'package:carsnexus_user/Constants/keys_values.dart';
import 'package:carsnexus_user/Constants/preference_utility.dart';
import 'package:carsnexus_user/Localization/localization_constant.dart';
import 'package:carsnexus_user/Profile/providers/profile_provider.dart';
import 'package:carsnexus_user/Theme/colors.dart';
import 'package:carsnexus_user/Theme/theme.dart';
import 'package:carsnexus_user/Widgets/app_bar_back_icon.dart';
import 'package:carsnexus_user/Widgets/constant_widget.dart';
import 'package:carsnexus_user/lang_const.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _formKeyChangePassword = GlobalKey<FormState>();

  ///user name controller & Focus node
  TextEditingController userNameController = TextEditingController();
  late FocusNode userNameFocusNode;

  ///email controller & Focus Node
  TextEditingController emailController = TextEditingController();
  late FocusNode emailFocusNode;

  ///Phone number Controller & Focus Node
  TextEditingController phoneNumberController = TextEditingController();
  late FocusNode phoneNumberFocusNode;

  ///Current Password Controller & Focus Node & Obscure
  TextEditingController currentPasswordController = TextEditingController();
  late FocusNode currentPasswordFocusNode;
  bool _isObscureTextCurrentPassword = true;

  ///new Password Controller & Focus Node & Obscure
  TextEditingController newPasswordController = TextEditingController();
  late FocusNode newPasswordFocusNode;
  bool _isObscureTextNewPassword = true;

  ///Confirm Password Controller & Focus Node & Obscure
  TextEditingController confirmPasswordController = TextEditingController();
  late FocusNode confirmFocusNode;
  bool _isObscureConfirmText = true;

  @override
  void initState() {
    userNameController.text = SharedPreferenceUtil.getString(PrefKey.fullName);
    emailController.text = SharedPreferenceUtil.getString(PrefKey.email);
    phoneNumberController.text = SharedPreferenceUtil.getString(PrefKey.mobile);
    profileProvider = Provider.of<ProfileProvider>(context, listen: false);
    super.initState();
    userNameFocusNode = FocusNode();
    emailFocusNode = FocusNode();
    phoneNumberFocusNode = FocusNode();
    currentPasswordFocusNode = FocusNode();
    newPasswordFocusNode = FocusNode();
    confirmFocusNode = FocusNode();
  }

  @override
  void dispose() {
    userNameController.dispose();
    emailController.dispose();
    phoneNumberController.dispose();
    currentPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();

    userNameFocusNode.dispose();
    emailFocusNode.dispose();
    phoneNumberFocusNode.dispose();
    currentPasswordFocusNode.dispose();
    newPasswordFocusNode.dispose();
    confirmFocusNode.dispose();
    super.dispose();
  }

  late ProfileProvider profileProvider;

  @override
  Widget build(BuildContext context) {
    profileProvider = Provider.of<ProfileProvider>(context);
    return ModalProgressHUD(
      inAsyncCall:
          profileProvider.updateProfile || profileProvider.passwordLoading,
      opacity: 0.5,
      progressIndicator: const SpinKitPulsingGrid(
        color: AppColors.primary,
        size: 50.0,
      ),
      child: Scaffold(
        backgroundColor: AppColors.white,
        appBar: AppBar(
          leading: const AppBarBack(),
          title: Text(getTranslated(context, LangConst.editProfile).toString()),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(Amount.screenMargin),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ///profile image
              GestureDetector(
                onTap: () {
                  profileProvider.showImageSource(context);
                },
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: CircleAvatar(
                        radius: 50,
                        backgroundImage: NetworkImage(
                          SharedPreferenceUtil.getString(PrefKey.profileImage),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 70, left: 60),
                      child: Align(
                        alignment: Alignment.center,
                        child: Container(
                          padding: const EdgeInsets.all(5),
                          decoration: const BoxDecoration(
                            borderRadius: AppBorderRadius.k06,
                            color: AppColors.primary,
                          ),
                          child: const Icon(
                            Icons.edit,
                            color: AppColors.white,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              ///Edit profile
              Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.only(top: 40),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        getTranslated(context, LangConst.editProfile)
                            .toString(),
                        style:
                            Theme.of(context).textTheme.titleMedium!.copyWith(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                      ),
                      const HeightBox(20),
                      TextFormField(
                        focusNode: userNameFocusNode,
                        controller: userNameController,
                        keyboardType: TextInputType.name,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter user name';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          labelText: getTranslated(context, LangConst.userName)
                              .toString(),
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
                          labelText: getTranslated(context, LangConst.email)
                              .toString(),
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
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter phone number';
                          }
                          return null;
                        },
                        inputFormatters: const [],
                        decoration: InputDecoration(
                          labelText:
                              getTranslated(context, LangConst.phoneNumber)
                                  .toString(),
                          filled: true,
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
                              'name': userNameController.text,
                              'email': emailController.text,
                              'phone_no': phoneNumberController.text,
                            };
                            profileProvider.updateProfileMethod(body);
                          }
                        },
                        style: AppButtonStyle.filledMedium.copyWith(
                          minimumSize: MaterialStatePropertyAll(
                            Size(MediaQuery.of(context).size.width, 50),
                          ),
                        ),
                        child: Text(
                          getTranslated(context, LangConst.save).toString(),
                          style:
                              Theme.of(context).textTheme.labelLarge!.copyWith(
                                    color: AppColors.white,
                                  ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              ///change Password
              Form(
                key: _formKeyChangePassword,
                child: Padding(
                  padding: const EdgeInsets.only(top: 40),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        getTranslated(context, LangConst.changePassword)
                            .toString(),
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(
                                fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      const HeightBox(20),
                      TextFormField(
                        focusNode: currentPasswordFocusNode,
                        controller: currentPasswordController,
                        obscureText: _isObscureTextCurrentPassword,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter current password';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          labelText:
                              getTranslated(context, LangConst.currentPassword)
                                  .toString(),
                          filled: true,
                          fillColor: currentPasswordFocusNode.hasFocus
                              ? AppColors.primary.withAlpha(40)
                              : Colors.white,
                          suffixIcon: InkWell(
                            onTap: () {
                              setState(() {
                                _isObscureTextCurrentPassword =
                                    !_isObscureTextCurrentPassword;
                              });
                            },
                            child: Icon(
                              _isObscureTextCurrentPassword
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                            ),
                          ),
                        ),
                      ),
                      const HeightBox(15),
                      TextFormField(
                        focusNode: newPasswordFocusNode,
                        controller: newPasswordController,
                        obscureText: _isObscureTextNewPassword,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter new password';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          labelText:
                              getTranslated(context, LangConst.newPassword)
                                  .toString(),
                          filled: true,
                          fillColor: newPasswordFocusNode.hasFocus
                              ? AppColors.primary.withAlpha(40)
                              : Colors.white,
                          suffixIcon: InkWell(
                            onTap: () {
                              setState(() {
                                _isObscureTextNewPassword =
                                    !_isObscureTextNewPassword;
                              });
                            },
                            child: Icon(
                              _isObscureTextNewPassword
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
                          labelText:
                              getTranslated(context, LangConst.confirmPassword)
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
                        onPressed: currentPasswordController.text.isEmpty &&
                                newPasswordController.text.isEmpty &&
                                confirmPasswordController.text.isEmpty
                            ? null
                            : () {
                                if (_formKeyChangePassword.currentState!
                                    .validate()) {
                                  Map<String, dynamic> body = {
                                    'old_password':
                                        currentPasswordController.text,
                                    'password': newPasswordController.text,
                                    'password_confirmation':
                                        confirmPasswordController.text,
                                  };
                                  profileProvider.changePassword(body);
                                }
                              },
                        style: AppButtonStyle.filledMedium.copyWith(
                          minimumSize: MaterialStatePropertyAll(
                            Size(MediaQuery.of(context).size.width, 50),
                          ),
                        ),
                        child: Text(
                          getTranslated(context, LangConst.changePassword)
                              .toString(),
                          style:
                              Theme.of(context).textTheme.labelLarge!.copyWith(
                                    color: AppColors.white,
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
    );
  }
}
