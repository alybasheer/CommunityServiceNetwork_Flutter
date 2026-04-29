import 'dart:async';

import 'package:fyp_source_code/help_requests/data/models/help_request_model.dart';
import 'package:fyp_source_code/help_requests/data/repo/help_request_repo.dart';
import 'package:fyp_source_code/utilities/reuse_components/storage_helper.dart';
import 'package:fyp_source_code/volunteer_side/map/data/map_repo.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';

class MapCntrl extends GetxController {
  final MapRepo mapRepo = MapRepo();
  final HelpRequestRepo helpRequestRepo = HelpRequestRepo();
  final StorageHelper storageHelper = StorageHelper();

  final Rx<LatLng?> currentLatLng = Rx<LatLng?>(null);
  final RxList<HelpRequestModel> liveRequests = <HelpRequestModel>[].obs;
  final RxBool isLoading = true.obs;
  final RxString errorMessage = ''.obs;

  StreamSubscription<Position>? positionStream;
  Timer? _pollingTimer;

  bool get isVolunteer => storageHelper.readData('role') == 'volunteer';
  bool get isAdmin => storageHelper.readData('role') == 'admin';

  @override
  void onInit() {
    super.onInit();
    startLocationStream();
    _pollingTimer = Timer.periodic(
      const Duration(seconds: 5),
      (_) => refreshLiveRequests(silent: true),
    );
  }

  @override
  void onClose() {
    positionStream?.cancel();
    _pollingTimer?.cancel();
    super.onClose();
  }

  Future<void> startLocationStream() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      errorMessage.value = 'Location services are disabled.';
      isLoading.value = false;
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      errorMessage.value = 'Location permission is required to load the live map.';
      isLoading.value = false;
      return;
    }

    positionStream = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.bestForNavigation,
        distanceFilter: 5,
      ),
    ).listen((Position pos) async {
      currentLatLng.value = LatLng(pos.latitude, pos.longitude);

      try {
        await mapRepo.updateCurrentLocation(
          lat: pos.latitude,
          long: pos.longitude,
        );
      } catch (_) {}

      await refreshLiveRequests(silent: true);
      isLoading.value = false;
    });
  }

  Future<void> refreshLiveRequests({bool silent = false}) async {
    final latLng = currentLatLng.value;
    if (latLng == null) {
      return;
    }

    try {
      if (!silent) {
        isLoading.value = true;
        errorMessage.value = '';
      }

      final List<HelpRequestModel> requests;
      if (isVolunteer || isAdmin) {
        requests = await helpRequestRepo.nearby(
          latitude: latLng.latitude,
          longitude: latLng.longitude,
          radiusMeters: 10000,
        );
      } else {
        requests = await helpRequestRepo.mine();
      }

      liveRequests.assignAll(requests);
    } catch (e) {
      if (liveRequests.isEmpty || !silent) {
        errorMessage.value = e.toString();
      }
    } finally {
      if (!silent) {
        isLoading.value = false;
      }
    }
  }
}
