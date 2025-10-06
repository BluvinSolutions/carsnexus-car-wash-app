import 'package:carq_user/Constants/keys_values.dart';
import 'package:carq_user/Constants/preference_utility.dart';
// ignore: depend_on_referenced_packages
import 'package:dio/dio.dart';

class RetroApi {
  Dio dioData() {
    final dio = Dio();
    dio.options.headers["Accept"] =
        "application/json"; // Config your dio headers globally
    // dio.options.headers["Authorization"] = "Bearer YOUR_TOKEN";
    dio.options.headers["Authorization"] =
        "Bearer ${SharedPreferenceUtil.getString(PrefKey.login)}";
    dio.options.followRedirects = false;
    dio.options.connectTimeout = const Duration(milliseconds: 75000); //5ss
    dio.options.receiveTimeout = const Duration(milliseconds: 75000);
    return dio;
  }
}
