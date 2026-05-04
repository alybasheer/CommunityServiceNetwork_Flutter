import 'package:fyp_source_code/view/chat/data/models/conversation_model.dart';
import 'package:fyp_source_code/view/chat/data/models/message_model.dart';
import 'package:fyp_source_code/network/api_service.dart';
import 'package:fyp_source_code/services/api_names.dart';

class ChatService {
  final DioHelper _dioHelper = DioHelper();

  /// Fetch all conversations for the current user
  Future<List<Conversation>> fetchConversations() async {
    try {
      print('🔄 Fetching conversations from API...');

      final response = await _dioHelper.get(
        url: ApiNames.chatConversations,
        isauthorize: true,
      );

      print('📦 Conversations Response: $response');

      if (response is Map) {
        final responseMap = Map<String, dynamic>.from(response);

        // Check for nested 'data' object with 'conversations' array
        if (responseMap.containsKey('data') && responseMap['data'] is Map) {
          final dataMap = Map<String, dynamic>.from(responseMap['data']);

          // Look for conversations array
          if (dataMap.containsKey('conversations') &&
              dataMap['conversations'] is List) {
            final conversations =
                (dataMap['conversations'] as List)
                    .cast<Map<String, dynamic>>()
                    .map((e) => Conversation.fromJson(e))
                    .toList();
            print(
              '✅ Fetched ${conversations.length} conversations from data.conversations',
            );
            return conversations;
          }
        }
        // Check for direct data as list (legacy format)
        else if (responseMap.containsKey('data') &&
            responseMap['data'] is List) {
          final conversations =
              (responseMap['data'] as List)
                  .cast<Map<String, dynamic>>()
                  .map((e) => Conversation.fromJson(e))
                  .toList();
          print(
            '✅ Fetched ${conversations.length} conversations from data array',
          );
          return conversations;
        }
        // Direct response as list
        else if (response is List) {
          final conversations =
              (response as List)
                  .cast<Map<String, dynamic>>()
                  .map((e) => Conversation.fromJson(e))
                  .toList();
          print(
            '✅ Fetched ${conversations.length} conversations (direct list)',
          );
          return conversations;
        }
      }

      print('⚠️ Unexpected response format');
      return [];
    } catch (e) {
      print('❌ Error fetching conversations: $e');
      rethrow;
    }
  }

  /// Fetch conversation history with another user
  Future<List<Message>> fetchConversationHistory(
    String otherUserId, {
    int limit = 50,
  }) async {
    try {
      print('🔄 Fetching conversation history with $otherUserId...');
      print(
        '📋 URL will be: ${ApiNames.chatConversation(otherUserId, limit: limit)}',
      );

      final response = await _dioHelper.get(
        url: ApiNames.chatConversation(otherUserId, limit: limit),
        isauthorize: true,
      );

      print('📦 Conversation History Response: $response');

      if (response is Map) {
        final responseMap = Map<String, dynamic>.from(response);

        // Try all possible response formats
        List<dynamic>? messagesList;

        // 1. Check for nested 'data' object with messages array
        if (responseMap.containsKey('data') && responseMap['data'] is Map) {
          final dataMap = Map<String, dynamic>.from(responseMap['data']);
          print('📊 Data object keys: ${dataMap.keys.toList()}');

          if (dataMap.containsKey('messages') && dataMap['messages'] is List) {
            messagesList = dataMap['messages'] as List;
            print('✅ Found messages in data.messages: ${messagesList.length}');
          }
        }

        // 2. Check for direct messages array at root
        if (messagesList == null &&
            responseMap.containsKey('messages') &&
            responseMap['messages'] is List) {
          messagesList = responseMap['messages'] as List;
          print('✅ Found messages in root messages: ${messagesList.length}');
        }

        // 3. If data is an array itself (less common)
        if (messagesList == null &&
            responseMap.containsKey('data') &&
            responseMap['data'] is List) {
          messagesList = responseMap['data'] as List;
          print('✅ Found messages in data array: ${messagesList.length}');
        }

        if (messagesList != null) {
          final messages =
              messagesList
                  .cast<Map<String, dynamic>>()
                  .map((e) => Message.fromJson(e))
                  .toList();

          print('✅ Fetched ${messages.length} messages total');

          if (messages.isEmpty) {
            print('⚠️ API returned empty messages array');
            print('   This is normal for first conversation');
          }

          return messages;
        } else {
          print('❌ Could not find messages in any expected location');
          print('   Response keys: ${responseMap.keys.toList()}');
          return [];
        }
      }

      print('⚠️ Response is not a Map, type: ${response.runtimeType}');
      return [];
    } catch (e) {
      print('❌ Error fetching conversation history: $e');
      rethrow;
    }
  }

  /// Get unread message count
  Future<int> fetchUnreadCount() async {
    try {
      print('🔄 Fetching unread count...');

      final response = await _dioHelper.get(
        url: ApiNames.chatUnreadCount,
        isauthorize: true,
      );

      print('📦 Unread Count Response: $response');

      if (response is Map) {
        final responseMap = Map<String, dynamic>.from(response);

        // Check for nested 'data' object
        if (responseMap.containsKey('data') && responseMap['data'] is Map) {
          final dataMap = Map<String, dynamic>.from(responseMap['data']);
          final count = dataMap['unreadCount'] ?? 0;
          print('✅ Unread count: $count');
          return count as int;
        }
        // Check for direct unreadCount field
        else if (responseMap.containsKey('unreadCount')) {
          final count = responseMap['unreadCount'] ?? 0;
          print('✅ Unread count: $count');
          return count as int;
        }
      }

      print('⚠️ Could not parse unread count');
      return 0;
    } catch (e) {
      print('❌ Error fetching unread count: $e');
      return 0;
    }
  }

  /// Mark messages from a sender as read
  Future<bool> markConversationAsRead(String senderId) async {
    try {
      print('🔄 Marking conversation with $senderId as read...');

      final response = await _dioHelper.get(
        url: ApiNames.markChatAsRead(senderId),
        isauthorize: true,
      );

      print('📦 Mark as Read Response: $response');

      if (response is Map) {
        final responseMap = Map<String, dynamic>.from(response);

        if (responseMap.containsKey('success')) {
          final success = responseMap['success'] == true;
          if (success) {
            print('✅ Marked as read successfully');
          }
          return success;
        }
      }

      print('✅ Mark as read completed');
      return true;
    } catch (e) {
      print('❌ Error marking as read: $e');
      return false;
    }
  }
}
