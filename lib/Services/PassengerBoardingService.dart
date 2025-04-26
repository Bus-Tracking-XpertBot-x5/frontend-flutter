import 'package:buslink_flutter/Models/PassengerBoardingModel.dart';
import 'package:buslink_flutter/Services/Api.dart';
import 'package:get/get.dart';

class PassengerBoardingService extends GetxService {
  Future<List<PassengerBoardingModel>> getAll({
    String statusFilter = "all",
    String search = "all",
  }) async {
    final response = await Api.dio.get(
      '/passenger-boardings',
      data: {"status": statusFilter, "search": search},
    );

    final List<PassengerBoardingModel> passengerBoardings =
        (response.data['data'] as List)
            .map((json) => PassengerBoardingModel.fromJson(json))
            .toList();

    return passengerBoardings;
  }

  Future<PassengerBoardingModel> create({required int busMovementId}) async {
    final response = await Api.dio.post(
      '/passenger-boardings',
      data: {"movement_id": busMovementId},
    );

    final PassengerBoardingModel passengerBoarding =
        PassengerBoardingModel.fromJson(response.data);

    return passengerBoarding;
  }

  Future<bool> triggerPassengerStatus({
    required int passengerBoardingId,
    required String status,
  }) async {
    final response = await Api.dio.put(
      '/passenger-boardings/status',
      data: {"status": status, "passenger_boarding_id": passengerBoardingId},
    );

    return response.statusCode == 200;
  }
}
