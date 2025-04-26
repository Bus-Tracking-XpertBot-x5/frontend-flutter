import 'dart:async';

import 'package:buslink_flutter/Controllers/ViewSingleTripController.dart';
import 'package:buslink_flutter/Models/PassengerBoardingModel.dart';
import 'package:buslink_flutter/Models/BusMovementModel.dart';
import 'package:buslink_flutter/Utils/Dialog.dart';
import 'package:buslink_flutter/Utils/GlobalFunctions.dart';
import 'package:buslink_flutter/Utils/Theme.dart';
import 'package:buslink_flutter/Widgets/MyAppBar.dart';
import 'package:buslink_flutter/Widgets/MyBottomNavbar.dart';
import 'package:buslink_flutter/Widgets/MyHeader.dart';
import 'package:buslink_flutter/Widgets/MyTripCard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ViewSingleTripPage extends StatefulWidget {
  const ViewSingleTripPage({super.key});

  @override
  State<ViewSingleTripPage> createState() => _ViewSingleTripPageState();
}

class _ViewSingleTripPageState extends State<ViewSingleTripPage>
    with GlobalFunctions {
  final controller = Get.find<ViewSingleTripController>();
  GoogleMapController? _mapController;
  bool _mapCreated = false;
  bool _mapLoaded = false;
  bool _routeDrawn = false;

  bool get _isPageReady => _mapCreated && _mapLoaded && _routeDrawn;

  final Set<Marker> _markers = {};
  final Set<Polyline> _polylines = {};
  BitmapDescriptor? _driverIcon;
  StreamSubscription<Position>? _positionStream;
  final TextEditingController _boardingSearchController =
      TextEditingController();
  RxString selectedBoardingFilter = "All".obs;
  final loadingPassengerBoardingIds = <int>{};

  @override
  void initState() {
    super.initState();
    _loadCustomDriverIcon();
  }

  @override
  void dispose() {
    _positionStream?.cancel();
    _boardingSearchController.dispose();
    _mapController?.dispose();
    super.dispose();
  }

  Future<void> _loadCustomDriverIcon() async {
    final bitmap = await BitmapDescriptor.asset(
      ImageConfiguration(size: Size(120, 62)),
      "images/driver-logo.png",
    );
    if (!mounted) return;
    setState(() => _driverIcon = bitmap);
  }

  Future<void> _onMapCreated(GoogleMapController mapCtrl) async {
    await _onMapLoaded();
    if (_mapCreated) return;
    _mapCreated = true;
    _mapController = mapCtrl;
    setState(() {});
  }

  Future<void> _onMapLoaded() async {
    if (_mapLoaded) return;
    _mapLoaded = true;
    await _startJourney();
    setState(() {});
  }

  Future<void> _startJourney() async {
    final pos = await _checkLocationPermissionAndService();
    if (pos == null) return;
    controller.driverCurrentLocation = LatLng(pos.latitude, pos.longitude);
    setState(() {
      _markers.addAll(_createMarkers(controller.trip!));
    });
    final routePoints = [
      controller.driverCurrentLocation!,
      ..._getPassengerLocations(controller.trip!),
    ];
    await _drawRoute(routePoints);
    if (!mounted) return;
    setState(() {
      _routeDrawn = true;
    });
    _trackDriverLocation();
  }

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

  Future<void> _trackDriverLocation() async {
    _positionStream?.cancel();
    _positionStream = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
    ).listen((pos) {
      if (!mounted) return;
      controller.driverCurrentLocation = LatLng(pos.latitude, pos.longitude);
      setState(() {
        _markers
          ..removeWhere((m) => m.markerId.value == 'driver')
          ..add(
            Marker(
              markerId: const MarkerId('driver'),
              position: controller.driverCurrentLocation!,
              icon: _driverIcon ?? BitmapDescriptor.defaultMarker,
              infoWindow: const InfoWindow(title: 'Driver Location'),
            ),
          );
      });
      _mapController?.animateCamera(
        CameraUpdate.newLatLng(controller.driverCurrentLocation!),
      );
    });
  }

  Future<void> _drawRoute(List<LatLng> points) async {
    final polylinePoints = PolylinePoints();
    final coords = <LatLng>[];
    for (var i = 0; i < points.length - 1; i++) {
      final result = await polylinePoints.getRouteBetweenCoordinates(
        request: PolylineRequest(
          origin: PointLatLng(points[i].latitude, points[i].longitude),
          destination: PointLatLng(
            points[i + 1].latitude,
            points[i + 1].longitude,
          ),
          mode: TravelMode.driving,
        ),
        googleApiKey: dotenv.env['GOOGLE_MAPS_API_KEY'],
      );
      if (result.status == 'OK') {
        coords.addAll(
          result.points.map((p) => LatLng(p.latitude, p.longitude)),
        );
      }
    }
    if (!mounted || coords.isEmpty) return;
    setState(() {
      _polylines
        ..clear()
        ..add(
          Polyline(
            polylineId: const PolylineId('route'),
            color: AppTheme.lightTheme.primaryColor,
            width: 5,
            points: coords,
          ),
        );
    });
  }

  List<LatLng> _getPassengerLocations(BusMovementModel trip) {
    return (trip.passengerBoardings ?? [])
        .where((b) => b.user?.latitude != null && b.user?.longitude != null)
        .map((b) => LatLng(b.user!.latitude!, b.user!.longitude!))
        .toList();
  }

  Set<Marker> _createMarkers(BusMovementModel trip) {
    final m = <Marker>{};
    if (controller.driverCurrentLocation != null && _driverIcon != null) {
      m.add(
        Marker(
          markerId: const MarkerId('driver'),
          position: controller.driverCurrentLocation!,
          icon: _driverIcon!,
          infoWindow: const InfoWindow(title: 'Driver Location'),
        ),
      );
    }
    for (var i = 0; i < (trip.passengerBoardings ?? []).length; i++) {
      final b = trip.passengerBoardings![i];
      if (b.user?.latitude != null && b.user?.longitude != null) {
        m.add(
          Marker(
            markerId: MarkerId('passenger_$i'),
            position: LatLng(b.user!.latitude!, b.user!.longitude!),
            icon: BitmapDescriptor.defaultMarkerWithHue(
              BitmapDescriptor.hueRed,
            ),
            infoWindow: InfoWindow(title: b.user!.name),
          ),
        );
      }
    }
    return m;
  }

  Color _getPassengerBoardingStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'boarded':
        return const Color(0xFF10B981);
      case 'pending':
        return const Color(0xFFF59E0B);
      case 'missed':
        return const Color(0xFFEF4444);
      default:
        return const Color(0xFF3B82F6);
    }
  }

  Widget _buildPassengerBoardingSearchBar(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _boardingSearchController,
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.search_rounded, color: Colors.grey[500]),
              hintText: 'Search passengers...',
            ),
            onChanged: (value) async {
              await controller.loadPassengerBoardings(
                search: _boardingSearchController.text.trim(),
                statusFilter: selectedBoardingFilter.value.toLowerCase(),
              );
              setState(() {});
            },
          ),
        ),
        const SizedBox(width: 12),
        DropdownButton<String>(
          value: selectedBoardingFilter.value,
          onChanged: (newValue) async {
            selectedBoardingFilter.value = newValue!;
            await controller.loadPassengerBoardings(
              search: _boardingSearchController.text.trim(),
              statusFilter: selectedBoardingFilter.value.toLowerCase(),
            );
            setState(() {});
          },
          items:
              ["All", "Scheduled", "Boarded", "Missed"]
                  .map(
                    (value) =>
                        DropdownMenuItem(value: value, child: Text(value)),
                  )
                  .toList(),
        ),
      ],
    );
  }

  void _handleBoarding(PassengerBoardingModel boarding) async {
    if (controller.trip!.status == "scheduled") {
      AppDialog.showError("Trip hasn't started yet!");
      return;
    }
    if (controller.trip!.status == "completed") {
      AppDialog.showError("Trip has ended!");
      return;
    }
    if (controller.trip!.status == "cancelled") {
      AppDialog.showError("Trip has been cancelled!");
      return;
    }
    AppDialog.showConfirm(
      message: "Are you sure you want to mark this passenger as Boarded?",
      title: "Confirm.",
      onConfirm:
          (loadingPassengerBoardingIds.contains(boarding.id))
              ? null
              : () async {
                loadingPassengerBoardingIds.add(boarding.id);
                setState(() {});
                try {
                  await controller.triggerPassengerStatus(
                    passengerBoardingId: boarding.id,
                    status: "boarded",
                  );
                } finally {
                  loadingPassengerBoardingIds.remove(boarding.id);
                  setState(() {});
                }
              },
    );
  }

  void _launchWhatsApp(String phone) async {
    if (phone.isNotEmpty) {
      await openWhatsApp(phone);
    } else {
      AppDialog.showError("Error Opening Whatsapp!");
    }
  }

  void _sendProximityNotification(PassengerBoardingModel boarding) {
    if (controller.trip!.status == "scheduled") {
      AppDialog.showError("Trip hasn't started yet!");
      return;
    }
    if (controller.trip!.status == "completed") {
      AppDialog.showError("Trip has ended!");
      return;
    }
    if (controller.trip!.status == "cancelled") {
      AppDialog.showError("Trip has been cancelled!");
      return;
    }
    AppDialog.showConfirm(
      message: "Notify ${boarding.user!.name} that you are close.",
      title: "Confirm.",
      onConfirm:
          (loadingPassengerBoardingIds.contains(boarding.id))
              ? null
              : () async {
                loadingPassengerBoardingIds.add(boarding.id);
                setState(() {});
                try {
                  await controller.noitfyPassenger(userId: boarding.userId);
                } finally {
                  loadingPassengerBoardingIds.remove(boarding.id);
                  setState(() {});
                }
              },
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: MyAppBar(),
      bottomNavigationBar: const MyBottomNavbar(),
      body: Stack(
        children: [
          AbsorbPointer(
            absorbing: !_isPageReady,
            child: SafeArea(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 24.0,
                  vertical: screenHeight * 0.02,
                ),
                child: Obx(() {
                  if (controller.isLoading.value) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (controller.trip == null) {
                    return const Center(child: Text('Details not found'));
                  } else {
                    return SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const MyHeader(title: 'View Single Trip'),
                          const SizedBox(height: 22),
                          SizedBox(
                            height: 500,
                            child: GestureDetector(
                              onVerticalDragDown: (_) {},
                              child: GoogleMap(
                                onMapCreated: _onMapCreated,
                                initialCameraPosition: CameraPosition(
                                  target:
                                      controller.driverCurrentLocation ??
                                      const LatLng(0, 0),
                                  zoom: 12,
                                ),
                                markers: _markers,
                                polylines: _polylines,
                                myLocationEnabled: true,
                                myLocationButtonEnabled: true,
                                zoomControlsEnabled: true,
                              ),
                            ),
                          ),
                          if (controller.authService.globalUser!.role ==
                                  "driver" &&
                              controller.trip!.status == "scheduled" &&
                              controller
                                  .trip!
                                  .passengerBoardings!
                                  .isNotEmpty) ...[
                            const SizedBox(height: 14),
                            ElevatedButton(
                              onPressed: () {
                                AppDialog.showConfirm(
                                  message: "Do you want to start the journey?",
                                  onConfirm: () async {
                                    if (controller.trip!.status ==
                                            "scheduled" &&
                                        controller
                                            .trip!
                                            .passengerBoardings!
                                            .isNotEmpty) {
                                      await controller.triggerTripStatus(
                                        tripId: controller.trip!.id,
                                        status: "in_progress",
                                      );
                                    }
                                  },
                                );
                              },
                              child: Text('Start Journey'),
                            ),
                          ],
                          const SizedBox(height: 24),
                          Text(
                            'Trip Details',
                            style: theme.textTheme.titleLarge,
                          ),
                          const SizedBox(height: 8),
                          MyTripCard(busMovement: controller.trip!),
                          if (controller.authService.globalUser!.role ==
                              "driver") ...[
                            const SizedBox(height: 36),
                            Text(
                              'Passenger Boardings',
                              style: theme.textTheme.titleLarge,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'On Board ${controller.trip!.passengerBoardings!.where((e) => e.status == "boarded").length}/${controller.trip!.bookedPassengerCount}',
                              style: theme.textTheme.titleSmall,
                            ),
                            const SizedBox(height: 16),
                            _buildPassengerBoardingSearchBar(context),
                            const SizedBox(height: 12),

                            // In your ListView.separated itemBuilder:
                            const SizedBox(height: 12),
                            controller.isPassengersLoading.value
                                ? SizedBox(
                                  height: 100,
                                  child: Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                )
                                : controller.trip!.passengerBoardings == null ||
                                    controller.trip!.passengerBoardings!.isEmpty
                                ? Center(child: Text("No Boardings found."))
                                : ListView.separated(
                                  separatorBuilder:
                                      (context, index) =>
                                          const SizedBox(height: 8),
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount:
                                      controller
                                          .trip!
                                          .passengerBoardings!
                                          .length,
                                  itemBuilder: (context, index) {
                                    final boarding =
                                        controller
                                            .trip!
                                            .passengerBoardings![index];
                                    final statusColor =
                                        _getPassengerBoardingStatusColor(
                                          boarding.status,
                                        );

                                    return SizedBox(
                                      height: 72, // Optimal card height
                                      child: Slidable(
                                        key: ValueKey(boarding.id),
                                        endActionPane: ActionPane(
                                          motion: const ScrollMotion(),
                                          extentRatio:
                                              0.6, // Controls how much of actions are visible when swiped
                                          children: [
                                            // Boarding Action
                                            SlidableAction(
                                              padding: EdgeInsets.only(
                                                bottom: 0,
                                              ),
                                              flex: 1,
                                              onPressed:
                                                  (_) =>
                                                      _handleBoarding(boarding),
                                              backgroundColor: const Color(
                                                0xFF10B981,
                                              ),
                                              foregroundColor: Colors.white,
                                              icon: Icons.check,
                                              label: 'Board',
                                            ),

                                            // WhatsApp Action
                                            SlidableAction(
                                              padding: EdgeInsets.only(
                                                bottom: 0,
                                              ),
                                              flex: 1,
                                              onPressed:
                                                  (_) => _launchWhatsApp(
                                                    boarding.user!.phoneNumber!,
                                                  ),
                                              backgroundColor: const Color(
                                                0xFF25D366,
                                              ),
                                              foregroundColor: Colors.white,
                                              icon: Icons.message,
                                              label: 'Chat',
                                            ),

                                            // Notify Action
                                            SlidableAction(
                                              padding: EdgeInsets.only(
                                                bottom: 0,
                                              ),
                                              flex: 1,
                                              onPressed:
                                                  (_) =>
                                                      _sendProximityNotification(
                                                        boarding,
                                                      ),
                                              backgroundColor: const Color(
                                                0xFFF59E0B,
                                              ),
                                              foregroundColor: Colors.white,
                                              icon: Icons.notifications,
                                              label: 'Notify',
                                            ),
                                          ],
                                        ),
                                        child: Container(
                                          margin: const EdgeInsets.symmetric(
                                            vertical: 2,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black12,
                                                blurRadius: 2,
                                                offset: Offset(0, 1),
                                              ),
                                            ],
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 16,
                                            ),
                                            child: Row(
                                              children: [
                                                // Passenger Info
                                                Expanded(
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        boarding.user?.name ??
                                                            'Unknown Passenger',
                                                        style: TextStyle(
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          color:
                                                              Colors.grey[800],
                                                        ),
                                                      ),
                                                      const SizedBox(height: 4),
                                                      Text(
                                                        DateFormat(
                                                          'h:mm a',
                                                        ).format(
                                                          boarding
                                                              .estimatedBoardingTime!,
                                                        ),
                                                        style: TextStyle(
                                                          fontSize: 13,
                                                          color:
                                                              Colors.grey[600],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),

                                                // Status Indicator
                                                Container(
                                                  padding:
                                                      const EdgeInsets.symmetric(
                                                        horizontal: 12,
                                                        vertical: 6,
                                                      ),
                                                  decoration: BoxDecoration(
                                                    color: statusColor
                                                        .withOpacity(0.1),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          20,
                                                        ),
                                                    border: Border.all(
                                                      color: statusColor
                                                          .withOpacity(0.3),
                                                      width: 1,
                                                    ),
                                                  ),
                                                  child: Text(
                                                    boarding.status
                                                        .toUpperCase(),
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: statusColor,
                                                      letterSpacing: 0.5,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),

                            const SizedBox(height: 36),
                            if (controller.trip!.status != "completed" &&
                                controller.trip!.status != "cancelled")
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  IconButton(
                                    onPressed: null,
                                    onLongPress:
                                        (controller.tripStatusLoading.value)
                                            ? null
                                            : () async {
                                              AppDialog.showConfirm(
                                                message:
                                                    "Do you want to cancel this trip?",
                                                onConfirm: () async {
                                                  await controller
                                                      .triggerTripStatus(
                                                        tripId:
                                                            controller.trip!.id,
                                                        status: "cancelled",
                                                      );
                                                  setState(() {});
                                                },
                                              );
                                            },
                                    style: ButtonStyle(
                                      backgroundColor: WidgetStatePropertyAll(
                                        Colors.red,
                                      ),
                                    ),
                                    icon: Icon(Icons.cancel),
                                  ),
                                  const SizedBox(width: 10),
                                  if (controller.trip!.status ==
                                          "in_progress" &&
                                      controller
                                          .trip!
                                          .passengerBoardings!
                                          .isNotEmpty)
                                    IconButton(
                                      onPressed:
                                          (controller.tripStatusLoading.value)
                                              ? null
                                              : () {
                                                AppDialog.showConfirm(
                                                  message:
                                                      "Is this trip completed?",
                                                  onConfirm: () async {
                                                    await controller
                                                        .triggerTripStatus(
                                                          tripId:
                                                              controller
                                                                  .trip!
                                                                  .id,
                                                          status: "completed",
                                                        );
                                                    setState(() {});
                                                  },
                                                );
                                              },
                                      icon: Icon(Icons.save),
                                    ),
                                  const SizedBox(height: 30),
                                ],
                              ),
                          ],
                        ],
                      ),
                    );
                  }
                }),
              ),
            ),
          ),
          if (!_isPageReady)
            Container(
              color: Colors.white.withOpacity(0.75),
              child: const Center(child: CircularProgressIndicator()),
            ),
        ],
      ),
    );
  }
}
