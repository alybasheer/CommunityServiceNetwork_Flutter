import 'package:fyp_source_code/services/location_services.dart';

class HelpRequestLocation {
  String? type;
  List<double>? coordinates;

  HelpRequestLocation({this.type, this.coordinates});

  HelpRequestLocation.fromJson(Map<String, dynamic> json) {
    type = json['type']?.toString();
    if (json['coordinates'] is List) {
      coordinates =
          (json['coordinates'] as List)
              .whereType<num>()
              .map((e) => e.toDouble())
              .toList();
    } else {
      final lat = _readDouble(json['latitude'] ?? json['lat']);
      final lng = _readDouble(json['longitude'] ?? json['lng']);
      if (lat != null && lng != null) {
        type = 'Point';
        coordinates = [lng, lat];
      }
    }
  }

  HelpRequestLocation.fromLatLng({required double lat, required double lng}) {
    type = 'Point';
    coordinates = [lng, lat];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['type'] = type;
    data['coordinates'] = coordinates;
    return data;
  }

  double? get longitude {
    if (coordinates == null || coordinates!.length < 2) {
      return null;
    }
    return coordinates![0];
  }

  double? get latitude {
    if (coordinates == null || coordinates!.length < 2) {
      return null;
    }
    return coordinates![1];
  }
}

class HelpRequest {
  String? sId;
  String? userId;
  String? userName;
  String? title;
  String? category;
  String? subCategory;
  String? description;
  String? image;
  String? locationName;
  HelpRequestLocation? location;
  String? status;
  String? acceptedBy;
  String? acceptedByName;
  bool isSos = false;
  double? rating;
  String? outcome;
  String? expiresAt;
  String? createdAt;
  String? updatedAt;

  HelpRequest({
    this.sId,
    this.userId,
    this.userName,
    this.title,
    this.category,
    this.subCategory,
    this.description,
    this.image,
    this.locationName,
    this.location,
    this.status,
    this.acceptedBy,
    this.acceptedByName,
    this.isSos = false,
    this.rating,
    this.outcome,
    this.expiresAt,
    this.createdAt,
    this.updatedAt,
  });

  HelpRequest.fromJson(Map<String, dynamic> json) {
    final userRef = json['userId'] ?? json['user'] ?? json['requestee'];
    final acceptedRef = json['acceptedBy'] ?? json['volunteer'];

    sId = _readId(json);
    userId = _readRefId(userRef);
    userName =
        _readRefName(userRef) ??
        json['userName']?.toString() ??
        json['requesteeName']?.toString();
    title = json['title']?.toString();
    category = json['category']?.toString();
    subCategory = json['subCategory']?.toString();
    description = json['description']?.toString();
    image = json['image']?.toString();
    locationName =
        json['locationName']?.toString() ?? json['address']?.toString();
    if (json['location'] is Map) {
      location = HelpRequestLocation.fromJson(
        Map<String, dynamic>.from(json['location']),
      );
    } else {
      final lat = _readDouble(json['latitude'] ?? json['lat']);
      final lng = _readDouble(json['longitude'] ?? json['lng']);
      if (lat != null && lng != null) {
        location = HelpRequestLocation.fromLatLng(lat: lat, lng: lng);
      }
    }
    status = json['status']?.toString();
    acceptedBy = _readRefId(acceptedRef);
    acceptedByName =
        _readRefName(acceptedRef) ?? json['acceptedByName']?.toString();
    isSos =
        _readBool(json['isSos']) ||
        _readBool(json['sos']) ||
        (category?.toLowerCase() == 'sos');
    rating = _readDouble(json['rating'] ?? json['volunteerRating']);
    outcome = json['outcome']?.toString();
    expiresAt = json['expiresAt']?.toString();
    createdAt = json['createdAt']?.toString();
    updatedAt = json['updatedAt']?.toString();
  }

  String get displayTitle {
    if (title != null && title!.trim().isNotEmpty) {
      return title!;
    }
    if (isSos) {
      return 'SOS Request';
    }
    if (category != null && subCategory != null) {
      return '$category - $subCategory';
    }
    return category ?? 'Emergency Request';
  }

  String get displayLocation {
    if (locationName != null &&
        locationName!.trim().isNotEmpty &&
        !isGenericLocationLabel(locationName!)) {
      return locationName!;
    }
    return 'Resolving nearby area...';
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['_id'] = sId;
    data['userId'] = userId;
    data['userName'] = userName;
    data['title'] = title;
    data['category'] = category;
    data['subCategory'] = subCategory;
    data['description'] = description;
    data['image'] = image;
    data['locationName'] = locationName;
    if (location != null) {
      data['location'] = location!.toJson();
    }
    data['status'] = status;
    data['acceptedBy'] = acceptedBy;
    data['acceptedByName'] = acceptedByName;
    data['isSos'] = isSos;
    data['rating'] = rating;
    data['outcome'] = outcome;
    data['expiresAt'] = expiresAt;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    return data;
  }
}

class NearbyVolunteer {
  final String id;
  final String name;
  final String email;
  final String expertise;
  final double rating;
  final bool isOnline;
  final double? distanceKm;
  final String? locationName;

  NearbyVolunteer({
    required this.id,
    required this.name,
    required this.email,
    required this.expertise,
    required this.rating,
    required this.isOnline,
    this.distanceKm,
    this.locationName,
  });

  factory NearbyVolunteer.fromJson(Map<String, dynamic> json) {
    final user =
        json['user'] is Map ? Map<String, dynamic>.from(json['user']) : json;
    final expertiseValue =
        user['expertise'] ?? user['skills'] ?? user['category'] ?? 'General';
    final expertise =
        expertiseValue is List
            ? expertiseValue.join(', ')
            : expertiseValue.toString();

    return NearbyVolunteer(
      id: _readRefId(user) ?? '',
      name:
          user['username']?.toString() ??
          user['name']?.toString() ??
          'Volunteer',
      email: user['email']?.toString() ?? '',
      expertise: expertise.isEmpty ? 'General' : expertise,
      rating: _readDouble(user['rating'] ?? user['averageRating']) ?? 0,
      isOnline: _readBool(
        user['isOnline'] ?? user['online'] ?? json['isOnline'],
      ),
      distanceKm: _readDouble(json['distanceKm'] ?? json['distance']),
      locationName:
          user['locationName']?.toString() ?? json['locationName']?.toString(),
    );
  }
}

String? _readId(Map<String, dynamic> json) {
  return json['_id']?.toString() ?? json['id']?.toString();
}

String? _readRefId(dynamic value) {
  if (value == null) {
    return null;
  }
  if (value is Map) {
    return value['_id']?.toString() ?? value['id']?.toString();
  }
  return value.toString();
}

String? _readRefName(dynamic value) {
  if (value is Map) {
    return value['username']?.toString() ?? value['name']?.toString();
  }
  return null;
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

bool _readBool(dynamic value) {
  if (value is bool) {
    return value;
  }
  if (value is String) {
    return value.toLowerCase() == 'true';
  }
  return false;
}
