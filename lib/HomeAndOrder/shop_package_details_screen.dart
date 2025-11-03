// import 'package:voyzo/HomeAndOrder/provider/home_screen_provider.dart';
// import 'package:voyzo/HomeAndOrder/provider/shop_services_provider.dart';
// import 'package:voyzo/HomeAndOrder/select_car_screen.dart';
// import 'package:voyzo/Localization/localization_constant.dart';
// import 'package:voyzo/Theme/colors.dart';
// import 'package:voyzo/Theme/theme.dart';
// import 'package:voyzo/Widgets/app_bar_back_icon.dart';
// import 'package:voyzo/Widgets/constant_widget.dart';
// import 'package:voyzo/Widgets/shop_package_widget.dart';
// import 'package:voyzo/lang_const.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_spinkit/flutter_spinkit.dart';
// import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
// import 'package:provider/provider.dart';
//
// class ShopPackageDetailsScreen extends StatefulWidget {
//   final int id;
//   final int index;
//   final Map<String, dynamic> service;
//   final List<String>? serviceName;
//
//   const ShopPackageDetailsScreen(
//       {super.key,
//       required this.id,
//       required this.service,
//       this.serviceName,
//       required this.index});
//
//   @override
//   State<ShopPackageDetailsScreen> createState() =>
//       _ShopPackageDetailsScreenState();
// }
//
// class _ShopPackageDetailsScreenState extends State<ShopPackageDetailsScreen> {
//   late HomeScreenProvider homeScreenProvider;
//   late ShopServicesProvider shopServicesProvider;
//
//   @override
//   void initState() {
//     homeScreenProvider =
//         Provider.of<HomeScreenProvider>(context, listen: false);
//     shopServicesProvider =
//         Provider.of<ShopServicesProvider>(context, listen: false);
//     homeScreenProvider.showPackageDetails(widget.id);
//     homeScreenProvider.packageLoading = true;
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     homeScreenProvider = Provider.of<HomeScreenProvider>(context);
//     return ModalProgressHUD(
//       inAsyncCall: homeScreenProvider.packageLoading,
//       opacity: 0.5,
//       progressIndicator: const SpinKitPulsingGrid(
//         color: AppColors.primary,
//         size: 50.0,
//       ),
//       child: Scaffold(
//         backgroundColor: AppColors.white,
//         appBar: AppBar(
//           leading: const AppBarBack(),
//           title:
//               Text(getTranslated(context, LangConst.packageDetails).toString()),
//         ),
//         body: Consumer<HomeScreenProvider>(
//           builder: (context, value, child) {
//             if (homeScreenProvider.packageData != null &&
//                 homeScreenProvider.packageLoading == false) {
//               return SingleChildScrollView(
//                 padding: const EdgeInsets.all(Amount.screenMargin),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     ShopPackageWidget(
//                       package: shopServicesProvider
//                           .shopDetails!.packageData![widget.index],
//                     ),
//                     const HeightBox(8),
//                     Text(
//                       getTranslated(context, LangConst.description).toString(),
//                       style: Theme.of(context)
//                           .textTheme
//                           .titleMedium!
//                           .copyWith(fontWeight: FontWeight.bold, fontSize: 16),
//                     ),
//                     Text(
//                       homeScreenProvider.packageData!.description!,
//                       style: Theme.of(context).textTheme.titleSmall,
//                       maxLines: 500,
//                     ),
//                   ],
//                 ),
//               );
//             }
//             return const Center(
//               child: Text('There is No Data.'),
//             );
//           },
//         ),
//         bottomNavigationBar: Container(
//           padding: const EdgeInsets.only(
//             left: Amount.screenMargin,
//             right: Amount.screenMargin,
//             bottom: Amount.screenMargin,
//           ),
//           child: ElevatedButton(
//             onPressed: () {
//               Navigator.of(context).push(
//                 MaterialPageRoute(
//                   builder: (context) => SelectCarScreen(
//                     service: widget.service,
//                     serviceName: widget.serviceName,
//                   ),
//                 ),
//               );
//             },
//             style: AppButtonStyle.filledLarge,
//             child: Text(
//               getTranslated(context, LangConst.selectCar).toString(),
//               style: Theme.of(context).textTheme.labelLarge!.copyWith(
//                     color: AppColors.white,
//                   ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'package:voyzo/HomeAndOrder/provider/home_screen_provider.dart';
import 'package:voyzo/HomeAndOrder/provider/shop_services_provider.dart';
import 'package:voyzo/HomeAndOrder/select_car_screen.dart';
import 'package:voyzo/Localization/localization_constant.dart';
import 'package:voyzo/Theme/colors.dart';
import 'package:voyzo/Theme/theme.dart';
import 'package:voyzo/Widgets/app_bar_back_icon.dart';
import 'package:voyzo/Widgets/constant_widget.dart';
import 'package:voyzo/Widgets/shop_package_widget.dart';
import 'package:voyzo/lang_const.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart'; // Import Google Fonts

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
        backgroundColor: AppColors.background, // Use background color for body
        appBar: AppBar(
          backgroundColor: AppColors.white, // Use white for the AppBar
          elevation: 1, // Subtle shadow
          leading: const AppBarBack(),
          title: Text(
            getTranslated(context, LangConst.packageDetails).toString(),
            style: GoogleFonts.poppins(
              color: AppColors.accent,
              fontWeight: FontWeight.w500,
              fontSize: 20,
            ),
          ),
          centerTitle: false,
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
                    // NOTE: ShopPackageWidget needs to be updated separately for design consistency
                    ShopPackageWidget(
                      package: shopServicesProvider
                          .shopDetails!.packageData![widget.index],
                    ),
                    const HeightBox(20), // Increased spacing

                    // Description Title
                    Text(
                      getTranslated(context, LangConst.description).toString(),
                      // **Updated: Poppins font, Accent color, Bold**
                      style: GoogleFonts.poppins(
                        color: AppColors.accent,
                        fontWeight: FontWeight.w700,
                        fontSize: 22,
                      ),
                    ),
                    const HeightBox(12),
                    // Description Body
                    Text(
                      homeScreenProvider.packageData!.description!,
                      // **Updated: Poppins font, SubText color, Improved readability**
                      style: GoogleFonts.poppins(
                        color: AppColors.subText,
                        fontSize: 15,
                        height: 1.5, // Increased line height
                      ),
                      maxLines: 500,
                    ),
                    const HeightBox(20),
                  ],
                ),
              );
            }
            return Center(
              child: Text(
                'There is No Data.',
                style: GoogleFonts.poppins(
                  color: AppColors.subText,
                ),
              ),
            );
          },
        ),

        // MARK: - Redesigned Bottom Navigation Bar / Call to Action
        bottomNavigationBar: Container(
          padding: const EdgeInsets.only(
            left: Amount.screenMargin,
            right: Amount.screenMargin,
            bottom: Amount.screenMargin,
            top: 8, // Little space from the body
          ),
          decoration: BoxDecoration(
            color: AppColors.white,
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withOpacity(0.15),
                blurRadius: 10,
                offset: const Offset(0, -5),
              ),
            ],
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
            // **Pill-shaped, bold, full-width button**
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
              minimumSize: Size(
                MediaQuery.of(context).size.width,
                55, // Consistent height with previous screen
              ),
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
            child: Text(
              getTranslated(context, LangConst.selectCar).toString(),
              // **Updated: Poppins font, White color, Extra bold**
              style: GoogleFonts.poppins(
                color: AppColors.white,
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }
}