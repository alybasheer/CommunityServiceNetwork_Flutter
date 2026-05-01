import 'package:latlong2/latlong.dart';

class MapUserModel {
  final String id;
  final String name;
  final String role;
  final LatLng location;

  MapUserModel({
    required this.id,
    required this.name,
    required this.role,
    required this.location,
  });

  bool get isVolunteer => role.toLowerCase() == 'volunteer';

  factory MapUserModel.fromJson(Map<String, dynamic> json) {
    final location =
        json['location'] is Map
            ? Map<String, dynamic>.from(json['location'])
            : <String, dynamic>{};
    final coordinates =
        location['coordinates'] is List
            ? location['coordinates'] as List
            : const [];
    final lng = coordinates.isNotEmpty ? _readDouble(coordinates[0]) : null;
    final lat = coordinates.length > 1 ? _readDouble(coordinates[1]) : null;

    return MapUserModel(
      id: json['_id']?.toString() ?? json['id']?.toString() ?? '',
      name: json['username']?.toString() ?? json['name']?.toString() ?? 'User',
      role: json['role']?.toString() ?? 'requestee',
      location: LatLng(
        lat ?? _readDouble(json['latitude'] ?? json['lat']) ?? 0,
        lng ?? _readDouble(json['longitude'] ?? json['lng']) ?? 0,
      ),
    );
  }
}

double? _readDouble(dynamic value) {
  if (value is num) {
    return value.toDouble();
  }
  if (value is String) {
    return double.tryParse(value);
  }
  return null;
}
