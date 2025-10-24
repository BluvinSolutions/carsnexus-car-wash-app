import 'package:voyzo/HomeAndOrder/model/book_slot_response.dart';
import 'package:voyzo/HomeAndOrder/model/category_response.dart';
import 'package:voyzo/HomeAndOrder/model/home_screen_response.dart';
import 'package:voyzo/HomeAndOrder/model/shop_count_response.dart';
import 'package:voyzo/HomeAndOrder/model/shop_details_response.dart';
import 'package:voyzo/HomeAndOrder/model/shop_list_response.dart';
import 'package:voyzo/Network/api_service.dart';
import 'package:voyzo/Network/base_model.dart';
import 'package:voyzo/Network/retrofit.dart';
import 'package:voyzo/Network/server_error.dart';
import 'package:flutter/foundation.dart';

class ShopServicesProvider extends ChangeNotifier {
  List<Services> services = [];
  List<PopularServices> popularServiceCenter = [];
  List<BestShops> bestShops = [];
  List<Services> searchServices = [];
  List<BestShops> searchBestShops = [];

  //*   GET List Of All Shops
  bool loading = false;
  List<BestShops> shopList = [];

  Future<BaseModel<ShopListResponse>> getListOfShops() async {
    ShopListResponse response;
    try {
      response = await RestClient(RetroApi().dioData()).getShopList();
      if (response.success == true) {
        shopList.clear();
        if (response.data != null) {
          shopList.addAll(response.data!);
        }
      }
      loading = false;
      notifyListeners();
    } catch (error) {
      loading = false;
      notifyListeners();
      return BaseModel()..error = ServerError.withError(error: error);
    }
    return BaseModel()..data = response;
  }

  onSearchTextChanged(String text) async {
    searchServices.clear();
    searchBestShops.clear();
    for (int i = 0; i < services.length; i++) {
      Services data = services[i];
      if (data.name.toString().toLowerCase().contains(text.toLowerCase())) {
        searchServices.add(data);
      }
    }
    for (int i = 0; i < bestShops.length; i++) {
      BestShops data = bestShops[i];
      if (data.name.toString().toLowerCase().contains(text.toLowerCase()) ||
          data.address.toString().toLowerCase().contains(text.toLowerCase())) {
        searchBestShops.add(data);
      }
    }
    notifyListeners();
  }

  //*   GET Shop Details
  ShopDetailsData? shopDetails;
  bool shopLoading = false;

  Future<BaseModel<ShopDetails>> getShop(int id) async {
    ShopDetails response;
    try {
      shopDetails = null;
      response = await RestClient(RetroApi().dioData()).getShopDetails(id);
      if (response.success == true) {
        if (response.data != null) {
          shopDetails = response.data!;
        }
      }
      shopLoading = false;
      notifyListeners();
    } catch (error) {
      shopLoading = false;
      notifyListeners();
      return BaseModel()..error = ServerError.withError(error: error);
    }
    return BaseModel()..data = response;
  }

  //*   GET Shop Details
  ShopCountResponseData? shopInfo;
  bool shopCountLoading = false;

  Future<BaseModel<ShopCountResponse>> getShopCount() async {
    ShopCountResponse response;
    try {
      shopInfo = null;
      response = await RestClient(RetroApi().dioData()).shopCounting();
      if (response.success == true) {
        if (response.data != null) {
          shopInfo = response.data!;
        }
      }
      shopCountLoading = false;
      notifyListeners();
    } catch (error) {
      shopCountLoading = false;
      notifyListeners();
      return BaseModel()..error = ServerError.withError(error: error);
    }
    return BaseModel()..data = response;
  }

  //*   GET HOME SCREEN
  bool homeScreenLoading = false;

  Future<BaseModel<HomeScreenResponse>> homeScreen() async {
    HomeScreenResponse response;
    try {
      response = await RestClient(RetroApi().dioData()).getHomeScreen();
      if (response.success == true) {
        if (response.data != null) {
          services.clear();
          popularServiceCenter.clear();
          bestShops.clear();

          services.addAll(response.data!.category!);
          popularServiceCenter.addAll(response.data!.popular!);
          bestShops.addAll(response.data!.best!);
        }
      }
      homeScreenLoading = false;
      notifyListeners();
    } catch (error) {
      homeScreenLoading = false;
      notifyListeners();
      return BaseModel()..error = ServerError.withError(error: error);
    }
    return BaseModel()..data = response;
  }

  //*   GET SERVICE DETAILS
  bool serviceDetailsLoading = false;
  List<BestShops> serviceShopList = [];

  Future<BaseModel<CategoryResponse>> showService(int id) async {
    CategoryResponse response;
    try {
      response = await RestClient(RetroApi().dioData()).getServiceDetails(id);
      serviceShopList.clear();
      if (response.success == true) {
        if (response.data != null) {
          serviceShopList.addAll(response.data!);
        }
      }
      serviceDetailsLoading = false;
      notifyListeners();
    } catch (error) {
      serviceDetailsLoading = false;
      notifyListeners();
      return BaseModel()..error = ServerError.withError(error: error);
    }
    return BaseModel()..data = response;
  }

  //*   BOOK LOADING
  bool bookingLoading = false;

  Future<BaseModel<BookSlot>> bookSlot(Map<String, dynamic> body) async {
    BookSlot response;
    try {
      bookingLoading = true;
      notifyListeners();
      if (kDebugMode) {
        print(body);
      }
      response = await RestClient(RetroApi().dioData()).booking(body);
      if (response.success == true) {
        if (kDebugMode) {
          print('DONE');
        }
      }
      bookingLoading = false;
      notifyListeners();
    } catch (error) {
      bookingLoading = false;
      notifyListeners();
      return BaseModel()..error = ServerError.withError(error: error);
    }
    return BaseModel()..data = response;
  }
}
