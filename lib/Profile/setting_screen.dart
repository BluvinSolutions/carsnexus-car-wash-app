import 'package:carq_user/Constants/keys_values.dart';
import 'package:carq_user/Constants/preference_utility.dart';
import 'package:carq_user/Localization/localization_constant.dart';
import 'package:carq_user/Profile/edit_profile_screen.dart';
import 'package:carq_user/Profile/providers/profile_provider.dart';
import 'package:carq_user/Theme/colors.dart';
import 'package:carq_user/Theme/theme.dart';
import 'package:carq_user/Widgets/app_bar_back_icon.dart';
import 'package:carq_user/Widgets/constant_widget.dart';
import 'package:carq_user/lang_const.dart';
import 'package:carq_user/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  bool isNotification = true;
  late ProfileProvider profileProvider;

  @override
  void initState() {
    Future.delayed(
      Duration.zero,
      () => profileProvider.getSettings(),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    profileProvider = Provider.of<ProfileProvider>(context);
    return ModalProgressHUD(
      inAsyncCall: profileProvider.updateProfile,
      opacity: 0.5,
      progressIndicator: const SpinKitPulsingGrid(
        color: AppColors.primary,
        size: 50.0,
      ),
      child: Scaffold(
        backgroundColor: AppColors.white,
        appBar: AppBar(
          leading: const AppBarBack(),
          title: const Text("Settings"),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(Amount.screenMargin),
          child: Column(
            children: [
              ListTile(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const EditProfileScreen(),
                    ),
                  );
                },
                shape: const RoundedRectangleBorder(
                  borderRadius: AppBorderRadius.k08,
                  side: BorderSide(
                    color: AppColors.stroke,
                  ),
                ),
                leading: const Icon(
                  CupertinoIcons.person_crop_square,
                  size: 22,
                  color: AppColors.primary,
                ),
                contentPadding: const EdgeInsets.only(
                  left: Amount.screenMargin,
                  right: Amount.screenMargin,
                  top: 5,
                  bottom: 5,
                ),
                visualDensity: const VisualDensity(vertical: -4, horizontal: 4),
                minLeadingWidth: 0,
                trailing: const Icon(
                  Icons.arrow_forward_ios_sharp,
                  size: 18,
                  color: AppColors.stroke,
                ),
                title: Text(
                  getTranslated(context, LangConst.editProfile).toString(),
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColors.bodyText,
                      ),
                ),
              ),
              const HeightBox(Amount.screenMargin),
              SwitchListTile(
                  shape: const RoundedRectangleBorder(
                    borderRadius: AppBorderRadius.k08,
                    side: BorderSide(
                      color: AppColors.stroke,
                    ),
                  ),
                  contentPadding: const EdgeInsetsDirectional.only(
                    start: Amount.screenMargin,
                    top: 5,
                    bottom: 5,
                  ),
                  visualDensity:
                      const VisualDensity(vertical: -4, horizontal: -4),
                  secondary: const Icon(
                    Icons.settings,
                    size: 22,
                    color: AppColors.primary,
                  ),
                  title: Text(
                    getTranslated(context, LangConst.notification).toString(),
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppColors.bodyText,
                        ),
                  ),
                  value: profileProvider.isNotification,
                  activeTrackColor: AppColors.primary,
                  inactiveTrackColor: AppColors.icon,
                  onChanged: (value) {
                    setState(() {
                      profileProvider.isNotification = value;
                      Map<String, dynamic> body = {'noti': value};
                      profileProvider.updateProfileMethod(body);
                    });
                  }),
              const HeightBox(Amount.screenMargin),
              ListTile(
                onTap: () {
                  showLanguageModelBottomSheet();
                },
                shape: const RoundedRectangleBorder(
                  borderRadius: AppBorderRadius.k08,
                  side: BorderSide(
                    color: AppColors.stroke,
                  ),
                ),
                leading: const Icon(
                  Icons.translate_outlined,
                  size: 22,
                  color: AppColors.primary,
                ),
                contentPadding: const EdgeInsets.only(
                  left: Amount.screenMargin,
                  right: Amount.screenMargin,
                  top: 5,
                  bottom: 5,
                ),
                visualDensity: const VisualDensity(vertical: -4, horizontal: 4),
                minLeadingWidth: 0,
                trailing: const Icon(
                  Icons.arrow_forward_ios_sharp,
                  size: 18,
                  color: AppColors.stroke,
                ),
                title: Text(
                  getTranslated(context, LangConst.language).toString(),
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColors.bodyText,
                      ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  showLanguageModelBottomSheet() {
    return showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return SizedBox(
              height: 125,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.only(
                      top: 20,
                    ),
                    decoration: const BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(28),
                        topLeft: Radius.circular(28),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsetsDirectional.only(
                              start: Amount.screenMargin),
                          child: Text(
                            getTranslated(context, LangConst.language)
                                .toString(),
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .copyWith(
                                  color: AppColors.bodyText,
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                        ),
                        ListView.builder(
                          itemCount: Language.languageList().length,
                          shrinkWrap: true,
                          padding: const EdgeInsets.only(
                            left: Amount.screenMargin,
                            right: Amount.screenMargin,
                          ),
                          itemBuilder: (context, index) {
                            return ListTile(
                              onTap: () async {
                                Locale local = await setLocale(
                                    Language.languageList()[index]
                                        .languageCode);
                                setState(() {
                                  MyApp.setLocale(context, local);
                                  SharedPreferenceUtil.putString(
                                      PrefKey.currentLanguageCode,
                                      Language.languageList()[index]
                                          .languageCode);
                                  Navigator.of(context).pop();
                                });
                              },
                              contentPadding: EdgeInsets.zero,
                              visualDensity: const VisualDensity(
                                  horizontal: -4, vertical: -4),
                              title: Text(
                                index == 0 ? "English (US)" : "Arabic",
                                style: Theme.of(context)
                                    .textTheme
                                    .labelLarge!
                                    .copyWith(
                                      color: AppColors.bodyText,
                                      fontWeight: FontWeight.w500,
                                    ),
                              ),
                              trailing: Icon(
                                SharedPreferenceUtil.getString(PrefKey
                                                    .currentLanguageCode) ==
                                                'N/A' &&
                                            index == 0 ||
                                        SharedPreferenceUtil.getString(
                                                PrefKey.currentLanguageCode) ==
                                            Language.languageList()[index]
                                                .languageCode
                                    ? Icons.check_box
                                    : Icons.check_box_outline_blank,
                                color: AppColors.primary,
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

class Language {
  final int id;
  final String name;
  final String flag;
  final String languageCode;

  Language(
    this.id,
    this.name,
    this.flag,
    this.languageCode,
  );

  static List<Language> languageList() {
    return <Language>[
      Language(1, 'English', '🇺🇸', 'en'),
      Language(2, 'Arabic', 'AE', 'ar'),
    ];
  }
}
