import 'dart:async';

import 'package:fyp_source_code/services/location_services.dart';
import 'package:fyp_source_code/volunteer_side/map/data/map_repo.dart';
import 'package:fyp_source_code/volunteer_side/map/data/map_user_model.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';

class MapCntrl extends GetxController {
  final MapRepo mapRepo = MapRepo();
  Rx<LatLng?> currentLatLng = Rx<LatLng?>(null);
  final RxList<MapUserModel> mapUsers = <MapUserModel>[].obs;
  StreamSubscription<Position>? positionStream;

  @override
  void onInit() {
    super.onInit();
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
}
