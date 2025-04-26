import 'package:buslink_flutter/Controllers/AddTripController.dart';
import 'package:get/get.dart';

class AddTripBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AddTripController>(() => AddTripController());
  }
}
