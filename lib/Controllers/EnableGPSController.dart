import 'package:buslink_flutter/Services/AuthService.dart';
import 'package:buslink_flutter/Utils/Dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class EnableGPSController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();

  var fieldErrors = <String, String>{}.obs;
  final RxBool isLoading = false.obs;
  final RxBool isGpsEnabled = false.obs;
  final Rx<LocationPermission> permissionStatus = LocationPermission.denied.obs;
  final Rx<LatLng?> currentPosition = Rx<LatLng?>(null);
  final RxString locationError = ''.obs;

  @override
  void onInit() {
    super.onInit();
    checkGpsStatus();
  }

  Future<void> checkGpsStatus() async {
    isLoading.value = true;
    try {
      isGpsEnabled.value = await Geolocator.isLocationServiceEnabled();
      permissionStatus.value = await Geolocator.checkPermission();
      if (permissionStatus.value == LocationPermission.whileInUse ||
          permissionStatus.value == LocationPermission.always) {
        await getCurrentLocation();
      }
    } catch (e) {
      locationError.value = 'Error checking GPS status: ${e.toString()}';
    }
    isLoading.value = false;
  }

  Future<void> requestLocationPermission() async {
    isLoading.value = true;
    try {
      final status = await Geolocator.requestPermission();
      permissionStatus.value = status;
      if (status == LocationPermission.whileInUse ||
          status == LocationPermission.always) {
        await getCurrentLocation();
      }
    } catch (e) {
      locationError.value = 'Permission request failed: ${e.toString()}';
    }
    isLoading.value = false;
  }

  Future<void> getCurrentLocation() async {
    try {
      final position = await Geolocator.getCurrentPosition();
      currentPosition.value = LatLng(position.latitude, position.longitude);
      locationError.value = '';
    } catch (e) {
      locationError.value = 'Location fetch failed: ${e.toString()}';
      currentPosition.value = null;
    }
  }

  Future<void> openLocationSettings() async {
    await Geolocator.openLocationSettings();
    await checkGpsStatus();
  }

  Future<void> updateLocation() async {
    try {
      isLoading.value = true;
      fieldErrors.value = {};

      // Update location via AuthService (API call)
      final result = await _authService.updateLocation(
        latitude: currentPosition.value!.latitude,
        longitude: currentPosition.value!.longitude,
      );

      if (result) {
        // Show success dialog/message
        AppDialog.showSuccess("Location Updated Successfully!");
      }
    } catch (e) {
      _handleError(e);
    } finally {
      isLoading.value = false;
    }
  }

  void _handleError(e) {
    if (e.response?.statusCode == 422) {
      final errors = e.response?.data['errors'] as Map<String, dynamic>;
      errors.forEach((key, value) {
        fieldErrors[key] = value[0];
      });
    } else {
      fieldErrors['general'] =
          e.response?.data['message'] ?? 'An error occurred';
    }
  }
}
