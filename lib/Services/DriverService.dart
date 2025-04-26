import 'package:buslink_flutter/Models/BusModel.dart';
import 'package:buslink_flutter/Models/DriverModel.dart';
import 'package:buslink_flutter/Services/Api.dart';
import 'package:get/get.dart';

class DriverService extends GetxService {
  DriverModel? globalDriver;

  Future<List<DriverModel>> getAll() async {
    final response = await Api.dio.get('/bus-movements');

    final List<DriverModel> drivers =
        (response.data as List)
            .map((json) => DriverModel.fromJson(json))
            .toList();

    return drivers;
  }

  Future<List<BusModel>> getAllDriverBuses() async {
    final response = await Api.dio.get('/driver/buses');

    final List<BusModel> buses =
        (response.data['buses'] as List)
            .map((json) => BusModel.fromJson(json))
            .toList();

    return buses;
  }

  Future<DriverModel> getDriverByUserId({required int id}) async {
    final response = await Api.dio.get('/driver/user', data: {"user_id": id});

    final DriverModel driver = DriverModel.fromJson(response.data['driver']);

    return driver;
  }

  Future<bool> updateDriverInfo({required String licenseNumber}) async {
    final response = await Api.dio.put(
      '/driver',
      data: {"license_number": licenseNumber},
    );

    globalDriver!.licenseNumber = licenseNumber;
    return response.statusCode == 200;
  }

  Future<bool> notifyPassenger({required int userId}) async {
    final response = await Api.dio.post(
      '/driver/notify-passenger',
      data: {"user_id": userId},
    );

    return response.statusCode == 200;
  }
}
