import 'package:buslink_flutter/Models/OrganizationModel.dart';
import 'package:buslink_flutter/Services/Api.dart';
import 'package:get/get.dart';

class OrganizationService extends GetxService {
  Future<List<OrganizationModel>> getAll() async {
    final response = await Api.dio.get('/organizations');

    final List<OrganizationModel> organizations =
        (response.data['data'] as List)
            .map((json) => OrganizationModel.fromJson(json))
            .toList();

    return organizations;
  }

  Future<List<OrganizationModel>> getDriverOrganizations() async {
    final response = await Api.dio.get('/organizations/driver');

    final List<OrganizationModel> organizations =
        (response.data['organizations'] as List)
            .map((json) => OrganizationModel.fromJson(json))
            .toList();

    return organizations;
  }
}
