import 'package:voyzo/Localization/localization_constant.dart';
import 'package:voyzo/Profile/models/booking_response.dart';
import 'package:voyzo/Profile/my_booking_details_screen.dart';
import 'package:voyzo/Theme/colors.dart';
import 'package:voyzo/Theme/theme.dart';
import 'package:voyzo/Widgets/constant_widget.dart';
import 'package:voyzo/lang_const.dart';
import 'package:flutter/material.dart';

class BookingItems extends StatelessWidget {
  final String status;
  final BookingStatus data;

  const BookingItems({super.key, required this.status, required this.data});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Future.delayed(
          Duration.zero,
          () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) =>
                    MyBookingDetailScreen(status: status, data: data),
              ),
            );
          },
        );
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: AppBorderRadius.k16,
          border: Border.all(
            color: AppColors.stroke,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: status == "pending"
                    ? AppColors.stroke.withAlpha(100)
                    : status == "Complete"
                        ? AppColors.complete.withAlpha(30)
                        : status == "cancel"
                            ? AppColors.cancel.withAlpha(30)
                            : AppColors.current,
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(Amount.screenMargin),
                  topLeft: Radius.circular(Amount.screenMargin),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "${data.bookingId}",
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          fontWeight: FontWeight.bold,
                          color: status == "pending"
                              ? AppColors.bodyText
                              : status == "Complete"
                                  ? AppColors.complete
                                  : status == "cancel"
                                      ? AppColors.cancel
                                      : AppColors.primary,
                        ),
                  ),
                  Text(
                    "${getTranslated(context, LangConst.date).toString()} : ${data.endTime!.day}-${data.endTime!.month}-${data.endTime!.year}",
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: AppColors.bodyText,
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    getTranslated(context, LangConst.carNumber).toString(),
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: AppColors.subText,
                        ),
                  ),
                  Text(
                    data.model == null ? "Loading..." : data.model!.regNumber!,
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: AppColors.bodyText,
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                  const HeightBox(8),
                  Text(
                    getTranslated(context, LangConst.address).toString(),
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: AppColors.subText,
                        ),
                  ),
                  Text(
                    '${data.address}',
                    maxLines: 3,
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: AppColors.bodyText,
                          fontWeight: FontWeight.w500,
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
