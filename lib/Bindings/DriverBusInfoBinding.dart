import 'package:buslink_flutter/Controllers/DriverBusInfoController.dart';
import 'package:get/get.dart';

class DriverBusInfoBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DriverBusInfoController>(() => DriverBusInfoController());
  }
}
