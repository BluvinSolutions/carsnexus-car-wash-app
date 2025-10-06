import 'package:carq_user/HomeAndOrder/model/shop_details_response.dart';
import 'package:carq_user/HomeAndOrder/multiple_service_details_screen.dart';
import 'package:carq_user/HomeAndOrder/provider/home_screen_provider.dart';
import 'package:carq_user/HomeAndOrder/provider/shop_services_provider.dart';
import 'package:carq_user/HomeAndOrder/shop_package_details_screen.dart';
import 'package:carq_user/Localization/localization_constant.dart';
import 'package:carq_user/Theme/colors.dart';
import 'package:carq_user/Theme/theme.dart';
import 'package:carq_user/Widgets/constant_widget.dart';
import 'package:carq_user/Widgets/shop_package_widget.dart';
import 'package:carq_user/lang_const.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';

class ShopDetailsScreen extends StatefulWidget {
  final int id;

  const ShopDetailsScreen({super.key, required this.id});

  @override
  State<ShopDetailsScreen> createState() => _ShopDetailsScreenState();
}

class _ShopDetailsScreenState extends State<ShopDetailsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late ShopServicesProvider shopServicesProvider;

  @override
  void initState() {
    shopServicesProvider =
        Provider.of<ShopServicesProvider>(context, listen: false);
    shopServicesProvider.getShop(widget.id);
    shopServicesProvider.shopLoading = true;
    shopServicesProvider.getShopCount();
    shopServicesProvider.shopCountLoading = true;
    _tabController = TabController(length: 2, vsync: this)
      ..addListener(
        () {
          if (kDebugMode) {
            print("Current Index : " '$_currentIndex');
          }
          setState(() {
            _currentIndex = _tabController.index;
          });
        },
      );
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<ShopServiceData> serviceList = [];
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    shopServicesProvider = Provider.of<ShopServicesProvider>(context);

    return DefaultTabController(
      length: 2,
      child: ModalProgressHUD(
        inAsyncCall: shopServicesProvider.shopLoading,
        opacity: 0.5,
        progressIndicator: const SpinKitPulsingGrid(
          color: AppColors.primary,
          size: 50.0,
        ),
        child: Scaffold(
          backgroundColor: AppColors.white,
          body: Consumer<HomeScreenProvider>(
            builder: (context, value, child) {
              if (shopServicesProvider.shopInfo != null &&
                  shopServicesProvider.shopDetails != null) {
                return Column(
                  children: [
                    ///background image,back button,cars,booking,review
                    Stack(
                      children: [
                        Container(
                          height: 245,
                          padding: const EdgeInsets.only(bottom: 10),
                          decoration: const BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.only(
                              bottomRight: Radius.circular(30),
                              bottomLeft: Radius.circular(30),
                            ),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      getTranslated(context, LangConst.cars)
                                          .toString(),
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelLarge!
                                          .copyWith(
                                            color:
                                                AppColors.white.withAlpha(80),
                                          ),
                                    ),
                                    Text(
                                      '${shopServicesProvider.shopInfo!.vehicle!}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge!
                                          .copyWith(
                                            color: AppColors.white,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      getTranslated(context, LangConst.bookings)
                                          .toString(),
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelLarge!
                                          .copyWith(
                                            color:
                                                AppColors.white.withAlpha(80),
                                          ),
                                    ),
                                    Text(
                                      '${shopServicesProvider.shopInfo!.booking!}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge!
                                          .copyWith(
                                            color: AppColors.white,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      getTranslated(context, LangConst.review)
                                          .toString(),
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelLarge!
                                          .copyWith(
                                            color:
                                                AppColors.white.withAlpha(80),
                                          ),
                                    ),
                                    Text(
                                      '${shopServicesProvider.shopInfo!.review!}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge!
                                          .copyWith(
                                            color: AppColors.white,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          height: 180,
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.only(
                              bottomRight: Radius.circular(30),
                              bottomLeft: Radius.circular(30),
                            ),
                            image: DecorationImage(
                              image: AssetImage(
                                  "assets/app/Dummy/portfolio10.png"),
                              fit: BoxFit.cover,
                            ),
                          ),
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: InkWell(
                              onTap: () {
                                Navigator.of(context).pop();
                              },
                              child: Container(
                                margin: const EdgeInsets.only(
                                  left: Amount.screenMargin,
                                  top: 40,
                                ),
                                padding: const EdgeInsetsDirectional.only(
                                  top: 8,
                                  bottom: 8,
                                  start: 11,
                                  end: 5,
                                ),
                                decoration: BoxDecoration(
                                  border: Border.all(color: AppColors.stroke),
                                  color: AppColors.stroke,
                                  borderRadius: AppBorderRadius.k12,
                                ),
                                child: const Icon(
                                  Icons.arrow_back_ios,
                                  size: 20,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    ///tab bar
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(Amount.screenMargin),
                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(5),
                              decoration: const BoxDecoration(
                                color: AppColors.background,
                                borderRadius: AppBorderRadius.k10,
                              ),
                              child: TabBar(
                                controller: _tabController,
                                labelStyle: Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .copyWith(
                                      color: AppColors.primary,
                                      fontWeight: FontWeight.bold,
                                    ),
                                dividerColor: Colors.transparent,
                                unselectedLabelColor: AppColors.subText,
                                unselectedLabelStyle: Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .copyWith(
                                      color: AppColors.subText,
                                      fontWeight: FontWeight.bold,
                                    ),
                                labelColor: AppColors.primary,
                                indicator: const BoxDecoration(
                                  color: AppColors.white,
                                  borderRadius: AppBorderRadius.k10,
                                ),
                                tabs: [
                                  Tab(
                                    text: getTranslated(
                                            context, LangConst.services)
                                        .toString(),
                                  ),
                                  Tab(
                                    text: getTranslated(
                                            context, LangConst.package)
                                        .toString(),
                                  )
                                ],
                              ),
                            ),
                            Expanded(
                              child: TabBarView(
                                controller: _tabController,
                                children: [
                                  ///service
                                  ListView.separated(
                                    separatorBuilder: (context, index) =>
                                        const HeightBox(8),
                                    itemBuilder: (context, index) {
                                      final shopDetails = shopServicesProvider
                                          .shopDetails!.serviceData!;
                                      return Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.stretch,
                                        children: [
                                          Container(
                                            height: 50,
                                            padding: const EdgeInsets.only(
                                                left: 16, right: 16),
                                            decoration: BoxDecoration(
                                              color: AppColors.primary
                                                  .withAlpha(50),
                                              borderRadius:
                                                  const BorderRadius.only(
                                                topLeft: Radius.circular(16),
                                                topRight: Radius.circular(16),
                                              ),
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  shopDetails[index].name!,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .titleMedium!
                                                      .copyWith(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                ),
                                                Text(
                                                  '${shopDetails[index].currency}${shopDetails[index].price}',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .titleMedium!
                                                      .copyWith(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color:
                                                            AppColors.primary,
                                                      ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(
                                                Amount.screenMargin),
                                            child: Row(
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    "${shopDetails[index].description}",
                                                    maxLines: 8,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .titleSmall!
                                                        .copyWith(
                                                          color:
                                                              AppColors.subText,
                                                        ),
                                                  ),
                                                ),
                                                Checkbox(
                                                  value: shopDetails[index]
                                                      .isSelected,
                                                  onChanged: (value) {
                                                    setState(() {
                                                      shopDetails[index]
                                                          .isSelected = value!;
                                                      if (value == true) {
                                                        serviceList.add(
                                                            shopDetails[index]);
                                                      } else {
                                                        serviceList.removeWhere(
                                                            (element) =>
                                                                element.id ==
                                                                shopDetails[
                                                                        index]
                                                                    .id);
                                                      }
                                                    });
                                                    if (kDebugMode) {
                                                      print(serviceList.length);
                                                    }
                                                  },
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                    itemCount:
                                        shopServicesProvider.shopDetails != null
                                            ? shopServicesProvider.shopDetails!
                                                .serviceData!.length
                                            : 0,
                                  ),

                                  ///packages
                                  ListView.separated(
                                    separatorBuilder: (context, index) =>
                                        const HeightBox(8),
                                    itemCount: shopServicesProvider
                                        .shopDetails!.packageData!.length,
                                    itemBuilder: (context, index) {
                                      if (shopServicesProvider.shopDetails!
                                          .packageData!.isNotEmpty) {
                                        return InkWell(
                                          onTap: () {
                                            final shopId = shopServicesProvider
                                                .shopDetails!.id!;
                                            final ownerId = shopServicesProvider
                                                .shopDetails!.ownerId!;
                                            final length = shopServicesProvider
                                                .shopDetails!
                                                .packageData![index]
                                                .packageServiceData!
                                                .length;
                                            List<int> tempServiceId = [];
                                            List<String> tempServiceName = [];
                                            for (int i = 0; i < length; i++) {
                                              tempServiceId.add(
                                                  shopServicesProvider
                                                      .shopDetails!
                                                      .packageData![index]
                                                      .packageServiceData![i]
                                                      .id!);
                                              tempServiceName.add(
                                                  shopServicesProvider
                                                      .shopDetails!
                                                      .packageData![index]
                                                      .packageServiceData![i]
                                                      .name!);
                                            }
                                            final serviceId = tempServiceId;
                                            final serviceName = tempServiceName;
                                            final amount = shopServicesProvider
                                                .shopDetails!
                                                .packageData![index]
                                                .price!;
                                            final duration =
                                                shopServicesProvider
                                                    .shopDetails!
                                                    .packageData![index]
                                                    .duration!;
                                            final currency =
                                                shopServicesProvider
                                                    .shopDetails!
                                                    .packageData![index]
                                                    .currency!;
                                            Map<String, dynamic> service = {
                                              'shop_id': shopId,
                                              'owner_id': ownerId,
                                              'service': serviceId.join(','),
                                              'isPackage': true,
                                              'amount': amount,
                                              'duration': duration,
                                              'currency': currency,
                                              'length': serviceId.length,
                                            };
                                            Navigator.of(context).push(
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    ShopPackageDetailsScreen(
                                                  id: shopServicesProvider
                                                      .shopDetails!
                                                      .packageData![index]
                                                      .id!,
                                                  service: service,
                                                  serviceName: serviceName,
                                                  index: index,
                                                ),
                                              ),
                                            );
                                          },
                                          child: ShopPackageWidget(
                                            package: shopServicesProvider
                                                .shopDetails!
                                                .packageData![index],
                                          ),
                                        );
                                      }
                                      return Center(
                                        child: Text(
                                          getTranslated(context,
                                                  LangConst.thereIsNoPackages)
                                              .toString(),
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              }
              return const SpinKitPulsingGrid(
                color: AppColors.primary,
                size: 50.0,
              );
            },
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          floatingActionButton: Consumer(
            builder: (context, value, child) {
              if (serviceList.isEmpty || _currentIndex == 1) {
                return const SizedBox.shrink();
              }
              return Padding(
                padding: const EdgeInsets.only(
                    bottom: 0, right: 16.0, left: 16.0, top: 16.0),
                child: ElevatedButton(
                  onPressed: () {
                    final shopId = shopServicesProvider.shopDetails!.id!;
                    final ownerId = shopServicesProvider.shopDetails!.ownerId!;
                    final length = serviceList.length;
                    List<int> tempServiceId = [];
                    List<String> tempServiceName = [];
                    // List<int> tempAmount = [];
                    int tempDuration = 0;
                    int totalAmount = 0;
                    for (int i = 0; i < length; i++) {
                      tempServiceId.add(serviceList[i].id!);
                      tempServiceName.add(serviceList[i].name!);
                      // tempAmount.add(serviceList[i].price!);
                      tempDuration += serviceList[i].duration!;
                      totalAmount += serviceList[i].price!;
                    }
                    final serviceId = tempServiceId;
                    final duration = tempDuration;
                    final currency = shopServicesProvider
                        .shopDetails!.serviceData!.first.currency;

                    Map<String, dynamic> service = {
                      'shop_id': shopId,
                      'owner_id': ownerId,
                      'service': serviceId.join(','),
                      'isPackage': false,
                      'isServicePackage': true,
                      'amount': totalAmount,
                      'duration': duration,
                      'currency': currency,
                      'length': serviceId.length,
                      'serviceName': tempServiceName,
                      'totalAmount': totalAmount,
                    };
                    if (kDebugMode) {
                      print(service);
                    }
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => MultipleServiceDetailsScreen(
                          service: service,
                          shopServiceData: serviceList,
                        ),
                      ),
                    );
                  },
                  style: AppButtonStyle.filledMedium.copyWith(
                    minimumSize: MaterialStatePropertyAll(
                      Size(
                        MediaQuery.of(context).size.width,
                        50,
                      ),
                    ),
                  ),
                  child: Text(
                    'Continue',
                    style: Theme.of(context).textTheme.labelLarge!.copyWith(
                          color: AppColors.white,
                        ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
