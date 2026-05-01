import 'dart:async';

import 'package:fyp_source_code/request_side/create_help_request/data/model/help_request.dart';
import 'package:fyp_source_code/request_side/create_help_request/data/repo/help_request_repo.dart';
import 'package:fyp_source_code/routing/route_names.dart';
import 'package:fyp_source_code/services/location_services.dart';
import 'package:fyp_source_code/utilities/helpers/toast_helper.dart';
import 'package:fyp_source_code/utilities/reuse_components/storage_helper.dart';
import 'package:fyp_source_code/volunteer_side/home/presentation/controller/home_controller.dart';
import 'package:fyp_source_code/volunteer_side/map/data/map_repo.dart';
import 'package:fyp_source_code/volunteer_side/map/data/map_user_model.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';

class MapCntrl extends GetxController {
  static const String _activeRequestStorageKey = 'volunteer_active_request';

  final MapRepo mapRepo = MapRepo();
  final HelpRequestRepo _helpRequestRepo = HelpRequestRepo();
  final StorageHelper _storage = StorageHelper();

  Rx<LatLng?> currentLatLng = Rx<LatLng?>(null);
  final Rx<HelpRequest?> activeRequest = Rx<HelpRequest?>(null);
  final RxList<MapUserModel> mapUsers = <MapUserModel>[].obs;
  final RxBool isCompleting = false.obs;
  final RxBool isCancelling = false.obs;
  StreamSubscription<Position>? positionStream;

  @override
  void onInit() {
    super.onInit();
    _restoreActiveRequest();
    startLocationStream();
  }

  @override
  void onClose() {
    positionStream?.cancel();
    super.onClose();
  }

  void startLocationStream() {
    _requestLocationPermission();
  }

  LatLng? get activeRequestLatLng {
    final request = activeRequest.value;
    final lat = request?.location?.latitude;
    final lng = request?.location?.longitude;
    if (lat == null || lng == null) {
      return null;
    }
    return LatLng(lat, lng);
  }

  List<LatLng> get activeRoutePoints {
    final current = currentLatLng.value;
    final target = activeRequestLatLng;
    if (current == null || target == null) {
      return <LatLng>[];
    }
    return [current, target];
  }

  double? get activeDistanceKm {
    final current = currentLatLng.value;
    final target = activeRequestLatLng;
    if (current == null || target == null) {
      return null;
    }
    return const Distance().as(LengthUnit.Kilometer, current, target);
  }

  void setActiveRequestFromArguments(dynamic arguments) {
    final request = _readRequestArgument(arguments);
    if (request == null) {
      return;
    }
    setActiveRequest(request);
  }

  void setActiveRequest(HelpRequest request) {
    activeRequest.value = request;
    _storage.saveData(_activeRequestStorageKey, request.toJson());
  }

  Future<void> completeActiveRequest() async {
    final request = activeRequest.value;
    final id = request?.sId?.trim();
    if (id == null || id.isEmpty) {
      ToastHelper.showError('No active request to complete.');
      return;
    }

    isCompleting.value = true;
    try {
      await _helpRequestRepo.resolveRequest(id);
      _clearActiveRequest();
      _refreshVolunteerDashboard(completed: true);
      ToastHelper.showSuccess('Request completed.');
    } catch (e) {
      ToastHelper.showErrorMessage(e);
    } finally {
      isCompleting.value = false;
    }
  }

  Future<void> cancelActiveRequest() async {
    final request = activeRequest.value;
    final id = request?.sId?.trim();
    if (id == null || id.isEmpty) {
      ToastHelper.showError('No active request to cancel.');
      return;
    }

    isCancelling.value = true;
    try {
      await _helpRequestRepo.releaseRequest(id);
      _clearActiveRequest();
      _refreshVolunteerDashboard();
      ToastHelper.showSuccess('Request cancelled.');
    } catch (e) {
      ToastHelper.showErrorMessage(e);
    } finally {
      isCancelling.value = false;
    }
  }

