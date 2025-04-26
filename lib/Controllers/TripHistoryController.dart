import 'package:buslink_flutter/Models/PassengerBoardingModel.dart';
import 'package:buslink_flutter/Services/PassengerBoardingService.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';

class TripHistoryController extends GetxController {
  final PassengerBoardingService _passengerBoardingService =
      Get.find<PassengerBoardingService>();

  final RxBool isLoading = false.obs;
  List<PassengerBoardingModel>? passengerBoardings;
  var fieldErrors = <String, String>{}.obs;

  Future<void> getAllTrips({
    String statusFilter = "all",
    String search = "all",
  }) async {
    try {
      isLoading.value = true;

      passengerBoardings = await _passengerBoardingService.getAll(
        statusFilter: statusFilter,
        search: search,
      );
    } catch (e) {
      throw e;
      // _handleError(e);
    } finally {
      isLoading.value = false;
    }
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
