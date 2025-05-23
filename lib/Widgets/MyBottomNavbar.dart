import 'package:buslink_flutter/Services/AuthService.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BottomNavController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();
  var currentIndex = 0.obs;

  final List<String> pages = [
    '/passengerDashboard',
    '/busRoutes',
    '/updateProfile',
    '/settings',
  ];

  void updateIndex(int index) {
    currentIndex.value = index;
    print(index);
    print(_authService.globalUser!.role);
    if (index == 0 && _authService.globalUser!.role == "driver") {
      Get.offAllNamed('/driverDashboard');
    } else if (index == 1 && _authService.globalUser!.role == "driver") {
      Get.offAllNamed('/driverTrips');
    } else {
      Get.offAllNamed(pages[index]);
    }
  }

  void resetIndex() {
    currentIndex.value = 0;
  }
}

class MyBottomNavbar extends StatelessWidget {
  const MyBottomNavbar({super.key});

  @override
  Widget build(BuildContext context) {
    final BottomNavController navController = Get.find<BottomNavController>();

    return Obx(
      () => Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              spreadRadius: 2,
            ),
          ],
        ),
        child: BottomNavigationBar(
          elevation: 0,
          backgroundColor: Colors.white,
          currentIndex: navController.currentIndex.value,
          onTap: navController.updateIndex,
          selectedItemColor: Theme.of(context).primaryColor,
          unselectedItemColor: Colors.grey[500],
          showUnselectedLabels: false,
          showSelectedLabels: false,
          type: BottomNavigationBarType.fixed,
          iconSize: 28,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.dashboard_rounded),
              label: 'Dashboard',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.directions_bus),
              label: 'Bus Stops',
            ),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: 'Settings',
            ),
          ],
        ),
      ),
    );
  }
}
