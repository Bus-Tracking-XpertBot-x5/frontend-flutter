import 'package:buslink_flutter/Controllers/PickOrganizationController.dart';
import 'package:get/get.dart';

class PickOrganizationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PickOrganizationController>(() => PickOrganizationController());
  }
}
