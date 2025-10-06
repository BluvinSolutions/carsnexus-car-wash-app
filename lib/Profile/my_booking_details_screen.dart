import 'package:carq_user/Localization/localization_constant.dart';
import 'package:carq_user/Profile/models/booking_response.dart';
import 'package:carq_user/Profile/payment_screen.dart';
import 'package:carq_user/Profile/providers/profile_provider.dart';
import 'package:carq_user/Theme/colors.dart';
import 'package:carq_user/Theme/theme.dart';
import 'package:carq_user/Widgets/app_bar_back_icon.dart';
import 'package:carq_user/Widgets/constant_widget.dart';
import 'package:carq_user/lang_const.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';

class MyBookingDetailScreen extends StatefulWidget {
  final String status;
  final BookingStatus data;

  const MyBookingDetailScreen(
      {super.key, required this.status, required this.data});

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
        backgroundColor: AppColors.white,
        appBar: AppBar(
          leading: const AppBarBack(),
          title:
              Text(getTranslated(context, LangConst.bookingDetails).toString()),
        ),
        body: profileProvider.details != null
            ? SingleChildScrollView(
                padding: const EdgeInsets.all(Amount.screenMargin),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ///order status
                    Row(
                      children: [
                        Text(
                          getTranslated(context, LangConst.status).toString(),
                          style:
                              Theme.of(context).textTheme.titleMedium!.copyWith(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                        ),
                        const WidthBox(8),
                        Container(
                          padding: const EdgeInsets.only(
                              left: 16, right: 16, top: 10, bottom: 10),
                          decoration: BoxDecoration(
                            color: widget.status == "pending"
                                ? AppColors.stroke.withAlpha(100)
                                : widget.status == "Complete"
                                    ? AppColors.complete.withAlpha(30)
                                    : widget.status == "cancel"
                                        ? AppColors.cancel.withAlpha(30)
                                        : AppColors.current,
                            borderRadius: AppBorderRadius.k08,
                          ),
                          child: Text(
                            widget.status == "pending"
                                ? "Waiting for approval"
                                : widget.status == "Complete"
                                    ? "Completed"
                                    : widget.status == "cancel"
                                        ? "Cancelled"
                                        : "Approved",
                            style: Theme.of(context)
                                .textTheme
                                .labelLarge!
                                .copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: widget.status == "pending"
                                      ? AppColors.bodyText
                                      : widget.status == "Complete"
                                          ? AppColors.complete
                                          : widget.status == "cancel"
                                              ? AppColors.cancel
                                              : AppColors.primary,
                                ),
                          ),
                        ),
                      ],
                    ),
                    const HeightBox(8),

                    ///vehicle type
                    Text(
                      getTranslated(context, LangConst.vehicleType).toString(),
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                    ),
                    const HeightBox(8),

                    Container(
                      padding: const EdgeInsets.all(Amount.screenMargin),
                      decoration: BoxDecoration(
                        borderRadius: AppBorderRadius.k16,
                        border: Border.all(
                          color: AppColors.stroke,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            getTranslated(context, LangConst.shopName)
                                .toString(),
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                  color: AppColors.subText,
                                ),
                          ),
                          Consumer<ProfileProvider>(
                            builder: (context, value, child) {
                              if (context.watch<ProfileProvider>().details ==
                                  null) {
                                return const Text("Loading...");
                              }
                              return Text(
                                "${profileProvider.details!.shop!.name}",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(
                                      color: AppColors.bodyText,
                                      fontWeight: FontWeight.w500,
                                    ),
                              );
                            },
                          ),
                          const HeightBox(8),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      getTranslated(context, LangConst.carModel)
                                          .toString(),
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium!
                                          .copyWith(
                                            color: AppColors.subText,
                                          ),
                                    ),
                                    Consumer<ProfileProvider>(
                                      builder: (context, value, child) {
                                        if (context
                                                .watch<ProfileProvider>()
                                                .details ==
                                            null) {
                                          return const Text("Loading...");
                                        }
                                        return Text(
                                          profileProvider
                                              .details!.model!.model!.name!,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium!
                                              .copyWith(
                                                color: AppColors.bodyText,
                                                fontWeight: FontWeight.w500,
                                              ),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      getTranslated(
                                              context, LangConst.regNumber)
                                          .toString(),
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium!
                                          .copyWith(
                                            color: AppColors.subText,
                                          ),
                                    ),
                                    Consumer<ProfileProvider>(
                                      builder: (context, value, child) {
                                        if (context
                                                .watch<ProfileProvider>()
                                                .details ==
                                            null) {
                                          return const Text("Loading...");
                                        }
                                        return Text(
                                          "${profileProvider.details!.model!.regNumber}",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium!
                                              .copyWith(
                                                color: AppColors.bodyText,
                                                fontWeight: FontWeight.w500,
                                              ),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      getTranslated(context, LangConst.color)
                                          .toString(),
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium!
                                          .copyWith(
                                            color: AppColors.subText,
                                          ),
                                    ),
                                    Consumer<ProfileProvider>(
                                      builder: (context, value, child) {
                                        if (context
                                                .watch<ProfileProvider>()
                                                .details ==
                                            null) {
                                          return const Text("Loading...");
                                        }
                                        return Text(
                                          "${profileProvider.details!.model!.color}",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium!
                                              .copyWith(
                                                color: AppColors.bodyText,
                                                fontWeight: FontWeight.w500,
                                              ),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const HeightBox(10),

                    ///booking details
                    Text(
                      getTranslated(context, LangConst.bookingDetails)
                          .toString(),
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                    ),
                    const HeightBox(8),

                    Container(
                      padding: const EdgeInsets.all(Amount.screenMargin),
                      decoration: BoxDecoration(
                        borderRadius: AppBorderRadius.k16,
                        border: Border.all(
                          color: AppColors.stroke,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            getTranslated(context, LangConst.orderId)
                                .toString(),
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                  color: AppColors.subText,
                                ),
                          ),
                          Consumer(
                            builder: (context, value, child) {
                              if (context.watch<ProfileProvider>().details ==
                                  null) {
                                return const Text("Loading...");
                              }
                              return Text(
                                "${profileProvider.details!.bookingId}",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(
                                      color: AppColors.bodyText,
                                      fontWeight: FontWeight.w500,
                                    ),
                              );
                            },
                          ),
                          const HeightBox(8),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      getTranslated(context, LangConst.date)
                                          .toString(),
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium!
                                          .copyWith(
                                            color: AppColors.subText,
                                          ),
                                    ),
                                    Consumer<ProfileProvider>(
                                      builder: (context, value, child) {
                                        if (context
                                                .watch<ProfileProvider>()
                                                .details ==
                                            null) {
                                          return const Text("Loading...");
                                        }
                                        return Text(
                                          "${profileProvider.details!.endTime!.day}-${profileProvider.details!.endTime!.month}-${profileProvider.details!.endTime!.year}",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium!
                                              .copyWith(
                                                color: AppColors.bodyText,
                                                fontWeight: FontWeight.w500,
                                              ),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      getTranslated(context, LangConst.time)
                                          .toString(),
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium!
                                          .copyWith(
                                            color: AppColors.subText,
                                          ),
                                    ),
                                    Consumer<ProfileProvider>(
                                      builder: (context, value, child) {
                                        if (context
                                                .watch<ProfileProvider>()
                                                .details ==
                                            null) {
                                          return const Text("Loading...");
                                        }
                                        return Text(
                                          "${DateFormat('hh:mm a').format(profileProvider.details!.startTime!)} to ${DateFormat('hh:mm a').format(profileProvider.details!.endTime!)}",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium!
                                              .copyWith(
                                                color: AppColors.bodyText,
                                                fontWeight: FontWeight.w500,
                                              ),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const HeightBox(8),
                          Text(
                            getTranslated(context, LangConst.address)
                                .toString(),
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                  color: AppColors.subText,
                                ),
                          ),
                          Consumer<ProfileProvider>(
                            builder: (context, value, child) {
                              if (context.watch<ProfileProvider>().details ==
                                  null) {
                                return const Text("Loading...");
                              }
                              return Text(
                                profileProvider.details!.address!,
                                maxLines: 3,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(
                                      color: AppColors.bodyText,
                                      fontWeight: FontWeight.w500,
                                    ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    const HeightBox(10),

                    ///Service Details
                    Text(
                      getTranslated(context, LangConst.serviceDetails)
                          .toString(),
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                    ),
                    const HeightBox(8),

                    Container(
                      padding: const EdgeInsets.all(Amount.screenMargin),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: AppBorderRadius.k16,
                        border: Border.all(
                          color: AppColors.stroke,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            getTranslated(context, LangConst.servicePlace)
                                .toString(),
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                  color: AppColors.subText,
                                ),
                          ),
                          Consumer<ProfileProvider>(
                            builder: (context, value, child) {
                              if (context.watch<ProfileProvider>().details ==
                                  null) {
                                return const Text("Loading...");
                              }
                              return Text(
                                profileProvider.details!.serviceType != 0
                                    ? getTranslated(context, LangConst.atHome)
                                        .toString()
                                    : getTranslated(context, LangConst.atShop)
                                        .toString(),
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(
                                      color: AppColors.bodyText,
                                      fontWeight: FontWeight.w500,
                                    ),
                              );
                            },
                          ),
                          const HeightBox(8),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      getTranslated(
                                              context, LangConst.serviceName)
                                          .toString(),
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium!
                                          .copyWith(
                                            color: AppColors.subText,
                                          ),
                                    ),
                                    profileProvider
                                                .details!.serviceData!.length >
                                            1
                                        ? ListView.builder(
                                            itemCount: profileProvider
                                                .details!.serviceData!.length,
                                            shrinkWrap: true,
                                            itemBuilder: (context, index) =>
                                                Text(
                                              "${profileProvider.details!.serviceData![index].name}",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyMedium!
                                                  .copyWith(
                                                    color: AppColors.bodyText,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                            ),
                                          )
                                        : Consumer<ProfileProvider>(
                                            builder: (context, value, child) {
                                              if (context
                                                      .watch<ProfileProvider>()
                                                      .details ==
                                                  null) {
                                                return const Text("Loading...");
                                              }
                                              return Text(
                                                "${profileProvider.details!.serviceData!.first.name}",
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyMedium!
                                                    .copyWith(
                                                      color: AppColors.bodyText,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                              );
                                            },
                                          ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      getTranslated(context, LangConst.amount)
                                          .toString(),
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium!
                                          .copyWith(
                                            color: AppColors.subText,
                                          ),
                                    ),
                                    Consumer<ProfileProvider>(
                                      builder: (context, value, child) {
                                        if (context
                                                .watch<ProfileProvider>()
                                                .details ==
                                            null) {
                                          return const Text("Loading...");
                                        }
                                        return Text(
                                          '${profileProvider.details!.currency}${profileProvider.details!.amount!}',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium!
                                              .copyWith(
                                                color: AppColors.primary,
                                                fontWeight: FontWeight.bold,
                                              ),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const HeightBox(8),

                    widget.status == "Complete" ||
                            widget.status == "pending" ||
                            widget.status == "cancel"
                        ? const SizedBox.shrink()
                        : Row(
                            children: [
                              profileProvider.details!.paymentStatus == 0
                                  ? Expanded(
                                      child: ElevatedButton(
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  PaymentScreen(
                                                id: widget.data.id!,
                                                amount: profileProvider
                                                    .details!.amount!,
                                              ),
                                            ),
                                          );
                                        },
                                        child: Text(
                                          getTranslated(context,
                                                  LangConst.proceedToPay)
                                              .toString(),
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    )
                                  : Container(
                                      padding: EdgeInsets.symmetric(
                                        vertical: 10,
                                        horizontal:
                                            MediaQuery.sizeOf(context).width *
                                                0.19,
                                      ),
                                      child: Text(
                                        getTranslated(
                                                context, LangConst.paymentDone)
                                            .toString(),
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.green.shade600,
                                        ),
                                      ),
                                    ),
                            ],
                          ),
                    widget.status == "Complete" &&
                            profileProvider.details!.review == null
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Center(
                                child: RatingBar(
                                  initialRating: 0,
                                  minRating: 1,
                                  direction: Axis.horizontal,
                                  allowHalfRating: false,
                                  itemCount: 5,
                                  itemPadding: const EdgeInsets.symmetric(
                                      horizontal: 4.0),
                                  ratingWidget: RatingWidget(
                                    full: const Icon(Icons.star,
                                        color: AppColors.warningMedium),
                                    half: const Icon(Icons.star,
                                        color: AppColors.warningMedium),
                                    empty: Icon(Icons.star_border,
                                        color: Colors.grey.shade500),
                                  ),
                                  onRatingUpdate: (rating) {
                                    if (kDebugMode) {
                                      print('Star Rating : $starRating');
                                      print(rating);
                                      print('Star Rating : $starRating');
                                    }
                                    starRating = ratingConvert(rating);
                                  },
                                ),
                              ),
                              const HeightBox(8),
                              TextField(
                                controller: reviewController,
                                maxLines: 3,
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.white,
                                  hintText: getTranslated(
                                          context, LangConst.typeYourReviewHere)
                                      .toString(),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(14),
                                    borderSide: const BorderSide(
                                      color: AppColors.primary,
                                      width: 2,
                                      style: BorderStyle.solid,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(14),
                                    borderSide: const BorderSide(
                                      color: AppColors.primary,
                                      width: 2,
                                      style: BorderStyle.solid,
                                    ),
                                  ),
                                ),
                              ),
                              const HeightBox(8),
                              ElevatedButton(
                                onPressed: () {
                                  Map<String, dynamic> body = {
                                    'shop_id': profileProvider.details!.shopId!,
                                    'employee_id':
                                        profileProvider.details!.employeeId!,
                                    'booking_id': profileProvider.details!.id!,
                                    'star': starRating,
                                    'cmt': reviewController.text,
                                  };
                                  profileProvider.review(body);
                                },
                                style: AppButtonStyle.filledMedium.copyWith(
                                  minimumSize: MaterialStatePropertyAll(
                                    Size(MediaQuery.of(context).size.width, 50),
                                  ),
                                ),
                                child: Text(
                                  getTranslated(context, LangConst.review)
                                      .toString(),
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelLarge!
                                      .copyWith(
                                        color: AppColors.white,
                                      ),
                                ),
                              ),
                            ],
                          )
                        : const SizedBox.shrink(),
                  ],
                ),
              )
            : const Center(
                child: Text('There Is No Data'),
              ),
      ),
    );
  }

  int ratingConvert(double rating) {
    return rating.round();
  }
}
