// import 'package:voyzo/HomeAndOrder/provider/home_screen_provider.dart';
// import 'package:voyzo/Localization/localization_constant.dart';
// import 'package:voyzo/Theme/colors.dart';
// import 'package:voyzo/Theme/theme.dart';
// import 'package:voyzo/Widgets/app_bar_back_icon.dart';
// import 'package:voyzo/Widgets/constant_widget.dart';
// import 'package:voyzo/lang_const.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_spinkit/flutter_spinkit.dart';
// import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
// import 'package:provider/provider.dart';
//
// class AddAddressScreen extends StatefulWidget {
//   const AddAddressScreen({super.key});
//
//   @override
//   State<AddAddressScreen> createState() => _AddAddressScreenState();
// }
//
// const List<String> typeList = ['Select Type', 'Home', 'Office', 'Other'];
//
// class _AddAddressScreenState extends State<AddAddressScreen> {
//   final TextEditingController cityController = TextEditingController();
//   final TextEditingController addressLineController = TextEditingController();
//   final TextEditingController pinCodeController = TextEditingController();
//
//   String dropdownValue = typeList.first;
//
//   late HomeScreenProvider homeScreenProvider;
//
//   @override
//   void initState() {
//     homeScreenProvider =
//         Provider.of<HomeScreenProvider>(context, listen: false);
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     homeScreenProvider = Provider.of<HomeScreenProvider>(context);
//     return ModalProgressHUD(
//       inAsyncCall: homeScreenProvider.addAddressLoading,
//       opacity: 0.5,
//       progressIndicator: const SpinKitPulsingGrid(
//         color: AppColors.primary,
//         size: 50.0,
//       ),
//       child: Scaffold(
//         backgroundColor: AppColors.white,
//         appBar: AppBar(
//           leading: const AppBarBack(),
//           title: Text(getTranslated(context, LangConst.addAddress).toString()),
//         ),
//         body: SingleChildScrollView(
//           padding: const EdgeInsets.all(Amount.screenMargin),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               /// Address Line
//               const HeightBox(15),
//               TextFormField(
//                 controller: addressLineController,
//                 keyboardType: TextInputType.name,
//                 validator: (value) {
//                   if (value!.isEmpty) {
//                     return 'Please enter Address';
//                   }
//                   return null;
//                 },
//                 decoration: InputDecoration(
//                   labelText:
//                       getTranslated(context, LangConst.address).toString(),
//                 ),
//               ),
//
//               /// City
//               const HeightBox(15),
//               TextFormField(
//                 controller: cityController,
//                 keyboardType: TextInputType.name,
//                 validator: (value) {
//                   if (value!.isEmpty) {
//                     return 'Please enter City';
//                   }
//                   return null;
//                 },
//                 decoration: InputDecoration(
//                   labelText: getTranslated(context, LangConst.city).toString(),
//                 ),
//               ),
//
//               /// PinCode
//               const HeightBox(15),
//               TextFormField(
//                 controller: pinCodeController,
//                 keyboardType: TextInputType.name,
//                 validator: (value) {
//                   if (value!.isEmpty) {
//                     return 'Please enter PinCode';
//                   }
//                   return null;
//                 },
//                 inputFormatters: [
//                   FilteringTextInputFormatter.digitsOnly,
//                   LengthLimitingTextInputFormatter(6),
//                 ],
//                 decoration: InputDecoration(
//                   labelText:
//                       getTranslated(context, LangConst.pinCode).toString(),
//                 ),
//               ),
//
//               /// Type
//               const HeightBox(15),
//               FormField<String>(
//                 builder: (FormFieldState<String> state) {
//                   return InputDecorator(
//                     decoration: InputDecoration(
//                       contentPadding: const EdgeInsets.fromLTRB(12, 10, 20, 20),
//                       errorStyle: const TextStyle(
//                         color: Colors.redAccent,
//                         fontSize: 16.0,
//                       ),
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(10.0),
//                       ),
//                     ),
//                     child: DropdownButtonHideUnderline(
//                       child: DropdownButton<String>(
//                         dropdownColor: AppColors.white,
//                         icon: const Icon(Icons.keyboard_arrow_down_sharp),
//                         style: Theme.of(context).textTheme.bodyMedium!.copyWith(
//                               color: AppColors.bodyText,
//                               fontWeight: FontWeight.bold,
//                             ),
//                         hint: Text(
//                           "Select Address Type",
//                           style:
//                               Theme.of(context).textTheme.bodySmall!.copyWith(
//                                     color: AppColors.subText,
//                                     fontSize: 14,
//                                   ),
//                         ),
//                         value: dropdownValue,
//                         isExpanded: true,
//                         isDense: true,
//                         onChanged: (value) {
//                           // This is called when the user selects an item.
//                           setState(() {
//                             dropdownValue = value!;
//                           });
//                         },
//                         items: typeList
//                             .map<DropdownMenuItem<String>>((String valueItem) {
//                           return DropdownMenuItem(
//                             value: valueItem,
//                             child: Text(
//                               valueItem,
//                               style: Theme.of(context).textTheme.bodyMedium,
//                             ),
//                           );
//                         }).toList(),
//                       ),
//                     ),
//                   );
//                 },
//               ),
//
//               const HeightBox(35),
//               ElevatedButton(
//                 onPressed: () {
//                   Map<String, dynamic> body = {
//                     'line_1': addressLineController.text,
//                     'city': cityController.text,
//                     'pincode': pinCodeController.text,
//                     'type': typeList.indexOf(dropdownValue) == 1
//                         ? 0
//                         : typeList.indexOf(dropdownValue) == 2
//                             ? 1
//                             : typeList.indexOf(dropdownValue) == 3
//                                 ? 2
//                                 : 0,
//                   };
//                   if (kDebugMode) {
//                     print(body.toString());
//                   }
//                   homeScreenProvider.addAddressInList(context, body);
//                 },
//                 style: AppButtonStyle.filledMedium.copyWith(
//                   minimumSize: WidgetStatePropertyAll(
//                     Size(MediaQuery.of(context).size.width, 50),
//                   ),
//                 ),
//                 child: Text(
//                   getTranslated(context, LangConst.addAddress).toString(),
//                   style: Theme.of(context).textTheme.labelLarge!.copyWith(
//                         color: AppColors.white,
//                       ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:voyzo/HomeAndOrder/provider/home_screen_provider.dart';
import 'package:voyzo/Localization/localization_constant.dart';
import 'package:voyzo/Theme/colors.dart';
import 'package:voyzo/Theme/theme.dart';
import 'package:voyzo/Widgets/app_bar_back_icon.dart';
import 'package:voyzo/Widgets/constant_widget.dart';
import 'package:voyzo/lang_const.dart';

