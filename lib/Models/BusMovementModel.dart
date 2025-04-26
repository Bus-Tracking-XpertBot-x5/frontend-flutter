import 'package:buslink_flutter/Models/BusModel.dart';
import 'package:buslink_flutter/Models/BusRouteModel.dart';
import 'package:buslink_flutter/Models/OrganizationModel.dart';
import 'package:buslink_flutter/Models/PassengerBoardingModel.dart';

class BusMovementModel {
  final int id;
  final BusModel bus;
  final BusRouteModel busRoute;
  final int organizationId;
  final OrganizationModel? organization;
  final DateTime estimatedStart;
  final DateTime estimatedEnd;
  final DateTime? actualStart;
  final DateTime? actualEnd;
  final int bookedPassengerCount;
  int actualPassengerCount;
  String status;
  final double price;
  final DateTime createdAt;
  final DateTime updatedAt;
  List<PassengerBoardingModel>? passengerBoardings;

  BusMovementModel({
    required this.id,
    required this.bus,
    required this.busRoute,
    required this.organizationId,
    this.organization,
    required this.estimatedStart,
    required this.estimatedEnd,
    this.actualStart,
    this.actualEnd,
    required this.bookedPassengerCount,
    required this.actualPassengerCount,
    required this.price,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    this.passengerBoardings,
  });

  factory BusMovementModel.fromJson(Map<String, dynamic> json) {
    return BusMovementModel(
      id: json['id'],
      bus: BusModel.fromJson(json['bus']),
      busRoute: BusRouteModel.fromJson(json['route']),
      organizationId: json['organization_id'],
      organization:
          json['organization'] != null
              ? OrganizationModel.fromJson(json['organization'])
              : null,
      estimatedStart: DateTime.parse(json['estimated_start']),
      estimatedEnd: DateTime.parse(json['estimated_end']),
      actualStart:
          json['actual_start'] != null
              ? DateTime.parse(json['actual_start'])
              : null,
      actualEnd:
          json['actual_end'] != null
              ? DateTime.parse(json['actual_end'])
              : null,
      bookedPassengerCount: json['booked_passenger_count'],
      actualPassengerCount: json['actual_passenger_count'],
      price: double.tryParse(json['price'].toString())!,
      status: json['status'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      passengerBoardings:
          json['passenger_boardings'] != null
              ? List<PassengerBoardingModel>.from(
                json['passenger_boardings'].map(
                  (x) => PassengerBoardingModel.fromJson(x),
                ),
              )
              : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'bus': bus.toJson(),
      'route': busRoute.toJson(),
      'organization_id': organizationId,
      'organization': organization?.toJson(),
      'estimated_start': estimatedStart.toIso8601String(),
      'estimated_end': estimatedEnd.toIso8601String(),
      'actual_start': actualStart?.toIso8601String(),
      'actual_end': actualEnd?.toIso8601String(),
      'booked_passenger_count': bookedPassengerCount,
      'actual_passenger_count': actualPassengerCount,
      'price': price,
      'status': status,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'passenger_boardings':
          passengerBoardings?.map((x) => x.toJson()).toList(),
    };
  }
}
