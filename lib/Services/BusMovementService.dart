import 'package:buslink_flutter/Models/BusMovementModel.dart';
import 'package:buslink_flutter/Models/PassengerBoardingModel.dart';
import 'package:buslink_flutter/Services/Api.dart';
import 'package:get/get.dart';

class BusMovementService extends GetxService {
  Future<List<BusMovementModel>> getAll() async {
    final response = await Api.dio.get('/bus-movements');

    final List<BusMovementModel> busMovements =
        (response.data as List)
            .map((json) => BusMovementModel.fromJson(json))
            .toList();

    return busMovements;
  }

  Future<List<BusMovementModel>> getAllDriverTrips({
    String search = "all",
    String statusFilter = "all",
  }) async {
    final response = await Api.dio.get(
      '/bus-movements/driver',
      data: {"search": search, "status": statusFilter},
    );

    final List<BusMovementModel> busMovements =
        (response.data as List)
            .map((json) => BusMovementModel.fromJson(json))
            .toList();

    return busMovements;
  }

  Future<BusMovementModel> getSingleTrip({required int tripId}) async {
    final response = await Api.dio.get(
      '/bus-movements/single',
      data: {"movement_id": tripId},
    );

    final BusMovementModel busMovement = BusMovementModel.fromJson(
      response.data,
    );
    print(busMovement.passengerBoardings);
    return busMovement;
  }

  Future<bool> triggerTripStatus({
    required int tripId,
    required String status,
  }) async {
    final response = await Api.dio.put(
      '/bus-movements/status',
      data: {"status": status, "movement_id": tripId},
    );

    return response.statusCode == 200;
  }

  Future<bool> createTrip({
    required int organizationId,
    required int routeId,
    required int busId,
    required DateTime estimatedStart,
    required DateTime estimatedEnd,
    required num price,
  }) async {
    final response = await Api.dio.post(
      '/bus-movements',
      data: {
        "organization_id": organizationId,
        "route_id": routeId,
        "bus_id": busId,
        "estimated_start": estimatedStart.toIso8601String(),
        "estimated_end": estimatedEnd.toIso8601String(),
        'price': price,
      },
    );
    return response.statusCode == 200;
  }

  Future<List<PassengerBoardingModel>> getTripBoardings({
    required int tripId,
    required String statusFilter,
    required String search,
  }) async {
    final response = await Api.dio.get(
      '/bus-movement/single/passenger-boardings',
      data: {"status": statusFilter, "search": search, "movement_id": tripId},
    );

    final List<PassengerBoardingModel> passengerBoardings =
        (response.data['data'] as List)
            .map((json) => PassengerBoardingModel.fromJson(json))
            .toList();

    return passengerBoardings;
  }
}
