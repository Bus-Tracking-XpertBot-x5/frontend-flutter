import 'package:buslink_flutter/Models/DriverModel.dart';

class BusModel {
  final int id;
  final String name;
  final String licensePlate;
  final int capacity;
  final String status;
  final DriverModel? driver;
  final int driverId;
  final DateTime createdAt;
  final DateTime updatedAt;

  BusModel({
    required this.id,
    required this.name,
    required this.licensePlate,
    required this.capacity,
    required this.status,
    this.driver,
    required this.driverId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory BusModel.fromJson(Map<String, dynamic> json) {
    return BusModel(
      id: json['id'],
      name: json['name'],
      licensePlate: json['license_plate'],
      capacity: json['capacity'],
      status: json['status'],
      driver:
          json['driver'] != null
              ? DriverModel.fromJson(json['driver'])
              : null, // Include Driver Model
      driverId: json['driver_id'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'license_plate': licensePlate,
      'capacity': capacity,
      'status': status,
      'driver': driver?.toJson(), // Include Driver Model
      'driverId': driverId,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
