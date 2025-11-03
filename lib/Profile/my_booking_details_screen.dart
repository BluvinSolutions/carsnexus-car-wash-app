import 'package:voyzo/Localization/localization_constant.dart';
import 'package:voyzo/Profile/models/booking_response.dart';
import 'package:voyzo/Profile/payment_screen.dart';
import 'package:voyzo/Profile/providers/profile_provider.dart';
import 'package:voyzo/Theme/colors.dart';
import 'package:voyzo/Theme/theme.dart';
import 'package:voyzo/Widgets/app_bar_back_icon.dart';
import 'package:voyzo/Widgets/constant_widget.dart';
import 'package:voyzo/lang_const.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';

class MyBookingDetailScreen extends StatefulWidget {
  final String status;
  final BookingStatus data;

  const MyBookingDetailScreen({
    super.key,
    required this.status,
    required this.data,
  });

  @override
  State<MyBookingDetailScreen> createState() => _MyBookingDetailScreenState();
}

class _MyBookingDetailScreenState extends State<MyBookingDetailScreen> {
  late ProfileProvider profileProvider;
  TextEditingController reviewController = TextEditingController();

  @override
  void initState() {
    profileProvider = Provider.of<ProfileProvider>(context, listen: false);
    profileProvider.bookingDetails(widget.data.id!);
    profileProvider.bookingDetailsLoading = true;
    super.initState();
  }

  double value = 0.0;
  int starRating = 0;

