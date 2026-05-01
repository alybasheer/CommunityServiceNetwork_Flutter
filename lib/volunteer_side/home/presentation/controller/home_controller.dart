import 'dart:async';

import 'package:fyp_source_code/chat/presentation/provider/chat_provider.dart';
import 'package:fyp_source_code/request_side/create_help_request/data/model/help_request.dart';
import 'package:fyp_source_code/request_side/create_help_request/data/repo/help_request_repo.dart';
import 'package:fyp_source_code/network/api_service.dart';
import 'package:fyp_source_code/routing/route_names.dart';
import 'package:fyp_source_code/services/api_names.dart';
import 'package:fyp_source_code/services/location_services.dart';
import 'package:fyp_source_code/utilities/helpers/toast_helper.dart';
import 'package:fyp_source_code/utilities/reuse_components/storage_helper.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  final HelpRequestRepo _repo = HelpRequestRepo();
  final StorageHelper _storage = StorageHelper();

  final RxBool isLoading = false.obs;
  final RxList<HelpRequest> requests = RxList();
  final RxInt completedCount = 0.obs;
  final RxDouble volunteerRating = 0.0.obs;
  final RxString fullName = ''.obs;
  final RxString locationName = ''.obs;
  StreamSubscription<Map<String, dynamic>>? _flowSubscription;

  @override
  void onInit() {
    super.onInit();
    _loadUserSummary();
    _connectFlowEvents();
    fetchRequests();
    fetchVolunteerStats();
  }

  Future<void> fetchRequests() async {
    isLoading.value = true;
    try {
      final position = await getCurrentLocation();
      _resolveHeaderLocation(position.latitude, position.longitude);
      final list = await _repo.getOpenRequests(
        latitude: position.latitude,
        longitude: position.longitude,
      );
      requests.assignAll(list);
    } catch (e) {
      ToastHelper.showErrorMessage(e);
      requests.clear();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> acceptRequest(HelpRequest request) async {
    final id = request.sId;
    if (id == null || id.isEmpty) {
      ToastHelper.showError('Request is not available right now.');
      return;
    }

    try {
      await _repo.acceptRequest(id);
      Get.toNamed(RouteNames.map);
      await fetchRequests();
      await fetchVolunteerStats();
    } catch (e) {
      ToastHelper.showErrorMessage(e);
    }
  }

  Future<void> fetchVolunteerStats() async {
    try {
      final response = await DioHelper().get(
        url: ApiNames.volunteerStatus,
        isauthorize: true,
      );

      final stats = _extractStatsMap(response);
      if (stats == null) {
        return;
      }

      final completed = _readInt(
        stats['completedRequests'] ??
            stats['completedCount'] ??
            stats['totalCompleted'] ??
            stats['resolvedRequests'] ??
            stats['helpRequestsCompleted'],
      );
      if (completed != null) {
        completedCount.value = completed;
      }

      final rating = _readDouble(
        stats['rating'] ??
            stats['averageRating'] ??
            stats['avgRating'] ??
            stats['volunteerRating'],
      );
      if (rating != null) {
        volunteerRating.value = rating;
      }
    } catch (e) {
      // Leave the last known stats in place if the endpoint fails.
    }
  }

  void _connectFlowEvents() {
    final provider =
        Get.isRegistered<ChatProvider>()
            ? Get.find<ChatProvider>()
            : Get.put(ChatProvider());

    _flowSubscription = provider.flowEventStream.listen((event) {
      final eventName = event['event']?.toString();
      if (eventName == 'new_help_request') {
        fetchRequests();
        return;
      }
      if (eventName == 'help_request_accepted' ||
          eventName == 'help_request_resolved' ||
          eventName == 'new_alert') {
        fetchRequests();
        if (eventName == 'help_request_accepted' ||
            eventName == 'help_request_resolved') {
          fetchVolunteerStats();
        }
      }
    });
  }

  @override
  void onClose() {
    _flowSubscription?.cancel();
    super.onClose();
  }

  Map<String, dynamic>? _extractStatsMap(dynamic response) {
    if (response is Map<String, dynamic>) {
      final data = response['data'];
      if (data is Map<String, dynamic>) {
        return data;
      }
      return response;
    }
    if (response is Map) {
      return Map<String, dynamic>.from(response);
    }
    return null;
  }

  int? _readInt(dynamic value) {
    if (value is int) {
      return value;
    }
    if (value is num) {
      return value.toInt();
    }
    if (value is String) {
      return int.tryParse(value);
    }
    return null;
  }

  double? _readDouble(dynamic value) {
    if (value is num) {
      return value.toDouble();
    }
    if (value is String) {
      return double.tryParse(value);
    }
    return null;
  }

  void _loadUserSummary() {
    final storedName =
        _storage.readData('profile_name') ?? _storage.readData('name');

    if (storedName is String && storedName.trim().isNotEmpty) {
      fullName.value = storedName.trim();
    } else {
      fullName.value = 'Volunteer User';
    }

    final storedLocation =
        _storage.readData('profile_location') ??
        _storage.readData('city') ??
        _storage.readData('location');
    if (storedLocation is String && storedLocation.trim().isNotEmpty) {
      final location = storedLocation.trim();
      locationName.value =
          _looksLikeCoordinates(location) ? 'Finding nearby area...' : location;
    } else {
      locationName.value = 'Finding nearby area...';
    }
  }

  void _resolveHeaderLocation(double latitude, double longitude) {
    unawaited(_loadReadableLocationName(latitude, longitude));
  }

  Future<void> _loadReadableLocationName(
    double latitude,
    double longitude,
  ) async {
    final resolvedName = await getLocationNameFromCoordinates(
      latitude: latitude,
      longitude: longitude,
    );
    if (resolvedName.trim().isEmpty) {
      return;
    }
    locationName.value = resolvedName;
    _storage.saveData('profile_location', resolvedName);
  }

  bool _looksLikeCoordinates(String value) {
    final normalized = value.trim().toLowerCase();
    if (normalized.contains('lat') || normalized.contains('lng')) {
      return true;
    }

    final parts = normalized.split(RegExp(r'\s*,\s*'));
    return parts.length == 2 &&
        double.tryParse(parts[0]) != null &&
        double.tryParse(parts[1]) != null;
  }
}
