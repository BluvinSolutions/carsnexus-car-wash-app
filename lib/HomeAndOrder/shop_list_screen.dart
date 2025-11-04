// import 'package:voyzo/HomeAndOrder/provider/shop_services_provider.dart';
// import 'package:voyzo/Localization/localization_constant.dart';
// import 'package:voyzo/Theme/colors.dart';
// import 'package:voyzo/Theme/theme.dart';
// import 'package:voyzo/Widgets/app_bar_back_icon.dart';
// import 'package:voyzo/Widgets/constant_widget.dart';
// import 'package:voyzo/Widgets/shop_list_tile_widget.dart';
// import 'package:voyzo/lang_const.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_spinkit/flutter_spinkit.dart';
// import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
// import 'package:provider/provider.dart';
//
// class ShopListScreen extends StatefulWidget {
//   final bool isBestShop;
//   final int? serviceId;
//
//   const ShopListScreen({
//     super.key,
//     required this.isBestShop,
//     this.serviceId,
//   });
//
//   @override
//   State<ShopListScreen> createState() => _ShopListScreenState();
// }
//
// class _ShopListScreenState extends State<ShopListScreen> {
//   late ShopServicesProvider shopServicesProvider;
//
//   @override
//   void initState() {
//     shopServicesProvider =
//         Provider.of<ShopServicesProvider>(context, listen: false);
//     if (widget.isBestShop) {
//       shopServicesProvider.getListOfShops();
//       shopServicesProvider.loading = true;
//     } else {
//       shopServicesProvider.showService(widget.serviceId!);
//       shopServicesProvider.serviceDetailsLoading = true;
//     }
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     shopServicesProvider = Provider.of<ShopServicesProvider>(context);
//     return ModalProgressHUD(
//       inAsyncCall: shopServicesProvider.loading ||
//           shopServicesProvider.serviceDetailsLoading,
//       opacity: 0.5,
//       progressIndicator: const SpinKitPulsingGrid(
//         color: AppColors.primary,
//         size: 50.0,
//       ),
//       child: Scaffold(
//         backgroundColor: AppColors.white,
//         appBar: AppBar(
//           leading: const AppBarBack(),
//           title: Text(
//             getTranslated(context, LangConst.bestShops).toString(),
//           ),
//         ),
//         body: ListView.separated(
//           separatorBuilder: (context, index) => const HeightBox(15),
//           itemCount: widget.isBestShop
//               ? shopServicesProvider.shopList.length
//               : shopServicesProvider.serviceShopList.length,
//           shrinkWrap: true,
//           padding: const EdgeInsets.only(
//             left: Amount.screenMargin,
//             right: Amount.screenMargin,
//             top: Amount.screenMargin,
//             bottom: Amount.screenMargin,
//           ),
//           physics: const NeverScrollableScrollPhysics(),
//           itemBuilder: (context, index) {
//             return ShopListTileWidget(
//               items: widget.isBestShop
//                   ? shopServicesProvider.shopList[index]
//                   : shopServicesProvider.serviceShopList[index],
//             );
//           },
//         ),
//       ),
//     );
//   }
// }

// lib/Screens/shop_list_screen.dart
import 'dart:convert';
import 'dart:math' show cos, sqrt, asin, pi, sin;

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:geolocator/geolocator.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'package:voyzo/HomeAndOrder/provider/shop_services_provider.dart';
import 'package:voyzo/Localization/localization_constant.dart';
import 'package:voyzo/Theme/colors.dart';
import 'package:voyzo/Theme/theme.dart';
import 'package:voyzo/Widgets/app_bar_back_icon.dart';
import 'package:voyzo/Widgets/constant_widget.dart';
import 'package:voyzo/Widgets/shop_list_tile_widget.dart';
import 'package:voyzo/lang_const.dart';

import 'model/shop_with_distance.dart';

class ShopListScreen extends StatefulWidget {
  final bool isBestShop;
  final int? serviceId;

  const ShopListScreen({
    super.key,
    required this.isBestShop,
    this.serviceId,
  });

  @override
  State<ShopListScreen> createState() => _ShopListScreenState();
}

class _ShopListScreenState extends State<ShopListScreen> {
  late ShopServicesProvider _provider;

  // Location & Radius
  double? _selectedLat;
  double? _selectedLng;
  double _radiusKm = 5.0;

  // Map
  late final WebViewController _webCtrl;
  bool _mapReady = false;

  @override
  void initState() {
    super.initState();
    _provider = Provider.of<ShopServicesProvider>(context, listen: false);

    if (widget.isBestShop) {
      _provider.getListOfShops();
      _provider.loading = true;
    } else {
      _provider.showService(widget.serviceId!);
      _provider.serviceDetailsLoading = true;
    }

    _initWebView();
    _getCurrentLocation();
  }

