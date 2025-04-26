import 'package:buslink_flutter/Controllers/ViewSingleTripController.dart';
import 'package:get/get.dart';

class ViewSingleTripBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ViewSingleTripController>(() => ViewSingleTripController());
  }
}
