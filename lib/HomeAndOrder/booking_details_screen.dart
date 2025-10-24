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

  int _selectedCarIndex = 0;

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
        backgroundColor: AppColors.white,
        appBar: AppBar(
          leading: const AppBarBack(),
          title:
              Text(getTranslated(context, LangConst.bookingDetails).toString()),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(Amount.screenMargin),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2100),
                    builder: (context, child) {
                      return Theme(
                        data: Theme.of(context).copyWith(
                          colorScheme: const ColorScheme.light(
                            primary: AppColors.primary,
                            // header background color
                            surfaceTint: AppColors.white,
                          ),
                          textButtonTheme: TextButtonThemeData(
                            style: TextButton.styleFrom(
                              foregroundColor:
                                  AppColors.primary, // button text color
                            ),
                          ),
                        ),
                        child: child!,
                      );
                    },
                  );

                  if (pickedDate != null) {
                    if (kDebugMode) {
                      print(pickedDate);
                    }
                    String formattedDate =
                        DateFormat('yyyy-MM-dd').format(pickedDate);
                    if (kDebugMode) {
                      print(formattedDate);
                    }
                    setState(
                      () {
                        dateTime = pickedDate;
                        dateController.text = formattedDate;
                      },
                    );
                  } else {}
                },
                decoration: InputDecoration(
                  labelText: getTranslated(context, LangConst.date).toString(),
                  suffixIcon: const Icon(
                    Icons.calendar_month_sharp,
                    size: 20,
                    color: AppColors.icon,
                  ),
                ),
              ),
              const HeightBox(15),
              TextFormField(
                controller: timeController,
                readOnly: true,
                keyboardType: TextInputType.name,
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: AppColors.bodyText,
                    ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please select date';
                  }
                  return null;
                },
                onTap: () async {
                  final currentTime =
                      DateTime.now().add(const Duration(hours: 1));
                  TimeOfDay? pickedTime = await showTimePicker(
                    initialTime: TimeOfDay(
                      hour: currentTime.hour,
                      minute: currentTime.minute,
                    ),
                    context: context,
                    builder: (BuildContext context, Widget? child) {
                      return Theme(
                        data: ThemeData.light().copyWith(
                          colorScheme: ColorScheme.light(
                            primary: Theme.of(context).colorScheme.primary,
                            onPrimary: Colors.white,
                            surface: Colors.white,
                            onSurface: Colors.black,
                          ),
                        ),
                        child: child!,
                      );
                    },
                  );

                  if (pickedTime != null) {
                    if (kDebugMode) {
                      print(DateTime.now());
                      print(currentTime);
                      print(pickedTime);
                    }
                    bool res = currentTime.isAfter(DateTime.now());
                    if (kDebugMode) {
                      print(res);
                    }
                    if (pickedTime != currentTime && res == true) {
                      setState(
                        () {
                          dateTime = dateTime!.toLocal();
                          dateTime = DateTime(
                            dateTime!.year,
                            dateTime!.month,
                            dateTime!.day,
                            pickedTime.hour,
                            pickedTime.minute,
                          );
                          timeController.text = pickedTime
                              .format(context); //set the value of text field.
                        },
                      );
                    } else {
                      Fluttertoast.showToast(
                          msg:
                              'Please Select a Time 1 hour Later From Current Time');
                    }
                  } else {}
                },
                decoration: InputDecoration(
                  labelText: getTranslated(context, LangConst.time).toString(),
                  suffixIcon: const Icon(
                    Icons.calendar_month_sharp,
                    size: 20,
                    color: AppColors.icon,
                  ),
                ),
              ),
              const HeightBox(15),
              Text(
                getTranslated(context, LangConst.selectAddress).toString(),
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
              ),
              ListView.separated(
                itemCount: homeScreenProvider.addressList.length,
                shrinkWrap: true,
                padding: const EdgeInsets.only(top: Amount.screenMargin),
                physics: const NeverScrollableScrollPhysics(),
                separatorBuilder: (context, index) => const HeightBox(10),
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      setState(
                        () {
                          _selectedCarIndex = index;
                        },
                      );
                    },
                    child: AddressListTile(
                      isSelected: _selectedCarIndex == index,
                      address: homeScreenProvider.addressList[index],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const AddAddressScreen(),
              ),
            );
          },
          shape: const RoundedRectangleBorder(
            borderRadius: AppBorderRadius.k16,
          ),
          child: const Icon(Icons.add),
        ),
        bottomNavigationBar: Container(
          padding: const EdgeInsets.only(
            left: Amount.screenMargin,
            right: Amount.screenMargin,
            bottom: Amount.screenMargin,
          ),
          child: ElevatedButton(
            onPressed: () {
              if (dateTime != null) {
                if (timeController.text.isNotEmpty) {
                  if (kDebugMode) {
                    print(dateTime!);
                  }

                  final int durationDiff = widget.vehicle['duration'];
                  final DateTime duration =
                      dateTime!.add(Duration(minutes: durationDiff));
                  if (kDebugMode) {
                    print(duration);
                  }
                  final String displayStartTime =
                      DateFormat('hh:mm a').format(dateTime!);
                  final String displayEndTime =
                      DateFormat('hh:mm a').format(duration);
                  final String startTime =
                      DateFormat('yyyy-MM-dd HH:mm:ss').format(dateTime!);
                  final String endTime =
                      DateFormat('yyyy-MM-dd HH:mm:ss').format(duration);
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
                    'address': homeScreenProvider
                        .addressList[_selectedCarIndex].line1!,
                  };

                  if (kDebugMode) {
                    print(widget.serviceName);
                  }
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => ServiceDetailsScreen(
                        details: details,
                        serviceName: widget.serviceName,
                      ),
                    ),
                  );
                } else {
                  Fluttertoast.showToast(msg: 'Please Select Time');
                }
              } else {
                Fluttertoast.showToast(msg: 'Please Select Date & Time');
              }
            },
            style: AppButtonStyle.filledLarge,
            child: Text(
              getTranslated(context, LangConst.next).toString(),
              style: Theme.of(context).textTheme.labelLarge!.copyWith(
                    color: AppColors.white,
                  ),
            ),
          ),
        ),
      ),
    );
  }
}
