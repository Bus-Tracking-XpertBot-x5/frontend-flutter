import 'package:buslink_flutter/Models/OrganizationModel.dart';
import 'package:buslink_flutter/Services/DriverService.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:buslink_flutter/Models/UserModel.dart';
import 'package:buslink_flutter/Services/Api.dart';
import 'package:buslink_flutter/Utils/Dialog.dart';

class AuthService extends GetxService {
  UserModel? globalUser;
  RxBool isLoggedIn = false.obs;

  @override
  void onInit() {
    redirect();
    super.onInit();
  }

  Future<void> redirect() async {
    var token = await GetStorage().read('login_token');

    Future.delayed(Duration(seconds: 3), () async {
      if (token != null) {
        isLoggedIn.value = true;

        try {
          // GetStorage().remove('login_token');
          globalUser = await getLoggedInUser();
          isLoggedIn.value = true;
          if (globalUser!.role == "driver") {
            final DriverService _driverService = Get.find<DriverService>();
            _driverService.globalDriver = await _driverService
                .getDriverByUserId(id: globalUser!.id);
            print(_driverService.globalDriver);
            Get.offAllNamed('/driverDashboard');
          } else {
            Get.offAllNamed('/passengerDashboard');
          }
          AppDialog.showSuccess('Logged In Successfully!');
        } catch (e) {
          GetStorage().remove('login_token');
          isLoggedIn.value = false;
          Get.offAllNamed('landing');
          AppDialog.showError('An error occurred while fetching user data.');
        }
        print(globalUser);
      } else {
        Get.offAndToNamed('landing');
      }
    });
  }

  Future<UserModel> register({
    required String name,
    required String email,
    required String phoneNumber,
    required String password,
  }) async {
    final response = await Api.dio.post(
      '/register',
      data: {
        'name': name,
        'email': email,
        'phone_number': phoneNumber,
        'password': password,
        'role': 'passenger',
      },
    );

    print(response.data['user']);
    final UserModel user = UserModel.fromJson({
      ...response.data['user'],
      'token': response.data['token'],
    });

    GetStorage().write('login_token', user.token);
    return user;
  }

  Future<UserModel> getLoggedInUser() async {
    final response = await Api.dio.get('/me');

    final data = (response.data);
    print(data);
    return UserModel.fromJson(data['user']);
  }

  Future<UserModel> login({
    required String phoneNumber,
    required String password,
  }) async {
    final response = await Api.dio.post(
      '/login',
      data: {'phone_number': phoneNumber, 'password': password},
    );

    final UserModel user = UserModel.fromJson({
      ...response.data['user'],
      'token': response.data['token'],
    });

    GetStorage().write('login_token', user.token);
    return user;
  }

  Future<bool> verifyEmail({required String email, required String otp}) async {
    await Api.dio.post('/email/verify', data: {'email': email, 'otp': otp});

    return true;
  }

  Future<bool> forgetPassword({required String email}) async {
    await Api.dio.post('/forget-password', data: {'email': email});

    return true;
  }

  Future<bool> logout() async {
    final response = await Api.dio.post('/logout');

    return response.statusCode == 200;
  }

  Future<bool> updateOrganization({required int organizationId}) async {
    final response = await Api.dio.post(
      '/user/update-organization',
      data: {"organization_id": organizationId},
    );

    globalUser!.organization = OrganizationModel.fromJson(
      response.data['organization'],
    );
    return response.statusCode == 200;
  }

  Future<bool> changePassword({
    required String oldPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    final response = await Api.dio.post(
      '/change-password',
      data: {
        'old_password': oldPassword,
        'new_password': newPassword,
        'confirm_password': confirmPassword,
      },
    );

    return response.statusCode == 200;
  }

  Future<bool> updateProfile({
    required String name,
    required String email,
    required String phoneNumber,
  }) async {
    final response = await Api.dio.put(
      '/user/profile',
      data: {'name': name, 'email': email, 'phone_number': phoneNumber},
    );

    globalUser!.name = name;
    globalUser!.email = email;
    globalUser!.phoneNumber = phoneNumber;

    return response.statusCode == 200;
  }

  Future<bool> updateLocation({
    required double latitude,
    required double longitude,
  }) async {
    final response = await Api.dio.put(
      '/user/location',
      data: {'latitude': latitude, 'longitude': longitude},
    );

    globalUser!.latitude = latitude;
    globalUser!.longitude = longitude;

    return response.statusCode == 200;
  }
}
