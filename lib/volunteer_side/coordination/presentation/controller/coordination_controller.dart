import 'dart:async';
import 'dart:convert';

import 'package:fyp_source_code/help_requests/data/models/help_request_model.dart';
import 'package:fyp_source_code/help_requests/data/repo/help_request_repo.dart';
import 'package:fyp_source_code/utilities/reuse_components/storage_helper.dart';
import 'package:get/get.dart';

class CoordinationController extends GetxController {
  final HelpRequestRepo _repo = HelpRequestRepo();
  final StorageHelper _storageHelper = StorageHelper();

  final RxBool showAccepted = false.obs;
  final RxBool isLoading = true.obs;
  final RxString errorMessage = ''.obs;
  final RxList<HelpRequestModel> openRequests = <HelpRequestModel>[].obs;
  final RxList<HelpRequestModel> acceptedRequests = <HelpRequestModel>[].obs;

  Timer? _pollingTimer;

  @override
  void onInit() {
    super.onInit();
    loadRequests();
    _pollingTimer = Timer.periodic(
      const Duration(seconds: 5),
      (_) => refreshRequests(silent: true),
    );
  }

  List<HelpRequestModel> get filteredRequests {
    if (showAccepted.value) {
      return acceptedRequests.toList();
    }
    return openRequests.toList();
  }

  void setShowAccepted(bool v) => showAccepted.value = v;

  Future<void> loadRequests() async {
    isLoading.value = true;
    await _fetchRequests(silent: false);
    isLoading.value = false;
  }

  Future<void> refreshRequests({bool silent = false}) async {
    await _fetchRequests(silent: silent);
  }

  Future<void> _fetchRequests({required bool silent}) async {
    try {
      if (!silent) {
        errorMessage.value = '';
      }
      final List<List<HelpRequestModel>> results = await Future.wait([
        _repo.open(),
        _repo.assigned(),
      ]);
      final currentUserId = _currentUserId;
      openRequests.assignAll(
        results[0]
            .where((request) => request.seekerId == null || request.seekerId != currentUserId)
            .toList(),
      );
      acceptedRequests.assignAll(results[1]);
    } catch (e) {
      if ((openRequests.isEmpty && acceptedRequests.isEmpty) || !silent) {
        errorMessage.value = e.toString();
      }
    }
  }

  Future<void> acceptRequest(String id) async {
    try {
      await _repo.accept(id);
      Get.snackbar('Assigned', 'Request accepted successfully');
      await refreshRequests();
    } catch (e) {
      Get.snackbar('Action failed', e.toString());
    }
  }

  Future<void> resolveRequest(String id) async {
    try {
      await _repo.resolve(id);
      Get.snackbar('Resolved', 'Request marked as resolved');
      await refreshRequests();
    } catch (e) {
      Get.snackbar('Action failed', e.toString());
    }
  }

  @override
  void onClose() {
    _pollingTimer?.cancel();
    super.onClose();
  }

  String? get _currentUserId {
    final storedUserId = _storageHelper.readData('userId');
    if (storedUserId != null && storedUserId.isNotEmpty) {
      return storedUserId;
    }

    final token = _storageHelper.readData('token');
    if (token == null || token.isEmpty) {
      return null;
    }

    final parts = token.split('.');
    if (parts.length < 2) {
      return null;
    }

    try {
      final normalized = base64.normalize(parts[1]);
      final payload = utf8.decode(base64Url.decode(normalized));
      final data = jsonDecode(payload);
      if (data is Map<String, dynamic>) {
        final sub = data['sub'];
        if (sub != null) {
          return sub.toString();
        }
      }
    } catch (_) {
      return null;
    }

    return null;
  }
}
