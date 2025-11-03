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
import 'package:google_fonts/google_fonts.dart'; // Import Google Fonts

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({super.key});

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  // MARK: - Updated Drawer Tile Builder
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
      // Consistent radii for all interactive elements
      shape: const RoundedRectangleBorder(borderRadius: AppBorderRadius.k12),
      // Enhanced selected/hover colors
      selectedTileColor: AppColors.primary.withOpacity(0.1),
      tileColor: AppColors.transparent,
      hoverColor: AppColors.primary.withOpacity(0.05),
      leading: Icon(
        icon,
        size: 24, // Slightly larger icon
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
        // **Updated: Poppins font, Stronger weight**
        style: GoogleFonts.poppins(
          fontWeight: FontWeight.w600,
          fontSize: 16,
          color: AppColors.accent,
        ),
      ),
    );
  }

  // MARK: - Updated Logout Tile Builder
  Widget _buildLogoutTile(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Amount.screenMargin, vertical: 16),
      child: Material(
        color: const Color(0xffCED5E0).withOpacity(0.1),
        borderRadius: AppBorderRadius.k12,
        child: InkWell(
          borderRadius: AppBorderRadius.k12,
          onTap: () async {
            return showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  // Consistent background and surface color
                  surfaceTintColor: AppColors.white,
                  backgroundColor: AppColors.white,
                  title: Text(
                    getTranslated(context, LangConst.logout).toString(),
                    style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                        color: AppColors.accent,
                        fontSize: 20
                    ),
                  ),
                  content: Text(
                    getTranslated(
                        context, LangConst.areYouSureToLogoutThisAccount)
                        .toString(),
                    maxLines: 2,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      color: AppColors.bodyText,
                    ),
                  ),
                  actions: [
                    // Cancel Button: secondary style
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xffCED5E0),
                        shape: const RoundedRectangleBorder(borderRadius: AppBorderRadius.k10),
                      ),
                      child: Text(
                        getTranslated(context, LangConst.cancel).toString(),
                        style: GoogleFonts.poppins(
                            color: AppColors.bodyText,
                            fontWeight: FontWeight.w600
                        ),
                      ),
                    ),
                    // Logout Button: destructive primary style
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
                        backgroundColor: const Color(0xffCED5E0),
                        shape: const RoundedRectangleBorder(borderRadius: AppBorderRadius.k10),
                      ),
                      child: Text(
                        getTranslated(context, LangConst.logout).toString(),
                        style: GoogleFonts.poppins(
                            color: AppColors.bodyText,
                            fontWeight: FontWeight.w700
                        ),
                      ),
                    ),
                  ],
                );
              },
            );
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: Amount.screenMargin, vertical: 14), // Increased vertical padding
            child: Row(
              children: [
                const Icon(
                  Icons.logout_outlined,
                  size: 24,
                  color: AppColors.primary,
                ),
                const WidthBox(16),
                Text(
                  getTranslated(context, LangConst.logout).toString(),
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                    color: AppColors.bodyText,
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
          // MARK: - Redesigned Drawer Header
          Container(
            padding: const EdgeInsets.only(
              top: 60, // Increased top padding for status bar space
              bottom: 24,
              left: Amount.screenMargin,
              right: Amount.screenMargin,
            ),
            width: double.infinity,
            decoration: const BoxDecoration(
              // Using Primary color tint for a strong brand statement
                color: AppColors.primary50,
                // Added subtle bottom shadow for visual lift
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary50,
                    offset: Offset(0, 4),
                    blurRadius: 4,
                  )
                ]
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Profile Image with primary border/fallback
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.primary, width: 3),
                  ),
                  child: CircleAvatar(
                    radius: 38, // Slightly larger avatar
                    backgroundColor: AppColors.white,
                    backgroundImage: CachedNetworkImageProvider(
                      SharedPreferenceUtil.getString(PrefKey.profileImage),
                    ),
                    child: SharedPreferenceUtil.getString(PrefKey.profileImage).isEmpty
                        ? Icon(Icons.person, size: 40, color: AppColors.primary) // Fallback icon
                        : null,
                  ),
                ),
                const HeightBox(16), // Increased spacing
                Text(
                  SharedPreferenceUtil.getString(PrefKey.fullName),
                  // **Updated: Poppins font, Accent color, Extra bold**
                  style: GoogleFonts.poppins(
                    color: AppColors.accent,
                    fontWeight: FontWeight.w800,
                    fontSize: 24,
                  ),
                ),
                const HeightBox(2),
                Text(
                  SharedPreferenceUtil.getString(PrefKey.email),
                  // **Updated: Poppins font, Subtext color**
                  style: GoogleFonts.poppins(
                    color: AppColors.subText,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),

          const HeightBox(Amount.screenMargin),

          // MARK: - Navigation List
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
                  icon: Icons.notifications_active_rounded,
                  destination: const NotificationScreen(),
                ),
                _buildDrawerTile(
                  context: context,
                  titleKey: LangConst.settings,
                  icon: Icons.settings_rounded,
                  destination: const SettingScreen(),
                ),
                // Separator before policy/FAQ for logical grouping
                const Divider(height: 1, indent: Amount.screenMargin, endIndent: Amount.screenMargin, color: const Color(0xffCED5E0)),
                _buildDrawerTile(
                  context: context,
                  titleKey: LangConst.privacyPolicy,
                  icon: Icons.policy_rounded,
                  destination: const PrivacyPolicyScreen(),
                ),
                _buildDrawerTile(
                  context: context,
                  titleKey: LangConst.faq,
                  icon: Icons.help_center_rounded,
                  destination: const FaqScreen(),
                ),
              ],
            ),
          ),

          // MARK: - Logout Section
          _buildLogoutTile(context),
        ],
      ),
    );
  }
}