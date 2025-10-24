import 'package:voyzo/HomeAndOrder/provider/shop_services_provider.dart';
import 'package:voyzo/Localization/localization_constant.dart';
import 'package:voyzo/Routes/routes.dart';
import 'package:voyzo/Theme/colors.dart';
import 'package:voyzo/Theme/theme.dart';
import 'package:voyzo/Widgets/app_bar_back_icon.dart';
import 'package:voyzo/Widgets/constant_widget.dart';
import 'package:voyzo/lang_const.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';

class ServiceDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> details;
  final List<String>? serviceName;

  const ServiceDetailsScreen(
      {super.key, required this.details, this.serviceName});

  @override
  State<ServiceDetailsScreen> createState() => _ServiceDetailsScreenState();
}

class _ServiceDetailsScreenState extends State<ServiceDetailsScreen> {
  ServicePlace _service = ServicePlace.serviceAtHome;
  late ShopServicesProvider shopServicesProvider;

  @override
  void initState() {
    if (kDebugMode) {
      print(widget.details.toString());
    }
    shopServicesProvider =
        Provider.of<ShopServicesProvider>(context, listen: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    shopServicesProvider = Provider.of<ShopServicesProvider>(context);
    return ModalProgressHUD(
      inAsyncCall: shopServicesProvider.bookingLoading,
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
              Text(getTranslated(context, LangConst.serviceDetails).toString()),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(Amount.screenMargin),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ///vehicle details
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
                  color: AppColors.white,
                  borderRadius: AppBorderRadius.k16,
                  border: Border.all(
                    color: AppColors.stroke,
                  ),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          widget.details['name'],
                          style:
                              Theme.of(context).textTheme.titleMedium!.copyWith(
                                    color: AppColors.bodyText,
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                getTranslated(context, LangConst.registeredNum)
                                    .toString(),
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(
                                      color: AppColors.subText,
                                    ),
                              ),
                              Text(
                                widget.details['reg-num'],
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(
                                      color: AppColors.bodyText,
                                      fontWeight: FontWeight.w500,
                                    ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
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
                              Text(
                                widget.details['color'],
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(
                                      color: AppColors.bodyText,
                                      fontWeight: FontWeight.w500,
                                    ),
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

              ///booking details
              Text(
                getTranslated(context, LangConst.bookingDetails).toString(),
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
                              Text(
                                widget.details['bookingDate'],
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(
                                      color: AppColors.bodyText,
                                      fontWeight: FontWeight.w500,
                                    ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
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
                              Text(
                                '${widget.details['startTime']} To ${widget.details['endTime']}',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(
                                      color: AppColors.bodyText,
                                      fontWeight: FontWeight.w500,
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const HeightBox(8),
                    Text(
                      getTranslated(context, LangConst.address).toString(),
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            color: AppColors.subText,
                          ),
                    ),
                    Text(
                      widget.details['address'],
                      maxLines: 3,
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            color: AppColors.bodyText,
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                  ],
                ),
              ),
              const HeightBox(8),

              ///service Details
              Text(
                getTranslated(context, LangConst.serviceDetails).toString(),
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
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            getTranslated(context, LangConst.serviceName)
                                .toString(),
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                  color: AppColors.subText,
                                ),
                          ),
                          widget.details['isPackage'] ||
                                  widget.details['isServicePackage']
                              ? ListView.builder(
                                  itemCount: widget.serviceName!.length,
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemBuilder: (context, index) => Text(
                                    widget.serviceName![index],
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(
                                          color: AppColors.bodyText,
                                          fontWeight: FontWeight.w500,
                                        ),
                                  ),
                                )
                              : Text(
                                  widget.details['serviceName'],
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(
                                        color: AppColors.bodyText,
                                        fontWeight: FontWeight.w500,
                                      ),
                                ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            getTranslated(context, LangConst.amount).toString(),
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                  color: AppColors.subText,
                                ),
                          ),
                          Text(
                            '${widget.details['currency']}${widget.details['amount']}',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const HeightBox(8),

              ///service Place
              Text(
                getTranslated(context, LangConst.servicePlace).toString(),
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
              ),
              const HeightBox(8),
              Row(
                children: [
                  Expanded(
                    child: RadioListTile(
                      value: ServicePlace.serviceAtHome,
                      contentPadding: EdgeInsets.zero,
                      visualDensity:
                          const VisualDensity(horizontal: -4, vertical: -4),
                      title: Text(
                        getTranslated(context, LangConst.serviceAtHome)
                            .toString(),
                        style: Theme.of(context).textTheme.labelLarge!.copyWith(
                              color: _service == ServicePlace.serviceAtHome
                                  ? AppColors.bodyText
                                  : AppColors.subText,
                              fontWeight: FontWeight.w500,
                            ),
                      ),
                      groupValue: _service,
                      onChanged: (ServicePlace? value) {
                        setState(
                          () {
                            _service = value!;
                          },
                        );
                      },
                    ),
                  ),
                  Expanded(
                    child: RadioListTile(
                      contentPadding: EdgeInsets.zero,
                      visualDensity:
                          const VisualDensity(horizontal: -4, vertical: -4),
                      title: Text(
                        getTranslated(context, LangConst.serviceAtShop)
                            .toString(),
                        style: Theme.of(context).textTheme.labelLarge!.copyWith(
                              color: _service == ServicePlace.serviceAtShop
                                  ? AppColors.bodyText
                                  : AppColors.subText,
                              fontWeight: FontWeight.w500,
                            ),
                      ),
                      onChanged: (ServicePlace? value) {
                        setState(
                          () {
                            _service = value!;
                          },
                        );
                      },
                      value: ServicePlace.serviceAtShop,
                      groupValue: _service,
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
        bottomNavigationBar: Container(
          padding: const EdgeInsets.only(
            left: Amount.screenMargin,
            right: Amount.screenMargin,
            bottom: Amount.screenMargin,
          ),
          child: ElevatedButton(
            onPressed: () {
              showSucessDialog(context);
              Map<String, dynamic> body = {
                'shop_id': widget.details['shop_id'],
                'owner_id': widget.details['owner_id'],
                'address': widget.details['address'],
                'start_time': widget.details['start_time'],
                'end_time': widget.details['end_time'],
                'vehicle_id': widget.details['vehicle_id'],
                'service_type': _service == ServicePlace.serviceAtHome ? 0 : 1,
                'amount': widget.details['amount'],
                'discount': 0,
                'payment_status': 0,
                'payment_method': 'Offline',
                'status': 0,
                'service': widget.details['service'],
              };
              if (kDebugMode) {
                print(body.toString());
              }
              shopServicesProvider.bookSlot(body);
              Future.delayed(
                const Duration(seconds: 2),
                () => Navigator.popAndPushNamed(context, Routes.home),
              );
            },
            style: AppButtonStyle.filledLarge,
            child: Text(
              getTranslated(context, LangConst.sendRequest).toString(),
              style: Theme.of(context).textTheme.labelLarge!.copyWith(
                    color: AppColors.white,
                  ),
            ),
          ),
        ),
      ),
    );
  }

  showSucessDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        surfaceTintColor: AppColors.white,
        backgroundColor: AppColors.white,
        shadowColor: AppColors.white,
        title: Text(
          "${getTranslated(context, LangConst.doneLabel)}",
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.titleLarge!.copyWith(
                color: AppColors.primary,
              ),
        ),
        content: Text(
          "${getTranslated(context, LangConst.requestSubmittedPleaseAwaitApproval)}",
          maxLines: 2,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                color: AppColors.bodyText,
                fontWeight: FontWeight.w500,
                fontSize: 18,
              ),
        ),
      ),
    );
  }
}

enum ServicePlace { serviceAtHome, serviceAtShop }