  // Safe translation helper
  String tr(String key) => getTranslated(context, key).toString();

  void _initWebView() {
    _webCtrl = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (_) async {
            await _injectLeaflet();
            await _registerJsChannel();
          },
        ),
      )
      ..loadHtmlString(_leafletHtml());
  }

  Future<void> _registerJsChannel() async {
    await _webCtrl.addJavaScriptChannel(
      'flutter_inject',
      onMessageReceived: (msg) async {
        final data = jsonDecode(msg.message);
        final lat = double.parse(data['lat']);
        final lng = double.parse(data['lng']);
        final isLive = data['live'] == true;

        setState(() {
          _selectedLat = lat;
          _selectedLng = lng;
        });

        if (isLive) await _drawRadiusCircle(lat, lng, _radiusKm);
      },
    );
  }

  String _leafletHtml() {
    return '''
<!DOCTYPE html><html><head><meta charset="utf-8"><title>Leaflet</title>
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<link rel="stylesheet" href="https://unpkg.com/leaflet@1.9.4/dist/leaflet.css"/>
<style>html,body,#map{height:100%;margin:0;padding:0;}</style>
</head><body><div id="map"></div>
<script src="https://unpkg.com/leaflet@1.9.4/dist/leaflet.js"></script>
<script>
var map, marker, circle;
function init(lat,lng,radius){
  map=L.map('map').setView([lat,lng],13);
  L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png').addTo(map);
  marker=L.marker([lat,lng],{draggable:true}).addTo(map);
  circle=L.circle([lat,lng],{radius:radius*1000,color:'#3388ff',fillOpacity:0.15}).addTo(map);
  marker.on('drag', e => { const p=e.target.getLatLng(); send(p.lat,p.lng,true); });
  marker.on('dragend', e => { const p=e.target.getLatLng(); send(p.lat,p.lng,false); });
  map.on('click', e => { marker.setLatLng(e.latlng); send(e.latlng.lat,e.latlng.lng,false); });
  send(lat,lng,false);
}
function send(lat,lng,live){
  if(window.flutter_inject)
    window.flutter_inject.postMessage(JSON.stringify({lat:lat.toFixed(6),lng:lng.toFixed(6),live:live}));
}
function move(lat,lng,radius){
  map.setView([lat,lng],13);
  marker.setLatLng([lat,lng]);
  circle.setLatLng([lat,lng]);
  circle.setRadius(radius*1000);
  send(lat,lng,false);
}
</script></body></html>
''';
  }

  Future<void> _injectLeaflet() async {
    await Future.delayed(const Duration(milliseconds: 120));
    final lat = _selectedLat ?? 22.5726;
    final lng = _selectedLng ?? 88.3639;
    await _webCtrl.runJavaScript('if(typeof init==="function") init($lat,$lng,$_radiusKm);');
    _mapReady = true;
  }

  Future<void> _drawRadiusCircle(double lat, double lng, double radiusKm) async {
    if (!_mapReady) return;
    await _webCtrl.runJavaScript('move($lat,$lng,$radiusKm);');
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return;

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return;
    }
    if (permission == LocationPermission.deniedForever) return;

    try {
      final pos = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      setState(() {
        _selectedLat = pos.latitude;
        _selectedLng = pos.longitude;
      });
      await _drawRadiusCircle(_selectedLat!, _selectedLng!, _radiusKm);
    } catch (_) {}
  }

  List<ShopWithDistance> _filteredShops() {
    if (_selectedLat == null || _selectedLng == null) return [];

    final List<dynamic> source = widget.isBestShop ? _provider.shopList : _provider.serviceShopList;
    final List<ShopWithDistance> result = [];

    for (final shop in source) {
      final double? shopLat = shop.latitude;
      final double? shopLng = shop.longitude;
      if (shopLat == null || shopLng == null) continue;

      final distance = _haversine(_selectedLat!, _selectedLng!, shopLat, shopLng);
      if (distance <= _radiusKm) {
        result.add(ShopWithDistance(shop, distance));
      }
    }

    result.sort((a, b) => a.distanceKm.compareTo(b.distanceKm));
    return result;
  }

  double _haversine(double lat1, double lon1, double lat2, double lon2) {
    const R = 6372.8;
    final dLat = _toRad(lat2 - lat1);
    final dLon = _toRad(lon2 - lon1);
    final a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_toRad(lat1)) * cos(_toRad(lat2)) * sin(dLon / 2) * sin(dLon / 2);
    final c = 2 * asin(sqrt(a));
    return R * c;
  }

  double _toRad(double deg) => deg * pi / 180;

  void _openLocationPicker() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _LocationRadiusPicker(
        initialLat: _selectedLat ?? 22.5726,
        initialLng: _selectedLng ?? 88.3639,
        initialRadius: _radiusKm,
        webCtrl: _webCtrl,
        onConfirm: (lat, lng, radius) {
          setState(() {
            _selectedLat = lat;
            _selectedLng = lng;
            _radiusKm = radius;
          });
          Navigator.pop(context);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    _provider = Provider.of<ShopServicesProvider>(context);
    final filtered = _filteredShops();

    return ModalProgressHUD(
      inAsyncCall: _provider.loading || _provider.serviceDetailsLoading,
      opacity: 0.5,
      progressIndicator: const SpinKitPulsingGrid(color: AppColors.primary, size: 50.0),
      child: Scaffold(
        backgroundColor: AppColors.white,
        appBar: AppBar(
          leading: const AppBarBack(),
          title: Text(tr(LangConst.bestShops)),
          actions: [
            IconButton(
              icon: const Icon(Icons.location_on, color: AppColors.primary),
              tooltip: tr(LangConst.tapToAdjust),
              onPressed: _openLocationPicker,
            ),
          ],
        ),
        body: _selectedLat == null
            ? Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.location_searching, size: 64, color: AppColors.subText.withOpacity(0.6)),
              const HeightBox(16),
              Text(
                tr(LangConst.searchingLocation),
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.subText,
                ),
                textAlign: TextAlign.center,
              ),
              const HeightBox(8),
              Text(
                tr(LangConst.enableLocationHint),
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.subText),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        )
            : filtered.isEmpty
            ? Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.location_off, size: 64, color: AppColors.subText.withOpacity(0.6)),
                const HeightBox(16),
                Text(
                  tr(LangConst.noShopsInArea),
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.subText,
                  ),
                  textAlign: TextAlign.center,
                ),
                const HeightBox(8),
                Text(
                  tr(LangConst.increaseRadiusHint),
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.subText),
                  textAlign: TextAlign.center,
                ),
                const HeightBox(20),
                GestureDetector(
                  onTap: _openLocationPicker,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.primary.withOpacity(0.3)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.location_on, color: AppColors.primary, size: 20),
                        const WidthBox(8),
                        Text(
                          tr(LangConst.tapToAdjust),
                          style: const TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        )
            : ListView.separated(
          separatorBuilder: (_, __) => const HeightBox(15),
          itemCount: filtered.length,
          padding: const EdgeInsets.all(Amount.screenMargin),
          itemBuilder: (context, index) {
            final shop = filtered[index].shop;
            final distance = filtered[index].distanceKm;
            return ShopListTileWidget(
              items: shop,
              trailingDistance: '${distance.toStringAsFixed(1)} km',
            );
          },
        ),
      ),
    );
  }
}

