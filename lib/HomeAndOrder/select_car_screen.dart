import 'package:carq_user/HomeAndOrder/add_car_screen.dart';
import 'package:carq_user/HomeAndOrder/booking_details_screen.dart';
import 'package:carq_user/HomeAndOrder/provider/car_screen_provider.dart';
import 'package:carq_user/HomeAndOrder/provider/home_screen_provider.dart';
import 'package:carq_user/Localization/localization_constant.dart';
import 'package:carq_user/Theme/colors.dart';
import 'package:carq_user/Theme/theme.dart';
import 'package:carq_user/Widgets/app_bar_back_icon.dart';
import 'package:carq_user/Widgets/constant_widget.dart';
import 'package:carq_user/Widgets/select_car_list_tile.dart';
import 'package:carq_user/lang_const.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';

class SelectCarScreen extends StatefulWidget {
  final Map<String, dynamic> service;
  final List<String>? serviceName;

  const SelectCarScreen({super.key, required this.service, this.serviceName});

  @override
  State<SelectCarScreen> createState() => _SelectCarScreenState();
}

class _SelectCarScreenState extends State<SelectCarScreen> {
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
        backgroundColor: AppColors.white,
        appBar: AppBar(
          leading: const AppBarBack(),
          title: Text(getTranslated(context, LangConst.selectCar).toString()),
        ),
        body: Consumer<HomeScreenProvider>(
          builder: (context, value, child) {
            if (carScreenProvider.vehicles.isNotEmpty) {
              return ListView.separated(
                padding: const EdgeInsets.all(Amount.screenMargin),
                separatorBuilder: (context, index) => const HeightBox(10),
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
                    child: SelectCarListTile(
                      isSelected: _selectedCarIndex == index,
                      vehicle: vehicle,
                    ),
                  );
                },
              );
            }
            return const Center(
              child: Text('There is No Car.'),
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
                );
              },
            );
          },
          shape:
              const RoundedRectangleBorder(borderRadius: AppBorderRadius.k16),
          child: const Icon(Icons.add),
        ),
        bottomNavigationBar: Container(
          padding: const EdgeInsets.only(
              left: Amount.screenMargin,
              right: Amount.screenMargin,
              bottom: Amount.screenMargin),
          child: ElevatedButton(
            onPressed: () {
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
