import 'dart:io';

import 'package:voyzo/Network/api_connection_test_response_model.dart';
import 'package:voyzo/Network/api_service.dart';
import 'package:voyzo/Network/apis.dart';
import 'package:voyzo/Network/retrofit.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    'Check pattern of baseUrl in Apis',
    () {
      // Define the regex pattern for the URL
      var pattern1 = RegExp(r'^https:\/\/.*\/api\/user\/$');
      var pattern2 = RegExp(r'^http:\/\/.*\/api\/user\/$');

      // Check if the baseUrl matches the pattern
      expect(
        ((pattern1.hasMatch(ApiKeys.siteUrl) ||
                pattern2.hasMatch(ApiKeys.siteUrl)) &&
            ApiKeys.siteUrl != "https://voyzo.in/api/user/"),
        isTrue,
        reason: 'The baseUrl does not match the required pattern',
      );
    },
  );

  test(
    'api_services.g.dart file exists',
    () {
      var filePath = 'lib/Network/api_service.g.dart';

      // Check if the file exists
      expect(File(filePath).existsSync(), isTrue,
          reason: 'api_service.g.dart file does not exist/\n'
              'Please run the command: flutter pub run build_runner build --delete-conflicting-outputs');
    },
  );

  test(
    'Check if [ApiKeys.settings] endpoint is giving response',
    () async {
      ApiConnectionTestResponse response;
      response = await RestClient(RetroApi().dioData()).apiConnectionTest();
      expect(response.success, true,
          reason:
              'The response from /${ApiKeys.apiConnectionTest} is not successful');
    },
  );
}
