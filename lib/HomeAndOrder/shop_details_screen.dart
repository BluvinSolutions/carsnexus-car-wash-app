import 'package:voyzo/HomeAndOrder/model/shop_details_response.dart';
import 'package:voyzo/HomeAndOrder/multiple_service_details_screen.dart';
import 'package:voyzo/HomeAndOrder/provider/home_screen_provider.dart';
import 'package:voyzo/HomeAndOrder/provider/shop_services_provider.dart';
import 'package:voyzo/HomeAndOrder/shop_package_details_screen.dart';
import 'package:voyzo/Localization/localization_constant.dart';
import 'package:voyzo/Theme/colors.dart';
import 'package:voyzo/Theme/theme.dart';
import 'package:voyzo/Widgets/constant_widget.dart';
import 'package:voyzo/Widgets/shop_package_widget.dart';
import 'package:voyzo/lang_const.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

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

  Widget _buildShopStats(ShopServicesProvider provider, BuildContext context) {
    if (provider.shopInfo == null) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: Amount.screenMargin, vertical: 12),
      child: Card(
        elevation: 6,
        color: AppColors.white,
        shape: const RoundedRectangleBorder(borderRadius: AppBorderRadius.k12),
        child: Padding(
          padding: const EdgeInsets.all(Amount.screenMargin),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem(
                  context,
                  getTranslated(context, LangConst.cars).toString(),
                  '${provider.shopInfo!.vehicle!}'),
              _buildStatItem(
                  context,
                  getTranslated(context, LangConst.bookings).toString(),
                  '${provider.shopInfo!.booking!}'),
              _buildStatItem(
                  context,
                  getTranslated(context, LangConst.review).toString(),
                  '${provider.shopInfo!.review!}'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem(BuildContext context, String title, String value) {
    return Column(
      children: [
        Text(
          value,
          style: GoogleFonts.roboto(
              color: AppColors.bodyText,
              fontSize: 20,
              fontWeight: FontWeight.w500),
        ),
        const HeightBox(4),
        Text(
          title,
          style: GoogleFonts.inter(
              color: AppColors.subText,
              fontSize: 10,
              fontWeight: FontWeight.normal),
        ),
      ],
    );
  }

  Widget _buildServiceCard(
      BuildContext context, ShopServiceData shopServiceData) {
    bool isSelected = shopServiceData.isSelected;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Amount.screenMargin),
      child: InkWell(
        onTap: () {
          setState(() {
            shopServiceData.isSelected = !isSelected;
            if (shopServiceData.isSelected) {
              serviceList.add(shopServiceData);
            } else {
              serviceList
                  .removeWhere((element) => element.id == shopServiceData.id);
            }
          });
        },
        borderRadius: AppBorderRadius.k12,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: AppBorderRadius.k12,
            border: Border.all(
              color: isSelected
                  ? AppColors.primary
                  : AppColors.stroke.withOpacity(0.5),
              width: isSelected ? 2 : 1,
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : [
                    BoxShadow(
                      color: AppColors.stroke.withOpacity(0.2),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(Amount.screenMargin),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        shopServiceData.name!,
                        style:
                            Theme.of(context).textTheme.titleMedium!.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                      ),
                    ),
                    const WidthBox(8),
                    Text(
                      '${shopServiceData.currency}${shopServiceData.price}',
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                    ),
                  ],
                ),
                const HeightBox(8),
                Text(
                  "${shopServiceData.description}",
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleSmall!.copyWith(
                        color: AppColors.subText,
                      ),
                ),
                const HeightBox(8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${shopServiceData.duration} Mins',
                      style: Theme.of(context).textTheme.labelLarge!.copyWith(
                            color: AppColors.bodyText,
                          ),
                    ),
                    Icon(
                      isSelected
                          ? Icons.check_circle
                          : Icons.radio_button_unchecked,
                      color: isSelected ? AppColors.primary : AppColors.subText,
                      size: 24,
                    ),
                  ],
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
    shopServicesProvider = Provider.of<ShopServicesProvider>(context);

    return ModalProgressHUD(
      inAsyncCall: shopServicesProvider.shopLoading,
      opacity: 0.5,
      progressIndicator: const SpinKitPulsingGrid(
        color: AppColors.primary,
        size: 50.0,
      ),
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          backgroundColor: AppColors.background,
          body: Consumer<HomeScreenProvider>(
            builder: (context, value, child) {
              if (shopServicesProvider.shopInfo != null &&
                  shopServicesProvider.shopDetails != null) {
                return Column(
                  children: [
                    Expanded(
                      child: CustomScrollView(
                        slivers: [
                          SliverAppBar(
                            expandedHeight: 250.0,
                            pinned: true,
                            backgroundColor: AppColors.primary,
                            automaticallyImplyLeading: false,
                            leading: InkWell(
                              onTap: () => Navigator.of(context).pop(),
                              child: Container(
                                margin: const EdgeInsets.only(
                                    left: Amount.screenMargin,
                                    top: 8,
                                    bottom: 8),
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: AppColors.white.withOpacity(0.8),
                                  borderRadius: AppBorderRadius.k12,
                                ),
                                child: const Icon(
                                  Icons.arrow_back_ios_new,
                                  size: 20,
                                  color: AppColors.bodyText,
                                ),
                              ),
                            ),
                            flexibleSpace: FlexibleSpaceBar(
                              centerTitle: false,
                              titlePadding: const EdgeInsets.only(
                                  left: Amount.screenMargin, bottom: 16),
                              title: Text(
                                shopServicesProvider.shopDetails!.name ??
                                    'Shop Details',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge!
                                    .copyWith(
                                      color: AppColors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                              background: Image.asset(
                                "assets/app/Dummy/portfolio10.png",
                                fit: BoxFit.cover,
                                color: Colors.black.withOpacity(0.2),
                                colorBlendMode: BlendMode.darken,
                              ),
                            ),
                          ),

                          SliverToBoxAdapter(
                            child:
                                _buildShopStats(shopServicesProvider, context),
                          ),

                          SliverAppBar(
                            pinned: true,
                            toolbarHeight: 65,
                            backgroundColor: AppColors
                                .background,
                            elevation: 0,
                            automaticallyImplyLeading:
                                false,
                            flexibleSpace: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: Amount.screenMargin, vertical: 8),
                              child: Container(
                                padding: const EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                    color: AppColors.white,
                                    borderRadius: AppBorderRadius.k12,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.05),
                                        blurRadius: 5,
                                        offset: const Offset(0, 2),
                                      )
                                    ]),
                                child: TabBar(
                                  controller: _tabController,
                                  labelStyle: Theme.of(context)
                                      .textTheme
                                      .bodyLarge!
                                      .copyWith(
                                        color: AppColors
                                            .primary,
                                        fontWeight: FontWeight.bold,
                                      ),
                                  dividerColor: Colors.transparent,
                                  unselectedLabelColor: AppColors.subText,
                                  unselectedLabelStyle: Theme.of(context)
                                      .textTheme
                                      .bodyLarge!
                                      .copyWith(
                                        color: AppColors.bodyText,
                                        fontWeight: FontWeight.bold,
                                      ),
                                  labelColor: AppColors.primary,
                                  indicator: const BoxDecoration(
                                    color: AppColors.primary50,
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
                            ),
                          ),

                          SliverFillRemaining(
                            child: TabBarView(
                              controller: _tabController,
                              children: [
                                // Service List
                                ListView.separated(
                                  padding: const EdgeInsets.only(
                                      top: 8, bottom: 100),
                                  separatorBuilder: (context, index) =>
                                      const HeightBox(8),
                                  itemBuilder: (context, index) {
                                    final shopDetails = shopServicesProvider
                                        .shopDetails!.serviceData!;
                                    return _buildServiceCard(
                                        context, shopDetails[index]);
                                  },
                                  itemCount:
                                      shopServicesProvider.shopDetails != null
                                          ? shopServicesProvider
                                              .shopDetails!.serviceData!.length
                                          : 0,
                                ),

                                // Packages List
                                ListView.separated(
                                  padding: const EdgeInsets.only(
                                      top: 8, bottom: 100),
                                  separatorBuilder: (context, index) =>
                                      const HeightBox(8),
                                  itemCount: shopServicesProvider
                                      .shopDetails!.packageData!.length,
                                  itemBuilder: (context, index) {
                                    final package = shopServicesProvider
                                        .shopDetails!.packageData![index];

                                    if (shopServicesProvider
                                        .shopDetails!.packageData!.isNotEmpty) {
                                      return InkWell(
                                        onTap: () {
                                          final shopId = shopServicesProvider
                                              .shopDetails!.id!;
                                          final ownerId = shopServicesProvider
                                              .shopDetails!.ownerId!;
                                          final length = package
                                              .packageServiceData!.length;
                                          List<int> tempServiceId = [];
                                          List<String> tempServiceName = [];
                                          for (int i = 0; i < length; i++) {
                                            tempServiceId.add(package
                                                .packageServiceData![i].id!);
                                            tempServiceName.add(package
                                                .packageServiceData![i].name!);
                                          }
                                          final serviceId = tempServiceId;
                                          final serviceName = tempServiceName;
                                          final amount = package.price!;
                                          final duration = package.duration!;
                                          final currency = package.currency!;
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
                                                id: package.id!,
                                                service: service,
                                                serviceName: serviceName,
                                                index: index,
                                              ),
                                            ),
                                          );
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: Amount.screenMargin),
                                          child: ShopPackageWidget(
                                              package: package),
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


                    Consumer(
                      builder: (context, value, child) {
                        if (serviceList.isEmpty || _currentIndex == 1) {
                          return const SizedBox.shrink();
                        }
                        return Container(
                          padding: const EdgeInsets.all(Amount.screenMargin),
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 10,
                                offset: const Offset(0, -5),
                              ),
                            ],
                          ),
                          child: ElevatedButton(
                            onPressed: () {
                              final shopId =
                                  shopServicesProvider.shopDetails!.id!;
                              final ownerId =
                                  shopServicesProvider.shopDetails!.ownerId!;
                              final length = serviceList.length;
                              List<int> tempServiceId = [];
                              List<String> tempServiceName = [];
                              int tempDuration = 0;
                              int totalAmount = 0;
                              for (int i = 0; i < length; i++) {
                                tempServiceId.add(serviceList[i].id!);
                                tempServiceName.add(serviceList[i].name!);
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
                                  builder: (context) =>
                                      MultipleServiceDetailsScreen(
                                    service: service,
                                    shopServiceData: serviceList,
                                  ),
                                ),
                              );
                            },
                            style: AppButtonStyle.filledMedium.copyWith(
                              minimumSize: WidgetStatePropertyAll(
                                Size(
                                  MediaQuery.of(context).size.width,
                                  50,
                                ),
                              ),
                            ),
                            child: Text(
                              'Continue (${serviceList.length} Selected)',
                              style: Theme.of(context)
                                  .textTheme
                                  .labelLarge!
                                  .copyWith(
                                    color: AppColors.white,
                                  ),
                            ),
                          ),
                        );
                      },
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
        ),
      ),
    );
  }
}
