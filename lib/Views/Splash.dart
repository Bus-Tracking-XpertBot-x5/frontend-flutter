import 'package:buslink_flutter/Services/AuthService.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashPage extends StatelessWidget {
  SplashPage({super.key});

  final AuthService authService = Get.find<AuthService>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset('images/logo.png', fit: BoxFit.contain, height: 96),
      ),
    );
  }
}
