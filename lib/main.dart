import 'package:buslink_flutter/Bindings/GlobalBinding.dart';
import 'package:buslink_flutter/Services/Api.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:buslink_flutter/Utils/Theme.dart';
import 'Routes/AppRoutes.dart';

void main() async {
  await GetStorage.init();

  Api.initializeInterceptors();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      transitionDuration: const Duration(milliseconds: 300),
      initialBinding: GlobalBinding(),
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      initialRoute: AppRoutes.splash,
      getPages: AppRoutes.routes,
    );
  }
}
