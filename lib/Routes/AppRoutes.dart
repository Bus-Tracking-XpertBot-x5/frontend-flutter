import 'package:buslink_flutter/Bindings/ForgetPasswordBinding.dart';
import 'package:buslink_flutter/Bindings/SignInBinding.dart';
import 'package:buslink_flutter/Bindings/SignUpBinding.dart';
import 'package:buslink_flutter/Bindings/VerifySMSBinding.dart';
import 'package:buslink_flutter/Views/BusLocations.dart';
import 'package:buslink_flutter/Views/BusRoutes.dart';
import 'package:buslink_flutter/Views/EnableGPS.dart';
import 'package:buslink_flutter/Views/ForgetPassword.dart';
import 'package:buslink_flutter/Views/Landing.dart';
import 'package:buslink_flutter/Views/Notifications.dart';
import 'package:buslink_flutter/Views/PassengerDashboard.dart';
import 'package:buslink_flutter/Views/Settings.dart';
import 'package:buslink_flutter/Views/SignIn.dart';
import 'package:buslink_flutter/Views/SignUp.dart';
import 'package:buslink_flutter/Views/Splash.dart';
import 'package:buslink_flutter/Views/UserSelection.dart';
import 'package:buslink_flutter/Views/VerifySMS.dart';

import 'package:get/get.dart';

class AppRoutes {
  static const String splash = '/splash';
  static const String landing = '/landing';
  static const String signUp = '/signUp';
  static const String signIn = '/signIn';
  static const String enableGPS = '/enableGpsLocation';
  static const String verifySMS = '/verifySms';
  static const String forgetPassword = '/forgetPassword';
  static const String userSelection = '/userSelection';
  static const String passengerDashboard = '/passengerDashboard';
  static const String busRoutes = '/busRoutes';
  static const String notifications = '/notifications';
  static const String settings = '/settings';
  static const String busLocations = '/busLocations';

  static List<GetPage> routes = [
    GetPage(name: splash, page: () => SplashPage()),
    GetPage(name: landing, page: () => LandingPage()),
    GetPage(name: signUp, page: () => SignUpPage(), binding: SignUpBinding()),
    GetPage(name: signIn, page: () => SignInPage(), binding: SignInBinding()),
    GetPage(name: enableGPS, page: () => EnableGPSPage()),
    GetPage(
      name: verifySMS,
      page: () => VerifySMSPage(),
      binding: VerifySMSBinding(),
    ),
    GetPage(
      name: forgetPassword,
      page: () => ForgetPasswordPage(),
      binding: ForgetPasswordBinding(),
    ),
    GetPage(name: userSelection, page: () => UserSelectionPage()),
    GetPage(name: passengerDashboard, page: () => PassengerDashboardPage()),
    GetPage(name: busRoutes, page: () => BusRoutesPage()),
    GetPage(name: notifications, page: () => NotificationsPage()),
    GetPage(name: settings, page: () => SettingsPage()),
    GetPage(name: busLocations, page: () => BusLocationsPage()),
  ];
}
