import 'package:buslink_flutter/Models/BusMovementModel.dart';
import 'package:buslink_flutter/Models/UserModel.dart';

class PassengerBoardingModel {
  final int id;
  final BusMovementModel? busMovement;
  final DateTime estimatedBoardingTime;
  String status;
  final int userId;
  final UserModel? user;
  final DateTime createdAt;
  final DateTime updatedAt;

  PassengerBoardingModel({
    required this.id,
    this.busMovement,
    required this.estimatedBoardingTime,
    required this.status,
    required this.userId,
    this.user,
    required this.createdAt,
    required this.updatedAt,
  });

  factory PassengerBoardingModel.fromJson(Map<String, dynamic> json) {
    return PassengerBoardingModel(
      id: json['id'],
      busMovement:
          json['movement'] != null
              ? BusMovementModel.fromJson(json['movement'])
              : null,
      estimatedBoardingTime: DateTime.parse(json['estimated_boarding_time']),
      status: json['status'],
      userId: json['user_id'],
      user: json['user'] != null ? UserModel.fromJson(json['user']) : null,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'movement': busMovement?.toJson(),
      'estimated_boarding_time': estimatedBoardingTime.toIso8601String(),
      'status': status,
      'user_id': userId,
      'user': user?.toJson(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  @override
  String toString() {
    return 'PassengerBoardingModel{id: $id, busMovement: $busMovement, estimatedBoardingTime: $estimatedBoardingTime, status: $status, userId: $userId, user: $user}';
  }
}
