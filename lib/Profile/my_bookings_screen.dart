import 'package:carsnexus_user/Localization/localization_constant.dart';
import 'package:carsnexus_user/Profile/providers/profile_provider.dart';
import 'package:carsnexus_user/Theme/colors.dart';
import 'package:carsnexus_user/Theme/theme.dart';
import 'package:carsnexus_user/Widgets/app_bar_back_icon.dart';
import 'package:carsnexus_user/Widgets/booking_items.dart';
import 'package:carsnexus_user/Widgets/constant_widget.dart';
import 'package:carsnexus_user/lang_const.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';

class MyBookingsScreen extends StatefulWidget {
  const MyBookingsScreen({super.key});

  @override
  State<MyBookingsScreen> createState() => _MyBookingsScreenState();
}

class _MyBookingsScreenState extends State<MyBookingsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late ProfileProvider profileProvider;

  @override
  void initState() {
    profileProvider = Provider.of<ProfileProvider>(context, listen: false);
    profileProvider.loadBookings();
    profileProvider.bookingLoading = true;
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    profileProvider = Provider.of<ProfileProvider>(context);
    return DefaultTabController(
      length: 4,
      child: ModalProgressHUD(
        inAsyncCall: profileProvider.bookingLoading,
        opacity: 0.5,
        progressIndicator: const SpinKitPulsingGrid(
          color: AppColors.primary,
          size: 50.0,
        ),
        child: Scaffold(
          backgroundColor: AppColors.white,
          appBar: AppBar(
            leading: const AppBarBack(),
            title:
                Text(getTranslated(context, LangConst.myBookings).toString()),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(40),
              child: SizedBox(
                height: 40,
                child: TabBar(
                  controller: _tabController,
                  dividerColor: Colors.transparent,
                  tabAlignment: TabAlignment.start,
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  isScrollable: true,
                  indicatorPadding: EdgeInsets.zero,
                  tabs: [
                    Tab(
                      text:
                          getTranslated(context, LangConst.pending).toString(),
                    ),
                    Tab(
                      text:
                          getTranslated(context, LangConst.current).toString(),
                    ),
                    Tab(
                      text:
                          getTranslated(context, LangConst.complete).toString(),
                    ),
                    Tab(
                      text: getTranslated(context, LangConst.cancel).toString(),
                    ),
                  ],
                ),
              ),
            ),
          ),
          body: TabBarView(
            controller: _tabController,
            children: [
              ListView.separated(
                itemCount: profileProvider.pendingList.isEmpty
                    ? 0
                    : profileProvider.pendingList.length,
                separatorBuilder: (context, index) => const HeightBox(10),
                shrinkWrap: true,
                padding: const EdgeInsets.all(Amount.screenMargin),
                itemBuilder: (context, index) {
                  if (profileProvider.pendingList.isEmpty) {
                    return const Center(
                      child: Text('There is No Booking.'),
                    );
                  }
                  return BookingItems(
                    status: "pending",
                    data: profileProvider.pendingList[index],
                  );
                },
              ),
              ListView.separated(
                itemCount: profileProvider.currentList.length,
                separatorBuilder: (context, index) => const HeightBox(10),
                shrinkWrap: true,
                padding: const EdgeInsets.all(Amount.screenMargin),
                itemBuilder: (context, index) {
                  return BookingItems(
                    status: "current",
                    data: profileProvider.currentList[index],
                  );
                },
              ),
              ListView.separated(
                itemCount: profileProvider.completeList.length,
                separatorBuilder: (context, index) => const HeightBox(10),
                shrinkWrap: true,
                padding: const EdgeInsets.all(Amount.screenMargin),
                itemBuilder: (context, index) {
                  return BookingItems(
                    status: "Complete",
                    data: profileProvider.completeList[index],
                  );
                },
              ),
              ListView.separated(
                itemCount: profileProvider.cancelList.length,
                separatorBuilder: (context, index) => const HeightBox(10),
                shrinkWrap: true,
                padding: const EdgeInsets.all(Amount.screenMargin),
                itemBuilder: (context, index) {
                  return BookingItems(
                    status: "cancel",
                    data: profileProvider.cancelList[index],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
