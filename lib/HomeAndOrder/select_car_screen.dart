import 'package:voyzo/HomeAndOrder/add_car_screen.dart';
import 'package:voyzo/HomeAndOrder/booking_details_screen.dart';
import 'package:voyzo/HomeAndOrder/provider/car_screen_provider.dart';
import 'package:voyzo/HomeAndOrder/provider/home_screen_provider.dart';
import 'package:voyzo/Localization/localization_constant.dart';
import 'package:voyzo/Theme/colors.dart';
import 'package:voyzo/Theme/theme.dart';
import 'package:voyzo/Widgets/app_bar_back_icon.dart';
import 'package:voyzo/Widgets/constant_widget.dart';
import 'package:voyzo/Widgets/select_car_list_tile.dart';
import 'package:voyzo/lang_const.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart'; // Import Google Fonts

class SelectCarScreen extends StatefulWidget {
  final Map<String, dynamic> service;
  final List<String>? serviceName;

  const SelectCarScreen({super.key, required this.service, this.serviceName});

  @override
  State<SelectCarScreen> createState() => _SelectCarScreenState();
}

class _SelectCarScreenState extends State<SelectCarScreen> {
  // NOTE: Initial index set to 0 to automatically select the first car if available
  int _selectedCarIndex = 0;

  late CarScreenProvider carScreenProvider;

  @override
  void initState() {
    carScreenProvider = Provider.of<CarScreenProvider>(context, listen: false);
    carScreenProvider.showVehicles();
    carScreenProvider.vehicalLoading = true;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    carScreenProvider = Provider.of<CarScreenProvider>(context);
    return ModalProgressHUD(
      inAsyncCall: carScreenProvider.vehicalLoading,
      opacity: 0.5,
      progressIndicator: const SpinKitPulsingGrid(
        color: AppColors.primary,
        size: 50.0,
      ),
      child: Scaffold(
        backgroundColor: AppColors.background, // Use background for cleaner look
        appBar: AppBar(
          backgroundColor: AppColors.white,
          elevation: 1,
          leading: const AppBarBack(),
          title: Text(
            getTranslated(context, LangConst.selectCar).toString(),
            style: GoogleFonts.poppins(
              color: AppColors.accent,
              fontWeight: FontWeight.w500,
              fontSize: 20,
            ),
          ),
          centerTitle: false,
        ),
        body: Consumer<HomeScreenProvider>(
          builder: (context, value, child) {
            if (carScreenProvider.vehicles.isNotEmpty) {
              return ListView.separated(
                padding: const EdgeInsets.all(Amount.screenMargin),
                separatorBuilder: (context, index) => const HeightBox(15), // Increased spacing
                itemCount: carScreenProvider.vehicles.length,
                itemBuilder: (context, index) {
                  Map<String, dynamic> vehicle = {
                    'name': carScreenProvider.vehicles[index].model!.name!,
                    'reg-num': carScreenProvider.vehicles[index].regNumber!,
                    'color': carScreenProvider.vehicles[index].color!,
                  };
                  return InkWell(
                    onTap: () {
                      setState(() {
                        _selectedCarIndex = index;
                      });
                    },
                    // NOTE: SelectCarListTile would need to be styled separately,
                    // but the usage pattern is retained.
                    child: SelectCarListTile(
                      isSelected: _selectedCarIndex == index,
                      vehicle: vehicle,
                    ),
                  );
                },
              );
            }

            return Center(
              child: Padding(
                padding: const EdgeInsets.all(Amount.screenMargin * 2),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.directions_car_filled_outlined,
                      size: 60,
                      color: const Color(0xffCED5E0),
                    ),
                    const HeightBox(16),
                    Text(
                      getTranslated(context, LangConst.addCar) ?? 'You haven\'t added any cars yet.',
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
          },
        ),

        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Future.delayed(
              Duration.zero,
                  () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const AddCarScreen(),
                  ),
                ).then((_) {
                  // Reload vehicles after returning from AddCarScreen
                  carScreenProvider.showVehicles();
                });
              },
            );
          },
          // **Circular, Primary-colored FAB**
          shape: const CircleBorder(),
          backgroundColor: AppColors.primary,
          elevation: 8,
          child: const Icon(
            Icons.add,
            color: AppColors.white, // Ensure icon color is white for contrast
            size: 28,
          ),
        ),

        // MARK: - Redesigned Bottom Navigation Bar / Call to Action
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
            onPressed: carScreenProvider.vehicles.isEmpty ? null : () { // Disable if no cars are added
              final carName =
              carScreenProvider.vehicles[_selectedCarIndex].model!.name!;
              final vehicalId =
              carScreenProvider.vehicles[_selectedCarIndex].id!;
              final regNum =
              carScreenProvider.vehicles[_selectedCarIndex].regNumber!;
              final carColor =
              carScreenProvider.vehicles[_selectedCarIndex].color!;
              if (kDebugMode) {
                print(widget.service['duration']);
              }
              Map<String, dynamic> selectedVehicle = {
                'name': carName,
                'reg-num': regNum,
                'color': carColor,
                'shop_id': widget.service['shop_id'],
                'owner_id': widget.service['owner_id'],
                'service': widget.service['service'],
                'vehicle_id': vehicalId,
                'serviceName': widget.service['serviceName'],
                'isPackage': widget.service['isPackage'],
                'isServicePackage': widget.service['isServicePackage'],
                'amount': widget.service['amount'],
                'duration': widget.service['duration'],
                'currency': widget.service['currency'],
                'length': widget.service['length'],
              };

              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => BookingDetailsScreen(
                    vehicle: selectedVehicle,
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
              // Grey out the button if no vehicles are present
              disabledBackgroundColor: const Color(0xffCED5E0).withOpacity(0.5),
              disabledForegroundColor: AppColors.subText.withOpacity(0.5),
            ),
            child: Text(
              getTranslated(context, LangConst.next).toString(),
              // **Updated: Poppins font, White color, Extra bold**
              style: GoogleFonts.poppins(
                color: AppColors.white,
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }
}