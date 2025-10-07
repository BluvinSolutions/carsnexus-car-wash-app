import 'package:carsnexus_user/Localization/localization_constant.dart';
import 'package:carsnexus_user/Profile/providers/profile_provider.dart';
import 'package:carsnexus_user/Theme/colors.dart';
import 'package:carsnexus_user/Theme/theme.dart';
import 'package:carsnexus_user/Widgets/app_bar_back_icon.dart';
import 'package:carsnexus_user/Widgets/constant_widget.dart';
import 'package:carsnexus_user/lang_const.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  late ProfileProvider profileProvider;

  @override
  void initState() {
    profileProvider = Provider.of<ProfileProvider>(context, listen: false);
    profileProvider.getNotifications();
    profileProvider.notificationLoading = true;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    profileProvider = Provider.of<ProfileProvider>(context);

    return ModalProgressHUD(
      inAsyncCall: profileProvider.notificationLoading,
      opacity: 0.5,
      progressIndicator: const SpinKitPulsingGrid(
        color: AppColors.primary,
        size: 50.0,
      ),
      child: Scaffold(
        backgroundColor: AppColors.white,
        appBar: AppBar(
          leading: const AppBarBack(),
          title:
              Text(getTranslated(context, LangConst.notification).toString()),
        ),
        body: profileProvider.notification.isEmpty &&
                profileProvider.notificationLoading == false
            ? const Center(
                child: Text('There Is No Notifications.'),
              )
            : ListView.separated(
                shrinkWrap: true,
                padding: const EdgeInsets.all(Amount.screenMargin),
                itemCount: profileProvider.notification.length,
                separatorBuilder: (context, index) => const Divider(
                  endIndent: 0,
                  indent: 0,
                ),
                itemBuilder: (context, index) => Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      backgroundColor: AppColors.primary.withAlpha(20),
                      child: const Icon(
                        Icons.notifications,
                        color: AppColors.primary,
                      ),
                    ),
                    const WidthBox(12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            profileProvider.notification[index].title!,
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .copyWith(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                          ),
                          const HeightBox(4),
                          Text(
                            profileProvider.notification[index].subTitle!,
                            style: Theme.of(context)
                                .textTheme
                                .labelMedium!
                                .copyWith(
                                  color: AppColors.subText,
                                  fontWeight: FontWeight.w500,
                                ),
                            maxLines: 3,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
