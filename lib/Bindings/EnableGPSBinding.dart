import 'package:buslink_flutter/Controllers/EnableGPSController.dart';
import 'package:get/get.dart';

class EnableGPSBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EnableGPSController>(() => EnableGPSController());
  }
}
