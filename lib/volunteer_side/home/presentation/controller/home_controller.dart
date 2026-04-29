import 'dart:async';

import 'package:fyp_source_code/help_requests/data/models/help_request_model.dart';
import 'package:fyp_source_code/help_requests/data/repo/help_request_repo.dart';
import 'package:fyp_source_code/utilities/reuse_components/storage_helper.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  final HelpRequestRepo _repo = HelpRequestRepo();
  final StorageHelper _storageHelper = StorageHelper();

  final RxBool isLoading = true.obs;
  final RxBool isRefreshing = false.obs;
  final RxString errorMessage = ''.obs;
  final RxList<HelpRequestModel> requests = <HelpRequestModel>[].obs;

  Timer? _pollingTimer;

  String get currentRole => _storageHelper.readData('role') ?? 'user';
  bool get isVolunteer => currentRole == 'volunteer';
  bool get isAdmin => currentRole == 'admin';
  bool get isSeeker => !isVolunteer && !isAdmin;

  int get openCount =>
      requests.where((request) => request.status == 'open').length;
  int get activeCount =>
      requests.where((request) => request.status == 'in_progress').length;
  int get resolvedCount =>
      requests.where((request) => request.status == 'resolved').length;

  @override
  void onInit() {
    super.onInit();
    loadRequests();
    _pollingTimer = Timer.periodic(
      const Duration(seconds: 5),
      (_) => refreshRequests(silent: true),
    );
  }

  Future<void> loadRequests() async {
    isLoading.value = true;
    await _fetchRequests(silent: false);
    isLoading.value = false;
  }

  Future<void> refreshRequests({bool silent = false}) async {
    if (!silent) {
      isRefreshing.value = true;
    }
    await _fetchRequests(silent: silent);
    if (!silent) {
      isRefreshing.value = false;
    }
  }

  Future<void> _fetchRequests({required bool silent}) async {
    try {
      if (!silent) {
        errorMessage.value = '';
      }
      final results = isVolunteer
          ? await _repo.assigned()
          : await _repo.mine();
      requests.assignAll(results);
    } catch (e) {
      if (requests.isEmpty || !silent) {
        errorMessage.value = e.toString();
      }
    }
  }

  Future<void> cancelRequest(String id) async {
    try {
      await _repo.cancel(id);
      Get.snackbar('Updated', 'Request cancelled');
      await refreshRequests();
    } catch (e) {
      Get.snackbar('Action failed', e.toString());
    }
  }

  Future<void> resolveRequest(String id) async {
    try {
      await _repo.resolve(id);
      Get.snackbar('Updated', 'Request marked as resolved');
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
}
