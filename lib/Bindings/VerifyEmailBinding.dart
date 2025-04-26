import 'package:buslink_flutter/Controllers/VerifyEmailController.dart';
import 'package:get/get.dart';

class VerifyEmailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<VerifyEmailController>(() => VerifyEmailController());
  }
}
