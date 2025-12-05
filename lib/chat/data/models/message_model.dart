class Message {
  final String id;
  final String senderId;
  final String receiverId;
  final String content;
  final DateTime timestamp;
  final bool isRead;

  Message({
    required this.id,
    required this.senderId,
    required this.receiverId,
    required this.content,
    required this.timestamp,
    required this.isRead,
  });

  /// Convert JSON to Message object
  factory Message.fromJson(Map<String, dynamic> json) {
    // Helper to safely convert any type to String
    String toString(dynamic value) {
      if (value == null) return '';
      if (value is String) return value;
      if (value is Map) {
        // If it's a nested object, try to get 'id' or '_id' field
        if (value.containsKey('_id')) return value['_id'].toString();
        if (value.containsKey('id')) return value['id'].toString();
        return value.toString();
      }
      return value.toString();
    }

    // Helper to safely parse DateTime
    DateTime parseDateTime(dynamic value) {
      if (value == null) return DateTime.now();
      if (value is DateTime) return value;
      if (value is String) {
        try {
          return DateTime.parse(value);
        } catch (e) {
          return DateTime.now();
        }
      }
      return DateTime.now();
    }

    return Message(
      id: json['_id'] ?? json['id'] ?? '',
      senderId: toString(json['senderId']),
      receiverId: toString(json['receiverId']),
      content: toString(json['content']),
      timestamp: parseDateTime(json['timestamp']),
      isRead: json['isRead'] ?? false,
    );
  }

  /// Convert Message object to JSON
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'senderId': senderId,
      'receiverId': receiverId,
      'content': content,
      'timestamp': timestamp.toIso8601String(),
      'isRead': isRead,
    };
  }

  /// Create a copy with modified fields
  Message copyWith({
    String? id,
    String? senderId,
    String? receiverId,
    String? content,
    DateTime? timestamp,
    bool? isRead,
  }) {
    return Message(
      id: id ?? this.id,
      senderId: senderId ?? this.senderId,
      receiverId: receiverId ?? this.receiverId,
      content: content ?? this.content,
      timestamp: timestamp ?? this.timestamp,
      isRead: isRead ?? this.isRead,
    );
  }
}