  void openActiveRequestChat() {
    final request = activeRequest.value;
    final userId = request?.userId?.trim();
    if (userId == null || userId.isEmpty) {
      ToastHelper.showError('Chat is not available for this request.');
      return;
    }

    Get.toNamed(
      RouteNames.chatDetail,
      arguments: {
        'userId': userId,
        'userName': request?.userName ?? 'Requestee',
      },
    );
  }

  /// Request location permission from user
  Future<void> _requestLocationPermission() async {
    try {
      // Check current permission status
      LocationPermission permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        // Request permission
        permission = await Geolocator.requestPermission();
        print('Location permission requested: $permission');
      }

      if (permission == LocationPermission.deniedForever) {
        print(' Location permission denied forever! Opening app settings...');
        await Geolocator.openLocationSettings();
        return;
      }

      if (permission == LocationPermission.whileInUse ||
          permission == LocationPermission.always) {
        print('Location permission granted! Fetching fresh location...');

        Position pos = await getCurrentLocation();
        currentLatLng.value = LatLng(pos.latitude, pos.longitude);
        await mapRepo.updateCurrentLocation(
          lat: pos.latitude,
          long: pos.longitude,
        );
        await fetchMapUsers();
        _startPositionStream();
      }
    } catch (e) {
      print('Error requesting location permission: $e');
    }
  }

  /// Start receiving continuous position updates
  void _startPositionStream() {
    positionStream?.cancel();
    positionStream = Geolocator.getPositionStream(
      locationSettings: AndroidSettings(
        accuracy: LocationAccuracy.best,
        distanceFilter: 5,
        forceLocationManager: false,
        timeLimit: Duration(seconds: 10),
      ),
    ).listen(
      (Position pos) async {
        // Filter out inaccurate readings
        if (pos.accuracy > 50) {
          print('⚠️ Low accuracy (${pos.accuracy}m) - skipping');
          return;
        }

        print(
          '📍 Stream device location: ${pos.latitude}, ${pos.longitude}, Accuracy: ${pos.accuracy}m',
        );
        currentLatLng.value = LatLng(pos.latitude, pos.longitude);

        Future.microtask(() async {
          try {
            await mapRepo.updateCurrentLocation(
              lat: pos.latitude,
              long: pos.longitude,
            );
            await fetchMapUsers();
            print(
              "✅ Location sent to backend: ${pos.latitude}, ${pos.longitude}",
            );
          } catch (e) {
            print("❌ Error sending location: $e");
          }
        });
      },
      onError: (e) {
        print("❌ GPS Stream Error: $e");
      },
    );
  }

  Future<void> fetchMapUsers() async {
    final latLng = currentLatLng.value;
    if (latLng == null) {
      return;
    }
    try {
      final users = await mapRepo.getMapUsers(
        lat: latLng.latitude,
        lng: latLng.longitude,
      );
      mapUsers.assignAll(users);
    } catch (e) {
      print('Error fetching map users: $e');
    }
  }

  void _restoreActiveRequest() {
    final request = _readRequestArgument(
      _storage.readData(_activeRequestStorageKey),
    );
    if (request == null) {
      return;
    }
    activeRequest.value = request;
  }

  HelpRequest? _readRequestArgument(dynamic value) {
    dynamic raw = value;
    if (value is Map) {
      raw = value['request'] ?? value['helpRequest'] ?? value;
    }

    if (raw is HelpRequest) {
      return raw;
    }

    if (raw is Map) {
      return HelpRequest.fromJson(Map<String, dynamic>.from(raw));
    }

    return null;
  }

  void _clearActiveRequest() {
    activeRequest.value = null;
    _storage.removeData(_activeRequestStorageKey);
  }

  void _refreshVolunteerDashboard({bool completed = false}) {
    if (!Get.isRegistered<HomeController>()) {
      return;
    }

    final homeController = Get.find<HomeController>();
    if (completed) {
      homeController.completedCount.value++;
    }
    unawaited(homeController.fetchRequests());
    unawaited(homeController.fetchVolunteerStats());
  }
}
