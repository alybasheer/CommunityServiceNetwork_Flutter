import 'package:flutter/widgets.dart';
import 'package:fyp_source_code/chat/presentation/provider/chat_provider.dart';
import 'package:fyp_source_code/utilities/helpers/toast_helper.dart';
import 'package:fyp_source_code/utilities/reuse_components/storage_helper.dart';
import 'package:fyp_source_code/volunteer_side/coordination/data/model/coordination_contact.dart';
import 'package:fyp_source_code/volunteer_side/coordination/data/repo/coordination_repo.dart';
import 'package:get/get.dart';

class CoordinationController extends GetxController {
  final CoordinationRepo _repo = CoordinationRepo();
  final StorageHelper _storage = StorageHelper();

  late ChatProvider chatProvider;

  final requestees = <CoordinationContact>[].obs;
  final volunteers = <CoordinationContact>[].obs;
  final filteredRequestees = <CoordinationContact>[].obs;
  final filteredVolunteers = <CoordinationContact>[].obs;
  final isLoading = false.obs;
  final selectedTab = 0.obs;
  final searchQuery = ''.obs;
  final userRole = ''.obs;
  final searchController = TextEditingController();

  bool get isVolunteer => userRole.value == 'volunteer';

  @override
  void onInit() {
    super.onInit();
    chatProvider =
        Get.isRegistered<ChatProvider>()
            ? Get.find<ChatProvider>()
            : Get.put(ChatProvider());
    userRole.value = (_storage.readData('role') ?? '').toString().toLowerCase();
    ever(searchQuery, (_) => _filterContacts());
    fetchContacts();
  }

  Future<void> fetchContacts() async {
    isLoading.value = true;
    try {
      final result = await _repo.getContacts();
      requestees.assignAll(result.requestees);
      volunteers.assignAll(result.volunteers);
      _filterContacts();
    } catch (e) {
      ToastHelper.showErrorMessage(e);
    } finally {
      isLoading.value = false;
    }
  }

  void updateSearch(String query) {
    searchQuery.value = query;
  }

  void changeTab(int index) {
    selectedTab.value = index;
  }

  List<CoordinationContact> get visibleContacts {
    if (!isVolunteer) {
      return filteredVolunteers;
    }
    return selectedTab.value == 0 ? filteredRequestees : filteredVolunteers;
  }

  void openContact(CoordinationContact contact) {
    chatProvider.openConversation(contact.id);
    Get.toNamed(
      '/chatDetail',
      arguments: {'userId': contact.id, 'userName': contact.name},
    );
  }

  void _filterContacts() {
    filteredRequestees.assignAll(_filter(requestees));
    filteredVolunteers.assignAll(_filter(volunteers));
  }

  List<CoordinationContact> _filter(List<CoordinationContact> source) {
    final query = searchQuery.value.toLowerCase();
    if (query.isEmpty) {
      return source;
    }
    return source
        .where(
          (contact) =>
              contact.name.toLowerCase().contains(query) ||
              contact.email.toLowerCase().contains(query),
        )
        .toList();
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}
