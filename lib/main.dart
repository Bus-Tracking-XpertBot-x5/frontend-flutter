import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:buslink_flutter/Utils/Api.dart';
import 'package:buslink_flutter/Utils/theme.dart';
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
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      initialRoute: AppRoutes.splash,
      getPages: AppRoutes.routes,
    );
  }
}
