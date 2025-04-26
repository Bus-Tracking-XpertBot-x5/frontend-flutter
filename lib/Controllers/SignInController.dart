import 'package:buslink_flutter/Services/DriverService.dart';
import 'package:buslink_flutter/Utils/Notifications.dart';
import 'package:buslink_flutter/Widgets/MyBottomNavbar.dart';
import 'package:get/get.dart';
import 'package:buslink_flutter/Models/UserModel.dart';
import 'package:buslink_flutter/Services/AuthService.dart';

class SignInController extends GetxController {
  final DriverService _driverService = Get.find<DriverService>();
  final AuthService _authService = Get.find<AuthService>();

  final RxBool isLoading = false.obs;
  var fieldErrors = <String, String>{}.obs;

  Future<void> loginUser(String phoneNumber, String password) async {
    try {
      isLoading.value = true;
      fieldErrors.value = {};

      final UserModel user = await _authService.login(
        phoneNumber: phoneNumber,
        password: password,
      );

      _authService.globalUser = user;
      print(_authService.globalUser);
      Get.find<BottomNavController>().resetIndex();
      NotificationService.storeDeviceToken();
      if (_authService.globalUser!.role == "driver") {
        _driverService.globalDriver = await _driverService.getDriverByUserId(
          id: user.id,
        );
        print(_driverService.globalDriver);
        Get.offAllNamed('/driverDashboard');
      } else {
        Get.offAllNamed('/passengerDashboard');
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
