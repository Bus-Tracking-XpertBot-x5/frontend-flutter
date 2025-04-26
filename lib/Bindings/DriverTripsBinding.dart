import 'package:buslink_flutter/Controllers/DriverTripsController.dart';
import 'package:get/get.dart';

class DriverTripsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DriverTripsController>(() => DriverTripsController());
  }
}
