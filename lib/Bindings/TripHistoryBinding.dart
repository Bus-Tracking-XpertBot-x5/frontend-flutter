import 'package:buslink_flutter/Controllers/TripHistoryController.dart';
import 'package:get/get.dart';

class TripHistoryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TripHistoryController>(() => TripHistoryController());
  }
}
