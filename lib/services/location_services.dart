import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

Future<Position> getCurrentLocation() async {
  LocationPermission permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      return Future.error('Location permissions are denied');
    }
  }

  if (permission == LocationPermission.deniedForever) {
    return Future.error('Location permissions are permanently denied');
  }

  return await Geolocator.getCurrentPosition(
    locationSettings: AndroidSettings(
      accuracy: LocationAccuracy.bestForNavigation,
      forceLocationManager: true,
    ),
  );
}

Future<String> getLocationNameFromCoordinates({
  required double latitude,
  required double longitude,
}) async {
  try {
    final placemarks = await placemarkFromCoordinates(latitude, longitude);
    if (placemarks.isEmpty) {
      return 'Current location';
    }

    final place = placemarks.first;
    final parts = <String?>[
      place.subLocality,
      place.locality,
      place.subAdministrativeArea,
      place.administrativeArea,
      place.country,
    ];
    final readableParts =
        parts
            .whereType<String>()
            .map((part) => part.trim())
            .where((part) => part.isNotEmpty)
            .toSet()
            .toList();

    if (readableParts.isNotEmpty) {
      return readableParts.join(', ');
    }

    final fallback = [place.street, place.name]
        .whereType<String>()
        .map((part) => part.trim())
        .firstWhere(
          (part) => part.isNotEmpty,
          orElse: () => 'Current location',
        );
    return fallback;
  } catch (_) {
    return 'Current location';
  }
}
