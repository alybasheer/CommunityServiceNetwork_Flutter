import 'package:geolocator/geolocator.dart';

Future<Position> getCurrentLocation() async {

  LocationPermission permission =await  Geolocator.checkPermission();
  if(permission == LocationPermission.denied){
    permission = await Geolocator.requestPermission();
    if(permission == LocationPermission.denied){
      return Future.error('Location permissions are denied');
    }
  }

  return await Geolocator.getCurrentPosition( locationSettings: AndroidSettings(accuracy: LocationAccuracy.bestForNavigation,forceLocationManager: true,));


}