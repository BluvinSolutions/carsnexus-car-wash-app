import 'package:voyzo/Localization/localization_constant.dart';
import 'package:voyzo/Profile/models/booking_response.dart';
import 'package:voyzo/Profile/my_booking_details_screen.dart';
import 'package:voyzo/Theme/colors.dart';
import 'package:voyzo/Theme/theme.dart';
import 'package:voyzo/Widgets/constant_widget.dart';
import 'package:voyzo/lang_const.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BookingItems extends StatelessWidget {
  final String status;
  final BookingStatus data;

  const BookingItems({super.key, required this.status, required this.data});

  // Helper to determine status color
  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case "complete":
        return AppColors.complete;
      case "cancel":
        return AppColors.cancel;
      case "pending":
        return AppColors.bodyText;
      case "current":
        return AppColors.primary;
      default:
        return AppColors.bodyText;
    }
  }

  // Helper to determine status text for the header
  String _getStatusText(BuildContext context, String status) {
    switch (status.toLowerCase()) {
      case "complete":
        return getTranslated(context, LangConst.complete) ?? "Completed";
      case "cancel":
        return getTranslated(context, LangConst.cancel) ?? "Cancelled";
      case "pending":
        return getTranslated(context, LangConst.pending) ?? "Pending";
      case "current":
        return getTranslated(context, LangConst.current) ?? "Current";
      default:
        return status;
    }
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = _getStatusColor(status);

    // Fallback for null data, though typically handles by parent screen
    final carRegNumber = data.model?.regNumber ?? (getTranslated(context, LangConst.loading) ?? 'Loading...');

    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) =>
                MyBookingDetailScreen(status: status, data: data),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white, // **Set to White**
          borderRadius: AppBorderRadius.k16,
          border: Border.all(
            color: const Color(0xffCED5E0).withOpacity(0.5), // Subtle border
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.subText.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // MARK: - Status and ID Header
            Container(
              padding: const EdgeInsets.symmetric(horizontal: Amount.screenMargin, vertical: 12),
              decoration: BoxDecoration(
                color: statusColor.withOpacity(0.15), // Light tint of the status color
                borderRadius: const BorderRadius.only(
                  topRight: AppBorderRadius.k16Radius,
                  topLeft: AppBorderRadius.k16Radius,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Status Text (Left)
                  Text(
                    _getStatusText(context, status),
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w700,
                      color: statusColor,
                      fontSize: 16,
                    ),
                  ),
                  // Booking ID (Right)
                  Text(
                    "${getTranslated(context, LangConst.orderId) ?? 'ID'}: ${data.bookingId}",
                    style: GoogleFonts.poppins(
                      color: AppColors.accent,
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            ),

            // Separator between header and content
            const Divider(height: 1, color: Color(0xffCED5E0)),

            // MARK: - Content Body
            Padding(
              padding: const EdgeInsets.all(Amount.screenMargin),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Date Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Car Info
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            getTranslated(context, LangConst.carNumber).toString(),
                            style: GoogleFonts.poppins(
                              color: AppColors.subText,
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            carRegNumber,
                            style: GoogleFonts.poppins(
                              color: AppColors.accent,
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                      // Date Info
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            getTranslated(context, LangConst.date).toString(),
                            style: GoogleFonts.poppins(
                              color: AppColors.subText,
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            "${data.endTime!.day}-${data.endTime!.month}-${data.endTime!.year}",
                            style: GoogleFonts.poppins(
                              color: AppColors.accent,
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  const HeightBox(12),
                  const Divider(height: 1, color: Color(0xffCED5E0)),
                  const HeightBox(12),

                  // Address Section
                  Text(
                    getTranslated(context, LangConst.address).toString(),
                    style: GoogleFonts.poppins(
                      color: AppColors.subText,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const HeightBox(4),
                  Text(
                    '${data.address}',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.poppins(
                      color: AppColors.bodyText,
                      fontWeight: FontWeight.w500,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}