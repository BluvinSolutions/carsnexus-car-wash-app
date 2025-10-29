import 'package:voyzo/Profile/providers/profile_provider.dart';
import 'package:voyzo/Theme/colors.dart';
import 'package:voyzo/Theme/theme.dart';
import 'package:voyzo/Widgets/app_bar_back_icon.dart';
import 'package:voyzo/Widgets/constant_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';

class FaqScreen extends StatefulWidget {
  const FaqScreen({super.key});

  @override
  State<FaqScreen> createState() => _FaqScreenState();
}

class _FaqScreenState extends State<FaqScreen> {
  late ProfileProvider profileProvider;

  @override
  void initState() {
    Future.delayed(
      Duration.zero,
          () => profileProvider.getFaq(),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    profileProvider = Provider.of<ProfileProvider>(context);
    return ModalProgressHUD(
      inAsyncCall: profileProvider.faqLoading,
      opacity: 0.5,
      progressIndicator: const SpinKitPulsingGrid(
        color: AppColors.primary,
        size: 50.0,
      ),
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.white,
          elevation: 0,
          leading: const AppBarBack(),
          title: Text(
            "FAQ",
            style: Theme.of(context).textTheme.headlineSmall!.copyWith(
              color: AppColors.bodyText,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: ListView.separated(
          itemCount: profileProvider.faqList.length,
          padding: const EdgeInsets.all(Amount.screenMargin),
          separatorBuilder: (context, index) => const HeightBox(10),
          itemBuilder: (context, index) {
            final faqItem = profileProvider.faqList[index];
            return Card(
              elevation: 3,
              margin: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                borderRadius: AppBorderRadius.k12,
              ),
              child: ClipRRect(
                borderRadius: AppBorderRadius.k12,
                child: Theme(
                  data: Theme.of(context).copyWith(
                    dividerColor: AppColors.transparent,
                  ),
                  child: ExpansionTile(
                    tilePadding: const EdgeInsets.symmetric(
                      horizontal: Amount.screenMargin,
                      vertical: 4,
                    ),
                    expandedCrossAxisAlignment: CrossAxisAlignment.start,
                    collapsedIconColor: AppColors.subText,
                    iconColor: AppColors.primary,
                    collapsedBackgroundColor: AppColors.white,
                    backgroundColor: AppColors.white,

                    // Custom builder to change color on expansion
                    title: Builder(
                      builder: (context) {
                        final isExpanded = ExpansionTileController.of(context).isExpanded;
                        return Container(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          decoration: BoxDecoration(
                            color: isExpanded ? AppColors.primary50 : AppColors.white,
                            borderRadius: AppBorderRadius.k08,
                          ),
                          child: Text(
                            faqItem.question!,
                            style: Theme.of(context).textTheme.titleMedium!.copyWith(
                              color: isExpanded ? AppColors.primary : AppColors.bodyText,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        );
                      },
                    ),

                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(
                          left: Amount.screenMargin,
                          right: Amount.screenMargin,
                          bottom: Amount.screenMargin,
                          top: 8,
                        ),
                        child: Text(
                          faqItem.answer!,
                          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            color: AppColors.subText,
                            fontWeight: FontWeight.w400,
                            height: 1.5,
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}