// trip_controller.dart
import 'package:buslink_flutter/Models/BusMovementModel.dart';
import 'package:buslink_flutter/Models/PassengerBoardingModel.dart';
import 'package:buslink_flutter/Services/AuthService.dart';
import 'package:buslink_flutter/Services/BusMovementService.dart';
import 'package:buslink_flutter/Services/DriverService.dart';
import 'package:buslink_flutter/Services/PassengerBoardingService.dart';
import 'package:buslink_flutter/Utils/Dialog.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ViewSingleTripController extends GetxController {
  final AuthService authService = Get.find<AuthService>();
  final BusMovementService _busMovementService = Get.find<BusMovementService>();
  final DriverService _driverService = Get.find<DriverService>();
  final PassengerBoardingService _passengerBoardingService =
      Get.find<PassengerBoardingService>();

  BusMovementModel? trip;
  final RxBool isLoading = false.obs;
  final RxBool tripStatusLoading = false.obs;
  final RxBool isPassengersLoading = false.obs;
  final int? tripId = int.tryParse(Get.parameters['tripId']!);
  LatLng? driverCurrentLocation;

  @override
  void onInit() {
    super.onInit();
    if (tripId != null) {
      _loadTripDetails();
    }
  }

  Future<void> _loadTripDetails() async {
    try {
      isLoading.value = true;
      trip = await _busMovementService.getSingleTrip(tripId: tripId!);
      driverCurrentLocation = LatLng(
        trip!.bus.driver!.user!.latitude!,
        trip!.bus.driver!.user!.longitude!,
      );
    } catch (e) {
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadPassengerBoardings({
    String statusFilter = "all",
    String search = "all",
  }) async {
    try {
      isPassengersLoading.value = true;
      trip!.passengerBoardings = await _busMovementService.getTripBoardings(
        tripId: tripId!,
        statusFilter: statusFilter,
        search: search,
      );
    } catch (e) {
    } finally {
      isPassengersLoading.value = false;
    }
  }

  Future<void> triggerPassengerStatus({
    required int passengerBoardingId,
    required String status,
  }) async {
    try {
      final result = await _passengerBoardingService.triggerPassengerStatus(
        passengerBoardingId: passengerBoardingId,
        status: status,
      );

      if (result) {
        if (trip != null) {
          trip!.actualPassengerCount += 1;

          final index = trip!.passengerBoardings?.indexWhere(
            (e) => e.id == passengerBoardingId,
          );
          if (index != null && index >= 0) {
            trip!.passengerBoardings![index].status = status;
          }
        }
      }
    } catch (e) {}
  }

  Future<void> noitfyPassenger({required int userId}) async {
    try {
      final result = await _driverService.notifyPassenger(userId: userId);
    } catch (e) {}
  }

  Future<void> triggerTripStatus({
    required int tripId,
    required String status,
  }) async {
    try {
      tripStatusLoading.value = true;
      await _busMovementService.triggerTripStatus(
        tripId: tripId,
        status: status,
      );
      trip!.status = status;
      AppDialog.showSuccess("Trip ${status} Successfully");
    } catch (e) {
    } finally {
      tripStatusLoading.value = false;
    }
  }
}
