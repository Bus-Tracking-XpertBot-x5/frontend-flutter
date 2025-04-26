import 'package:buslink_flutter/Services/DriverService.dart';
import 'package:buslink_flutter/Utils/Dialog.dart';
import 'package:get/get.dart';

class DriverInfoController extends GetxController {
  final DriverService driverService = Get.find<DriverService>();

  final RxBool isLoading = false.obs;
  final RxMap<String, String> fieldErrors = <String, String>{}.obs;

  Future<void> updateDriverInfo({required String licenseNumber}) async {
    try {
      isLoading.value = true;
      fieldErrors.clear();

      final updatedUser = await driverService.updateDriverInfo(
        licenseNumber: licenseNumber,
      );

      if (updatedUser) {
        AppDialog.showSuccess("License number updated successfully!");
      }
    } catch (e) {
      _handleError(e);
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
