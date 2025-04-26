import 'package:buslink_flutter/Controllers/LogoutController.dart';
import 'package:get/get.dart';

class SettingsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LogoutController>(() => LogoutController());
  }
}
