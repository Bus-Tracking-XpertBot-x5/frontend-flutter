import 'package:buslink_flutter/Utils/Dialog.dart';
import 'package:get/get.dart';
import 'package:buslink_flutter/Services/AuthService.dart';

class ChangePasswordController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();

  final RxBool isLoading = false.obs;
  var fieldErrors = <String, String>{}.obs;

  Future<void> changePassword({
    required String oldPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    try {
      isLoading.value = true;
      fieldErrors.value = {};

      final result = await _authService.changePassword(
        oldPassword: oldPassword,
        newPassword: newPassword,
        confirmPassword: confirmPassword,
      );

      if (result) {
        AppDialog.showSuccess("Password Updated Successfully!");
        // Get.toNamed('/home');
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
          e.response?.data['message'] ?? 'An error occurred';
    }
  }
}
