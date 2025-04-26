import 'package:buslink_flutter/Utils/Notifications.dart';
import 'package:get/get.dart';
import 'package:buslink_flutter/Services/AuthService.dart';
import 'package:buslink_flutter/Utils/Dialog.dart';

class VerifyEmailController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();

  final RxBool isLoading = false.obs;
  var fieldErrors = <String, String>{}.obs;

  Future<void> veriyfEmailUser(String otp) async {
    try {
      isLoading.value = true;
      fieldErrors.value = {};

      final bool emailVerified = await _authService.verifyEmail(
        email: _authService.globalUser!.email,
        otp: otp,
      );

      if (emailVerified) {
        NotificationService.storeDeviceToken();
        AppDialog.showSuccess("Email Verified Successfully!");
        await Future.delayed(Duration(seconds: 3), () async {
          Get.offAllNamed('/userSelection');
        });
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
