import 'package:cached_network_image/cached_network_image.dart';
import 'package:carsnexus_user/Constants/keys_values.dart';
import 'package:carsnexus_user/Constants/preference_utility.dart';
import 'package:carsnexus_user/Localization/localization_constant.dart';
import 'package:carsnexus_user/Profile/faq_screen.dart';
import 'package:carsnexus_user/Profile/my_bookings_screen.dart';
import 'package:carsnexus_user/Profile/notification_screen.dart';
import 'package:carsnexus_user/Profile/privacy_policy_screen.dart';
import 'package:carsnexus_user/Profile/setting_screen.dart';
import 'package:carsnexus_user/Routes/routes.dart';
import 'package:carsnexus_user/Theme/colors.dart';
import 'package:carsnexus_user/Theme/theme.dart';
import 'package:carsnexus_user/Widgets/app_bar_back_icon.dart';
import 'package:carsnexus_user/Widgets/constant_widget.dart';
import 'package:carsnexus_user/lang_const.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({super.key});

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: MediaQuery.of(context).size.width * .8,
      child: ListView(
        padding: const EdgeInsets.only(left: 8, right: 8),
        children: [
          DrawerHeader(
            padding: EdgeInsets.zero,
            margin: EdgeInsets.zero,
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Colors.transparent,
                ),
              ),
            ),
            child: Stack(
              children: [
                const Align(
                  alignment: Alignment.topLeft,
                  child: AppBarBack(),
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  top: Amount.screenMargin,
                  child: Column(
                    children: [
                      CircleAvatar(
                          radius: 35,
                          backgroundColor: AppColors.primary,
                          backgroundImage: CachedNetworkImageProvider(
                            SharedPreferenceUtil.getString(
                                PrefKey.profileImage),
                          )),
                      Text(
                        SharedPreferenceUtil.getString(PrefKey.fullName),
                        style:
                            Theme.of(context).textTheme.headlineSmall!.copyWith(
                                  color: AppColors.bodyText,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 24,
                                ),
                      ),
                      Text(
                        SharedPreferenceUtil.getString(PrefKey.email),
                        style:
                            Theme.of(context).textTheme.labelMedium!.copyWith(
                                  color: AppColors.subText,
                                ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const HeightBox(Amount.screenMargin),

          ///my Bookings
          ListTile(
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const MyBookingsScreen(),
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
              CupertinoIcons.briefcase_fill,
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
              getTranslated(context, LangConst.myBookings).toString(),
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.bodyText,
                  ),
            ),
          ),
          const HeightBox(Amount.screenMargin),

          ///notification
          ListTile(
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const NotificationScreen(),
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
              Icons.notifications,
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
              getTranslated(context, LangConst.notification).toString(),
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.bodyText,
                  ),
            ),
          ),
          const HeightBox(Amount.screenMargin),

          ///settings
          ListTile(
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const SettingScreen(),
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
              Icons.settings,
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
              getTranslated(context, LangConst.settings).toString(),
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.bodyText,
                  ),
            ),
          ),
          const HeightBox(Amount.screenMargin),

          ///privacy policy
          ListTile(
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const PrivacyPolicyScreen(),
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
              CupertinoIcons.doc_chart_fill,
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
              getTranslated(context, LangConst.privacyPolicy).toString(),
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.bodyText,
                  ),
            ),
          ),
          const HeightBox(Amount.screenMargin),

          ///faq
          ListTile(
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const FaqScreen(),
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
              CupertinoIcons.bubble_left_fill,
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
              getTranslated(context, LangConst.faq).toString(),
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.bodyText,
                  ),
            ),
          ),
          const HeightBox(Amount.screenMargin),

          ///logout
          ListTile(
            selectedTileColor: Colors.red.withAlpha(50),
            selected: true,
            shape: const RoundedRectangleBorder(
              borderRadius: AppBorderRadius.k08,
            ),
            leading: const Icon(
              Icons.logout_outlined,
              size: 20,
              color: Colors.red,
            ),
            contentPadding: const EdgeInsets.only(
              left: Amount.screenMargin,
              right: Amount.screenMargin,
              top: 5,
              bottom: 5,
            ),
            visualDensity: const VisualDensity(vertical: -4, horizontal: 4),
            minLeadingWidth: 0,
            title: Text(
              getTranslated(context, LangConst.logout).toString(),
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Colors.red,
                  ),
            ),
            onTap: () async {
              return showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    surfaceTintColor: AppColors.white,
                    backgroundColor: AppColors.white,
                    shadowColor: AppColors.white,
                    actionsPadding: const EdgeInsets.only(
                      right: 16,
                      bottom: 16,
                      left: 16,
                    ),
                    title: Text(
                      getTranslated(context, LangConst.logout).toString(),
                    ),
                    content: Text(
                      getTranslated(
                              context, LangConst.areYouSureToLogoutThisAccount)
                          .toString(),
                      maxLines: 2,
                      textAlign: TextAlign.center,
                    ),
                    actions: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.stroke,
                        ),
                        child: Text(
                          getTranslated(context, LangConst.cancel).toString(),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          String languageCode = SharedPreferenceUtil.getString(
                              PrefKey.currentLanguageCode);
                          await SharedPreferenceUtil.clear();
                          if (context.mounted) {
                            Navigator.of(context).pushNamedAndRemoveUntil(
                                Routes.login, (route) => false);
                          }
                          SharedPreferenceUtil.putString(
                              PrefKey.currentLanguageCode, languageCode);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFF4D4F),
                        ),
                        child: Text(
                          getTranslated(context, LangConst.logout).toString(),
                        ),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
