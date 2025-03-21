import 'package:buslink_flutter/Widgets/MyBottomNavbar.dart';
import 'package:get/get.dart';
import 'package:buslink_flutter/Services/AuthService.dart';

class GlobalBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(AuthService(), permanent: true);
    Get.put(BottomNavController(), permanent: true);
  }
}
