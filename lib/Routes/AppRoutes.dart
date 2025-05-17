import 'package:buslink_flutter/Bindings/AddTripBinding.dart';
import 'package:buslink_flutter/Bindings/BusRoutesBinding.dart';
import 'package:buslink_flutter/Bindings/ChangePasswordBinding.dart';
import 'package:buslink_flutter/Bindings/DriverBusInfoBinding.dart';
import 'package:buslink_flutter/Bindings/DriverInfoBinding.dart';
import 'package:buslink_flutter/Bindings/DriverOrganizationsInfoBinding.dart';
import 'package:buslink_flutter/Bindings/DriverTripsBinding.dart';
import 'package:buslink_flutter/Bindings/EnableGPSBinding.dart';
import 'package:buslink_flutter/Bindings/ForgetPasswordBinding.dart';
import 'package:buslink_flutter/Bindings/PickOrganizationBinding.dart';
import 'package:buslink_flutter/Bindings/SettingsBinding.dart';
import 'package:buslink_flutter/Bindings/SignInBinding.dart';
import 'package:buslink_flutter/Bindings/SignUpBinding.dart';
import 'package:buslink_flutter/Bindings/TripHistoryBinding.dart';
import 'package:buslink_flutter/Bindings/UpdateProfileBinding.dart';
import 'package:buslink_flutter/Bindings/VerifyEmailBinding.dart';
import 'package:buslink_flutter/Bindings/ViewSingleTripBinding.dart';
import 'package:buslink_flutter/Views/AddTrip.dart';
import 'package:buslink_flutter/Views/BusLocations.dart';
import 'package:buslink_flutter/Views/BusRoutes.dart';
import 'package:buslink_flutter/Views/ChangePasswordPage.dart';
import 'package:buslink_flutter/Views/DriverBusInfo.dart';
import 'package:buslink_flutter/Views/DriverDashboard.dart';
import 'package:buslink_flutter/Views/DriverInfo.dart';
import 'package:buslink_flutter/Views/DriverOrganizationsInfo.dart';
import 'package:buslink_flutter/Views/DriverTrips.dart';
import 'package:buslink_flutter/Views/EnableGPS.dart';
import 'package:buslink_flutter/Views/ForgetPassword.dart';
import 'package:buslink_flutter/Views/Landing.dart';
import 'package:buslink_flutter/Views/PassengerDashboard.dart';
import 'package:buslink_flutter/Views/PickOrganization.dart';
import 'package:buslink_flutter/Views/Settings.dart';
import 'package:buslink_flutter/Views/SignIn.dart';
import 'package:buslink_flutter/Views/SignUp.dart';
import 'package:buslink_flutter/Views/Splash.dart';
import 'package:buslink_flutter/Views/TripHistory.dart';
import 'package:buslink_flutter/Views/UpdateProfile.dart';
import 'package:buslink_flutter/Views/UserSelection.dart';
import 'package:buslink_flutter/Views/VerifyEmail.dart';
import 'package:buslink_flutter/Views/ViewSingleTrip.dart';

import 'package:get/get.dart';

class AppRoutes {
  static const String splash = '/splash';
  static const String landing = '/landing';
  static const String signUp = '/signUp';
  static const String signIn = '/signIn';
  static const String enableGPS = '/enableGpsLocation';
  static const String verifyEmail = '/verifyEmail';
  static const String forgetPassword = '/forgetPassword';
  static const String userSelection = '/userSelection';
  static const String passengerDashboard = '/passengerDashboard';
  static const String busRoutes = '/busRoutes';
  static const String notifications = '/notifications';
  static const String settings = '/settings';
  static const String busLocations = '/busLocations';
  static const String tripHistory = '/tripHistory';
  static const String pickOrganization = '/pickOrganization';
  static const String changePassword = '/changePassword';
  static const String updateProfile = '/updateProfile';
  static const String driverDashboard = '/driverDashboard';
  static const String driverTrips = '/driverTrips';
  static const String driverBusInfo = '/driverBusInfo';
  static const String driverInfo = '/driverInfo';
  static const String driverOrganizationsInfo = '/driverOrganizationsInfo';
  static const String viewSingleTrip = '/viewSingleTrip/:tripId';
  static const String addTrip = '/addTrip';

  static List<GetPage> routes = [
    GetPage(name: splash, page: () => SplashPage()),
    GetPage(name: landing, page: () => LandingPage()),
    GetPage(name: signUp, page: () => SignUpPage(), binding: SignUpBinding()),
    GetPage(name: signIn, page: () => SignInPage(), binding: SignInBinding()),
    GetPage(
      name: enableGPS,
      page: () => EnableGPSPage(),
      binding: EnableGPSBinding(),
    ),
    GetPage(
      name: verifyEmail,
      page: () => VerifyEmailPage(),
      binding: VerifyEmailBinding(),
    ),
    GetPage(
      name: forgetPassword,
      page: () => ForgetPasswordPage(),
      binding: ForgetPasswordBinding(),
    ),
    GetPage(name: userSelection, page: () => UserSelectionPage()),
    GetPage(name: passengerDashboard, page: () => PassengerDashboardPage()),
    GetPage(
      name: busRoutes,
      page: () => BusRoutesPage(),
      binding: BusRoutesBinding(),
    ),
    GetPage(
      name: settings,
      page: () => SettingsPage(),
      binding: SettingsBinding(),
    ),
    GetPage(name: busLocations, page: () => BusLocationsPage()),
    GetPage(
      name: tripHistory,
      page: () => TripHistoryPage(),
      binding: TripHistoryBinding(),
    ),
    GetPage(
      name: pickOrganization,
      page: () => PickOrganizationPage(),
      binding: PickOrganizationBinding(),
    ),
    GetPage(
      name: changePassword,
      page: () => ChangePasswordPage(),
      binding: ChangePasswordBinding(),
    ),
    GetPage(
      name: updateProfile,
      page: () => UpdateProfilePage(),
      binding: UpdateProfileBinding(),
    ),
    GetPage(name: driverDashboard, page: () => DriverDashboardPage()),
    GetPage(
      name: driverTrips,
      page: () => DriverTripsPage(),
      binding: DriverTripsBinding(),
    ),
    GetPage(
      name: driverBusInfo,
      page: () => DriverBusInfoPage(),
      binding: DriverBusInfoBinding(),
    ),
    GetPage(
      name: driverInfo,
      page: () => DriverInfoPage(),
      binding: DriverInfoBinding(),
    ),
    GetPage(
      name: driverOrganizationsInfo,
      page: () => DriverOrganizationsInfoPage(),
      binding: DriverOrganizationsInfoBinding(),
    ),
    GetPage(
      name: viewSingleTrip,
      page: () => ViewSingleTripPage(),
      binding: ViewSingleTripBinding(),
    ),
    GetPage(
      name: addTrip,
      page: () => AddTripPage(),
      binding: AddTripBinding(),
    ),
  ];
}
