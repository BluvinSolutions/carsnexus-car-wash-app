import 'package:carsnexus_user/HomeAndOrder/model/add_address_response.dart';
import 'package:carsnexus_user/HomeAndOrder/model/address_list_response.dart';
import 'package:carsnexus_user/HomeAndOrder/model/package_details_response.dart';
import 'package:carsnexus_user/Network/api_service.dart';
import 'package:carsnexus_user/Network/base_model.dart';
import 'package:carsnexus_user/Network/retrofit.dart';
import 'package:carsnexus_user/Network/server_error.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class HomeScreenProvider extends ChangeNotifier {
  //*   GET Package Details
  bool packageLoading = false;
  PackageDetailsResponseData? packageData;

  Future<BaseModel<PackageDetailsResponse>> showPackageDetails(int id) async {
    PackageDetailsResponse response;
    try {
      packageData = null;
      response = await RestClient(RetroApi().dioData()).getPackageDetails(id);
      if (response.success == true) {
        if (response.data != null) {
          packageData = response.data!;
        }
      }
      packageLoading = false;
      notifyListeners();
    } catch (error) {
      packageLoading = false;
      notifyListeners();
      return BaseModel()..error = ServerError.withError(error: error);
    }
    return BaseModel()..data = response;
  }

  //*   GET List Of Address
  bool addressLoading = false;
  List<AddressListData> addressList = [];
  AddressListData? selectedAddress;

  Future<BaseModel<AddressListResponse>> showAddress() async {
    AddressListResponse response;
    try {
      addressLoading = true;
      // notifyListeners();
      response = await RestClient(RetroApi().dioData()).showAddressList();
      if (response.success == true) {
        addressList.clear();
        if (response.data != null) {
          addressList.addAll(response.data!);
        }
      }
      addressLoading = false;
      notifyListeners();
    } catch (error) {
      addressLoading = false;
      notifyListeners();
      return BaseModel()..error = ServerError.withError(error: error);
    }
    return BaseModel()..data = response;
  }

  //*   Add Address
  bool addAddressLoading = false;

  Future<BaseModel<AddAddressResponse>> addAddressInList(
      BuildContext context, Map<String, dynamic> body) async {
    AddAddressResponse response;
    try {
      addAddressLoading = true;
      notifyListeners();
      response = await RestClient(RetroApi().dioData()).addAddress(body);
      if (response.success == true) {
        Fluttertoast.showToast(msg: response.msg!);
        addressList.add(response.data!);
        if (context.mounted) Navigator.pop(context);
      }
      addAddressLoading = false;
      notifyListeners();
    } catch (error) {
      addAddressLoading = false;
      notifyListeners();
      return BaseModel()..error = ServerError.withError(error: error);
    }
    return BaseModel()..data = response;
  }
}
