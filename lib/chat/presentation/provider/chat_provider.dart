import 'dart:async';

import 'package:fyp_source_code/chat/data/models/conversation_model.dart';
import 'package:fyp_source_code/chat/data/models/message_model.dart';
import 'package:fyp_source_code/chat/data/services/chat_service.dart';
import 'package:fyp_source_code/chat/data/services/socket_service.dart';
import 'package:fyp_source_code/utilities/helpers/toast_helper.dart';
import 'package:fyp_source_code/utilities/reuse_components/storage_helper.dart';
import 'package:get/get.dart';

class ChatProvider extends GetxController {
  final ChatService _chatService = ChatService();
  final SocketService _socketService = SocketService();
  final StorageHelper _storage = StorageHelper();

  // Observables
  final RxList<Conversation> conversations = RxList<Conversation>();

  /// currentMessages holds the currently opened chat's messages (oldest -> newest)
  final RxList<Message> currentMessages = RxList<Message>();
  final RxInt unreadCount = 0.obs;
  final RxBool isLoading = false.obs;
  final RxBool isSocketConnected = false.obs;
  final Rx<String?> currentChatUserId = Rx<String?>(null);
  final RxMap<String, bool> typingUsers = RxMap<String, bool>();

  Stream<Map<String, dynamic>> get flowEventStream =>
      _socketService.flowEventStream;

  Timer? _typingTimer;

  @override
  void onInit() {
    super.onInit();
    _initializeChat();
  }

  /// Initialize chat system
  Future<void> _initializeChat() async {
    try {
      final token = _storage.readData('token');
      if (token == null) return;

      _socketService.connect(token);
      _setupSocketListeners();
      await Future.wait([fetchConversations(), fetchUnreadCount()]);
    } catch (e) {
      ToastHelper.showError('Failed to initialize chat');
    }
  }

  /// Setup socket event listeners
  void _setupSocketListeners() {
    _socketService.messageStream.listen(_handleReceivedMessage);
    _socketService.typingStream.listen(_handleTypingIndicator);
    _socketService.connectionStream.listen((connected) {
      isSocketConnected.value = connected;
    });
  }

  /// Handle received messages
  void _handleReceivedMessage(Message message) {
    try {
      final currentUserId = _storage.readData('userId');

      // Check if message belongs to current chat
      final isForCurrentChat =
          (message.senderId == currentUserId &&
              message.receiverId == currentChatUserId.value) ||
          (message.senderId == currentChatUserId.value &&
              message.receiverId == currentUserId);

      if (isForCurrentChat) {
        // Add if not already exists
        if (!currentMessages.any((msg) => msg.id == message.id)) {
          currentMessages.add(message);
          _saveMessagesToCache(
            message.senderId == currentUserId
                ? message.receiverId
                : message.senderId,
            currentMessages.toList(),
          );
        }
        markAsRead(
          message.senderId == currentUserId
              ? message.receiverId
              : message.senderId,
        );
      } else {
        // Save for later view
        if (message.receiverId == currentUserId ||
            message.senderId == currentUserId) {
          final otherId =
              message.senderId == currentUserId
                  ? message.receiverId
                  : message.senderId;
          _appendMessageToCache(otherId, message);
          fetchConversations();
        }
      }
      fetchUnreadCount();
    } catch (e) {
      // Silent fail
    }
  }

  /// Handle typing indicator
  void _handleTypingIndicator(Map<String, dynamic> data) {
    final isTyping = data['isTyping'] ?? false;
    final userId = data['userId'] ?? '';

    if (isTyping) {
      typingUsers[userId] = true;
    } else {
      typingUsers.remove(userId);
    }
  }

  // ============ CONVERSATION METHODS ============

  /// Fetch all conversations
  Future<void> fetchConversations() async {
    try {
      isLoading.value = true;
      print('🔄 Fetching conversations...');

      final fetchedConversations = await _chatService.fetchConversations();
      conversations.assignAll(fetchedConversations);

      print('✅ Fetched ${conversations.length} conversations');
    } catch (e) {
      print('❌ Error fetching conversations: $e');
      ToastHelper.showError('Failed to load conversations');
    } finally {
      isLoading.value = false;
    }
  }