class AddAddressScreen extends StatefulWidget {
  const AddAddressScreen({super.key});

  @override
  State<AddAddressScreen> createState() => _AddAddressScreenState();
}

const List<String> typeList = ['Select Type', 'Home', 'Office', 'Other'];

class _AddAddressScreenState extends State<AddAddressScreen> {
  final TextEditingController _addressLineCtrl = TextEditingController();
  final TextEditingController _cityCtrl = TextEditingController();
  final TextEditingController _pinCtrl = TextEditingController();

  String _selectedType = typeList.first;
  late HomeScreenProvider _provider;

  late final WebViewController _webCtrl;
  bool _mapReady = false;

  double _lat = 22.5726; // Kolkata fallback
  double _lng = 88.3639;

  Timer? _debounceTimer;

  @override
  void initState() {
    super.initState();
    _provider = Provider.of<HomeScreenProvider>(context, listen: false);
    _initWebView();
    _getCurrentLocation();
  }

  // ───── Initialise WebView ─────
  void _initWebView() {
    _webCtrl = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (url) async {
            await _injectLeaflet();
            await _registerJsChannel();
          },
        ),
      )
      ..loadHtmlString(_leafletHtml());
  }

  // ───── Register JS Channel (Live + Final) ─────
  Future<void> _registerJsChannel() async {
    await _webCtrl.addJavaScriptChannel(
      'flutter_inject',
      onMessageReceived: (msg) async {
        final data = jsonDecode(msg.message);
        final lat = double.parse(data['lat']);
        final lng = double.parse(data['lng']);
        final isLive = data['live'] == true;

        // Always update lat/lng and show live coords
        setState(() {
          _lat = lat;
          _lng = lng;
        });

        // Only reverse-geocode on final position (not during drag)
        if (!isLive) {
          await _reverseGeocode(lat, lng);
        }
      },
    );
  }

  // ───── Leaflet HTML – Live Drag + Final Save ─────
  String _leafletHtml() {
    return '''
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<title>Leaflet Map</title>
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<link rel="stylesheet" href="https://unpkg.com/leaflet@1.9.4/dist/leaflet.css"/>
<style>
  html,body,#map{height:100%;margin:0;padding:0;}
</style>
</head>
<body>
<div id="map"></div>

<script src="https://unpkg.com/leaflet@1.9.4/dist/leaflet.js"></script>
<script>
  var map, marker;

  function init(lat, lng) {
    map = L.map('map').setView([lat, lng], 16);
    L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
      attribution: '&copy; OpenStreetMap contributors'
    }).addTo(map);

    marker = L.marker([lat, lng], {draggable:true}).addTo(map);

    // LIVE UPDATE WHILE DRAGGING
    marker.on('drag', function(e){
      var p = e.target.getLatLng();
      sendCoords(p.lat, p.lng, true); // live = true
    });

    // FINAL UPDATE WHEN DRAG ENDS
    marker.on('dragend', function(e){
      var p = e.target.getLatLng();
      sendCoords(p.lat, p.lng, false); // live = false → trigger reverse geocode
    });

    // TAP ON MAP
    map.on('click', function(e){
      marker.setLatLng(e.latlng);
      sendCoords(e.latlng.lat, e.latlng.lng, false);
    });

    sendCoords(lat, lng, false);
  }

  function sendCoords(lat, lng, live){
    if (window.flutter_inject) {
      window.flutter_inject.postMessage(JSON.stringify({
        lat: lat.toFixed(6),
        lng: lng.toFixed(6),
        live: live
      }));
    }
  }

  function moveTo(lat, lng){
    map.setView([lat, lng], 16);
    marker.setLatLng([lat, lng]);
    sendCoords(lat, lng, false);
  }
</script>
</body>
</html>
''';
  }

  // ───── Inject Leaflet ─────
  Future<void> _injectLeaflet() async {
    await Future.delayed(const Duration(milliseconds: 100));
    await _webCtrl.runJavaScript('if (typeof init === "function") init($_lat, $_lng);');
    _mapReady = true;
  }

  // ───── Move Map ─────
  Future<void> _moveMap(double lat, double lng) async {
    if (!_mapReady) return;
    await _webCtrl.runJavaScript('moveTo($lat, $lng);');
  }

  // ───── GET LOCATION + PERMISSION POPUP ─────
  Future<void> _getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      _showLocationServiceDialog();
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      permission = await Geolocator.requestPermission();

      if (permission == LocationPermission.deniedForever) {
        _showPermissionDeniedForeverDialog();
        return;
      }
      if (permission == LocationPermission.denied) {
        return;
      }
    }

    if (permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always) {
      try {
        Position pos = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
          timeLimit: const Duration(seconds: 10),
        );

        setState(() {
          _lat = pos.latitude;
          _lng = pos.longitude;
        });

        await _moveMap(_lat, _lng);
        await _reverseGeocode(_lat, _lng);
      } catch (e) {
        if (kDebugMode) print('Location error: $e');
      }
    }
  }

  // ───── Dialogs ─────
  void _showLocationServiceDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Location Service Disabled'),
        content: const Text('Please enable location to auto-fill your address.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              Geolocator.openLocationSettings();
            },
            child: const Text('Open Settings'),
          ),
        ],
      ),
    );
  }

  void _showPermissionDeniedForeverDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Permission Required'),
        content: const Text(
          'Location access is permanently denied. '
              'Go to Settings > Apps > Voyzo > Permissions to enable it.',
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              Geolocator.openAppSettings();
            },
            child: const Text('Open Settings'),
          ),
        ],
      ),
    );
  }

  // ───── Reverse Geocode (Debounced) – Only on Final Position ─────
  Future<void> _reverseGeocode(double lat, double lng) async {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 600), () async {
      final url =
          'https://nominatim.openstreetmap.org/reverse?format=json&lat=$lat&lon=$lng';
      try {
        final resp = await http.get(Uri.parse(url),
            headers: {'User-Agent': 'Voyzo-App/1.0'});
        if (resp.statusCode == 200) {
          final json = jsonDecode(resp.body);
          final addr = json['address'] ?? {};

          setState(() {
            _addressLineCtrl.text =
                addr['road'] ?? addr['suburb'] ?? addr['village'] ?? '';
            _cityCtrl.text =
                addr['city'] ?? addr['town'] ?? addr['county'] ?? '';
            _pinCtrl.text = addr['postcode'] ?? '';
          });
        }
      } catch (e) {
        if (kDebugMode) print(e);
      }
    });
  }

  // ───── UI ─────
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<HomeScreenProvider>(context);

    return ModalProgressHUD(
      inAsyncCall: provider.addAddressLoading,
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
              const Text(
                'Tap / drag the marker to set location',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              const HeightBox(8),
              SizedBox(
                height: 300,
                child: WebViewWidget(controller: _webCtrl),
              ),
              const HeightBox(20),

              // Address Line (Live update during drag)
              TextFormField(
                controller: _addressLineCtrl,
                decoration: InputDecoration(
                  labelText: getTranslated(context, LangConst.address).toString(),
                  border: const OutlineInputBorder(),
                ),
              ),
              const HeightBox(15),

              // City
              TextFormField(
                controller: _cityCtrl,
                decoration: InputDecoration(
                  labelText: getTranslated(context, LangConst.city).toString(),
                  border: const OutlineInputBorder(),
                ),
              ),
              const HeightBox(15),

              // Pincode
              TextFormField(
                controller: _pinCtrl,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(6),
                ],
                decoration: InputDecoration(
                  labelText: getTranslated(context, LangConst.pinCode).toString(),
                  border: const OutlineInputBorder(),
                ),
              ),
              const HeightBox(15),

              // Dropdown – White background
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey.shade400),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _selectedType,
                    isExpanded: true,
                    icon: const Icon(Icons.keyboard_arrow_down, color: Colors.black54),
                    dropdownColor: Colors.white,
                    style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
                    items: typeList
                        .map((e) => DropdownMenuItem(
                      value: e,
                      child: Text(e),
                    ))
                        .toList(),
                    onChanged: (v) => setState(() => _selectedType = v!),
                  ),
                ),
              ),
              const HeightBox(35),

              // Save Button
              ElevatedButton(
                onPressed: _saveAddress,
                style: AppButtonStyle.filledMedium.copyWith(
                  minimumSize: WidgetStatePropertyAll(
                    Size(MediaQuery.of(context).size.width, 50),
                  ),
                ),
                child: Text(
                  getTranslated(context, LangConst.addAddress).toString(),
                  style: Theme.of(context)
                      .textTheme
                      .labelLarge!
                      .copyWith(color: AppColors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ───── Save Address ─────
  void _saveAddress() {
    if (_selectedType == typeList.first) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select address type')),
      );
      return;
    }

    final int typeInt = typeList.indexOf(_selectedType) == 1
        ? 0
        : typeList.indexOf(_selectedType) == 2
        ? 1
        : 2;

    final Map<String, dynamic> body = {
      'line_1': _addressLineCtrl.text.trim(),
      'city': _cityCtrl.text.trim(),
      'pincode': _pinCtrl.text.trim(),
      'type': typeInt,
      'latitude': _lat,
      'longitude': _lng,
    };

    if (kDebugMode) print('Payload → $body');

    _provider.addAddressInList(context, body);
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _addressLineCtrl.dispose();
    _cityCtrl.dispose();
    _pinCtrl.dispose();
    super.dispose();
  }
}
