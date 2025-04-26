import 'package:buslink_flutter/Models/BusModel.dart';
import 'package:buslink_flutter/Services/Api.dart';
import 'package:get/get.dart';

class BusService extends GetxService {
  Future<List<BusModel>> getAll() async {
    final response = await Api.dio.get('/buses');

    final List<BusModel> buses =
        (response.data['data'] as List)
            .map((json) => BusModel.fromJson(json))
            .toList();

    return buses;
  }

  Future<List<BusModel>> getDriverBuses() async {
    final response = await Api.dio.get('/buses/driver');

    final List<BusModel> buses =
        (response.data['data'] as List)
            .map((json) => BusModel.fromJson(json))
            .toList();

    return buses;
  }
}
