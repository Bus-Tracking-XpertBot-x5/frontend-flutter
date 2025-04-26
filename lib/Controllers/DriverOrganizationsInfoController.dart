import 'package:buslink_flutter/Models/OrganizationModel.dart';
import 'package:buslink_flutter/Services/OrganizationService.dart';
import 'package:get/get.dart';

class DriverOrganizationsInfoController extends GetxController {
  final OrganizationService _organizationService =
      Get.find<OrganizationService>();
  List<OrganizationModel> organizations = [];

  final RxBool isLoading = false.obs;

  Future<void> getDriverOrganizations() async {
    try {
      isLoading.value = true;

      organizations = await _organizationService.getDriverOrganizations();
    } catch (e) {
      throw e;
      // _handleError(e);
    } finally {
      isLoading.value = false;
    }
  }
}
