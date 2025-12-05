class SignupModel {
  User? user;
  String? accessToken;

  SignupModel({this.user, this.accessToken});

  SignupModel.fromJson(Map<String, dynamic> json) {
    // Normalize response: API may return token/user at root or under 'data'
    Map<String, dynamic> root = Map<String, dynamic>.from(json);
    if (json['data'] != null && json['data'] is Map) {
      root = Map<String, dynamic>.from(json['data']);
    }

    // Handle both nested and flat user structures
    if (root['user'] != null && root['user'] is Map) {
      user = User.fromJson(Map<String, dynamic>.from(root['user']));
    } else if (json['user'] != null && json['user'] is Map) {
      user = User.fromJson(Map<String, dynamic>.from(json['user']));
    } else {
      // Fallback: parse from flat structure
      user = User(
        username: root['username'] ?? json['username'],
        email: root['email'] ?? json['email'],
        password: root['password'] ?? json['password'],
        role: root['role'] ?? json['role'],
      );
    }

    // Support multiple possible token keys
    accessToken =
        root['access_token'] ??
        root['token'] ??
        root['accessToken'] ??
        json['access_token'] ??
        json['token'] ??
        json['accessToken'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    // Send flat structure: username, email, password at root level (backend expects this)
    if (user != null) {
      data['username'] = user!.username;
      data['email'] = user!.email;
      data['password'] = user!.password;
      if (user!.role != null) {
        data['role'] = user!.role;
      }
    }
    if (accessToken != null) {
      data['access_token'] = accessToken;
    }
    return data;
  }

  // Copy with for immutability
  SignupModel copyWith({User? user, String? accessToken}) {
    return SignupModel(
      user: user ?? this.user,
      accessToken: accessToken ?? this.accessToken,
    );
  }

  @override
  String toString() => 'SignupModel(user: $user, accessToken: $accessToken)';
}

class User {
  String? id;
  String? username;
  String? email;
  String? password;
  String? role;
  String? verificationStatus; // NEW: Add verification status from backend

  User({
    this.username,
    this.email,
    this.password,
    this.role,
    this.id,
    this.verificationStatus, // NEW: Include in constructor
  });

  User.fromJson(Map<String, dynamic> json) {
    username = json['username'];
    email = json['email'];
    password = json['password'];
    role = json['role'];
    id = json['_id'] ?? json['id'];

    // Parse verificationStatus with multiple field name support
    verificationStatus =
        json['verificationStatus'] ??
        json['verification_status'] ??
        json['status'] ??
        json['verifyStatus'];

    print(
      '🔍 User.fromJson - Parsed verificationStatus: $verificationStatus from: ${json.keys}',
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['username'] = username;
    data['email'] = email;
    data['password'] = password;
    data['role'] = role;
    if (id != null) {
      data['id'] = id;
    }
    if (verificationStatus != null) {
      data['verificationStatus'] = verificationStatus;
    }
    return data;
  }

  // Copy with for immutability
  User copyWith({
    String? id,
    String? username,
    String? email,
    String? password,
    String? role,
    String? verificationStatus,
  }) {
    return User(
      id: id ?? this.id,
      username: username ?? this.username,
      email: email ?? this.email,
      password: password ?? this.password,
      role: role ?? this.role,
      verificationStatus: verificationStatus ?? this.verificationStatus,
    );
  }

  @override
  String toString() =>
      'User(id: $id, username: $username, email: $email, role: $role, verificationStatus: $verificationStatus)';
}
