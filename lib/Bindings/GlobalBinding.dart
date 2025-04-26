import 'package:buslink_flutter/Services/BusMovementService.dart';
import 'package:buslink_flutter/Services/BusRouteService.dart';
import 'package:buslink_flutter/Services/BusService.dart';
import 'package:buslink_flutter/Services/DriverService.dart';
import 'package:buslink_flutter/Services/OrganizationService.dart';
import 'package:buslink_flutter/Services/PassengerBoardingService.dart';
import 'package:buslink_flutter/Widgets/MyBottomNavbar.dart';
import 'package:get/get.dart';
import 'package:buslink_flutter/Services/AuthService.dart';

class GlobalBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(AuthService(), permanent: true);
    Get.put(BusService(), permanent: true);
    Get.put(BusRouteService(), permanent: true);
    Get.put(DriverService(), permanent: true);
    Get.put(OrganizationService(), permanent: true);
    Get.put(PassengerBoardingService(), permanent: true);
    Get.put(BusMovementService(), permanent: true);
    Get.put(BottomNavController(), permanent: true);
  }
}
