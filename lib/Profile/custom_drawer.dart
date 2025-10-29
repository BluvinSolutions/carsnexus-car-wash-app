import 'package:cached_network_image/cached_network_image.dart';
import 'package:voyzo/Constants/keys_values.dart';
import 'package:voyzo/Constants/preference_utility.dart';
import 'package:voyzo/Localization/localization_constant.dart';
import 'package:voyzo/Profile/faq_screen.dart';
import 'package:voyzo/Profile/my_bookings_screen.dart';
import 'package:voyzo/Profile/notification_screen.dart';
import 'package:voyzo/Profile/privacy_policy_screen.dart';
import 'package:voyzo/Profile/setting_screen.dart';
import 'package:voyzo/Routes/routes.dart';
import 'package:voyzo/Theme/colors.dart';
import 'package:voyzo/Theme/theme.dart';
import 'package:voyzo/Widgets/constant_widget.dart';
import 'package:voyzo/lang_const.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({super.key});

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  Widget _buildDrawerTile({
    required BuildContext context,
    required String titleKey,
    required IconData icon,
    required Widget destination,
  }) {
    return ListTile(
      onTap: () {
        Navigator.of(context).pop();
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => destination),
        );
      },

      shape: const RoundedRectangleBorder(borderRadius: AppBorderRadius.k12),
      selectedTileColor: AppColors.primary50,
      tileColor: AppColors.transparent,
      hoverColor: AppColors.primary50.withOpacity(0.5),
      leading: Icon(
        icon,
        size: 22,
        color: AppColors.primary,
      ),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: Amount.screenMargin,
        vertical: 4,
      ),
      visualDensity: VisualDensity.compact,
      minLeadingWidth: 0,
      trailing: const Icon(
        Icons.arrow_forward_ios_sharp,
        size: 16,
        color: AppColors.subText,
      ),
      title: Text(
        getTranslated(context, titleKey).toString(),
        style: Theme.of(context).textTheme.titleMedium!.copyWith(
          fontWeight: FontWeight.w500,
          color: AppColors.bodyText,
        ),
      ),
    );
  }


  Widget _buildLogoutTile(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Amount.screenMargin, vertical: 16),
      child: Material(
        color: Colors.red.withOpacity(0.1),
        borderRadius: AppBorderRadius.k12,
        child: InkWell(
          borderRadius: AppBorderRadius.k12,
          onTap: () async {
            return showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  surfaceTintColor: AppColors.white,
                  backgroundColor: AppColors.white,
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
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: Amount.screenMargin, vertical: 12),
            child: Row(
              children: [
                const Icon(
                  Icons.logout_outlined,
                  size: 22,
                  color: Colors.red,
                ),
                const WidthBox(16),
                Text(
                  getTranslated(context, LangConst.logout).toString(),
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: MediaQuery.of(context).size.width * .8,
      backgroundColor: AppColors.white,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.only(
              top: 50,
              bottom: 24,
              left: Amount.screenMargin,
              right: Amount.screenMargin,
            ),
            width: double.infinity,
            decoration: const BoxDecoration(
              color: AppColors.primary50,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 35,
                  backgroundColor: AppColors.primary,
                  backgroundImage: CachedNetworkImageProvider(
                    SharedPreferenceUtil.getString(PrefKey.profileImage),
                  ),
                ),
                const HeightBox(12),
                Text(
                  SharedPreferenceUtil.getString(PrefKey.fullName),
                  style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                    color: AppColors.bodyText,
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                  ),
                ),
                Text(
                  SharedPreferenceUtil.getString(PrefKey.email),
                  style: Theme.of(context).textTheme.labelMedium!.copyWith(
                    color: AppColors.subText,
                  ),
                ),
              ],
            ),
          ),

          const HeightBox(Amount.screenMargin),

          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _buildDrawerTile(
                  context: context,
                  titleKey: LangConst.myBookings,
                  icon: CupertinoIcons.briefcase_fill,
                  destination: const MyBookingsScreen(),
                ),
                _buildDrawerTile(
                  context: context,
                  titleKey: LangConst.notification,
                  icon: Icons.notifications,
                  destination: const NotificationScreen(),
                ),
                _buildDrawerTile(
                  context: context,
                  titleKey: LangConst.settings,
                  icon: Icons.settings,
                  destination: const SettingScreen(),
                ),
                _buildDrawerTile(
                  context: context,
                  titleKey: LangConst.privacyPolicy,
                  icon: CupertinoIcons.doc_chart_fill,
                  destination: const PrivacyPolicyScreen(),
                ),
                _buildDrawerTile(
                  context: context,
                  titleKey: LangConst.faq,
                  icon: CupertinoIcons.bubble_left_fill,
                  destination: const FaqScreen(),
                ),
              ],
            ),
          ),

          _buildLogoutTile(context),
        ],
      ),
    );
  }
}