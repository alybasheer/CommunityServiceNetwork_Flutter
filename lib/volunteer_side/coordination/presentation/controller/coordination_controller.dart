import 'package:flutter/widgets.dart';
import 'package:fyp_source_code/chat/data/models/conversation_model.dart';
import 'package:fyp_source_code/chat/presentation/provider/chat_provider.dart';
import 'package:fyp_source_code/network/api_service.dart';
import 'package:get/get.dart';

class VolunteerProfile {
  final String id;
  final String username;
  final String email;
  final String role;

  VolunteerProfile({
    required this.id,
    required this.username,
    required this.email,
    required this.role,
  });

  factory VolunteerProfile.fromJson(Map<String, dynamic> json) {
    return VolunteerProfile(
      id: json['_id'] ?? '',
      username: json['username'] ?? 'Unknown',
      email: json['email'] ?? '',
      role: json['role'] ?? 'volunteer',
    );
  }
}

class CoordinationController extends GetxController {
  late ChatProvider chatProvider;
  final DioHelper _dioHelper = DioHelper();

  // Tab selection: true = Active Chats, false = All Volunteers
  final RxBool showActiveChats = true.obs;

  // Conversations from ChatProvider
  final RxList<Conversation> conversations = RxList<Conversation>();

  // All available volunteers
  final RxList<VolunteerProfile> allVolunteers = RxList<VolunteerProfile>();
  final RxList<VolunteerProfile> filteredVolunteers =
      RxList<VolunteerProfile>();

  // Loading & search
  final RxBool isLoading = false.obs;
  final RxString searchQuery = ''.obs;
  final TextEditingController searchController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    _initializeChat();

    // Listen to search changes
    ever(searchQuery, (_) => _filterVolunteers());
  }

  /// Initialize chat provider and fetch conversations
  Future<void> _initializeChat() async {
    try {
      isLoading.value = true;

      // Get ChatProvider instance
      chatProvider = Get.put(ChatProvider());

      // Listen to conversations from ChatProvider
      ever(chatProvider.conversations, (_) {
        conversations.assignAll(chatProvider.conversations);
        print('📡 Conversations updated: ${conversations.length}');
      });

      // Fetch conversations
      await chatProvider.fetchConversations();

      // Fetch all volunteers
      await fetchAllVolunteers();

      print('✅ Coordination initialized');
    } catch (e) {
      print('❌ Error initializing coordination: $e');
    } finally {
      isLoading.value = false;
    }
  }

  /// Fetch all available volunteers from backend
  Future<void> fetchAllVolunteers({String search = ''}) async {
    try {
      print('🔄 Fetching all volunteers...');

      final response = await _dioHelper.get(
        url:
            'chat/volunteers/list${search.isNotEmpty ? '?search=$search' : ''}',
        isauthorize: true,
      );

      print('📦 Volunteers Response: $response');

      if (response is Map) {
        final responseMap = Map<String, dynamic>.from(response);

        if (responseMap.containsKey('data') && responseMap['data'] is Map) {
          final dataMap = Map<String, dynamic>.from(responseMap['data']);

          if (dataMap.containsKey('volunteers') &&
              dataMap['volunteers'] is List) {
            final volunteers =
                (dataMap['volunteers'] as List)
                    .cast<Map<String, dynamic>>()
                    .map((e) => VolunteerProfile.fromJson(e))
                    .toList();

            allVolunteers.assignAll(volunteers);
            filteredVolunteers.assignAll(volunteers);

            print('✅ Fetched ${volunteers.length} volunteers');
            return;
          }
        }
      }

      print('⚠️ Unexpected response format');
      allVolunteers.clear();
      filteredVolunteers.clear();
    } catch (e) {
      print('❌ Error fetching volunteers: $e');
      allVolunteers.clear();
      filteredVolunteers.clear();
    }
  }

  /// Filter volunteers based on search query
  void _filterVolunteers() {
    final query = searchQuery.value.toLowerCase();

    if (query.isEmpty) {
      filteredVolunteers.assignAll(allVolunteers);
    } else {
      filteredVolunteers.assignAll(
        allVolunteers
            .where(
              (v) =>
                  v.username.toLowerCase().contains(query) ||
                  v.email.toLowerCase().contains(query),
            )
            .toList(),
      );
    }

    print('🔍 Filtered to ${filteredVolunteers.length} volunteers');
  }

  /// Update search query
  void updateSearch(String query) {
    searchQuery.value = query;
  }

  /// Get current list based on tab
  List<Conversation> get conversationsList => conversations;

  List<VolunteerProfile> get volunteersList => filteredVolunteers;

  /// Open existing conversation
  void openConversation(Conversation conversation) {
    print('💬 Opening existing conversation with ${conversation.userId}');
    chatProvider.openConversation(conversation.userId);
    Get.toNamed(
      '/chatDetail',
      arguments: {
        'userId': conversation.userId,
        'userName': conversation.username,
      },
    );
  }

  /// Start new conversation with a volunteer
  void startNewConversation(VolunteerProfile volunteer) {
    print('💬 Starting new conversation with ${volunteer.username}');
    chatProvider.openConversation(volunteer.id);
    Get.toNamed(
      '/chatDetail',
      arguments: {'userId': volunteer.id, 'userName': volunteer.username},
    );
  }

  /// Toggle between Active Chats and All Volunteers
  void toggleTab(bool isActive) {
    showActiveChats.value = isActive;
    print(isActive ? '💬 Showing active chats' : '👥 Showing all volunteers');
  }

  /// Refresh data
  @override
  Future<void> refresh() async {
    await Future.wait([
      chatProvider.fetchConversations(),
      fetchAllVolunteers(),
    ]);
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}
