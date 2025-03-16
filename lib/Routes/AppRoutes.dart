import 'package:buslink_flutter/Bindings/ForgetPasswordBinding.dart';
import 'package:buslink_flutter/Bindings/SignInBinding.dart';
import 'package:buslink_flutter/Bindings/SignUpBinding.dart';
import 'package:buslink_flutter/Bindings/VerifySMSBinding.dart';
import 'package:buslink_flutter/Views/EnableGPS.dart';
import 'package:buslink_flutter/Views/ForgetPassword.dart';
import 'package:buslink_flutter/Views/Landing.dart';
import 'package:buslink_flutter/Views/PassengerDashboard.dart';
import 'package:buslink_flutter/Views/SignIn.dart';
import 'package:buslink_flutter/Views/SignUp.dart';
import 'package:buslink_flutter/Views/Splash.dart';
import 'package:buslink_flutter/Bindings/SplashBinding.dart';
import 'package:buslink_flutter/Views/UserSelection.dart';
import 'package:buslink_flutter/Views/VerifySMS.dart';

import 'package:get/get.dart';

class AppRoutes {
  static const String splash = '/splash';
  static const String landing = '/landing';
  static const String signUp = '/sign-up';
  static const String signIn = '/sign-in';
  static const String enableGPS = '/enable-gps';
  static const String verifySMS = '/verify-sms';
  static const String forgetPassword = '/forget-password';
  static const String userSelection = '/user-selection';
  static const String passengerDashboard = '/passenger-dashboard';

  static List<GetPage> routes = [
    GetPage(name: splash, page: () => SplashPage(), binding: SplashBinding()),
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
    GetPage(name: passengerDashboard, page: () => PassengerDashboard()),
  ];
}
