// AddTripController.dart
import 'package:buslink_flutter/Models/BusModel.dart';
import 'package:buslink_flutter/Models/BusRouteModel.dart';
import 'package:buslink_flutter/Models/OrganizationModel.dart';
import 'package:buslink_flutter/Services/AuthService.dart';
import 'package:buslink_flutter/Services/BusMovementService.dart';
import 'package:buslink_flutter/Services/BusRouteService.dart';
import 'package:buslink_flutter/Services/DriverService.dart';
import 'package:buslink_flutter/Services/OrganizationService.dart';
import 'package:buslink_flutter/Utils/Dialog.dart';
import 'package:get/get.dart';

class AddTripController extends GetxController {
  final AuthService authService = Get.find<AuthService>();
  final OrganizationService organizationService =
      Get.find<OrganizationService>();
  final DriverService driverService = Get.find<DriverService>();
  final BusRouteService busRouteService = Get.find<BusRouteService>();
  final BusMovementService busMovementService = Get.find<BusMovementService>();

  // Mock data
  List<OrganizationModel> organizations = [];

  List<BusRouteModel> routes = [];

  List<BusModel> buses = [];

  // Observable variables
  var selectedOrganization = ''.obs;
  var selectedRoute = ''.obs;
  var selectedBus = ''.obs;
  var selectedStartTime = DateTime.now().obs;
  var selectedEndTime = DateTime.now().add(const Duration(hours: 2)).obs;
  var isLoading = false.obs;
  var fieldErrors = <String, String?>{}.obs;

  void loadInitialData() async {
    // In real app, load data from API
    selectedOrganization.value = '';
    selectedRoute.value = '';
    selectedBus.value = '';

    isLoading.value = true;
    buses = await driverService.getAllDriverBuses();
    organizations = await organizationService.getDriverOrganizations();
    routes = await busRouteService.getAll();
    isLoading.value = false;
  }

  void addTrip({required num price}) async {
    isLoading.value = true;
    fieldErrors.clear();

    // Validate end time
    if (selectedStartTime.value.isAfter(selectedEndTime.value)) {
      fieldErrors['end_time'] = 'End time must be after start time';
      update();
      isLoading.value = false;
      return;
    }

    // Validate price
    if (price < 0) {
      fieldErrors['price'] = 'Price must be a positive number';
      update();
      isLoading.value = false;
      return;
    }

    try {
      await busMovementService.createTrip(
        organizationId: int.parse(selectedOrganization.value),
        routeId: int.parse(selectedRoute.value),
        busId: int.parse(selectedBus.value),
        estimatedStart: selectedStartTime.value,
        estimatedEnd: selectedEndTime.value,
        price: price,
      );

      AppDialog.showSuccess("Trip Created Successfully!");
    } catch (e) {
      // Handle error accordingly, you can parse e for specific messages
    } finally {
      isLoading.value = false;
    }
  }
}
