import 'package:carsnexus_user/HomeAndOrder/model/home_screen_response.dart';
import 'package:carsnexus_user/HomeAndOrder/provider/shop_services_provider.dart';
import 'package:carsnexus_user/HomeAndOrder/shop_list_screen.dart';
import 'package:carsnexus_user/Localization/localization_constant.dart';
import 'package:carsnexus_user/Theme/colors.dart';
import 'package:carsnexus_user/Theme/theme.dart';
import 'package:carsnexus_user/Widgets/app_bar_back_icon.dart';
import 'package:carsnexus_user/Widgets/constant_widget.dart';
import 'package:carsnexus_user/lang_const.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ServiceListScreen extends StatefulWidget {
  final List<Services> services;

  const ServiceListScreen({super.key, required this.services});

  @override
  State<ServiceListScreen> createState() => _ServiceListScreenState();
}

class _ServiceListScreenState extends State<ServiceListScreen> {
  late ShopServicesProvider shopServicesProvider;

  @override
  void initState() {
    shopServicesProvider =
        Provider.of<ShopServicesProvider>(context, listen: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    shopServicesProvider = Provider.of<ShopServicesProvider>(context);
    final orientation = MediaQuery.of(context).orientation;
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        leading: const AppBarBack(),
        title: Text(
          getTranslated(context, LangConst.services).toString(),
        ),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.only(
            left: Amount.screenMargin, right: Amount.screenMargin),
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          crossAxisSpacing: 4.0,
          mainAxisSpacing: 4.0,
          childAspectRatio: (orientation == Orientation.portrait) ? 0.7 : 1,
        ),
        itemCount: widget.services.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => ShopListScreen(
                    isBestShop: false,
                    serviceId: shopServicesProvider.services[index].id!,
                  ),
                ),
              );
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: AppColors.primary.withAlpha(50),
                  backgroundImage: NetworkImage(
                    widget.services[index].imageUri!,
                  ),
                ),
                const HeightBox(8),
                Text(
                  widget.services[index].name!,
                  maxLines: 2,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodySmall!.copyWith(
                        color: AppColors.bodyText,
                        fontSize: 14,
                      ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
