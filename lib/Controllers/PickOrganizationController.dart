import 'package:buslink_flutter/Models/OrganizationModel.dart';
import 'package:buslink_flutter/Services/OrganizationService.dart';
import 'package:get/get.dart';
import 'package:buslink_flutter/Services/AuthService.dart';
import 'package:buslink_flutter/Utils/Dialog.dart';

class PickOrganizationController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();
  final OrganizationService _organizationService =
      Get.find<OrganizationService>();
  List<OrganizationModel> organizations = [];

  final RxBool isLoading = false.obs;

  Future<void> getAllOrganizations() async {
    try {
      isLoading.value = true;

      organizations = await _organizationService.getAll();
    } catch (e) {
      throw e;
      // _handleError(e);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> submitSelection({required int organizationId}) async {
    try {
      isLoading.value = true;
      final bool orgUpdated = await _authService.updateOrganization(
        organizationId: organizationId,
      );

      if (orgUpdated) {
        AppDialog.showSuccess("Organization Updated Successfully!");
      }
    } catch (e) {
    } finally {
      isLoading.value = false;
    }
  }
}
