// import 'package:voyzo/HomeAndOrder/model/shop_details_response.dart';
// import 'package:voyzo/HomeAndOrder/multiple_service_details_screen.dart';
// import 'package:voyzo/HomeAndOrder/provider/home_screen_provider.dart';
// import 'package:voyzo/HomeAndOrder/provider/shop_services_provider.dart';
// import 'package:voyzo/HomeAndOrder/shop_package_details_screen.dart';
// import 'package:voyzo/Localization/localization_constant.dart';
// import 'package:voyzo/Theme/colors.dart';
// import 'package:voyzo/Theme/theme.dart';
// import 'package:voyzo/Widgets/constant_widget.dart';
// import 'package:voyzo/Widgets/shop_package_widget.dart';
// import 'package:voyzo/lang_const.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_spinkit/flutter_spinkit.dart';
// import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
// import 'package:provider/provider.dart';
// import 'package:google_fonts/google_fonts.dart';
//
// class ShopDetailsScreen extends StatefulWidget {
//   final int id;
//
//   const ShopDetailsScreen({super.key, required this.id});
//
//   @override
//   State<ShopDetailsScreen> createState() => _ShopDetailsScreenState();
// }
//
// class _ShopDetailsScreenState extends State<ShopDetailsScreen>
//     with SingleTickerProviderStateMixin {
//   late TabController _tabController;
//   late ShopServicesProvider shopServicesProvider;
//
//   @override
//   void initState() {
//     shopServicesProvider =
//         Provider.of<ShopServicesProvider>(context, listen: false);
//     shopServicesProvider.getShop(widget.id);
//     shopServicesProvider.shopLoading = true;
//     shopServicesProvider.getShopCount();
//     shopServicesProvider.shopCountLoading = true;
//     _tabController = TabController(length: 2, vsync: this)
//       ..addListener(
//         () {
//           if (kDebugMode) {
//             print("Current Index : " '$_currentIndex');
//           }
//           setState(() {
//             _currentIndex = _tabController.index;
//           });
//         },
//       );
//     super.initState();
//   }
//
//   @override
//   void dispose() {
//     _tabController.dispose();
//     super.dispose();
//   }
//
//   List<ShopServiceData> serviceList = [];
//   int _currentIndex = 0;
//
//   Widget _buildShopStats(ShopServicesProvider provider, BuildContext context) {
//     if (provider.shopInfo == null) return const SizedBox.shrink();
//
//     return Padding(
//       padding: const EdgeInsets.symmetric(
//           horizontal: Amount.screenMargin, vertical: 12),
//       child: Card(
//         elevation: 6,
//         color: AppColors.white,
//         shape: const RoundedRectangleBorder(borderRadius: AppBorderRadius.k12),
//         child: Padding(
//           padding: const EdgeInsets.all(Amount.screenMargin),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceAround,
//             children: [
//               _buildStatItem(
//                   context,
//                   getTranslated(context, LangConst.cars).toString(),
//                   '${provider.shopInfo!.vehicle!}'),
//               _buildStatItem(
//                   context,
//                   getTranslated(context, LangConst.bookings).toString(),
//                   '${provider.shopInfo!.booking!}'),
//               _buildStatItem(
//                   context,
//                   getTranslated(context, LangConst.review).toString(),
//                   '${provider.shopInfo!.review!}'),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildStatItem(BuildContext context, String title, String value) {
//     return Column(
//       children: [
//         Text(
//           value,
//           style: GoogleFonts.roboto(
//               color: AppColors.bodyText,
//               fontSize: 20,
//               fontWeight: FontWeight.w500),
//         ),
//         const HeightBox(4),
//         Text(
//           title,
//           style: GoogleFonts.inter(
//               color: AppColors.subText,
//               fontSize: 10,
//               fontWeight: FontWeight.normal),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildServiceCard(
//       BuildContext context, ShopServiceData shopServiceData) {
//     bool isSelected = shopServiceData.isSelected;
//
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: Amount.screenMargin),
//       child: InkWell(
//         onTap: () {
//           setState(() {
//             shopServiceData.isSelected = !isSelected;
//             if (shopServiceData.isSelected) {
//               serviceList.add(shopServiceData);
//             } else {
//               serviceList
//                   .removeWhere((element) => element.id == shopServiceData.id);
//             }
//           });
//         },
//         borderRadius: AppBorderRadius.k12,
//         child: AnimatedContainer(
//           duration: const Duration(milliseconds: 300),
//           decoration: BoxDecoration(
//             color: AppColors.white,
//             borderRadius: AppBorderRadius.k12,
//             border: Border.all(
//               color: isSelected
//                   ? AppColors.primary
//                   : AppColors.stroke.withOpacity(0.5),
//               width: isSelected ? 2 : 1,
//             ),
//             boxShadow: isSelected
//                 ? [
//                     BoxShadow(
//                       color: AppColors.primary.withOpacity(0.2),
//                       blurRadius: 8,
//                       offset: const Offset(0, 4),
//                     ),
//                   ]
//                 : [
//                     BoxShadow(
//                       color: AppColors.stroke.withOpacity(0.2),
//                       blurRadius: 4,
//                       offset: const Offset(0, 2),
//                     ),
//                   ],
//           ),
//           child: Padding(
//             padding: const EdgeInsets.all(Amount.screenMargin),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Row(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Expanded(
//                       child: Text(
//                         shopServiceData.name!,
//                         style:
//                             Theme.of(context).textTheme.titleMedium!.copyWith(
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                       ),
//                     ),
//                     const WidthBox(8),
//                     Text(
//                       '${shopServiceData.currency}${shopServiceData.price}',
//                       style: Theme.of(context).textTheme.titleMedium!.copyWith(
//                             fontWeight: FontWeight.bold,
//                             color: AppColors.primary,
//                           ),
//                     ),
//                   ],
//                 ),
//                 const HeightBox(8),
//                 Text(
//                   "${shopServiceData.description}",
//                   maxLines: 3,
//                   overflow: TextOverflow.ellipsis,
//                   style: Theme.of(context).textTheme.titleSmall!.copyWith(
//                         color: AppColors.subText,
//                       ),
//                 ),
//                 const HeightBox(8),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Text(
//                       '${shopServiceData.duration} Mins',
//                       style: Theme.of(context).textTheme.labelLarge!.copyWith(
//                             color: AppColors.bodyText,
//                           ),
//                     ),
//                     Icon(
//                       isSelected
//                           ? Icons.check_circle
//                           : Icons.radio_button_unchecked,
//                       color: isSelected ? AppColors.primary : AppColors.subText,
//                       size: 24,
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     shopServicesProvider = Provider.of<ShopServicesProvider>(context);
//
//     return ModalProgressHUD(
//       inAsyncCall: shopServicesProvider.shopLoading,
//       opacity: 0.5,
//       progressIndicator: const SpinKitPulsingGrid(
//         color: AppColors.primary,
//         size: 50.0,
//       ),
//       child: DefaultTabController(
//         length: 2,
//         child: Scaffold(
//           backgroundColor: AppColors.background,
//           body: Consumer<HomeScreenProvider>(
//             builder: (context, value, child) {
//               if (shopServicesProvider.shopInfo != null &&
//                   shopServicesProvider.shopDetails != null) {
//                 return Column(
//                   children: [
//                     Expanded(
//                       child: CustomScrollView(
//                         slivers: [
//                           SliverAppBar(
//                             expandedHeight: 250.0,
//                             pinned: true,
//                             backgroundColor: AppColors.primary,
//                             automaticallyImplyLeading: false,
//                             leading: InkWell(
//                               onTap: () => Navigator.of(context).pop(),
//                               child: Container(
//                                 margin: const EdgeInsets.only(
//                                     left: Amount.screenMargin,
//                                     top: 8,
//                                     bottom: 8),
//                                 padding: const EdgeInsets.all(4),
//                                 decoration: BoxDecoration(
//                                   color: AppColors.white.withOpacity(0.8),
//                                   borderRadius: AppBorderRadius.k12,
//                                 ),
//                                 child: const Icon(
//                                   Icons.arrow_back_ios_new,
//                                   size: 20,
//                                   color: AppColors.bodyText,
//                                 ),
//                               ),
//                             ),
//                             flexibleSpace: FlexibleSpaceBar(
//                               centerTitle: false,
//                               titlePadding: const EdgeInsets.only(
//                                   left: Amount.screenMargin, bottom: 16),
//                               title: Text(
//                                 shopServicesProvider.shopDetails!.name ??
//                                     'Shop Details',
//                                 style: Theme.of(context)
//                                     .textTheme
//                                     .titleLarge!
//                                     .copyWith(
//                                       color: AppColors.white,
//                                       fontWeight: FontWeight.bold,
//                                     ),
//                               ),
//                               background: Image.asset(
//                                 "assets/app/Dummy/portfolio10.png",
//                                 fit: BoxFit.cover,
//                                 color: Colors.black.withOpacity(0.2),
//                                 colorBlendMode: BlendMode.darken,
//                               ),
//                             ),
//                           ),
//
//                           SliverToBoxAdapter(
//                             child:
//                                 _buildShopStats(shopServicesProvider, context),
//                           ),
//
//                           SliverAppBar(
//                             pinned: true,
//                             toolbarHeight: 65,
//                             backgroundColor: AppColors
//                                 .background,
//                             elevation: 0,
//                             automaticallyImplyLeading:
//                                 false,
//                             flexibleSpace: Padding(
//                               padding: const EdgeInsets.symmetric(
//                                   horizontal: Amount.screenMargin, vertical: 8),
//                               child: Container(
//                                 padding: const EdgeInsets.all(5),
//                                 decoration: BoxDecoration(
//                                     color: AppColors.white,
//                                     borderRadius: AppBorderRadius.k12,
//                                     boxShadow: [
//                                       BoxShadow(
//                                         color: Colors.black.withOpacity(0.05),
//                                         blurRadius: 5,
//                                         offset: const Offset(0, 2),
//                                       )
//                                     ]),
//                                 child: TabBar(
//                                   controller: _tabController,
//                                   labelStyle: Theme.of(context)
//                                       .textTheme
//                                       .bodyLarge!
//                                       .copyWith(
//                                         color: AppColors
//                                             .primary,
//                                         fontWeight: FontWeight.bold,
//                                       ),
//                                   dividerColor: Colors.transparent,
//                                   unselectedLabelColor: AppColors.subText,
//                                   unselectedLabelStyle: Theme.of(context)
//                                       .textTheme
//                                       .bodyLarge!
//                                       .copyWith(
//                                         color: AppColors.bodyText,
//                                         fontWeight: FontWeight.bold,
//                                       ),
//                                   labelColor: AppColors.primary,
//                                   indicator: const BoxDecoration(
//                                     color: AppColors.primary50,
//                                     borderRadius: AppBorderRadius.k10,
//                                   ),
//                                   tabs: [
//                                     Tab(
//                                       text: getTranslated(
//                                               context, LangConst.services)
//                                           .toString(),
//                                     ),
//                                     Tab(
//                                       text: getTranslated(
//                                               context, LangConst.package)
//                                           .toString(),
//                                     )
//                                   ],
//                                 ),
//                               ),
//                             ),
//                           ),
//
//                           SliverFillRemaining(
//                             child: TabBarView(
//                               controller: _tabController,
//                               children: [
//                                 // Service List
//                                 ListView.separated(
//                                   padding: const EdgeInsets.only(
//                                       top: 8, bottom: 100),
//                                   separatorBuilder: (context, index) =>
//                                       const HeightBox(8),
//                                   itemBuilder: (context, index) {
//                                     final shopDetails = shopServicesProvider
//                                         .shopDetails!.serviceData!;
//                                     return _buildServiceCard(
//                                         context, shopDetails[index]);
//                                   },
//                                   itemCount:
//                                       shopServicesProvider.shopDetails != null
//                                           ? shopServicesProvider
//                                               .shopDetails!.serviceData!.length
//                                           : 0,
//                                 ),
//
//                                 // Packages List
//                                 ListView.separated(
//                                   padding: const EdgeInsets.only(
//                                       top: 8, bottom: 100),
//                                   separatorBuilder: (context, index) =>
//                                       const HeightBox(8),
//                                   itemCount: shopServicesProvider
//                                       .shopDetails!.packageData!.length,
//                                   itemBuilder: (context, index) {
//                                     final package = shopServicesProvider
//                                         .shopDetails!.packageData![index];
//
//                                     if (shopServicesProvider
//                                         .shopDetails!.packageData!.isNotEmpty) {
//                                       return InkWell(
//                                         onTap: () {
//                                           final shopId = shopServicesProvider
//                                               .shopDetails!.id!;
//                                           final ownerId = shopServicesProvider
//                                               .shopDetails!.ownerId!;
//                                           final length = package
//                                               .packageServiceData!.length;
//                                           List<int> tempServiceId = [];
//                                           List<String> tempServiceName = [];
//                                           for (int i = 0; i < length; i++) {
//                                             tempServiceId.add(package
//                                                 .packageServiceData![i].id!);
//                                             tempServiceName.add(package
//                                                 .packageServiceData![i].name!);
//                                           }
//                                           final serviceId = tempServiceId;
//                                           final serviceName = tempServiceName;
//                                           final amount = package.price!;
//                                           final duration = package.duration!;
//                                           final currency = package.currency!;
//                                           Map<String, dynamic> service = {
//                                             'shop_id': shopId,
//                                             'owner_id': ownerId,
//                                             'service': serviceId.join(','),
//                                             'isPackage': true,
//                                             'amount': amount,
//                                             'duration': duration,
//                                             'currency': currency,
//                                             'length': serviceId.length,
//                                           };
//                                           Navigator.of(context).push(
//                                             MaterialPageRoute(
//                                               builder: (context) =>
//                                                   ShopPackageDetailsScreen(
//                                                 id: package.id!,
//                                                 service: service,
//                                                 serviceName: serviceName,
//                                                 index: index,
//                                               ),
//                                             ),
//                                           );
//                                         },
//                                         child: Padding(
//                                           padding: const EdgeInsets.symmetric(
//                                               horizontal: Amount.screenMargin),
//                                           child: ShopPackageWidget(
//                                               package: package),
//                                         ),
//                                       );
//                                     }
//                                     return Center(
//                                       child: Text(
//                                         getTranslated(context,
//                                                 LangConst.thereIsNoPackages)
//                                             .toString(),
//                                       ),
//                                     );
//                                   },
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//
//
//                     Consumer(
//                       builder: (context, value, child) {
//                         if (serviceList.isEmpty || _currentIndex == 1) {
//                           return const SizedBox.shrink();
//                         }
//                         return Container(
//                           padding: const EdgeInsets.all(Amount.screenMargin),
//                           decoration: BoxDecoration(
//                             color: AppColors.white,
//                             boxShadow: [
//                               BoxShadow(
//                                 color: Colors.black.withOpacity(0.1),
//                                 blurRadius: 10,
//                                 offset: const Offset(0, -5),
//                               ),
//                             ],
//                           ),
//                           child: ElevatedButton(
//                             onPressed: () {
//                               final shopId =
//                                   shopServicesProvider.shopDetails!.id!;
//                               final ownerId =
//                                   shopServicesProvider.shopDetails!.ownerId!;
//                               final length = serviceList.length;
//                               List<int> tempServiceId = [];
//                               List<String> tempServiceName = [];
//                               int tempDuration = 0;
//                               int totalAmount = 0;
//                               for (int i = 0; i < length; i++) {
//                                 tempServiceId.add(serviceList[i].id!);
//                                 tempServiceName.add(serviceList[i].name!);
//                                 tempDuration += serviceList[i].duration!;
//                                 totalAmount += serviceList[i].price!;
//                               }
//                               final serviceId = tempServiceId;
//                               final duration = tempDuration;
//                               final currency = shopServicesProvider
//                                   .shopDetails!.serviceData!.first.currency;
//
//                               Map<String, dynamic> service = {
//                                 'shop_id': shopId,
//                                 'owner_id': ownerId,
//                                 'service': serviceId.join(','),
//                                 'isPackage': false,
//                                 'isServicePackage': true,
//                                 'amount': totalAmount,
//                                 'duration': duration,
//                                 'currency': currency,
//                                 'length': serviceId.length,
//                                 'serviceName': tempServiceName,
//                                 'totalAmount': totalAmount,
//                               };
//                               if (kDebugMode) {
//                                 print(service);
//                               }
//                               Navigator.of(context).push(
//                                 MaterialPageRoute(
//                                   builder: (context) =>
//                                       MultipleServiceDetailsScreen(
//                                     service: service,
//                                     shopServiceData: serviceList,
//                                   ),
//                                 ),
//                               );
//                             },
//                             style: AppButtonStyle.filledMedium.copyWith(
//                               minimumSize: WidgetStatePropertyAll(
//                                 Size(
//                                   MediaQuery.of(context).size.width,
//                                   50,
//                                 ),
//                               ),
//                             ),
//                             child: Text(
//                               'Continue (${serviceList.length} Selected)',
//                               style: Theme.of(context)
//                                   .textTheme
//                                   .labelLarge!
//                                   .copyWith(
//                                     color: AppColors.white,
//                                   ),
//                             ),
//                           ),
//                         );
//                       },
//                     ),
//                   ],
//                 );
//               }
//               return const SpinKitPulsingGrid(
//                 color: AppColors.primary,
//                 size: 50.0,
//               );
//             },
//           ),
//         ),
//       ),
//     );
//   }
// }

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

  // Brand colors (Voyzo style) — used inline so visuals match the image.
  final Color _electricIndigo = const Color(0xFF5F27CD);
  final Color _deepViolet = const Color(0xFF3415F7);
  final Color _aquaMint = const Color(0xFF1DD1A1);
  final Color _whiteSmoke = const Color(0xFFF5F5FA);
  final Color _softGray = const Color(0xFFCED5E0);

  // MARK: - Redesigned UI Elements

  Widget _buildShopStats(ShopServicesProvider provider, BuildContext context) {
    if (provider.shopInfo == null) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: Amount.screenMargin, vertical: 14),
      child: Container(
        decoration: BoxDecoration(
          color: _whiteSmoke,
          borderRadius: AppBorderRadius.k12,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 18,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: Amount.screenMargin, vertical: 18),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem(
                context,
                getTranslated(context, LangConst.cars).toString(),
                '${provider.shopInfo!.vehicle!}',
              ),
              _buildStatItem(
                context,
                getTranslated(context, LangConst.bookings).toString(),
                '${provider.shopInfo!.booking!}',
              ),
              _buildStatItem(
                context,
                getTranslated(context, LangConst.review).toString(),
                '${provider.shopInfo!.review!}',
              ),
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
          style: GoogleFonts.poppins(
            color: _aquaMint,
            fontSize: 20,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.2,
          ),
        ),
        const HeightBox(6),
        Text(
          title,
          style: GoogleFonts.poppins(
            color: AppColors.subText,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
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
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: AppBorderRadius.k12,
            border: Border.all(
              color: isSelected ? _electricIndigo.withOpacity(0.9) : _softGray.withOpacity(0.6),
              width: isSelected ? 2.2 : 1,
            ),
            boxShadow: [
              BoxShadow(
                color: isSelected
                    ? _electricIndigo.withOpacity(0.08)
                    : Colors.black.withOpacity(0.03),
                blurRadius: isSelected ? 18 : 8,
                offset: isSelected ? const Offset(0, 8) : const Offset(0, 4),
              )
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      shopServiceData.name ?? '',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                        color: _deepViolet,
                      ),
                    ),
                  ),
                  const WidthBox(12),
                  Text(
                    '${shopServiceData.currency ?? ''}${shopServiceData.price ?? ''}',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w800,
                      fontSize: 16,
                      color: _electricIndigo,
                    ),
                  ),
                ],
              ),
              const HeightBox(8),
              Text(
                "${shopServiceData.description ?? ''}",
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.poppins(
                  color: AppColors.subText,
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const HeightBox(12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${shopServiceData.duration ?? 0} Mins',
                    style: GoogleFonts.poppins(
                      color: AppColors.bodyText,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Row(
                    children: [
                      Icon(
                        isSelected
                            ? Icons.check_circle_rounded
                            : Icons.radio_button_unchecked,
                        color: isSelected ? _electricIndigo : _softGray.withOpacity(0.9),
                        size: 26,
                      ),
                      const WidthBox(8),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderBackground(BuildContext context) {
    // gradient header that matches brand
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [_electricIndigo, _deepViolet],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: Amount.screenMargin),
          child: Row(
            children: [
              // optional small logo placeholder
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    'V',
                    style: GoogleFonts.poppins(
                      color: Colors.white.withOpacity(0.95),
                      fontWeight: FontWeight.w700,
                      fontSize: 26,
                    ),
                  ),
                ),
              ),
              const WidthBox(12),
              Expanded(
                child: Text(
                  shopServicesProvider.shopDetails!.name ?? 'Shop Details',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    shadows: [
                      Shadow(
                        color: Colors.black.withOpacity(0.2),
                        offset: const Offset(0, 2),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                ),
              ),
            ],
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
          backgroundColor: _whiteSmoke,
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
                            expandedHeight: 240.0,
                            pinned: true,
                            backgroundColor: Colors.transparent,
                            elevation: 0,
                            automaticallyImplyLeading: false,
                            leading: InkWell(
                              onTap: () => Navigator.of(context).pop(),
                              child: Container(
                                margin: const EdgeInsets.only(
                                    left: Amount.screenMargin,
                                    top: 10,
                                    bottom: 10),
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: AppColors.white.withOpacity(0.95),
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.08),
                                      blurRadius: 10,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: const Icon(
                                  Icons.arrow_back_ios_new,
                                  size: 20,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                            flexibleSpace: FlexibleSpaceBar(
                              centerTitle: false,
                              titlePadding: const EdgeInsets.only(
                                  left: Amount.screenMargin,
                                  bottom: 16,
                                  right: Amount.screenMargin),
                              title: Text(
                                shopServicesProvider.shopDetails!.name ??
                                    'Shop Details',
                                style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 18,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                              background: ClipRRect(
                                borderRadius: const BorderRadius.only(
                                  bottomLeft: Radius.circular(24),
                                  bottomRight: Radius.circular(24),
                                ),
                                child: Image.asset(
                                  "assets/app/Dummy/portfolio10.png",
                                  fit: BoxFit.cover,
                                ),
                              )

                            ),
                            shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(24),
                                    bottomRight: Radius.circular(24))),
                          ),

                          SliverToBoxAdapter(
                            child:
                            _buildShopStats(shopServicesProvider, context),
                          ),

                          SliverAppBar(
                            pinned: true,
                            toolbarHeight: 72,
                            backgroundColor: _whiteSmoke,
                            elevation: 0,
                            automaticallyImplyLeading: false,
                            flexibleSpace: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: Amount.screenMargin, vertical: 10),
                              child: Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: AppColors.white,
                                  borderRadius: AppBorderRadius.k12,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.04),
                                      blurRadius: 14,
                                      offset: const Offset(0, 8),
                                    ),
                                  ],
                                ),
                                child: TabBar(
                                  controller: _tabController,
                                  labelStyle: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w700,
                                  ),
                                  dividerColor: Colors.transparent,
                                  unselectedLabelColor: AppColors.subText,
                                  unselectedLabelStyle: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w600,
                                  ),
                                  labelColor: Colors.white,
                                  indicator: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [_electricIndigo, _deepViolet],
                                    ),
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
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),

                          SliverFillRemaining(
                            child: TabBarView(
                              controller: _tabController,
                              children: [
                                // Services List
                                ListView.separated(
                                  padding: const EdgeInsets.only(
                                      top: 12, bottom: 120),
                                  separatorBuilder: (context, index) =>
                                  const HeightBox(16),
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
                                      top: 12, bottom: 120),
                                  separatorBuilder: (context, index) =>
                                  const HeightBox(12),
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
                                          child:
                                          ShopPackageWidget(package: package),
                                        ),
                                      );
                                    }
                                    return Center(
                                      child: Text(
                                        getTranslated(context,
                                            LangConst.thereIsNoPackages)
                                            .toString(),
                                        style: GoogleFonts.poppins(
                                            color: AppColors.subText),
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

                    // Redesigned Floating Continue Button
                    Consumer(
                      builder: (context, value, child) {
                        // Only show the button on the 'Services' tab (_currentIndex == 0) and if services are selected.
                        if (serviceList.isEmpty || _currentIndex == 1) {
                          return const SizedBox.shrink();
                        }

                        // Calculate total amount and duration for display
                        int totalAmount = serviceList.fold(0, (sum, item) => sum + (item.price ?? 0));
                        String? currency = shopServicesProvider.shopDetails!.serviceData!.first.currency;

                        return Container(
                          // Padding only on sides and bottom for a floating effect
                          padding: EdgeInsets.fromLTRB(
                              Amount.screenMargin, 16, Amount.screenMargin,
                              Amount.screenMargin + MediaQuery.of(context).padding.bottom // safe area
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.white, // White background for the safe area/padding
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.12),
                                blurRadius: 18,
                                offset: const Offset(0, -8),
                              ),
                            ],
                          ),
                          child: InkWell(
                            // Use InkWell for the tap and ripple effect
                            onTap: () {
                              // Logic for navigation (as you had it)
                              final shopId = shopServicesProvider.shopDetails!.id!;
                              final ownerId = shopServicesProvider.shopDetails!.ownerId!;
                              final length = serviceList.length;
                              List<int> tempServiceId = [];
                              List<String> tempServiceName = [];
                              int tempDuration = 0;

                              for (int i = 0; i < length; i++) {
                                tempServiceId.add(serviceList[i].id!);
                                tempServiceName.add(serviceList[i].name!);
                                tempDuration += serviceList[i].duration!;
                              }

                              Map<String, dynamic> service = {
                                'shop_id': shopId,
                                'owner_id': ownerId,
                                'service': tempServiceId.join(','),
                                'isPackage': false,
                                'isServicePackage': true,
                                'amount': totalAmount,
                                'duration': tempDuration,
                                'currency': currency,
                                'length': tempServiceId.length,
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
                            borderRadius: BorderRadius.circular(30.0),
                            child: Container(
                              // This Container applies the gradient background and dimensions
                              height: 52, // Explicit height
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [_electricIndigo, _deepViolet],
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                ),
                                borderRadius: BorderRadius.circular(30.0),
                                boxShadow: [
                                  // Enhanced shadow for a lifted effect
                                  BoxShadow(
                                    color: _electricIndigo.withOpacity(0.35),
                                    blurRadius: 15,
                                    offset: const Offset(0, 7),
                                  ),
                                ],
                              ),
                              alignment: Alignment.center,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  // Total amount on the left
                                  Padding(
                                    padding: const EdgeInsets.only(left: 20),
                                    child: Text(
                                      '$currency$totalAmount', // Display total price
                                      style: GoogleFonts.poppins(
                                        color: AppColors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w800, // Extra bold for price
                                      ),
                                    ),
                                  ),
                                  // Main button text and arrow on the right
                                  Expanded(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          'Continue (${serviceList.length} Selected)',
                                          style: GoogleFonts.poppins(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                        const WidthBox(8),
                                        const Icon(
                                          Icons.arrow_forward_rounded,
                                          color: Colors.white,
                                          size: 20,
                                        ),
                                      ],
                                    ),
                                  ),
                                  // Empty space to balance the price on the left
                                  const WidthBox(80),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                );
              }

              return const Center(
                child: SpinKitPulsingGrid(
                  color: AppColors.primary,
                  size: 50.0,
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
