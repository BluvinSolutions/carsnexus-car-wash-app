import 'package:carsnexus_user/HomeAndOrder/provider/shop_services_provider.dart';
import 'package:carsnexus_user/Localization/localization_constant.dart';
import 'package:carsnexus_user/Theme/colors.dart';
import 'package:carsnexus_user/Theme/theme.dart';
import 'package:carsnexus_user/Widgets/app_bar_back_icon.dart';
import 'package:carsnexus_user/Widgets/constant_widget.dart';
import 'package:carsnexus_user/Widgets/shop_list_tile_widget.dart';
import 'package:carsnexus_user/lang_const.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';

class ShopListScreen extends StatefulWidget {
  final bool isBestShop;
  final int? serviceId;

  const ShopListScreen({
    super.key,
    required this.isBestShop,
    this.serviceId,
  });

  @override
  State<ShopListScreen> createState() => _ShopListScreenState();
}

class _ShopListScreenState extends State<ShopListScreen> {
  late ShopServicesProvider shopServicesProvider;

  @override
  void initState() {
    shopServicesProvider =
        Provider.of<ShopServicesProvider>(context, listen: false);
    if (widget.isBestShop) {
      shopServicesProvider.getListOfShops();
      shopServicesProvider.loading = true;
    } else {
      shopServicesProvider.showService(widget.serviceId!);
      shopServicesProvider.serviceDetailsLoading = true;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    shopServicesProvider = Provider.of<ShopServicesProvider>(context);
    return ModalProgressHUD(
      inAsyncCall: shopServicesProvider.loading ||
          shopServicesProvider.serviceDetailsLoading,
      opacity: 0.5,
      progressIndicator: const SpinKitPulsingGrid(
        color: AppColors.primary,
        size: 50.0,
      ),
      child: Scaffold(
        backgroundColor: AppColors.white,
        appBar: AppBar(
          leading: const AppBarBack(),
          title: Text(
            getTranslated(context, LangConst.bestShops).toString(),
          ),
        ),
        body: ListView.separated(
          separatorBuilder: (context, index) => const HeightBox(15),
          itemCount: widget.isBestShop
              ? shopServicesProvider.shopList.length
              : shopServicesProvider.serviceShopList.length,
          shrinkWrap: true,
          padding: const EdgeInsets.only(
            left: Amount.screenMargin,
            right: Amount.screenMargin,
            top: Amount.screenMargin,
            bottom: Amount.screenMargin,
          ),
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            return ShopListTileWidget(
              items: widget.isBestShop
                  ? shopServicesProvider.shopList[index]
                  : shopServicesProvider.serviceShopList[index],
            );
          },
        ),
      ),
    );
  }
}
