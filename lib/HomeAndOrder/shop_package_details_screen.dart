import 'package:carq_user/HomeAndOrder/provider/home_screen_provider.dart';
import 'package:carq_user/HomeAndOrder/provider/shop_services_provider.dart';
import 'package:carq_user/HomeAndOrder/select_car_screen.dart';
import 'package:carq_user/Localization/localization_constant.dart';
import 'package:carq_user/Theme/colors.dart';
import 'package:carq_user/Theme/theme.dart';
import 'package:carq_user/Widgets/app_bar_back_icon.dart';
import 'package:carq_user/Widgets/constant_widget.dart';
import 'package:carq_user/Widgets/shop_package_widget.dart';
import 'package:carq_user/lang_const.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';

class ShopPackageDetailsScreen extends StatefulWidget {
  final int id;
  final int index;
  final Map<String, dynamic> service;
  final List<String>? serviceName;

  const ShopPackageDetailsScreen(
      {super.key,
      required this.id,
      required this.service,
      this.serviceName,
      required this.index});

  @override
  State<ShopPackageDetailsScreen> createState() =>
      _ShopPackageDetailsScreenState();
}

class _ShopPackageDetailsScreenState extends State<ShopPackageDetailsScreen> {
  late HomeScreenProvider homeScreenProvider;
  late ShopServicesProvider shopServicesProvider;

  @override
  void initState() {
    homeScreenProvider =
        Provider.of<HomeScreenProvider>(context, listen: false);
    shopServicesProvider =
        Provider.of<ShopServicesProvider>(context, listen: false);
    homeScreenProvider.showPackageDetails(widget.id);
    homeScreenProvider.packageLoading = true;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    homeScreenProvider = Provider.of<HomeScreenProvider>(context);
    return ModalProgressHUD(
      inAsyncCall: homeScreenProvider.packageLoading,
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
              Text(getTranslated(context, LangConst.packageDetails).toString()),
        ),
        body: Consumer<HomeScreenProvider>(
          builder: (context, value, child) {
            if (homeScreenProvider.packageData != null &&
                homeScreenProvider.packageLoading == false) {
              return SingleChildScrollView(
                padding: const EdgeInsets.all(Amount.screenMargin),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ShopPackageWidget(
                      package: shopServicesProvider
                          .shopDetails!.packageData![widget.index],
                    ),
                    const HeightBox(8),
                    Text(
                      getTranslated(context, LangConst.description).toString(),
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium!
                          .copyWith(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    Text(
                      homeScreenProvider.packageData!.description!,
                      style: Theme.of(context).textTheme.titleSmall,
                      maxLines: 500,
                    ),
                  ],
                ),
              );
            }
            return const Center(
              child: Text('There is No Data.'),
            );
          },
        ),
        bottomNavigationBar: Container(
          padding: const EdgeInsets.only(
            left: Amount.screenMargin,
            right: Amount.screenMargin,
            bottom: Amount.screenMargin,
          ),
          child: ElevatedButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => SelectCarScreen(
                    service: widget.service,
                    serviceName: widget.serviceName,
                  ),
                ),
              );
            },
            style: AppButtonStyle.filledLarge,
            child: Text(
              getTranslated(context, LangConst.selectCar).toString(),
              style: Theme.of(context).textTheme.labelLarge!.copyWith(
                    color: AppColors.white,
                  ),
            ),
          ),
        ),
      ),
    );
  }
}
