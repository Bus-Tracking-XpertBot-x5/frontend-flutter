import 'package:buslink_flutter/Controllers/UpdateProfileController.dart';
import 'package:get/get.dart';

class UpdateProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UpdateProfileController>(() => UpdateProfileController());
  }
}
