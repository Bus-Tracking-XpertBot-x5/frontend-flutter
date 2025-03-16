import 'package:buslink_flutter/Controllers/VerifySMSController.dart';
import 'package:get/get.dart';

class VerifySMSBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<VerifySMSController>(() => VerifySMSController());
  }
}
