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

  final popularServiceCenterController = ScrollController(keepScrollOffset: true);

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

  void navigateToShopDetails(int id) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ShopDetailsScreen(
          id: id,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    shopServicesProvider = Provider.of<ShopServicesProvider>(
      context,
    );
    profileProvider = Provider.of<ProfileProvider>(
      context,
    );
    final orientation = MediaQuery.of(context).orientation;
    final screenWidth = MediaQuery.of(context).size.width;

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
          backgroundColor: AppColors.white,
          elevation: 0,
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
              child: CircleAvatar(
                radius: 25,
                backgroundColor: const Color(0xffCED5E0),
                backgroundImage: CachedNetworkImageProvider(
                  SharedPreferenceUtil.getString(PrefKey.profileImage),
                ),
              ),
            ),
          ),
          title: Text(
            "${getTranslated(context, LangConst.welcomeToApp)}, ${SharedPreferenceUtil.getString(PrefKey.fullName)}!! 👋",
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w600,
              fontSize: 20,
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
            crossAxisAlignment: CrossAxisAlignment.start,
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
                    color: const Color(0xffCED5E0).withOpacity(0.5),
                    borderRadius: BorderRadius.circular(12.0),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withOpacity(0.1),
                        spreadRadius: 0,
                        blurRadius: 10,
                        offset: const Offset(0, 4),
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
                            color: AppColors.primary,
                          ),
                          labelText: "${getTranslated(
                            context,
                            LangConst.searchFieldLabelText,
                          )}",
                          labelStyle: GoogleFonts.poppins(
                              color: AppColors.subText,
                              fontSize: 14,
                              fontWeight: FontWeight.w400),
                          suffixIcon: searchController.text.isNotEmpty
                              ? GestureDetector(
                            onTap: () {
                              setState(() {
                                searchController.clear();
                              });
                            },
                            child: const Icon(Icons.clear, color: AppColors.subText),
                          )
                              : const SizedBox(),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                            borderSide: BorderSide.none,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                            borderSide:
                            const BorderSide(color: AppColors.primary, width: 2),
                          ),
                          contentPadding:
                          const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
                          filled: true,
                          fillColor: Colors.transparent)
                  ),
                ),
              ),
              const SizedBox(height: 24),

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
                      style: GoogleFonts.poppins(
                        color: AppColors.accent,
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Directionality(
                      textDirection: TextDirection.ltr,
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
                        icon: const Icon(Icons.arrow_forward_ios, size: 14, color: AppColors.primary),
                        label: Text(
                          getTranslated(context, LangConst.seeMore).toString(),
                          style: GoogleFonts.poppins(
                            color: AppColors.primary,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
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
                  crossAxisSpacing: 12.0,
                  mainAxisSpacing: 12.0,
                  childAspectRatio:
                  (orientation == Orientation.portrait) ? 0.8 : 1,
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
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(18),
                          child: Container(
                            width: 65,
                            height: 65,
                            color: AppColors.primary.withOpacity(0.1),
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
                            style: GoogleFonts.poppins(
                              color: AppColors.accent.withOpacity(0.8),
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
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
                  top: 24,
                  left: Amount.screenMargin,
                  right: Amount.screenMargin,
                ),
                child: Text(
                  getTranslated(context, LangConst.popularServiceCenters).toString(),
                  style: GoogleFonts.poppins(
                    color: AppColors.accent,
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

              ///Popular Service Center List
              searchController.text.isNotEmpty
                  ? const SizedBox()
                  : SizedBox(
                height: 250,
                child: Align(
                  alignment: Alignment.topLeft,
                  child: ListView.separated(
                    controller: popularServiceCenterController,
                    separatorBuilder: (context, index) => const WidthBox(8),
                    itemCount:
                    shopServicesProvider.popularServiceCenter.length,
                    keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                    shrinkWrap: true,
                    padding: const EdgeInsets.only(
                        left: Amount.screenMargin,
                        top: Amount.screenMargin,
                        right: 8),
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      PopularServices data = shopServicesProvider
                          .popularServiceCenter[index];

                      final double cardWidth = screenWidth - (Amount.screenMargin + 8);

                      return InkWell(
                        onTap: () => navigateToShopDetails(data.id!),
                        child: Container(
                          width: cardWidth,
                          margin: const EdgeInsets.only(bottom: 5.0),
                          decoration: BoxDecoration(
                            borderRadius: AppBorderRadius.k12,
                            color: AppColors.white,
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primary.withOpacity(0.15),
                                spreadRadius: 0,
                                blurRadius: 10,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(12),
                                  topRight: Radius.circular(12),
                                ),
                                child: CachedNetworkImage(
                                  imageUrl: data.imageUri!,
                                  width: double.infinity,
                                  height: 130,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(12.0, 8.0, 12.0, 12.0),
                                child: Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      data.name!,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                        color: AppColors.accent,
                                      ),
                                    ),
                                    const HeightBox(4),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        // Rating
                                        Row(
                                          children: [
                                            const Icon(
                                              Icons.star_rounded,
                                              color: Color(0xFFFFC107),
                                              size: 18,
                                            ),
                                            const WidthBox(4),
                                            Text(
                                              data.avgRating ?? 'N/A',
                                              style: GoogleFonts.poppins(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 14,
                                                  color: AppColors.subText),
                                            ),
                                          ],
                                        ),

                                        // Book Now Button
                                        ElevatedButton(
                                          onPressed: () => navigateToShopDetails(data.id!),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: AppColors.primary,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(30.0),
                                            ),
                                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                            minimumSize: const Size(0, 40),
                                            elevation: 4,
                                          ),
                                          child: Text(
                                            getTranslated(context, LangConst.bookNow).toString(),
                                            style: GoogleFonts.poppins(
                                              color: const Color(0xffCED5E0),
                                              fontWeight: FontWeight.w600,
                                              fontSize: 13,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
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
              const SizedBox(height: 24),

              ///Best Shops text
              Padding(
                padding: const EdgeInsets.only(
                    left: Amount.screenMargin, right: Amount.screenMargin),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      getTranslated(context, LangConst.bestShops).toString(),
                      style: GoogleFonts.poppins(
                        color: AppColors.accent,
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Directionality(
                      textDirection: TextDirection.ltr,
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
                        icon: const Icon(Icons.arrow_forward_ios, size: 14, color: AppColors.primary),
                        label: Text(
                          getTranslated(context, LangConst.seeMore).toString(),
                          style: GoogleFonts.poppins(
                            color: AppColors.primary,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
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
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(12.0),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withOpacity(0.1),
                          spreadRadius: 0,
                          blurRadius: 10,
                          offset: const Offset(0, 4),
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