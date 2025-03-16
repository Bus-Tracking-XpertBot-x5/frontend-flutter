import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:buslink_flutter/Controllers/AuthController.dart';

class SplashPage extends StatelessWidget {
  SplashPage({super.key});

  final AuthController controller = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset(
          'images/logo.png',
          fit: BoxFit.contain,
          height: MediaQuery.of(context).size.height * 0.4,
        ),
      ),
    );
  }
}
