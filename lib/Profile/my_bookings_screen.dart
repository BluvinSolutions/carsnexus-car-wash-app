import 'package:voyzo/Localization/localization_constant.dart';
import 'package:voyzo/Profile/providers/profile_provider.dart';
import 'package:voyzo/Theme/colors.dart';
import 'package:voyzo/Theme/theme.dart';
import 'package:voyzo/Widgets/app_bar_back_icon.dart';
import 'package:voyzo/Widgets/booking_items.dart';
import 'package:voyzo/Widgets/constant_widget.dart';
import 'package:voyzo/lang_const.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

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

  // MARK: - Generic Booking List Builder with Empty State
  Widget _buildBookingList(
      List<dynamic> list, String status, String emptyMessage) {
    if (list.isEmpty && !profileProvider.bookingLoading) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(Amount.screenMargin * 2),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.event_note_rounded,
                size: 60,
                color: Color(0xffCED5E0),
              ),
              const HeightBox(16),
              Text(
                emptyMessage,
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  color: AppColors.subText,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      );
    }
    return ListView.separated(
      itemCount: list.length,
      separatorBuilder: (context, index) => const HeightBox(12), // Increased spacing
      shrinkWrap: true,
      padding: const EdgeInsets.all(Amount.screenMargin),
      itemBuilder: (context, index) {
        // NOTE: BookingItems widget needs to be updated separately for consistency
        return BookingItems(
          status: status,
          data: list[index],
        );
      },
    );
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
          backgroundColor: AppColors.background, // Use background color
          appBar: AppBar(
            backgroundColor: AppColors.white,
            elevation: 1,
            leading: const AppBarBack(),
            title: Text(
              getTranslated(context, LangConst.myBookings).toString(),
              // **Updated: Poppins font, Accent color, Bold**
              style: GoogleFonts.poppins(
                color: AppColors.accent,
                fontWeight: FontWeight.w700,
                fontSize: 20,
              ),
            ),
            centerTitle: false,
            // MARK: - Redesigned TabBar
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(50), // Slightly taller bar
              child: Container(
                color: AppColors.white,
                child: TabBar(
                  controller: _tabController,
                  dividerColor: Colors.transparent,
                  tabAlignment: TabAlignment.start,
                  padding: const EdgeInsets.symmetric(horizontal: Amount.screenMargin), // Consistent screen padding
                  isScrollable: true,
                  indicatorPadding: EdgeInsets.zero,
                  // Custom Indicator Style: Primary colored underline
                  indicator: const UnderlineTabIndicator(
                    borderSide: BorderSide(color: AppColors.primary, width: 3.0),
                    insets: EdgeInsets.symmetric(horizontal: 0.0),
                  ),
                  labelColor: AppColors.primary, // Active tab text color
                  unselectedLabelColor: AppColors.subText, // Inactive tab text color
                  labelStyle: GoogleFonts.poppins(
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                  ),
                  unselectedLabelStyle: GoogleFonts.poppins(
                    fontWeight: FontWeight.w500,
                    fontSize: 15,
                  ),
                  tabs: [
                    Tab(
                      text: getTranslated(context, LangConst.pending).toString(),
                    ),
                    Tab(
                      text: getTranslated(context, LangConst.current).toString(),
                    ),
                    Tab(
                      text: getTranslated(context, LangConst.complete).toString(),
                    ),
                    Tab(
                      text: getTranslated(context, LangConst.cancel).toString(),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // MARK: - TabBarView with Empty State handling
          body: TabBarView(
            controller: _tabController,
            children: [
              _buildBookingList(
                profileProvider.pendingList,
                "pending",
                getTranslated(context, LangConst.noDataFound) ?? 'No pending bookings found.',
              ),
              _buildBookingList(
                profileProvider.currentList,
                "current",
                getTranslated(context, LangConst.noDataFound) ?? 'No current bookings found.',
              ),
              _buildBookingList(
                profileProvider.completeList,
                "Complete",
                getTranslated(context, LangConst.noDataFound) ?? 'No completed bookings found.',
              ),
              _buildBookingList(
                profileProvider.cancelList,
                "cancel",
                getTranslated(context, LangConst.noDataFound) ?? 'No cancelled bookings found.',
              ),
            ],
          ),
        ),
      ),
    );
  }
}