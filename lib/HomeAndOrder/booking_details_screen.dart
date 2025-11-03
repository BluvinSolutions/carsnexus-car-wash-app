import 'package:voyzo/HomeAndOrder/provider/home_screen_provider.dart';
import 'package:voyzo/HomeAndOrder/service_details_screen.dart';
import 'package:voyzo/Localization/localization_constant.dart';
import 'package:voyzo/Profile/add_address_screen.dart';
import 'package:voyzo/Theme/colors.dart';
import 'package:voyzo/Theme/theme.dart';
import 'package:voyzo/Widgets/address_list_tile.dart';
import 'package:voyzo/Widgets/app_bar_back_icon.dart';
import 'package:voyzo/Widgets/constant_widget.dart';
import 'package:voyzo/lang_const.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

class BookingDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> vehicle;
  final List<String>? serviceName;

  const BookingDetailsScreen(
      {super.key, required this.vehicle, this.serviceName});

  @override
  State<BookingDetailsScreen> createState() => _BookingDetailsScreenState();
}

class _BookingDetailsScreenState extends State<BookingDetailsScreen> {
  TextEditingController dateController = TextEditingController();
  TextEditingController timeController = TextEditingController();

  late HomeScreenProvider homeScreenProvider;
  DateTime? dateTime;

  @override
  void initState() {
    if (kDebugMode) {
      print(widget.vehicle.toString());
      print(widget.serviceName.toString());
    }
    homeScreenProvider = Provider.of<HomeScreenProvider>(
      context,
      listen: false,
    );
    homeScreenProvider.showAddress();
    super.initState();
  }

  @override
  void dispose() {
    dateController.dispose();
    timeController.dispose();
    super.dispose();
  }

  // NOTE: Renamed to clearly reflect it selects an address index
  int _selectedAddressIndex = 0;

  // MARK: - Date and Time Picker Styles

  InputDecoration _getInputDecoration(BuildContext context, String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: GoogleFonts.poppins(
        color: AppColors.subText,
        fontWeight: FontWeight.w500,
        fontSize: 16,
      ),
      filled: true,
      fillColor: const Color(0xffCED5E0).withOpacity(0.3), // Soft gray background
      border: OutlineInputBorder(
        borderRadius: AppBorderRadius.k12,
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: AppBorderRadius.k12,
        borderSide: BorderSide(color: const Color(0xffCED5E0).withOpacity(0.5), width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: AppBorderRadius.k12,
        borderSide: const BorderSide(color: AppColors.primary, width: 2), // Primary focus
      ),
      contentPadding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
    );
  }

  @override
  Widget build(BuildContext context) {
    homeScreenProvider = Provider.of<HomeScreenProvider>(context);
    return ModalProgressHUD(
      inAsyncCall: homeScreenProvider.addressLoading,
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
            getTranslated(context, LangConst.bookingDetails).toString(),
            // **Updated: Poppins font, Accent color, Bold**
            style: GoogleFonts.poppins(
              color: AppColors.accent,
              fontWeight: FontWeight.w700,
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
              // MARK: - Date Picker
              TextFormField(
                controller: dateController,
                readOnly: true,
                keyboardType: TextInputType.name,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please select date';
                  }
                  return null;
                },
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now().add(const Duration(hours: 1)),
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2100),
                    builder: (context, child) {
                      return Theme(
                        data: Theme.of(context).copyWith(
                          colorScheme: const ColorScheme.light(
                            primary: AppColors.primary, // Header background color
                            onPrimary: AppColors.white, // Header text color
                            surfaceTint: AppColors.white,
                          ),
                          textButtonTheme: TextButtonThemeData(
                            style: TextButton.styleFrom(
                              foregroundColor: AppColors.primary, // Button text color
                            ),
                          ),
                        ),
                        child: child!,
                      );
                    },
                  );

