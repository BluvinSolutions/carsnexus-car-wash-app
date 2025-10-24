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
  bool _maxLines = false;

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
        backgroundColor: AppColors.white,
        appBar: AppBar(
          leading: const AppBarBack(),
          title: const Text("FAQ"),
        ),
        body: ListView.separated(
          itemCount: profileProvider.faqList.length,
          padding: const EdgeInsets.all(Amount.screenMargin),
          separatorBuilder: (context, index) => const HeightBox(10),
          itemBuilder: (context, index) {
            return ExpansionTile(
              expandedAlignment: Alignment.centerLeft,
              collapsedIconColor: AppColors.stroke,
              tilePadding: const EdgeInsets.only(
                left: Amount.screenMargin,
                right: Amount.screenMargin,
              ),
              childrenPadding: const EdgeInsets.only(
                left: Amount.screenMargin,
                right: Amount.screenMargin,
                bottom: 10,
              ),
              shape: const RoundedRectangleBorder(
                borderRadius: AppBorderRadius.k08,
                side: BorderSide(
                  color: AppColors.stroke,
                ),
              ),
              collapsedShape: const RoundedRectangleBorder(
                borderRadius: AppBorderRadius.k08,
                side: BorderSide(
                  color: AppColors.stroke,
                ),
              ),
              title: Text(
                profileProvider.faqList[index].question!,
                maxLines: _maxLines ? 5 : 1,
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      color: AppColors.bodyText,
                      fontWeight: FontWeight.w600,
                    ),
              ),
              onExpansionChanged: (value) {
                if (value == true) {
                  setState(
                    () => _maxLines = value,
                  );
                } else {
                  setState(
                    () => _maxLines = false,
                  );
                }
              },
              children: <Widget>[
                Text(
                  profileProvider.faqList[index].answer!,
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        color: AppColors.bodyText,
                        fontWeight: FontWeight.w500,
                      ),
                  maxLines: 50,
                  textAlign: TextAlign.left,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
