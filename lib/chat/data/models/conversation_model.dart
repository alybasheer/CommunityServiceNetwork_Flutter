import 'message_model.dart';

class Conversation {
  final String userId;
  final String username;
  final String email;
  final String? avatar;
  final Message? lastMessage;
  final DateTime? lastMessageTime;
  final bool hasUnread;

  Conversation({
    required this.userId,
    required this.username,
    required this.email,
    this.avatar,
    this.lastMessage,
    this.lastMessageTime,
    this.hasUnread = false,
  });

  /// Convert JSON to Conversation object
  factory Conversation.fromJson(Map<String, dynamic> json) {
    final lastMessageJson = json['lastMessage'];

    // Handle nested 'user' object from backend
    final userObj =
        json['user'] is Map ? Map<String, dynamic>.from(json['user']) : null;

    // Determine if conversation has unread messages
    // Check both direct hasUnread field and lastMessage.isRead
    bool unread = json['hasUnread'] ?? false;
    if (!unread && lastMessageJson is Map) {
      final lastMsg = Map<String, dynamic>.from(lastMessageJson);
      unread = lastMsg['isRead'] == false;
    }

    return Conversation(
      userId: userObj?['_id'] ?? json['userId'] ?? json['_id'] ?? '',
      username: userObj?['username'] ?? json['username'] ?? '',
      email: userObj?['email'] ?? json['email'] ?? '',
      avatar: userObj?['avatar'] ?? json['avatar'],
      lastMessage:
          lastMessageJson != null
              ? Message.fromJson(lastMessageJson as Map<String, dynamic>)
              : null,
      lastMessageTime:
          json['lastMessageTime'] is String
              ? DateTime.parse(json['lastMessageTime'])
              : (lastMessageJson is Map &&
                      lastMessageJson['timestamp'] is String
                  ? DateTime.parse(lastMessageJson['timestamp'])
                  : null),
      hasUnread: unread,
    );
  }

  /// Convert Conversation object to JSON
  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'username': username,
      'email': email,
      'avatar': avatar,
      'lastMessage': lastMessage?.toJson(),
      'lastMessageTime': lastMessageTime?.toIso8601String(),
      'hasUnread': hasUnread,
    };
  }

  /// Create a copy with modified fields
  Conversation copyWith({
    String? userId,
    String? username,
    String? email,
    String? avatar,
    Message? lastMessage,
    DateTime? lastMessageTime,
    bool? hasUnread,
  }) {
    return Conversation(
      userId: userId ?? this.userId,
      username: username ?? this.username,
      email: email ?? this.email,
      avatar: avatar ?? this.avatar,
      lastMessage: lastMessage ?? this.lastMessage,
      lastMessageTime: lastMessageTime ?? this.lastMessageTime,
      hasUnread: hasUnread ?? this.hasUnread,
    );
  }
}
