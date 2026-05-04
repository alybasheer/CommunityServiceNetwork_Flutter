class CoordinationContact {
  final String id;
  final String name;
  final String email;
  final String role;
  final String? requestId;

  CoordinationContact({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.requestId,
  });

  bool get isVolunteer => role.toLowerCase() == 'volunteer';

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
      requestId:
          json['requestId']?.toString() ?? json['helpRequestId']?.toString(),
    );
  }
}
