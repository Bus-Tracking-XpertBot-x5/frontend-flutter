class OrganizationModel {
  final int id;
  final String name;
  final double? latitude;
  final double? longitude;
  final String? description;
  final int? managerId;
  final DateTime createdAt;
  final DateTime updatedAt;

  OrganizationModel({
    required this.id,
    required this.name,
    this.latitude,
    this.longitude,
    this.description,
    this.managerId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory OrganizationModel.fromJson(Map<String, dynamic> json) {
    return OrganizationModel(
      id: json['id'],
      name: json['name'],
      latitude:
          json['latitude'] != null ? double.parse(json['latitude']) : null,
      longitude:
          json['longitude'] != null ? double.parse(json['longitude']) : null,
      description: json['description'],
      managerId: json['manager_id'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'latitude': latitude,
      'longitude': longitude,
      'description': description,
      'manager_id': managerId,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  @override
  String toString() {
    return 'OrganizationModel{name: $name, latitude: $latitude, longitude: $longitude, description: $description, managerId: $managerId}';
  }
}
