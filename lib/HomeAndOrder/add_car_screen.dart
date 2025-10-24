import 'package:voyzo/HomeAndOrder/model/vehicle_brand_response.dart';
import 'package:voyzo/HomeAndOrder/model/vehicle_model_response.dart';
import 'package:voyzo/HomeAndOrder/provider/car_screen_provider.dart';
import 'package:voyzo/Localization/localization_constant.dart';
import 'package:voyzo/Theme/colors.dart';
import 'package:voyzo/Theme/theme.dart';
import 'package:voyzo/Widgets/app_bar_back_icon.dart';
import 'package:voyzo/Widgets/constant_widget.dart';
import 'package:voyzo/lang_const.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';

class AddCarScreen extends StatefulWidget {
  const AddCarScreen({super.key});

  @override
  State<AddCarScreen> createState() => _AddCarScreenState();
}

class _AddCarScreenState extends State<AddCarScreen> {
  late CarScreenProvider carScreenProvider;

  TextEditingController registerController = TextEditingController();
  TextEditingController colorController = TextEditingController();

  @override
  void initState() {
    carScreenProvider = Provider.of<CarScreenProvider>(context, listen: false);
    carScreenProvider.showVehicalBrands();
    carScreenProvider.vehicalBrandsLoading = true;
    super.initState();
  }

  @override
  void dispose() {
    registerController.dispose();
    colorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    carScreenProvider = Provider.of<CarScreenProvider>(context);
    return ModalProgressHUD(
      inAsyncCall: carScreenProvider.vehicalModelLoading ||
          carScreenProvider.vehicalBrandsLoading ||
          carScreenProvider.addCarLoader,
      opacity: 0.5,
      progressIndicator: const SpinKitPulsingGrid(
        color: AppColors.primary,
        size: 50.0,
      ),
      child: Scaffold(
        backgroundColor: AppColors.white,
        appBar: AppBar(
          leading: const AppBarBack(),
          title: Text(getTranslated(context, LangConst.addCar).toString()),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(Amount.screenMargin),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ///car brand
              Text(
                getTranslated(context, LangConst.carBrand).toString(),
                style: Theme.of(context).textTheme.labelMedium!.copyWith(
                      color: AppColors.subText,
                    ),
              ),
              const HeightBox(5),
              FormField<String>(
                builder: (FormFieldState<String> state) {
                  return InputDecorator(
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.fromLTRB(12, 10, 20, 20),
                      errorStyle: const TextStyle(
                        color: Colors.redAccent,
                        fontSize: 16.0,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<VehicalBrandName>(
                        icon: const Icon(Icons.keyboard_arrow_down_sharp),
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                              color: AppColors.bodyText,
                              fontWeight: FontWeight.bold,
                            ),
                        hint: Text(
                          getTranslated(context, LangConst.selectCarBrand)
                              .toString(),
                          style:
                              Theme.of(context).textTheme.bodySmall!.copyWith(
                                    color: AppColors.subText,
                                    fontSize: 14,
                                  ),
                        ),
                        value: carScreenProvider.selectedVehicalBrand,
                        isExpanded: true,
                        isDense: true,
                        onChanged: (VehicalBrandName? newValue) {
                          setState(() {
                            carScreenProvider.selectedVehicalBrand = newValue!;
                            carScreenProvider.showVehicalModels(newValue.id!);
                            carScreenProvider.vehicalModelLoading = true;
                          });
                        },
                        items: carScreenProvider.vehicalBrands
                            .map<DropdownMenuItem<VehicalBrandName>>(
                                (VehicalBrandName valueItem) {
                          return DropdownMenuItem(
                            value: valueItem,
                            child: Text(
                              valueItem.name!,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  );
                },
              ),
              const HeightBox(15),

              ///car model
              Text(
                getTranslated(context, LangConst.carModel).toString(),
                style: Theme.of(context).textTheme.labelMedium!.copyWith(
                      color: AppColors.subText,
                    ),
              ),
              const HeightBox(5),

              FormField<String>(
                builder: (FormFieldState<String> state) {
                  return InputDecorator(
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.fromLTRB(12, 10, 20, 20),
                      errorStyle: const TextStyle(
                          color: Colors.redAccent, fontSize: 16.0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<VehicleModelsResponseData>(
                        icon: const Icon(Icons.keyboard_arrow_down_sharp),
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                              color: AppColors.bodyText,
                              fontWeight: FontWeight.bold,
                            ),
                        hint: Text(
                          getTranslated(context, LangConst.selectCarModel)
                              .toString(),
                          style:
                              Theme.of(context).textTheme.bodySmall!.copyWith(
                                    color: AppColors.subText,
                                    fontSize: 14,
                                  ),
                        ),
                        value: carScreenProvider.selectedVehicalModel,
                        isExpanded: true,
                        isDense: true,
                        onChanged: (VehicleModelsResponseData? newValue) {
                          setState(() {
                            carScreenProvider.selectedVehicalModel = newValue!;
                            if (kDebugMode) {
                              print(carScreenProvider
                                  .selectedVehicalBrand!.name!);
                            }
                          });
                        },
                        items: carScreenProvider.selectedVehicalBrand != null
                            ? carScreenProvider.vehicalModels.map<
                                    DropdownMenuItem<
                                        VehicleModelsResponseData>>(
                                (VehicleModelsResponseData valueItem) {
                                return DropdownMenuItem(
                                  value: valueItem,
                                  child: Text(
                                    valueItem.name!,
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                  ),
                                );
                              }).toList()
                            : List.empty(),
                      ),
                    ),
                  );
                },
              ),

              ///register number
              const HeightBox(15),
              TextFormField(
                controller: registerController,
                keyboardType: TextInputType.name,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter register number';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  labelText: getTranslated(
                    context,
                    LangConst.registeredNum,
                  ).toString(),
                ),
              ),

              ///color
              const HeightBox(15),
              TextFormField(
                controller: colorController,
                keyboardType: TextInputType.name,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter color';
                  }
                  return null;
                },
                inputFormatters: [
                  FilteringTextInputFormatter.deny(RegExp(r"\s")),
                  // To prevent space
                  FilteringTextInputFormatter.allow(RegExp(r"[a-zA-Z]+")),
                ],
                decoration: InputDecoration(
                  labelText: getTranslated(context, LangConst.color).toString(),
                ),
              ),

              const HeightBox(35),
              ElevatedButton(
                onPressed: () async {
                  Map<String, dynamic> body = {
                    'model_id': carScreenProvider.selectedVehicalModel!.id!,
                    'reg_number': registerController.text,
                    'color': colorController.text,
                  };
                  await carScreenProvider.addCar(context, body);
                  // Navigator.pop(context);
                },
                style: AppButtonStyle.filledMedium.copyWith(
                  minimumSize: WidgetStatePropertyAll(
                    Size(MediaQuery.of(context).size.width, 50),
                  ),
                ),
                child: Text(
                  getTranslated(context, LangConst.addCar).toString(),
                  style: Theme.of(context).textTheme.labelLarge!.copyWith(
                        color: AppColors.white,
                      ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
