class AlertModel {
  final String id;
  final String title;
  final String description;
  final String locationName;
  final String createdByName;
  final DateTime? expiresAt;
  final DateTime? createdAt;

  AlertModel({
    required this.id,
    required this.title,
    required this.description,
    required this.locationName,
    required this.createdByName,
    this.expiresAt,
    this.createdAt,
  });

  factory AlertModel.fromJson(Map<String, dynamic> json) {
    final creator =
        json['createdBy'] is Map
            ? Map<String, dynamic>.from(json['createdBy'])
            : null;

    return AlertModel(
      id: json['_id']?.toString() ?? json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? 'Alert',
      description: json['description']?.toString() ?? '',
      locationName:
          json['locationName']?.toString() ??
          json['address']?.toString() ??
          'Nearby area',
      createdByName:
          creator?['username']?.toString() ??
          creator?['name']?.toString() ??
          json['createdByName']?.toString() ??
          'Community member',
      expiresAt: _parseDate(json['expiresAt']),
      createdAt: _parseDate(json['createdAt']),
    );
  }
}

DateTime? _parseDate(dynamic value) {
  if (value is String) {
    return DateTime.tryParse(value);
  }
  return null;
}
