import 'package:dio/dio.dart' hide Headers;
import 'package:flutter/foundation.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ServerError implements Exception {
  int? _errorCode;
  final String _errorMessage = "";

  ServerError.withError({error}) {
    _handleError(error);
  }

  getErrorCode() {
    return _errorCode;
  }

  getErrorMessage() {
    return _errorMessage;
  }

  _handleError(DioException error) {
    // If response is available, handle response-based errors
    if (error.response != null) {
      final statusCode = error.response!.statusCode;
      final errorMsg =
          error.response!.data?['msg']?.toString() ?? "Unknown error";

      if (statusCode == 401) {
        return Fluttertoast.showToast(msg: errorMsg);
      } else if (error.type == DioExceptionType.badResponse) {
        if (kDebugMode) print(errorMsg);
        return Fluttertoast.showToast(msg: errorMsg);
      } else if (error.type == DioExceptionType.unknown) {
        if (kDebugMode) print(errorMsg);
        return Fluttertoast.showToast(msg: errorMsg);
      } else if (error.type == DioExceptionType.badCertificate) {
        if (kDebugMode) print(errorMsg);
        return Fluttertoast.showToast(msg: errorMsg);
      }
    }

    // Handle cases with no response or specific error types
    if (error.type == DioExceptionType.cancel) {
      if (kDebugMode) print('Request was cancelled');
      return Fluttertoast.showToast(msg: 'Request was cancelled');
    } else if (error.type == DioExceptionType.connectionError) {
      if (kDebugMode)
        print('Connection failed. Please check internet connection');
      return Fluttertoast.showToast(
          msg: 'Connection failed. Please check internet connection');
    } else if (error.type == DioExceptionType.connectionTimeout) {
      if (kDebugMode) print('Connection timeout');
      return Fluttertoast.showToast(msg: 'Connection timeout');
    } else if (error.type == DioExceptionType.receiveTimeout) {
      if (kDebugMode) print('Receive timeout in connection');
      return Fluttertoast.showToast(msg: 'Receive timeout in connection');
    } else if (error.type == DioExceptionType.sendTimeout) {
      if (kDebugMode) print('Receive timeout in send request');
      return Fluttertoast.showToast(msg: 'Receive timeout in send request');
    }

    // Default fallback error message if none matched
    return Fluttertoast.showToast(msg: 'An unexpected error occurred.');
  }
}
