import 'package:voyzo/HomeAndOrder/model/add_vehicle_response.dart';
import 'package:voyzo/HomeAndOrder/model/vehical_response.dart';
import 'package:voyzo/HomeAndOrder/model/vehicle_brand_response.dart';
import 'package:voyzo/HomeAndOrder/model/vehicle_model_response.dart';
import 'package:voyzo/Network/api_service.dart';
import 'package:voyzo/Network/base_model.dart';
import 'package:voyzo/Network/retrofit.dart';
import 'package:voyzo/Network/server_error.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CarScreenProvider extends ChangeNotifier {
  //*   GET All vehicle
  bool vehicalLoading = false;
  List<VehicalResponseData> vehicles = [];

  Future<BaseModel<VehicleResponse>> showVehicles() async {
    VehicleResponse response;
    try {
      response = await RestClient(RetroApi().dioData()).getVehicles();
      if (response.success == true) {
        vehicles.clear();
        if (response.data != null) {
          vehicles.addAll(response.data!);
        }
      }
      vehicalLoading = false;
      notifyListeners();
    } catch (error) {
      vehicalLoading = false;
      notifyListeners();
      return BaseModel()..error = ServerError.withError(error: error);
    }
    return BaseModel()..data = response;
  }

  //*   GET All vehicle
  bool vehicalBrandsLoading = false;
  List<VehicalBrandName> vehicalBrands = [];
  VehicalBrandName? selectedVehicalBrand;

  Future<BaseModel<VehicalBrandResponse>> showVehicalBrands() async {
    VehicalBrandResponse response;
    try {
      selectedVehicalBrand = null;
      response = await RestClient(RetroApi().dioData()).getVehicleBrands();
      if (response.success == true) {
        if (response.data != null) {
          vehicalBrands.clear();
          vehicalBrands.addAll(response.data!);
        }
        vehicalBrandsLoading = false;
        notifyListeners();
      }
    } catch (error) {
      vehicalBrandsLoading = false;
      notifyListeners();
      return BaseModel()..error = ServerError.withError(error: error);
    }
    return BaseModel()..data = response;
  }

  //*   GET All vehicle
  bool vehicalModelLoading = false;
  List<VehicleModelsResponseData> vehicalModels = [];
  VehicleModelsResponseData? selectedVehicalModel;

  Future<BaseModel<VehicleModelsResponse>> showVehicalModels(int id) async {
    VehicleModelsResponse response;
    try {
      selectedVehicalModel = null;
      response = await RestClient(RetroApi().dioData()).getVehicleModel(id);
      if (response.success == true) {
        if (response.data != null) {
          vehicalModels.clear();
          vehicalModels.addAll(response.data!);
        }
        vehicalModelLoading = false;
        notifyListeners();
      }
    } catch (error) {
      vehicalModelLoading = false;
      notifyListeners();
      return BaseModel()..error = ServerError.withError(error: error);
    }
    return BaseModel()..data = response;
  }

  //*   ADD VEHICAL
  bool addCarLoader = false;

  Future<BaseModel<VehicalAddResponse>> addCar(
      BuildContext context, Map<String, dynamic> body) async {
    VehicalAddResponse response;
    try {
      addCarLoader = true;
      notifyListeners();
      response = await RestClient(RetroApi().dioData()).addVehicle(body);
      if (response.success == true) {
        Fluttertoast.showToast(msg: "Car Added Successfully");
        vehicles.add(response.data!);
        selectedVehicalModel = null;
        selectedVehicalBrand = null;
        if (context.mounted) Navigator.pop(context);
      }
      addCarLoader = false;
      notifyListeners();
    } catch (error) {
      addCarLoader = false;
      notifyListeners();
      return BaseModel()..error = ServerError.withError(error: error);
    }
    return BaseModel()..data = response;
  }
}
