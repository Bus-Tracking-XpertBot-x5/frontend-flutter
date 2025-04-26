import 'package:buslink_flutter/Utils/Dialog.dart';
import 'package:get/get.dart';
import 'package:buslink_flutter/Services/AuthService.dart';

class UpdateProfileController extends GetxController {
  final AuthService authService = Get.find<AuthService>();

  final RxBool isLoading = false.obs;
  final RxMap<String, String> fieldErrors = <String, String>{}.obs;

  Future<void> updateProfile({
    required String name,
    required String email,
    required String phoneNumber,
  }) async {
    try {
      isLoading.value = true;
      fieldErrors.clear();

      final updatedUser = await authService.updateProfile(
        name: name,
        email: email,
        phoneNumber: phoneNumber,
      );

      if (updatedUser) {
        AppDialog.showSuccess("Profile Updated Successfully!");
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
