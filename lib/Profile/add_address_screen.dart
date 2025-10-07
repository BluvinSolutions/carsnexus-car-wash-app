import 'package:carsnexus_user/HomeAndOrder/provider/home_screen_provider.dart';
import 'package:carsnexus_user/Localization/localization_constant.dart';
import 'package:carsnexus_user/Theme/colors.dart';
import 'package:carsnexus_user/Theme/theme.dart';
import 'package:carsnexus_user/Widgets/app_bar_back_icon.dart';
import 'package:carsnexus_user/Widgets/constant_widget.dart';
import 'package:carsnexus_user/lang_const.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';

class AddAddressScreen extends StatefulWidget {
  const AddAddressScreen({super.key});

  @override
  State<AddAddressScreen> createState() => _AddAddressScreenState();
}

const List<String> typeList = ['Select Type', 'Home', 'Office', 'Other'];

class _AddAddressScreenState extends State<AddAddressScreen> {
  final TextEditingController cityController = TextEditingController();
  final TextEditingController addressLineController = TextEditingController();
  final TextEditingController pinCodeController = TextEditingController();

  String dropdownValue = typeList.first;

  late HomeScreenProvider homeScreenProvider;

  @override
  void initState() {
    homeScreenProvider =
        Provider.of<HomeScreenProvider>(context, listen: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    homeScreenProvider = Provider.of<HomeScreenProvider>(context);
    return ModalProgressHUD(
      inAsyncCall: homeScreenProvider.addAddressLoading,
      opacity: 0.5,
      progressIndicator: const SpinKitPulsingGrid(
        color: AppColors.primary,
        size: 50.0,
      ),
      child: Scaffold(
        backgroundColor: AppColors.white,
        appBar: AppBar(
          leading: const AppBarBack(),
          title: Text(getTranslated(context, LangConst.addAddress).toString()),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(Amount.screenMargin),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Address Line
              const HeightBox(15),
              TextFormField(
                controller: addressLineController,
                keyboardType: TextInputType.name,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter Address';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  labelText:
                      getTranslated(context, LangConst.address).toString(),
                ),
              ),

              /// City
              const HeightBox(15),
              TextFormField(
                controller: cityController,
                keyboardType: TextInputType.name,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter City';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  labelText: getTranslated(context, LangConst.city).toString(),
                ),
              ),

              /// PinCode
              const HeightBox(15),
              TextFormField(
                controller: pinCodeController,
                keyboardType: TextInputType.name,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter PinCode';
                  }
                  return null;
                },
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(6),
                ],
                decoration: InputDecoration(
                  labelText:
                      getTranslated(context, LangConst.pinCode).toString(),
                ),
              ),

              /// Type
              const HeightBox(15),
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
                      child: DropdownButton<String>(
                        icon: const Icon(Icons.keyboard_arrow_down_sharp),
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                              color: AppColors.bodyText,
                              fontWeight: FontWeight.bold,
                            ),
                        hint: Text(
                          "Select Address Type",
                          style:
                              Theme.of(context).textTheme.bodySmall!.copyWith(
                                    color: AppColors.subText,
                                    fontSize: 14,
                                  ),
                        ),
                        value: dropdownValue,
                        isExpanded: true,
                        isDense: true,
                        onChanged: (value) {
                          // This is called when the user selects an item.
                          setState(() {
                            dropdownValue = value!;
                          });
                        },
                        items: typeList
                            .map<DropdownMenuItem<String>>((String valueItem) {
                          return DropdownMenuItem(
                            value: valueItem,
                            child: Text(
                              valueItem,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  );
                },
              ),

              const HeightBox(35),
              ElevatedButton(
                onPressed: () {
                  Map<String, dynamic> body = {
                    'line_1': addressLineController.text,
                    'city': cityController.text,
                    'pincode': pinCodeController.text,
                    'type': typeList.indexOf(dropdownValue) == 1
                        ? 0
                        : typeList.indexOf(dropdownValue) == 2
                            ? 1
                            : typeList.indexOf(dropdownValue) == 3
                                ? 2
                                : 0,
                  };
                  if (kDebugMode) {
                    print(body.toString());
                  }
                  homeScreenProvider.addAddressInList(context, body);
                },
                style: AppButtonStyle.filledMedium.copyWith(
                  minimumSize: MaterialStatePropertyAll(
                    Size(MediaQuery.of(context).size.width, 50),
                  ),
                ),
                child: Text(
                  getTranslated(context, LangConst.addAddress).toString(),
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
