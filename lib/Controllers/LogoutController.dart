import 'package:buslink_flutter/Widgets/MyBottomNavbar.dart';
import 'package:get/get.dart';
import 'package:buslink_flutter/Services/AuthService.dart';
import 'package:get_storage/get_storage.dart';

class LogoutController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();

  final RxBool isLoading = false.obs;
  var fieldErrors = <String, String>{}.obs;

  Future<void> logout() async {
    try {
      isLoading.value = true;
      fieldErrors.value = {};

      await _authService.logout();
      await GetStorage().remove('login_token');
      _authService.globalUser = null;
      _authService.isLoggedIn.value = false;
      Get.find<BottomNavController>().resetIndex();

      await Get.offAllNamed('/landing');
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
