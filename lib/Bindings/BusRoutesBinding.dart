import 'package:buslink_flutter/Controllers/BusRoutesController.dart';
import 'package:get/get.dart';

class BusRoutesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BusRoutesController>(() => BusRoutesController());
  }
}
