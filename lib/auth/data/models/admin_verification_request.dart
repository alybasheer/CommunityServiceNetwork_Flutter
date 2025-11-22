class AdminVerificationRequest {
  final String id;
  final String fullName;
  final String expertise;
  final String cnicNumber;
  final String description;
  final String location;
  final String? imagePath;
  final DateTime submittedAt;
  final String status; // pending, approved, disapproved
  final String? adminComments;

  AdminVerificationRequest({
    required this.id,
    required this.fullName,
    required this.expertise,
    required this.cnicNumber,
    required this.description,
    required this.location,
    this.imagePath,
    required this.submittedAt,
    this.status = 'pending',
    this.adminComments,
  });

  AdminVerificationRequest copyWith({
    String? id,
    String? fullName,
    String? expertise,
    String? cnicNumber,
    String? description,
    String? location,
    String? imagePath,
    DateTime? submittedAt,
    String? status,
    String? adminComments,
  }) {
    return AdminVerificationRequest(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      expertise: expertise ?? this.expertise,
      cnicNumber: cnicNumber ?? this.cnicNumber,
      description: description ?? this.description,
      location: location ?? this.location,
      imagePath: imagePath ?? this.imagePath,
      submittedAt: submittedAt ?? this.submittedAt,
      status: status ?? this.status,
      adminComments: adminComments ?? this.adminComments,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'fullName': fullName,
      'expertise': expertise,
      'cnicNumber': cnicNumber,
      'description': description,
      'location': location,
      'imagePath': imagePath,
      'submittedAt': submittedAt.toIso8601String(),
      'status': status,
      'adminComments': adminComments,
    };
  }

  factory AdminVerificationRequest.fromMap(Map<String, dynamic> map) {
    return AdminVerificationRequest(
      id: map['id'] ?? '',
      fullName: map['fullName'] ?? '',
      expertise: map['expertise'] ?? '',
      cnicNumber: map['cnicNumber'] ?? '',
      description: map['description'] ?? '',
      location: map['location'] ?? '',
      imagePath: map['imagePath'],
      submittedAt: DateTime.parse(
        map['submittedAt'] ?? DateTime.now().toIso8601String(),
      ),
      status: map['status'] ?? 'pending',
      adminComments: map['adminComments'],
    );
  }
}
