import 'package:buslink_flutter/Controllers/DriverOrganizationsInfoController.dart';
import 'package:get/get.dart';

class DriverOrganizationsInfoBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DriverOrganizationsInfoController>(
      () => DriverOrganizationsInfoController(),
    );
  }
}
