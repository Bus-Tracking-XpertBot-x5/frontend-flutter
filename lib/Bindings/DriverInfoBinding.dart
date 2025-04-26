import 'package:buslink_flutter/Controllers/DriverInfoController.dart';
import 'package:get/get.dart';

class DriverInfoBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DriverInfoController>(() => DriverInfoController());
  }
}
