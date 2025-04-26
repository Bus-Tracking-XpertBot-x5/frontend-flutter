import 'package:buslink_flutter/Models/BusModel.dart';
import 'package:buslink_flutter/Services/DriverService.dart';
import 'package:get/get.dart';
import 'package:buslink_flutter/Services/AuthService.dart';

class DriverBusInfoController extends GetxController {
  final AuthService authService = Get.find<AuthService>();
  final DriverService driverService = Get.find<DriverService>();
  final RxList<BusModel> buses = <BusModel>[].obs;

  final RxBool isLoading = false.obs;
  final RxMap<String, String> fieldErrors = <String, String>{}.obs;

  Future<void> fetchBuses() async {
    try {
      isLoading.value = true;
      final result = await driverService.getAllDriverBuses();
      buses.assignAll(result);
      print("busdadfasdfasdfasdfases");
    } catch (e) {
      throw e;
    } finally {
      isLoading.value = false;
    }
  }

  void _handleError(e) {
    if (e.response?.statusCode == 422) {
      final errors = e.response?.data['errors'] as Map<String, dynamic>;
      errors.forEach((key, value) {
        fieldErrors[key] = value[0];
      });
    } else {
      fieldErrors['general'] =
          e.response?.data['message'] ?? 'Something went wrong';
    }
  }
}
