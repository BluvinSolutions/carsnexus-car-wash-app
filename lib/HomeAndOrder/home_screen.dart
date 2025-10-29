import 'package:cached_network_image/cached_network_image.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:voyzo/Constants/keys_values.dart';
import 'package:voyzo/Constants/preference_utility.dart';
import 'package:voyzo/HomeAndOrder/model/home_screen_response.dart';
import 'package:voyzo/HomeAndOrder/provider/shop_services_provider.dart';
import 'package:voyzo/HomeAndOrder/services_lists_screen.dart';
import 'package:voyzo/HomeAndOrder/shop_details_screen.dart';
import 'package:voyzo/HomeAndOrder/shop_list_screen.dart';
import 'package:voyzo/Localization/localization_constant.dart';
import 'package:voyzo/Profile/custom_drawer.dart';
import 'package:voyzo/Profile/providers/profile_provider.dart';
import 'package:voyzo/Theme/colors.dart';
import 'package:voyzo/Theme/theme.dart';
import 'package:voyzo/Widgets/constant_widget.dart';
import 'package:voyzo/Widgets/shop_list_tile_widget.dart';
import 'package:voyzo/lang_const.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  late ShopServicesProvider shopServicesProvider;
  late ProfileProvider profileProvider;

  final popularServiceCenter = ScrollController(keepScrollOffset: true);

  @override
  void initState() {
    shopServicesProvider =
        Provider.of<ShopServicesProvider>(context, listen: false);
    profileProvider = Provider.of<ProfileProvider>(context, listen: false);
    shopServicesProvider.homeScreen();
    shopServicesProvider.homeScreenLoading = true;
    super.initState();
  }

  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    shopServicesProvider = Provider.of<ShopServicesProvider>(
      context,
    );
    profileProvider = Provider.of<ProfileProvider>(
      context,
    );
    final orientation = MediaQuery.of(context).orientation;
    return ModalProgressHUD(
      inAsyncCall: shopServicesProvider.homeScreenLoading,
      opacity: 0.5,
      progressIndicator: const SpinKitPulsingGrid(
        color: AppColors.primary,
        size: 50.0,
      ),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: AppColors.white,
        appBar: AppBar(
          leadingWidth: 65,
          leading: InkWell(
            onTap: () {
              scaffoldKey.currentState!.openDrawer();
            },
            child: Container(
              margin: const EdgeInsetsDirectional.only(
                start: 15,
                top: 2,
                bottom: 2,
              ),
              padding: const EdgeInsetsDirectional.only(
                top: 2,
                bottom: 2,
                start: 5,
              ),
              child: CircleAvatar(
                backgroundImage: CachedNetworkImageProvider(
                  SharedPreferenceUtil.getString(PrefKey.profileImage),
                ),
              ),
            ),
          ),
          title: Text(
            "${getTranslated(context, LangConst.welcomeToApp)}, ${SharedPreferenceUtil.getString(PrefKey.fullName)}!! 👋",
            style: GoogleFonts.roboto(
              fontWeight: FontWeight.w500,
              fontSize: 22,
              color: AppColors.accent,
            ),
            overflow: TextOverflow.ellipsis,
          ),
          centerTitle: false,
        ),
        drawer: const CustomDrawer(),
        body: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          padding: const EdgeInsets.only(bottom: Amount.screenMargin),
          child: Column(
            children: [
              ///search TextField
              Padding(
                padding: const EdgeInsets.only(
                  top: Amount.screenMargin,
                  left: Amount.screenMargin,
                  right: Amount.screenMargin,
                ),
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(30.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 1,
                        blurRadius: 5,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: TextFormField(
                    controller: searchController,
                    onChanged: (value) {
                      shopServicesProvider.onSearchTextChanged(value);
                    },
                    decoration: InputDecoration(
                      prefixIcon: const Icon(
                        Icons.search,
                        color: AppColors.icon,
                      ),
                      labelText: "${getTranslated(
                        context,
                        LangConst.searchFieldLabelText,
                      )}",
                      labelStyle: Theme.of(context).textTheme.bodyLarge,
                      suffixIcon: searchController.text.isNotEmpty
                          ? GestureDetector(
                        onTap: () {
                          setState(() {
                            searchController.clear();
                          });
                        },
                        child: const Icon(Icons.clear),
                      )
                          : const SizedBox(),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                        borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
                      ),
                      contentPadding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
                      filled: true,
                      fillColor: Colors.transparent)
                  ),
                ),
              ),
              const SizedBox(height: 16),

              ///service text
              Padding(
                padding: const EdgeInsets.only(
                  left: Amount.screenMargin,
                  right: Amount.screenMargin,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      getTranslated(context, LangConst.services).toString(),
                      style: GoogleFonts.roboto(
                        color: AppColors.accent,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Directionality(
                      textDirection: TextDirection.rtl,
                      child: TextButton.icon(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => ServiceListScreen(
                                services: shopServicesProvider.services,
                              ),
                            ),
                          );
                        },
                        label: Text(
                          getTranslated(context, LangConst.seeMore).toString(),
                          style:
                          GoogleFonts.inter(
                            color: AppColors.subText,
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        style: ButtonStyle(
                          padding: WidgetStateProperty.all(EdgeInsets.zero),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              ///service List
              GridView.builder(
                padding: const EdgeInsets.only(
                  left: Amount.screenMargin,
                  right: Amount.screenMargin,
                ),
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  crossAxisSpacing: 4.0,
                  mainAxisSpacing: 4.0,
                  childAspectRatio:
                      (orientation == Orientation.portrait) ? 0.7 : 1,
                ),
                itemCount: searchController.text.isNotEmpty &&
                        shopServicesProvider.searchServices.isNotEmpty
                    ? shopServicesProvider.searchServices.length
                    : shopServicesProvider.services.length > 8
                        ? 8
                        : shopServicesProvider.services.length,
                itemBuilder: (context, index) {
                  Services service = searchController.text.isNotEmpty &&
                          shopServicesProvider.searchServices.isNotEmpty
                      ? shopServicesProvider.searchServices[index]
                      : shopServicesProvider.services[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => ShopListScreen(
                            isBestShop: false,
                            serviceId: service.id!,
                          ),
                        ),
                      );
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // CircleAvatar(
                        //   radius: 30,
                        //   backgroundColor: AppColors.primary.withAlpha(50),
                        //   backgroundImage: CachedNetworkImageProvider(
                        //     service.imageUri!,
                        //   ),
                        // ),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10), // for soft corners
                          child: Container(
                            width: 70,
                            height: 70,
                            color: AppColors.primary.withAlpha(50),
                            child: CachedNetworkImage(
                              imageUrl: service.imageUri!,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),

                        const HeightBox(8),
                        Expanded(
                          child: Text(
                            service.name!,
                            maxLines: 2,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.inter(
                              color: AppColors.subText,
                              fontSize: 12,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),

              ///Popular Service Centers text
              searchController.text.isNotEmpty
                  ? const SizedBox()
                  : Padding(
                      padding: const EdgeInsets.only(
                        left: Amount.screenMargin,
                        right: Amount.screenMargin,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            getTranslated(context, LangConst.popularServiceCenters).toString(),
                            style: GoogleFonts.roboto(
                              color: AppColors.accent,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
        ///Popular Service Center
        searchController.text.isNotEmpty
            ? const SizedBox()
            : SizedBox(
          height: 220, // Slightly increased height for the rating row
          child: Align(
            alignment: Alignment.topLeft,
            child: ListView.separated(
              controller: popularServiceCenter,
              separatorBuilder: (context, index) =>
              const WidthBox(15),
              itemCount:
              shopServicesProvider.popularServiceCenter.length,
              keyboardDismissBehavior:
              ScrollViewKeyboardDismissBehavior.onDrag,
              shrinkWrap: true,
              padding: const EdgeInsets.only(
                  left: Amount.screenMargin,
                  top: Amount.screenMargin,
                  right: Amount.screenMargin
              ),
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                PopularServices data = shopServicesProvider
                    .popularServiceCenter[index];
                return InkWell(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => ShopDetailsScreen(
                          id: data.id!,
                        ),
                      ),
                    );
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.7, // Set a specific width for the card
                    margin: const EdgeInsets.only(bottom: 5.0, right: 2.0),
                    decoration: BoxDecoration(
                      borderRadius: AppBorderRadius.k10,
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.4),
                          spreadRadius: 1,
                          blurRadius: 5,
                          offset: const Offset(3, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Image with rounded top corners
                        ClipRRect(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10),
                          ),
                          child: CachedNetworkImage(
                            imageUrl: data.imageUri!,
                            width: double.infinity, // Max width of the container
                            height: 120, // Maintain height
                            fit: BoxFit.cover,
                          ),
                        ),
                        // Text Section
                        Expanded(
                          child: Padding(
                            padding:
                            const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  data.name!,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.roboto(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                ),
                                ),
                                const HeightBox(4),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.star,
                                      color: Colors.amber,
                                      size: 16,
                                    ),
                                    const WidthBox(4),
                                    Text(
                                      data.avgRating ?? 'N/A',
                                      style: GoogleFonts.inter(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                        color: AppColors.subText
                                      ),
                                    ),
                                    // Optional: You can add the review count here if available
                                    // const WidthBox(8),
                                    // Text(
                                    //   '(${data.reviewCount ?? '0'})',
                                    //   style: Theme.of(context).textTheme.bodySmall!.copyWith(
                                    //     color: AppColors.subText,
                                    //   ),
                                    // ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
              ),
              const SizedBox(height: 16),
              ///Best Shops text
              Padding(
                padding: const EdgeInsets.only(
                    left: Amount.screenMargin, right: Amount.screenMargin),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      getTranslated(context, LangConst.bestShops).toString(),
                      style: GoogleFonts.roboto(
                        color: AppColors.accent,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Directionality(
                      textDirection: TextDirection.rtl,
                      child: TextButton.icon(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const ShopListScreen(
                                isBestShop: true,
                              ),
                            ),
                          );
                        },
                        label: Text(
                          getTranslated(context, LangConst.seeMore).toString(),
                          style:
                          GoogleFonts.inter(
                          color: AppColors.subText,
                          fontSize: 14,
                          fontWeight: FontWeight.normal,
                        ),
                        ),
                        style: ButtonStyle(
                          padding: WidgetStateProperty.all(EdgeInsets.zero),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              ///Best Shop List
              // ListView.separated(
              //   separatorBuilder: (context, index) => const HeightBox(15),
              //   itemCount: searchController.text.isNotEmpty &&
              //           shopServicesProvider.searchBestShops.isNotEmpty
              //       ? shopServicesProvider.searchBestShops.length
              //       : shopServicesProvider.bestShops.length > 4
              //           ? 4
              //           : shopServicesProvider.bestShops.length,
              //   shrinkWrap: true,
              //   padding: const EdgeInsets.only(
              //       left: Amount.screenMargin, right: Amount.screenMargin),
              //   physics: const NeverScrollableScrollPhysics(),
              //   itemBuilder: (context, index) {
              //     BestShops data = searchController.text.isNotEmpty &&
              //             shopServicesProvider.searchBestShops.isNotEmpty
              //         ? shopServicesProvider.searchBestShops[index]
              //         : shopServicesProvider.bestShops[index];
              //     return ShopListTileWidget(
              //       items: data,
              //     );
              //   },
              // )
              ListView.separated(
                separatorBuilder: (context, index) => const HeightBox(15),
                itemCount: searchController.text.isNotEmpty &&
                    shopServicesProvider.searchBestShops.isNotEmpty
                    ? shopServicesProvider.searchBestShops.length
                    : shopServicesProvider.bestShops.length > 4
                    ? 4
                    : shopServicesProvider.bestShops.length,
                shrinkWrap: true,
                padding: const EdgeInsets.only(
                    left: Amount.screenMargin, right: Amount.screenMargin),
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  BestShops data = searchController.text.isNotEmpty &&
                      shopServicesProvider.searchBestShops.isNotEmpty
                      ? shopServicesProvider.searchBestShops[index]
                      : shopServicesProvider.bestShops[index];

                  return Container(
                    margin: const EdgeInsets.only(bottom: 8.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 1,
                          blurRadius: 5,
                          offset: const Offset(3, 5),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: ShopListTileWidget(
                        items: data,
                      ),
                    ),
                  );
                },
              )
        ],
          ),
        ),
      ),
    );
  }
}
