class HelpRequestModel {
  String? id;
  String? seekerId;
  String? responderId;
  String? category;
  String? description;
  String? urgency;
  String? status;
  double? latitude;
  double? longitude;
  String? locationLabel;
  bool isSOS = false;
  List<String> mediaUrls = [];
  String? createdAt;
  String? updatedAt;
  String? resolvedAt;

  HelpRequestModel({
    this.id,
    this.seekerId,
    this.responderId,
    this.category,
    this.description,
    this.urgency,
    this.status,
    this.latitude,
    this.longitude,
    this.locationLabel,
    this.isSOS = false,
    this.mediaUrls = const [],
    this.createdAt,
    this.updatedAt,
    this.resolvedAt,
  });

  HelpRequestModel.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    seekerId = _readId(json['seekerId']);
    responderId = _readId(json['responderId']);
    category = json['category'];
    description = json['description'];
    urgency = json['urgency'];
    status = json['status'];
    final coordinates = json['location'] is Map
        ? (json['location']['coordinates'] as List?)
        : null;
    if (coordinates != null && coordinates.length >= 2) {
      longitude = (coordinates[0] as num?)?.toDouble();
      latitude = (coordinates[1] as num?)?.toDouble();
    }
    locationLabel = json['locationLabel'];
    isSOS = json['isSOS'] == true;
    mediaUrls = (json['mediaUrls'] as List?)?.map((e) => e.toString()).toList() ?? [];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    resolvedAt = json['resolvedAt'];
  }

  Map<String, dynamic> toCreateJson() {
    return {
      'category': category,
      'description': description,
      'urgency': urgency,
      'latitude': latitude,
      'longitude': longitude,
      'locationLabel': locationLabel,
      'isSOS': isSOS,
      'mediaUrls': mediaUrls,
    };
  }

  static String? _readId(dynamic value) {
    if (value == null) return null;
    if (value is String) return value;
    if (value is Map && value['_id'] != null) return value['_id'].toString();
    return value.toString();
  }
}
