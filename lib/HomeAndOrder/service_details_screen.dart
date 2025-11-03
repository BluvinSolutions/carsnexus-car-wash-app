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
import 'package:google_fonts/google_fonts.dart'; // Import Google Fonts

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

  // MARK: - Helper Widgets for Design

  Widget _buildDetailCard({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(Amount.screenMargin),
      margin: const EdgeInsets.only(bottom: Amount.screenMargin),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: AppBorderRadius.k16,
        border: Border.all(
          color: const Color(0xffCED5E0).withOpacity(0.5),
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
      child: child,
    );
  }

  Widget _buildDetailItem(BuildContext context, String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.poppins(
              color: AppColors.subText,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
          const HeightBox(4),
          Text(
            value,
            style: GoogleFonts.poppins(
              color: AppColors.accent,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Text(
        title,
        style: GoogleFonts.poppins(
          color: AppColors.accent,
          fontWeight: FontWeight.w700,
          fontSize: 22,
        ),
      ),
    );
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
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.white,
          elevation: 1,
          leading: const AppBarBack(),
          title: Text(
            getTranslated(context, LangConst.serviceDetails).toString(),
            style: GoogleFonts.poppins(
              color: AppColors.accent,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          centerTitle: false,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(Amount.screenMargin),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // MARK: - Vehicle Details
              _buildSectionTitle(
                  context, getTranslated(context, LangConst.vehicleType).toString()),
              _buildDetailCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.details['name'],
                      style: GoogleFonts.poppins(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w800,
                        fontSize: 20,
                      ),
                    ),
                    const HeightBox(12),
                    Row(
                      children: [
                        Expanded(
                          child: _buildDetailItem(
                            context,
                            getTranslated(context, LangConst.registeredNum).toString(),
                            widget.details['reg-num'],
                          ),
                        ),
                        Expanded(
                          child: _buildDetailItem(
                            context,
                            getTranslated(context, LangConst.color).toString(),
                            widget.details['color'],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // MARK: - Booking Details
              _buildSectionTitle(
                  context, getTranslated(context, LangConst.bookingDetails).toString()),
              _buildDetailCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: _buildDetailItem(
                            context,
                            getTranslated(context, LangConst.date).toString(),
                            widget.details['bookingDate'],
                          ),
                        ),
                        Expanded(
                          child: _buildDetailItem(
                            context,
                            getTranslated(context, LangConst.time).toString(),
                            '${widget.details['startTime']} - ${widget.details['endTime']}',
                          ),
                        ),
                      ],
                    ),
                    const HeightBox(8),
                    _buildDetailItem(
                      context,
                      getTranslated(context, LangConst.address).toString(),
                      widget.details['address'],
                    ),
                  ],
                ),
              ),

              // MARK: - Service Details
              _buildSectionTitle(
                  context, getTranslated(context, LangConst.serviceDetails).toString()),
              _buildDetailCard(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            getTranslated(context, LangConst.serviceName).toString(),
                            style: GoogleFonts.poppins(
                              color: AppColors.subText,
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const HeightBox(4),
                          widget.details['isPackage'] ||
                              widget.details['isServicePackage']
                              ? ListView.builder(
                            itemCount: widget.serviceName!.length,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) => Text(
                              '• ${widget.serviceName![index]}',
                              style: GoogleFonts.poppins(
                                color: AppColors.accent,
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                            ),
                          )
                              : Text(
                            widget.details['serviceName'],
                            style: GoogleFonts.poppins(
                              color: AppColors.accent,
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            getTranslated(context, LangConst.amount).toString(),
                            style: GoogleFonts.poppins(
                              color: AppColors.subText,
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const HeightBox(4),
                          Text(
                            '${widget.details['currency']}${widget.details['amount']}',
                            style: GoogleFonts.poppins(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w800, // Extra bold for amount
                              fontSize: 22,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // MARK: - Service Place
              _buildSectionTitle(
                  context, getTranslated(context, LangConst.servicePlace).toString()),
              Row(
                children: [
                  Expanded(
                    child: _buildServicePlaceTile(
                      context,
                      ServicePlace.serviceAtHome,
                      getTranslated(context, LangConst.serviceAtHome).toString(),
                      Icons.home_work_rounded,
                    ),
                  ),
                  const WidthBox(12),
                  Expanded(
                    child: _buildServicePlaceTile(
                      context,
                      ServicePlace.serviceAtShop,
                      getTranslated(context, LangConst.serviceAtShop).toString(),
                      Icons.store_mall_directory_rounded,
                    ),
                  ),
                ],
              ),
              const HeightBox(20),
            ],
          ),
        ),

        // MARK: - Bottom Button
        bottomNavigationBar: Container(
          padding: const EdgeInsets.only(
            left: Amount.screenMargin,
            right: Amount.screenMargin,
            bottom: Amount.screenMargin,
            top: 8,
          ),
          decoration: BoxDecoration(
            color: AppColors.white,
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withOpacity(0.15),
                blurRadius: 10,
                offset: const Offset(0, -5),
              ),
            ],
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
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
              minimumSize: Size(
                MediaQuery.of(context).size.width,
                55,
              ),
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
            child: Text(
              getTranslated(context, LangConst.sendRequest).toString(),
              style: GoogleFonts.poppins(
                color: AppColors.white,
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ),
      ),
    );
  }

  // MARK: - Custom Radio Tile for Service Place
  Widget _buildServicePlaceTile(
      BuildContext context, ServicePlace value, String title, IconData icon) {
    bool isSelected = _service == value;
    return InkWell(
      onTap: () {
        setState(() {
          _service = value;
        });
      },
      borderRadius: AppBorderRadius.k12,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary.withOpacity(0.1) : const Color(0xffCED5E0).withOpacity(0.3),
          borderRadius: AppBorderRadius.k12,
          border: Border.all(
            color: isSelected ? AppColors.primary : const Color(0xffCED5E0),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: isSelected ? AppColors.primary : AppColors.accent,
              size: 30,
            ),
            const HeightBox(8),
            Text(
              title,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                color: isSelected ? AppColors.primary : AppColors.bodyText,
                fontWeight: FontWeight.w700,
                fontSize: 14,
              ),
            ),
          ],
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
        title: Text(
          "${getTranslated(context, LangConst.doneLabel)}",
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        content: Text(
          "${getTranslated(context, LangConst.requestSubmittedPleaseAwaitApproval)}",
          maxLines: 2,
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(
            color: AppColors.bodyText,
            fontWeight: FontWeight.w300,
            fontSize: 18,
          ),
        ),
      ),
    );
  }
}

enum ServicePlace { serviceAtHome, serviceAtShop }