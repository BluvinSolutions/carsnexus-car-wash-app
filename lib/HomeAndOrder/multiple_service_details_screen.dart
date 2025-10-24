import 'package:voyzo/HomeAndOrder/model/shop_details_response.dart';
import 'package:voyzo/HomeAndOrder/provider/home_screen_provider.dart';
import 'package:voyzo/HomeAndOrder/select_car_screen.dart';
import 'package:voyzo/Localization/localization_constant.dart';
import 'package:voyzo/Theme/colors.dart';
import 'package:voyzo/Theme/theme.dart';
import 'package:voyzo/Widgets/app_bar_back_icon.dart';
import 'package:voyzo/Widgets/constant_widget.dart';
import 'package:voyzo/lang_const.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MultipleServiceDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> service;
  final List<ShopServiceData> shopServiceData;

  const MultipleServiceDetailsScreen({
    super.key,
    required this.service,
    required this.shopServiceData,
  });

  @override
  State<MultipleServiceDetailsScreen> createState() =>
      _MultipleServiceDetailsScreenState();
}

class _MultipleServiceDetailsScreenState
    extends State<MultipleServiceDetailsScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        leading: const AppBarBack(),
        title:
            Text(getTranslated(context, LangConst.packageDetails).toString()),
      ),
      body: Consumer<HomeScreenProvider>(
        builder: (context, value, child) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(Amount.screenMargin),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: AppBorderRadius.k16,
                        border: Border.all(color: AppColors.stroke),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Container(
                            height: 50,
                            padding: const EdgeInsets.only(left: 16, right: 16),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withAlpha(50),
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(16),
                                topRight: Radius.circular(16),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Selected Services',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium!
                                      .copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                                Text(
                                  '${widget.service['currency']}${widget.service['totalAmount']}',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium!
                                      .copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.primary,
                                      ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(Amount.screenMargin),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ListView.builder(
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: widget.shopServiceData.length,
                                  itemBuilder: (context, index) => Text(
                                    "• ${widget.shopServiceData[index].name!}",
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleSmall!
                                        .copyWith(
                                          color: AppColors.subText,
                                        ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const HeightBox(8),
              ],
            ),
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
            if (kDebugMode) {
              print(widget.service['duration']);
            }
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => SelectCarScreen(
                  service: widget.service,
                  serviceName: widget.service['serviceName'],
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
    );
  }
}