  // ============ CHAT DETAIL METHODS ============

  /// Open a conversation and load history
  Future<void> openConversation(String userId) async {
    try {
      print('🔄 [OPEN_CONV] Starting to open conversation with $userId');
      print(
        '   Current state: currentChatUserId=${currentChatUserId.value}, messages=${currentMessages.length}',
      );

      isLoading.value = true;

      // CRITICAL: Set current chat ID FIRST, before ANY async operations
      // This tells socket listener which chat is active
      currentChatUserId.value = userId;
      print('✅ [OPEN_CONV] Set currentChatUserId to: $userId');

      // Try to load from cache first
      List<Message> messages = _loadMessagesFromCache(userId);
      print('📦 [OPEN_CONV] Cache returned ${messages.length} messages');

      // If cache is empty, fetch from API
      if (messages.isEmpty) {
        print('📡 [OPEN_CONV] Cache empty, fetching from API...');
        messages = await _chatService.fetchConversationHistory(userId);
        print('📡 [OPEN_CONV] API returned ${messages.length} messages');
        // Save to cache
        if (messages.isNotEmpty) {
          _saveMessagesToCache(userId, messages);
          print('💾 [OPEN_CONV] Saved ${messages.length} messages to cache');
        }
      } else {
        print('💾 [OPEN_CONV] Using ${messages.length} cached messages');
      }

      // Ensure messages are sorted ASC (oldest -> newest)
      messages.sort((a, b) => a.timestamp.compareTo(b.timestamp));
      print('📋 [OPEN_CONV] Sorted messages, oldest first');

      // CRITICAL: Clear and populate in one operation
      print(
        '📋 [OPEN_CONV] Before clear: currentMessages.length = ${currentMessages.length}',
      );
      currentMessages.clear();
      print(
        '📋 [OPEN_CONV] After clear: currentMessages.length = ${currentMessages.length}',
      );

      // Add all messages
      currentMessages.addAll(messages);
      print(
        '✅ [OPEN_CONV] After addAll: currentMessages.length = ${currentMessages.length}',
      );
      print(
        '✅ [OPEN_CONV] Final state: currentChatUserId=$userId, messages.length=${currentMessages.length}',
      );

      // Mark as read
      await markAsRead(userId);
      print('✅ [OPEN_CONV] Marked messages as read');

      // Remove typing indicator
      typingUsers.remove(userId);

      print(
        '✅ [OPEN_CONV] COMPLETE: Conversation $userId loaded with ${currentMessages.length} messages',
      );
    } catch (e) {
      print('❌ [OPEN_CONV] ERROR: $e');
      ToastHelper.showError('Failed to load chat');
    } finally {
      isLoading.value = false;
    }
  }

  /// Close current conversation
  void closeConversation() {
    // Save messages before clearing
    if (currentChatUserId.value != null && currentMessages.isNotEmpty) {
      _saveMessagesToCache(currentChatUserId.value!, currentMessages.toList());
      print(
        '💾 Saved ${currentMessages.length} messages before closing conversation',
      );
    }

    currentChatUserId.value = null;
    currentMessages.clear();
    typingUsers.clear();
    print('❌ Closed conversation');
  }

  // ============ MESSAGE METHODS ============

  /// Send a message
  void sendMessage({required String receiverId, required String content}) {
    try {
      // Validate
      if (content.trim().isEmpty) {
        ToastHelper.showWarning('Cannot send empty message');
        return;
      }

      print('📤 Sending message: $content');

      // Create optimistic message (shows immediately)
      final message = Message(
        id: 'temp_${DateTime.now().millisecondsSinceEpoch}',
        senderId: _storage.readData('userId') ?? 'unknown',
        receiverId: receiverId,
        content: content,
        timestamp: DateTime.now(),
        isRead: false,
      );

      // Add to messages immediately (append to end; list is oldest->newest)
      // If the currently opened chat is the receiverId, add it
      if (currentChatUserId.value == receiverId) {
        currentMessages.add(message);
      }

      // Save to cache immediately for that conversation
      _appendMessageToCache(receiverId, message);

      // Emit via WebSocket
      _socketService.sendMessage(receiverId: receiverId, content: content);

      print('✅ Message sent (optimistic)');
    } catch (e) {
      print('❌ Error sending message: $e');
      ToastHelper.showError('Failed to send message');
    }
  }

