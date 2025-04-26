class BusRouteModel {
  final int id;
  final String routeName;
  final Map<String, dynamic> startLocation;
  final Map<String, dynamic> endLocation;
  final DateTime createdAt;
  final DateTime updatedAt;

  BusRouteModel({
    required this.id,
    required this.routeName,
    required this.startLocation,
    required this.endLocation,
    required this.createdAt,
    required this.updatedAt,
  });

  factory BusRouteModel.fromJson(Map<String, dynamic> json) {
    return BusRouteModel(
      id: json['id'],
      routeName: json['route_name'],
      startLocation: Map<String, dynamic>.from(json['start_location']),
      endLocation: Map<String, dynamic>.from(json['end_location']),
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'route_name': routeName,
      'start_location': startLocation,
      'end_location': endLocation,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  @override
  String toString() {
    return 'BusRouteModel{routeName: $routeName, startLocation: $startLocation, endLocation: $endLocation}';
  }
}
