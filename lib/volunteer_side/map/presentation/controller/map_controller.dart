import 'dart:async';

import 'package:fyp_source_code/volunteer_side/map/data/map_repo.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';

class MapCntrl extends GetxController {
  final MapRepo mapRepo = MapRepo();
  Rx<LatLng?> currentLatLng = Rx<LatLng?>(null);
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
    positionStream = Geolocator.getPositionStream(
      locationSettings: AndroidSettings(
        accuracy: LocationAccuracy.bestForNavigation,
        distanceFilter: 5, // only emit if moved 5 meters
        forceLocationManager: true,
      ),
    ).listen((Position pos) async {
      // Update observable
      currentLatLng.value = LatLng(pos.latitude, pos.longitude);

      // Send to backend
      try {
        await mapRepo.updateCurrentLocation(
          lat: pos.latitude,
          long: pos.longitude,
        );
        print("Location updated: ${pos.latitude}, ${pos.longitude}");
      } catch (e) {
        print("Error sending location: $e");
      }
    });
  }
}