  // ============ TYPING INDICATOR ============

  /// Emit typing indicator with debounce
  void onTyping({required String receiverId, required bool isTyping}) {
    _typingTimer?.cancel();

    // Always emit immediately when starting to type
    if (isTyping) {
      _socketService.emitTyping(receiverId: receiverId, isTyping: true);
    } else {
      // Debounce when stopping
      _typingTimer = Timer(Duration(milliseconds: 300), () {
        _socketService.emitTyping(receiverId: receiverId, isTyping: false);
      });
    }
  }

  // ============ UNREAD COUNT ============

  /// Fetch unread count
  Future<void> fetchUnreadCount() async {
    try {
      final count = await _chatService.fetchUnreadCount();
      unreadCount.value = count;
      print('📊 Unread count: $count');
    } catch (e) {
      print('❌ Error fetching unread count: $e');
    }
  }

  /// Mark conversation as read
  Future<void> markAsRead(String userId) async {
    try {
      final success = await _chatService.markConversationAsRead(userId);
      if (success) {
        print('✅ Marked as read: $userId');
        await fetchUnreadCount();
      }
    } catch (e) {
      print('❌ Error marking as read: $e');
    }
  }

  // ============ PULL TO REFRESH ============

  /// Refresh conversations
  Future<void> refreshConversations() async {
    print('🔄 Refreshing conversations...');
    await fetchConversations();
  }

  // ============ MESSAGE CACHING ============

  /// Get cache key for messages with a user
  String _getCacheKey(String userId) => 'chat_messages_$userId';

  /// Save messages to local cache
  void _saveMessagesToCache(String userId, List<Message> messages) {
    try {
      final json = messages.map((m) => m.toJson()).toList();
      _storage.writeData(_getCacheKey(userId), json);
      print('💾 Saved ${messages.length} messages to cache for $userId');
    } catch (e) {
      print('❌ Error saving messages to cache: $e');
    }
  }

  /// Load messages from local cache
  List<Message> _loadMessagesFromCache(String userId) {
    try {
      final cached = _storage.readData(_getCacheKey(userId));
      if (cached != null && cached is List) {
        final messages =
            cached
                .map((e) => Map<String, dynamic>.from(e as Map))
                .map((json) => Message.fromJson(json))
                .toList();
        print('📦 Loaded ${messages.length} cached messages for $userId');

        // Sort messages by timestamp ascending (oldest -> newest)
        messages.sort((a, b) => a.timestamp.compareTo(b.timestamp));
        return messages;
      }
      return [];
    } catch (e) {
      print('❌ Error loading messages from cache: $e');
      return [];
    }
  }

  /// Append a single message to cache (for first message scenarios)
  void _appendMessageToCache(String userId, Message message) {
    try {
      List<Message> messages = _loadMessagesFromCache(userId);

      // Check if message already exists
      if (!messages.any((msg) => msg.id == message.id)) {
        messages.add(message);
        // Ensure order oldest->newest
        messages.sort((a, b) => a.timestamp.compareTo(b.timestamp));
        _saveMessagesToCache(userId, messages);
        print('📦 Appended message to cache for $userId');
      } else {
        print('⚠️ Tried to append duplicate to cache for $userId');
      }
    } catch (e) {
      print('❌ Error appending message to cache: $e');
    }
  }

  @override
  void onClose() {
    _typingTimer?.cancel();
    // Save current messages before closing to ensure persistence
    if (currentChatUserId.value != null && currentMessages.isNotEmpty) {
      _saveMessagesToCache(currentChatUserId.value!, currentMessages.toList());
      print(
        '💾 Saved ${currentMessages.length} messages on ChatProvider close',
      );
    }
    // Don't dispose socket - keep it alive for reconnection across screens
    print('🧹 ChatProvider closed (socket kept alive for persistence)');
    super.onClose();
  }
}
