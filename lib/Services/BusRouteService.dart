import 'package:buslink_flutter/Models/BusRouteModel.dart';
import 'package:buslink_flutter/Services/Api.dart';
import 'package:get/get.dart';

class BusRouteService extends GetxService {
  Future<List<BusRouteModel>> getAll() async {
    final response = await Api.dio.get('/bus-routes');

    final List<BusRouteModel> routes =
        (response.data['data'] as List)
            .map((json) => BusRouteModel.fromJson(json))
            .toList();

    return routes;
  }
}