  @override
  Widget build(BuildContext context) {
    profileProvider = Provider.of<ProfileProvider>(context);
    return ModalProgressHUD(
      inAsyncCall:
      profileProvider.bookingDetailsLoading || profileProvider.reviewLoader,
      opacity: 0.5,
      progressIndicator: const SpinKitPulsingGrid(
        color: AppColors.primary,
        size: 50.0,
      ),
      child: Scaffold(
        backgroundColor: Colors.grey.shade100,
        appBar: AppBar(
          leading: const AppBarBack(),
          title: Text(
            getTranslated(context, LangConst.bookingDetails).toString(),
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w600,
              fontSize: 18,
            ),
          ),
          backgroundColor: AppColors.white,
          elevation: 1,
        ),
        body: profileProvider.details != null
            ? SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildStatusCard(context),

              const SizedBox(height: 12),
              _sectionTitle(context, LangConst.vehicleType),
              const SizedBox(height: 8),
              _whiteCard(
                child: _vehicleDetails(context),
              ),

              const SizedBox(height: 16),
              _sectionTitle(context, LangConst.bookingDetails),
              const SizedBox(height: 8),
              _whiteCard(
                child: _bookingDetails(context),
              ),

              const SizedBox(height: 16),
              _sectionTitle(context, LangConst.serviceDetails),
              const SizedBox(height: 8),
              _whiteCard(
                child: _serviceDetails(context),
              ),

              const SizedBox(height: 16),
              _paymentSection(context),

              if (widget.status == "Complete" &&
                  profileProvider.details!.review == null)
                _reviewSection(context),
            ],
          ),
        )
            : const Center(child: Text('There is no data')),
      ),
    );
  }

  /// ---------- UI Builders ----------

  Widget _buildStatusCard(BuildContext context) {
    Color bgColor;
    Color textColor;
    String label;

    switch (widget.status) {
      case "pending":
        bgColor = Colors.orange.shade100;
        textColor = Colors.orange.shade800;
        label = "Waiting for approval";
        break;
      case "Complete":
        bgColor = Colors.green.shade100;
        textColor = Colors.green.shade700;
        label = "Completed";
        break;
      case "cancel":
        bgColor = Colors.red.shade100;
        textColor = Colors.red.shade700;
        label = "Cancelled";
        break;
      default:
        bgColor = Colors.blue.shade100;
        textColor = Colors.blue.shade700;
        label = "Approved";
    }

    return _whiteCard(
      child: Row(
        children: [
          Text(
            getTranslated(context, LangConst.status).toString(),
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(30),
            ),
            child: Text(
              label,
              style: GoogleFonts.poppins(
                color: textColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _vehicleDetails(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _labelValue(
          context,
          LangConst.shopName,
          profileProvider.details?.shop?.name ?? "Loading...",
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: _labelValue(
                context,
                LangConst.carModel,
                profileProvider.details?.model?.model?.name ?? "Loading...",
              ),
            ),
            Expanded(
              child: _labelValue(
                context,
                LangConst.regNumber,
                profileProvider.details?.model?.regNumber ?? "Loading...",
              ),
            ),
            Expanded(
              child: _labelValue(
                context,
                LangConst.color,
                profileProvider.details?.model?.color ?? "Loading...",
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _bookingDetails(BuildContext context) {
    final details = profileProvider.details!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _labelValue(context, LangConst.orderId, details.bookingId ?? ""),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: _labelValue(
                context,
                LangConst.date,
                "${details.endTime?.day}-${details.endTime?.month}-${details.endTime?.year}",
              ),
            ),
            Expanded(
              flex: 2,
              child: _labelValue(
                context,
                LangConst.time,
                "${DateFormat('hh:mm a').format(details.startTime!)} - ${DateFormat('hh:mm a').format(details.endTime!)}",
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        _labelValue(context, LangConst.address, details.address ?? ""),
      ],
    );
  }

  Widget _serviceDetails(BuildContext context) {
    final details = profileProvider.details!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _labelValue(
          context,
          LangConst.servicePlace,
          details.serviceType != 0
              ? getTranslated(context, LangConst.atHome).toString()
              : getTranslated(context, LangConst.atShop).toString(),
        ),
        const SizedBox(height: 8),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: _labelValue(
                context,
                LangConst.serviceName,
                details.serviceData!.map((e) => e.name).join(", "),
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    getTranslated(context, LangConst.amount).toString(),
                    style: GoogleFonts.poppins(
                      color: Colors.grey.shade600,
                      fontSize: 13,
                    ),
                  ),
                  Text(
                    '${details.currency}${details.amount!}',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _paymentSection(BuildContext context) {
    final details = profileProvider.details!;
    if (widget.status == "Complete" ||
        widget.status == "pending" ||
        widget.status == "cancel") return const SizedBox.shrink();

    return details.paymentStatus == 0
        ? ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        minimumSize: const Size.fromHeight(50),
      ),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PaymentScreen(
              id: widget.data.id!,
              amount: details.amount!,
            ),
          ),
        );
      },
      child: Text(
        getTranslated(context, LangConst.proceedToPay).toString(),
        style: GoogleFonts.poppins(
          color: Colors.white,
          fontWeight: FontWeight.w600,
          fontSize: 16,
        ),
      ),
    )
        : Center(
      child: Text(
        getTranslated(context, LangConst.paymentDone).toString(),
        style: GoogleFonts.poppins(
          color: Colors.green.shade700,
          fontWeight: FontWeight.w600,
          fontSize: 16,
        ),
      ),
    );
  }

  Widget _reviewSection(BuildContext context) {
    return _whiteCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: RatingBar(
              initialRating: 0,
              minRating: 1,
              allowHalfRating: false,
              itemCount: 5,
              ratingWidget: RatingWidget(
                full: const Icon(Icons.star, color: AppColors.warningMedium),
                half: const Icon(Icons.star, color: AppColors.warningMedium),
                empty:
                Icon(Icons.star_border, color: Colors.grey.shade400),
              ),
              onRatingUpdate: (rating) {
                starRating = ratingConvert(rating);
              },
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: reviewController,
            maxLines: 3,
            style: GoogleFonts.poppins(),
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.grey.shade50,
              hintText: getTranslated(context, LangConst.typeYourReviewHere)
                  .toString(),
              hintStyle: GoogleFonts.poppins(color: Colors.grey.shade600),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(color: AppColors.primary),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(color: AppColors.primary, width: 1.8),
              ),
            ),
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              minimumSize: const Size.fromHeight(50),
            ),
            onPressed: () {
              Map<String, dynamic> body = {
                'shop_id': profileProvider.details!.shopId!,
                'employee_id': profileProvider.details!.employeeId!,
                'booking_id': profileProvider.details!.id!,
                'star': starRating,
                'cmt': reviewController.text,
              };
              profileProvider.review(body);
            },
            child: Text(
              getTranslated(context, LangConst.review).toString(),
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _whiteCard({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _labelValue(BuildContext context, String labelKey, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          getTranslated(context, labelKey).toString(),
          style: GoogleFonts.poppins(
            color: Colors.grey.shade600,
            fontSize: 13,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: GoogleFonts.poppins(
            color: AppColors.bodyText,
            fontWeight: FontWeight.w500,
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Widget _sectionTitle(BuildContext context, String titleKey) {
    return Text(
      getTranslated(context, titleKey).toString(),
      style: GoogleFonts.poppins(
        fontWeight: FontWeight.w600,
        fontSize: 17,
        color: Colors.black87,
      ),
    );
  }

  int ratingConvert(double rating) => rating.round();
}
