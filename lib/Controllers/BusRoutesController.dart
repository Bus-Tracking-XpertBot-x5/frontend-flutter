import 'package:buslink_flutter/Models/BusMovementModel.dart';
import 'package:buslink_flutter/Models/PassengerBoardingModel.dart';
import 'package:buslink_flutter/Services/BusMovementService.dart';
import 'package:buslink_flutter/Services/PassengerBoardingService.dart';
import 'package:buslink_flutter/Utils/Dialog.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class BusRoutesController extends GetxController {
  final BusMovementService _busMovementService = Get.find<BusMovementService>();
  final PassengerBoardingService _passengerBoardingService =
      Get.find<PassengerBoardingService>();

  final RxBool isLoading = false.obs;
  List<BusMovementModel>? busMovements;
  var fieldErrors = <String, String>{}.obs;

  Future<void> getAllTrips() async {
    try {
      isLoading.value = true;

      busMovements = await _busMovementService.getAll();
    } catch (e) {
      throw e;
      // _handleError(e);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> rideTrip({required int busMovementId}) async {
    try {
      final PassengerBoardingModel passengerBoarding =
          await _passengerBoardingService.create(busMovementId: busMovementId);

      AppDialog.showSuccess(
        "Waiting for you at ${DateFormat('hh:mm a').format(passengerBoarding.estimatedBoardingTime)}",
        title: "Congratz!",
      );
    } catch (e) {
      // _handleError(e);
    } finally {}
  }

  void _handleError(dynamic e) {
    if (e is DioException) {
      if (e.response?.statusCode == 422) {
        final errors = e.response?.data['errors'] as Map<String, dynamic>;
        errors.forEach((key, value) {
          fieldErrors[key] = value[0];
        });
      } else {
        fieldErrors['general'] =
            e.response?.data['message'] ?? 'An error occurred';
      }
    } else {
      fieldErrors['general'] = 'An unexpected error occurred';
    }
  }
}