                  if (pickedDate != null) {
                    String formattedDate =
                    DateFormat('yyyy-MM-dd').format(pickedDate);
                    setState(
                          () {
                        // Ensure we retain the current time or default to a safe time if it was null
                        dateTime = DateTime(
                            pickedDate.year,
                            pickedDate.month,
                            pickedDate.day,
                            dateTime?.hour ?? 10,
                            dateTime?.minute ?? 0);
                        dateController.text = formattedDate;
                      },
                    );
                  }
                },
                decoration: _getInputDecoration(context, getTranslated(context, LangConst.date).toString()).copyWith(
                  suffixIcon: const Icon(
                    Icons.calendar_today_rounded, // Modern calendar icon
                    size: 20,
                    color: AppColors.primary, // Primary color for icon
                  ),
                ),
                style: GoogleFonts.poppins(
                  color: AppColors.bodyText,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const HeightBox(20), // Increased spacing

              // MARK: - Time Picker
              TextFormField(
                controller: timeController,
                readOnly: true,
                keyboardType: TextInputType.name,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please select time';
                  }
                  return null;
                },
                onTap: () async {
                  TimeOfDay initialTime = TimeOfDay.now();
                  if (dateController.text == DateFormat('yyyy-MM-dd').format(DateTime.now())) {
                    // If picking today, set initial time one hour from now
                    DateTime oneHourLater = DateTime.now().add(const Duration(hours: 1));
                    initialTime = TimeOfDay.fromDateTime(oneHourLater);
                  }

                  TimeOfDay? pickedTime = await showTimePicker(
                    initialTime: initialTime,
                    context: context,
                    builder: (BuildContext context, Widget? child) {
                      return Theme(
                        data: ThemeData.light().copyWith(
                          colorScheme: const ColorScheme.light(
                            primary: AppColors.primary,
                            onPrimary: AppColors.white,
                            surface: AppColors.white,
                            onSurface: AppColors.accent,
                          ),
                          textButtonTheme: TextButtonThemeData(
                            style: TextButton.styleFrom(
                              foregroundColor: AppColors.primary,
                            ),
                          ),
                        ),
                        child: child!,
                      );
                    },
                  );

                  if (pickedTime != null) {
                    // 1. Create a DateTime object combining selected date and picked time
                    DateTime selectedDateTime = DateTime(
                      dateTime!.year,
                      dateTime!.month,
                      dateTime!.day,
                      pickedTime.hour,
                      pickedTime.minute,
                    );

                    // 2. Check if the selected time is at least 1 hour later than current time if today is selected
                    if (selectedDateTime.isBefore(DateTime.now().add(const Duration(hours: 1))) && dateController.text == DateFormat('yyyy-MM-dd').format(DateTime.now())) {
                      Fluttertoast.showToast(msg:'Please select a time at least 1 hour from the current time.', backgroundColor: AppColors.primary, textColor: AppColors.white);
                    } else {
                      setState(() {
                        dateTime = selectedDateTime;
                        timeController.text = pickedTime.format(context);
                      });
                    }
                  }
                },
                decoration: _getInputDecoration(context, getTranslated(context, LangConst.time).toString()).copyWith(
                  suffixIcon: const Icon(
                    Icons.access_time_filled_rounded, // Modern time icon
                    size: 20,
                    color: AppColors.primary,
                  ),
                ),
                style: GoogleFonts.poppins(
                  color: AppColors.bodyText,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const HeightBox(30), // Increased spacing before Address

              // MARK: - Select Address Title
              Text(
                getTranslated(context, LangConst.selectAddress).toString(),
                style: GoogleFonts.poppins(
                  color: AppColors.accent,
                  fontWeight: FontWeight.w500,
                  fontSize: 22, // Larger title
                ),
              ),

              // MARK: - Address List
              ListView.separated(
                itemCount: homeScreenProvider.addressList.length,
                shrinkWrap: true,
                padding: const EdgeInsets.only(top: Amount.screenMargin),
                physics: const NeverScrollableScrollPhysics(),
                separatorBuilder: (context, index) => const HeightBox(15), // Increased separation
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      setState(
                            () {
                          _selectedAddressIndex = index;
                        },
                      );
                    },
                    // NOTE: AddressListTile needs to be updated separately
                    child: AddressListTile(
                      isSelected: _selectedAddressIndex == index,
                      address: homeScreenProvider.addressList[index],
                    ),
                  );
                },
              ),
            ],
          ),
        ),

        // MARK: - Floating Action Button (Add Address)
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const AddAddressScreen(),
              ),
            ).then((_) {
              // Reload addresses after returning from AddAddressScreen
              homeScreenProvider.showAddress();
            });
          },
          // **Circular, Primary-colored FAB**
          shape: const CircleBorder(),
          backgroundColor: AppColors.primary,
          elevation: 8,
          child: const Icon(
            Icons.add,
            color: AppColors.white,
            size: 28,
          ),
        ),

        // MARK: - Bottom Navigation Bar / Call to Action (Next)
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
            onPressed: homeScreenProvider.addressList.isEmpty || dateController.text.isEmpty || timeController.text.isEmpty
                ? null // Disable if required fields are empty
                : () {
              // Check time consistency one last time
              if (dateTime!.isBefore(DateTime.now().add(const Duration(hours: 1)))) {
                Fluttertoast.showToast(msg: 'Please select a time at least 1 hour from the current time.', backgroundColor: AppColors.primary, textColor: AppColors.white);
                return;
              }

              final int durationDiff = widget.vehicle['duration'];
              final DateTime duration = dateTime!.add(Duration(minutes: durationDiff));

              final String displayStartTime = DateFormat('hh:mm a').format(dateTime!);
              final String displayEndTime = DateFormat('hh:mm a').format(duration);
              final String startTime = DateFormat('yyyy-MM-dd HH:mm:ss').format(dateTime!);
              final String endTime = DateFormat('yyyy-MM-dd HH:mm:ss').format(duration);

              Map<String, dynamic> details = {
                'name': widget.vehicle['name'],
                'reg-num': widget.vehicle['reg-num'],
                'color': widget.vehicle['color'],
                'shop_id': widget.vehicle['shop_id'],
                'owner_id': widget.vehicle['owner_id'],
                'service': widget.vehicle['service'],
                'vehicle_id': widget.vehicle['vehicle_id'],
                'serviceName': widget.vehicle['serviceName'],
                'isPackage': widget.vehicle['isPackage'],
                'isServicePackage': widget.vehicle['isServicePackage'],
                'startTime': displayStartTime,
                'endTime': displayEndTime,
                'start_time': startTime,
                'end_time': endTime,
                'bookingDate': dateController.text,
                'amount': widget.vehicle['amount'],
                'currency': widget.vehicle['currency'],
                'length': widget.vehicle['length'],
                'address': homeScreenProvider.addressList[_selectedAddressIndex].line1!,
              };

              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => ServiceDetailsScreen(
                    details: details,
                    serviceName: widget.serviceName,
                  ),
                ),
              );
            },
            // **Pill-shaped, bold, full-width button**
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
              // Disable styling
              disabledBackgroundColor: const Color(0xffCED5E0).withOpacity(0.5),
              disabledForegroundColor: AppColors.subText.withOpacity(0.5),
            ),
            child: Text(
              getTranslated(context, LangConst.next).toString(),
              // **Updated: Poppins font, White color, Extra bold**
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
}