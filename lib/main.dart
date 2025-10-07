import 'dart:io';

import 'package:carsnexus_user/Authentication/login_screen.dart';
import 'package:carsnexus_user/Authentication/provider/auth_provider.dart';
import 'package:carsnexus_user/Constants/keys_values.dart';
import 'package:carsnexus_user/Constants/preference_utility.dart';
import 'package:carsnexus_user/HomeAndOrder/provider/car_screen_provider.dart';
import 'package:carsnexus_user/HomeAndOrder/provider/home_screen_provider.dart';
import 'package:carsnexus_user/HomeAndOrder/provider/shop_services_provider.dart';
import 'package:carsnexus_user/Localization/language_localization.dart';
import 'package:carsnexus_user/Localization/localization_constant.dart';
import 'package:carsnexus_user/Profile/providers/payment_provider.dart';
import 'package:carsnexus_user/Profile/providers/profile_provider.dart';
import 'package:carsnexus_user/Routes/routes.dart';
import 'package:carsnexus_user/Theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = MyHttpOverrides();
  await SharedPreferenceUtil.getInstance();
  runApp(const MyApp());
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();

  static void setLocale(BuildContext context, Locale newLocale) {
    _MyAppState state = context.findAncestorStateOfType<_MyAppState>()!;
    state.setLocale(newLocale);
  }
}

class _MyAppState extends State<MyApp> {
  Locale? _locale;

  void setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  void didChangeDependencies() {
    getLocale().then((local) => {
          setState(() {
            _locale = local;
          })
        });
    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (_locale == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider<AuthProvider>(
            create: (context) => AuthProvider(),
          ),
          ChangeNotifierProvider<HomeScreenProvider>(
            create: (context) => HomeScreenProvider(),
          ),
          ChangeNotifierProvider<ShopServicesProvider>(
            create: (context) => ShopServicesProvider(),
          ),
          ChangeNotifierProvider<CarScreenProvider>(
            create: (context) => CarScreenProvider(),
          ),
          ChangeNotifierProvider<ProfileProvider>(
            create: (context) => ProfileProvider(),
          ),
          ChangeNotifierProvider<PaymentProvider>(
            create: (context) => PaymentProvider(),
          ),
        ],
        child: MaterialApp(
          title: 'Car-Q',
          debugShowCheckedModeBanner: false,
          theme: CustomTheme.lightTheme,
          home: const LoginScreen(),
          locale: _locale,
          supportedLocales: const [
            Locale(english, 'US'),
            Locale(arabic, 'AE'),
          ],
          localizationsDelegates: const [
            LanguageLocalization.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          localeResolutionCallback: (deviceLocal, supportedLocales) {
            for (var local in supportedLocales) {
              if (local.languageCode == deviceLocal!.languageCode &&
                  local.countryCode == deviceLocal.countryCode) {
                return deviceLocal;
              }
            }
            return supportedLocales.first;
          },
          onGenerateRoute: CustomRouter.allRoutes,
          initialRoute: SharedPreferenceUtil.getBool(PrefKey.isLoggedIn)
              ? Routes.home
              : Routes.login,
        ),
      ),
    );
  }
}
