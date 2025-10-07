import 'package:cached_network_image/cached_network_image.dart';
import 'package:carsnexus_user/Constants/keys_values.dart';
import 'package:carsnexus_user/Constants/preference_utility.dart';
import 'package:carsnexus_user/HomeAndOrder/model/home_screen_response.dart';
import 'package:carsnexus_user/HomeAndOrder/provider/shop_services_provider.dart';
import 'package:carsnexus_user/HomeAndOrder/services_lists_screen.dart';
import 'package:carsnexus_user/HomeAndOrder/shop_details_screen.dart';
import 'package:carsnexus_user/HomeAndOrder/shop_list_screen.dart';
import 'package:carsnexus_user/Localization/localization_constant.dart';
import 'package:carsnexus_user/Profile/custom_drawer.dart';
import 'package:carsnexus_user/Profile/providers/profile_provider.dart';
import 'package:carsnexus_user/Theme/colors.dart';
import 'package:carsnexus_user/Theme/theme.dart';
import 'package:carsnexus_user/Widgets/constant_widget.dart';
import 'package:carsnexus_user/Widgets/shop_list_tile_widget.dart';
import 'package:carsnexus_user/lang_const.dart';
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
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                SharedPreferenceUtil.getString(PrefKey.fullName),
                style: Theme.of(context).textTheme.displaySmall!.copyWith(
                      color: AppColors.accent,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              Text(
                getTranslated(context, LangConst.welcomeToApp).toString(),
                style: Theme.of(context).textTheme.bodySmall,
              )
            ],
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
                  ),
                ),
              ),

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
                      style: Theme.of(context).textTheme.displaySmall!.copyWith(
                            color: AppColors.accent,
                            fontSize: 16,
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
                        icon: const Icon(
                          Icons.arrow_back,
                          color: AppColors.primary,
                          size: 20,
                        ),
                        label: Text(
                          getTranslated(context, LangConst.seeMore).toString(),
                          style:
                              Theme.of(context).textTheme.bodyMedium!.copyWith(
                                    color: AppColors.primary,
                                  ),
                        ),
                        style: ButtonStyle(
                          padding: MaterialStateProperty.all(EdgeInsets.zero),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

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
                        CircleAvatar(
                          radius: 30,
                          backgroundColor: AppColors.primary.withAlpha(50),
                          backgroundImage: CachedNetworkImageProvider(
                            service.imageUri!,
                          ),
                        ),
                        const HeightBox(8),
                        Expanded(
                          child: Text(
                            service.name!,
                            maxLines: 2,
                            textAlign: TextAlign.center,
                            style:
                                Theme.of(context).textTheme.bodySmall!.copyWith(
                                      color: AppColors.bodyText,
                                      fontSize: 14,
                                    ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
              const HeightBox(16),

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
                            getTranslated(
                                    context, LangConst.popularServiceCenters)
                                .toString(),
                            style: Theme.of(context)
                                .textTheme
                                .displaySmall!
                                .copyWith(
                                  color: AppColors.accent,
                                  fontSize: 16,
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
                      height: 200,
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
                              right: Amount.screenMargin),
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
                                decoration: BoxDecoration(
                                  borderRadius: AppBorderRadius.k10,
                                  color: AppColors.primary.withAlpha(50),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ClipRRect(
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(10),
                                        topRight: Radius.circular(10),
                                      ),
                                      child: CachedNetworkImage(
                                        imageUrl: data.imageUri!,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.8,
                                        height: 140,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    Expanded(
                                      child: Center(
                                        child: Padding(
                                          padding:
                                              const EdgeInsetsDirectional.only(
                                                  start: 10),
                                          child: Text(
                                            data.name!,
                                            style: Theme.of(context)
                                                .textTheme
                                                .displaySmall!
                                                .copyWith(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                          ),
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

              ///Best Shops text
              Padding(
                padding: const EdgeInsets.only(
                    left: Amount.screenMargin, right: Amount.screenMargin),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      getTranslated(context, LangConst.bestShops).toString(),
                      style: Theme.of(context).textTheme.displaySmall!.copyWith(
                            color: AppColors.accent,
                            fontSize: 16,
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
                        icon: const Icon(
                          Icons.arrow_back,
                          color: AppColors.primary,
                          size: 20,
                        ),
                        label: Text(
                          getTranslated(context, LangConst.seeMore).toString(),
                          style:
                              Theme.of(context).textTheme.bodyMedium!.copyWith(
                                    color: AppColors.primary,
                                  ),
                        ),
                        style: ButtonStyle(
                          padding: MaterialStateProperty.all(EdgeInsets.zero),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

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
                  return ShopListTileWidget(
                    items: data,
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
