class CoordinationContact {
  final String id;
  final String name;
  final String email;
  final String role;
  final String contactType;
  final String? requestId;

  CoordinationContact({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.contactType = '',
    this.requestId,
  });

  bool get isVolunteer => role.toLowerCase() == 'volunteer';
  bool get isAcceptedVolunteer =>
      contactType.toLowerCase() == 'acceptedvolunteer';

  String get contextLabel {
    switch (contactType.toLowerCase()) {
      case 'acceptedvolunteer':
        return 'Accepted volunteer for your request';
      case 'requestee':
        return 'Requester you are helping';
      case 'volunteer':
        return 'Volunteer contact';
      default:
        return '';
    }
  }

  factory CoordinationContact.fromJson(Map<String, dynamic> json) {
    final user =
        json['user'] is Map
            ? Map<String, dynamic>.from(json['user'])
            : json['contact'] is Map
            ? Map<String, dynamic>.from(json['contact'])
            : json;

    return CoordinationContact(
      id: user['_id']?.toString() ?? user['id']?.toString() ?? '',
      name:
          user['username']?.toString() ??
          user['name']?.toString() ??
          json['username']?.toString() ??
          'User',
      email: user['email']?.toString() ?? json['email']?.toString() ?? '',
      role: user['role']?.toString() ?? json['role']?.toString() ?? 'requestee',
      contactType: json['contactType']?.toString() ?? '',
      requestId:
          json['requestId']?.toString() ?? json['helpRequestId']?.toString(),
    );
  }
}
