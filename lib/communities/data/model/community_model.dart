class CommunityModel {
  final String id;
  final String title;
  final String details;
  final String category;
  final String timeNeeded;
  final String locationName;
  final int peopleRequired;
  final int joinedCount;
  final String status;
  final String creatorId;
  final String creatorName;

  CommunityModel({
    required this.id,
    required this.title,
    required this.details,
    required this.category,
    required this.timeNeeded,
    required this.locationName,
    required this.peopleRequired,
    required this.joinedCount,
    required this.status,
    required this.creatorId,
    required this.creatorName,
  });

  factory CommunityModel.fromJson(Map<String, dynamic> json) {
    final creator =
        json['createdBy'] is Map
            ? Map<String, dynamic>.from(json['createdBy'])
            : json['author'] is Map
            ? Map<String, dynamic>.from(json['author'])
            : null;
    final members = json['members'] is List ? json['members'] as List : null;

    return CommunityModel(
      id: json['_id']?.toString() ?? json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? 'Community request',
      details:
          json['details']?.toString() ?? json['description']?.toString() ?? '',
      category: json['category']?.toString() ?? 'Other',
      timeNeeded: json['timeNeeded']?.toString() ?? '',
      locationName: json['locationName']?.toString() ?? 'Nearby area',
      peopleRequired: _readInt(json['peopleRequired']) ?? 0,
      joinedCount: _readInt(json['joinedCount']) ?? members?.length ?? 0,
      status: json['status']?.toString() ?? 'open',
      creatorId:
          creator?['_id']?.toString() ??
          creator?['id']?.toString() ??
          json['createdBy']?.toString() ??
          '',
      creatorName:
          creator?['username']?.toString() ??
          creator?['name']?.toString() ??
          'Volunteer',
    );
  }
}

class CommunityMessage {
  final String id;
  final String senderId;
  final String senderName;
  final String content;
  final DateTime? createdAt;

  CommunityMessage({
    required this.id,
    required this.senderId,
    required this.senderName,
    required this.content,
    this.createdAt,
  });

  factory CommunityMessage.fromJson(Map<String, dynamic> json) {
    final sender =
        json['sender'] is Map
            ? Map<String, dynamic>.from(json['sender'])
            : null;
    return CommunityMessage(
      id: json['_id']?.toString() ?? json['id']?.toString() ?? '',
      senderId:
          sender?['_id']?.toString() ??
          sender?['id']?.toString() ??
          json['senderId']?.toString() ??
          '',
      senderName:
          sender?['username']?.toString() ??
          sender?['name']?.toString() ??
          json['senderName']?.toString() ??
          'Volunteer',
      content: json['content']?.toString() ?? '',
      createdAt:
          json['createdAt'] is String
              ? DateTime.tryParse(json['createdAt'])
              : null,
    );
  }
}

int? _readInt(dynamic value) {
  if (value is int) {
    return value;
  }
  if (value is num) {
    return value.toInt();
  }
  if (value is String) {
    return int.tryParse(value);
  }
  return null;
}
