import 'package:buslink_flutter/Bindings/GlobalBinding.dart';
import 'package:buslink_flutter/Services/Api.dart';
import 'package:buslink_flutter/Views/Notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
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
  try {
    await dotenv.load(fileName: ".env"); // Load environment variables
  } catch (e) {
    throw Exception('Error loading .env file: $e'); // Print error if any
  }

  await GetStorage.init();
  await NotificationService.init();
  await Firebase.initializeApp();
  NotificationService.initFCM();
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
