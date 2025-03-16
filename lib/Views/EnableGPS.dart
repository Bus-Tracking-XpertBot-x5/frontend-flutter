import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:buslink_flutter/Utils/GeoLocator.dart';

class EnableGPSPage extends StatefulWidget {
  const EnableGPSPage({super.key});

  @override
  _EnableGPSPageState createState() => _EnableGPSPageState();
}

class _EnableGPSPageState extends State<EnableGPSPage> with GeoLocator {
  late String locationMessage = "";

  Future<void> _getLocation() async {
    try {
      Position position = await determinePosition();
      setState(() {
        locationMessage =
            "Lat: ${position.latitude}, Long: ${position.longitude}";
      });
    } catch (e) {
      setState(() {
        locationMessage = "Error: $e";
      });
      // Check if the error is related to permissions being denied
      if (e.toString().toLowerCase().contains('denied')) {
        Get.defaultDialog(
          titlePadding: EdgeInsets.only(top: 26),
          contentPadding: EdgeInsets.only(bottom: 26),
          title: 'Location Access Required',
          middleText:
          'This app needs access to your location. Please enable location permissions from your app settings.',
          textConfirm: 'Open Settings',
          onConfirm: () async {
            await Geolocator.openAppSettings();
            Get.back();
          },
          textCancel: 'Cancel',

        );
      }
    } finally {
      print(locationMessage);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          // Image Section
          const SizedBox(height: 120),
          Flexible(
            flex: 5,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Image.asset(
                'images/enable-gps.png',
                fit: BoxFit.contain,
                height: MediaQuery.of(context).size.height * 0.4,
              ),
            ),
          ),
          // Text Section
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                'Enable GPS Location',
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Text(
                locationMessage,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 14, color: Colors.red),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.only(bottom: 20, right: 20, left: 20),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _getLocation,
                child: const Text('Enable to Continue', style: TextStyle(fontSize: 16)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
