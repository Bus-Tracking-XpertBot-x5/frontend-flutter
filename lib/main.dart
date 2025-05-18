import 'package:buslink_flutter/Bindings/GlobalBinding.dart';
import 'package:buslink_flutter/Services/Api.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:buslink_flutter/Utils/Theme.dart';
import 'Routes/AppRoutes.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<Position?> _checkLocationPermissionAndService() async {
  if (!await Geolocator.isLocationServiceEnabled()) {
    await Geolocator.openLocationSettings();
    return null;
  }
  var permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) return null;
  }
  if (permission == LocationPermission.deniedForever) {
    await Geolocator.openAppSettings();
    return null;
  }
  return Geolocator.getCurrentPosition();
}

void main() async {
  await dotenv.load();

  print("📍 Google Maps API Key: ${dotenv.env['GOOGLE_MAPS_API_KEY']}");

  await GetStorage.init();
  _checkLocationPermissionAndService();
  Api.initializeInterceptors();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      transitionDuration: const Duration(milliseconds: 300),
      initialBinding: GlobalBinding(),
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      initialRoute: AppRoutes.splash,
      getPages: AppRoutes.routes,
    );
  }
}
