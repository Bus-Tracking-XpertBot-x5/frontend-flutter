import 'package:buslink_flutter/Models/UserModel.dart';

class DriverModel {
  final int id;
  final UserModel? user;
  final int userId;
  String licenseNumber;
  final DateTime createdAt;
  final DateTime updatedAt;

  DriverModel({
    required this.id,
    required this.user,
    required this.userId,
    required this.licenseNumber,
    required this.createdAt,
    required this.updatedAt,
  });

  factory DriverModel.fromJson(Map<String, dynamic> json) {
    return DriverModel(
      id: json['id'],
      userId: json['user_id'],
      user: json['user'] != null ? UserModel.fromJson(json['user']) : null,
      licenseNumber: json['license_number'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user': user!.toJson(),
      'user_id': userId,
      'license_number': licenseNumber,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  @override
  String toString() {
    return 'DriverModel{user: $user,userId: $userId, licenseNumber: $licenseNumber}';
  }
}
