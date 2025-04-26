import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class BusLocationsPage extends StatefulWidget {
  @override
  _BusLocationsPageState createState() => _BusLocationsPageState();
}

class _BusLocationsPageState extends State<BusLocationsPage> {
  late final MapController _mapController;
  LatLng _currentLocation = LatLng(33.8938, 35.5018); // Beirut, Lebanon
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    _requestLocationPermission();
  }

  Future<void> _requestLocationPermission() async {
    var status = await Permission.location.request();
    if (status.isGranted) {
      _getLiveLocation();
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Location permission denied.")));
    }
  }

  void _getLiveLocation() {
    Geolocator.getPositionStream(
      locationSettings: LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10, // Updates when user moves 10 meters
      ),
    ).listen((Position position) {
      setState(() {
        _currentLocation = LatLng(position.latitude, position.longitude);
        _loading = false;
        _mapController.move(_currentLocation, 16.0);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Live GPS Map (Free API)")),
      body:
          false
              ? Center(child: CircularProgressIndicator())
              : FlutterMap(
                mapController: _mapController,
                options: MapOptions(
                  initialCenter: _currentLocation,
                  initialZoom: 16.0,
                ),
                children: [
                  TileLayer(
                    urlTemplate:
                        'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                    subdomains: ['a', 'b', 'c'],
                  ),
                  MarkerLayer(
                    markers: [
                      Marker(
                        point: _currentLocation,
                        width: 50,
                        height: 50,
                        child: Icon(
                          Icons.location_pin,
                          size: 50,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
    );
  }
}
