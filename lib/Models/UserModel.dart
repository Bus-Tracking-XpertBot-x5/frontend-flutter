import 'package:buslink_flutter/Models/OrganizationModel.dart';

class UserModel {
  final int id;
  String name;
  String phoneNumber;
  String email;
  String role;
  final String? token;
  double? latitude;
  double? longitude;
  OrganizationModel? organization;

  UserModel({
    required this.id,
    required this.name,
    required this.phoneNumber,
    required this.email,
    required this.role,
    this.token,
    required this.latitude,
    required this.longitude,
    this.organization,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phoneNumber: json['phone_number'],
      role: json['role'],
      token: json['token'],
      latitude:
          json['latitude'] != null
              ? double.tryParse(json['latitude'].toString())
              : null,
      longitude:
          json['longitude'] != null
              ? double.tryParse(json['longitude'].toString())
              : null,
      organization:
          json['organization'] != null
              ? OrganizationModel.fromJson(json['organization'])
              : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phoneNumber': phoneNumber,
      'role': role,
      'latitude': latitude,
      'longitude': longitude,
      'organization': organization?.toJson(),
    };
  }

  @override
  String toString() {
    return 'UserModel{name: $name, phoneNumber: $phoneNumber, email: $email, role: $role, organization: ${organization?.name}}';
  }
}
