class SignupModel {
  User? user;
  String? accessToken;

  SignupModel({this.user, this.accessToken});

  SignupModel.fromJson(Map<String, dynamic> json) {
    // Handle both nested and flat response structures
    if (json['user'] != null) {
      user = User.fromJson(json['user']);
    } else {
      // Fallback: parse from flat structure
      user = User(
        username: json['username'],
        email: json['email'],
        password: json['password'],
        role: json['role'],
      );
    }
    accessToken = json['access_token'] ?? json['accessToken'];
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
}

class User {
  String? id;
  String? username;
  String? email;
  String? password;
  String? role;

  User({this.username, this.email, this.password, this.role, this.id});

  User.fromJson(Map<String, dynamic> json) {
    username = json['username'];
    email = json['email'];
    password = json['password'];
    role = json['role'];
    id = json['_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['username'] = username;
    data['email'] = email;
    data['password'] = password;
    data['role'] = role;
    return data;
  }
}