// MODAL PICKER
class _LocationRadiusPicker extends StatefulWidget {
  final double initialLat, initialLng, initialRadius;
  final WebViewController webCtrl;
  final void Function(double, double, double) onConfirm;

  const _LocationRadiusPicker({
    required this.initialLat,
    required this.initialLng,
    required this.initialRadius,
    required this.webCtrl,
    required this.onConfirm,
  });

  @override
  State<_LocationRadiusPicker> createState() => _LocationRadiusPickerState();
}

class _LocationRadiusPickerState extends State<_LocationRadiusPicker> {
  late double _lat = widget.initialLat;
  late double _lng = widget.initialLng;
  late double _radius = widget.initialRadius;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await widget.webCtrl.runJavaScript('if(typeof init==="function") init($_lat,$_lng,$_radius);');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Select Area', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
              ],
            ),
          ),
          Expanded(
            flex: 3,
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              child: WebViewWidget(controller: widget.webCtrl),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Radius: ${_radius.toStringAsFixed(0)} km', style: const TextStyle(fontWeight: FontWeight.w500)),
                Slider(
                  min: 1,
                  max: 20,
                  divisions: 19,
                  value: _radius,
                  onChanged: (v) async {
                    setState(() => _radius = v);
                    await widget.webCtrl.runJavaScript('if(circle) circle.setRadius(${v * 1000});');
                  },
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: ElevatedButton(
              style: AppButtonStyle.filledMedium.copyWith(
                minimumSize: const WidgetStatePropertyAll(Size(double.infinity, 50)),
              ),
              onPressed: () => widget.onConfirm(_lat, _lng, _radius),
              child: const Text('Apply', style: TextStyle(color: AppColors.white)),
            ),
          ),
        ],
      ),
    );
  }
}
