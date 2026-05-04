import 'package:fyp_source_code/network/api_service.dart';
import 'package:fyp_source_code/services/api_names.dart';
import 'package:fyp_source_code/view/volunteer_side/map/data/map_user_model.dart';

class MapRepo {
  final dioHelper = DioHelper();
  Future<dynamic> updateCurrentLocation({
    required double lat,
    required double long,
  }) async {
    final response = dioHelper.post(
      url: ApiNames.getLocation,
      reqBody: {'latitude': lat.toDouble(), 'longitude': long.toDouble()},
      isauthorize: true,
    );
    return response;
  }

  Future<List<MapUserModel>> getMapUsers({
    required double lat,
    required double lng,
    double radiusKm = 10,
    String? role,
  }) async {
    final response = await dioHelper.get(
      url: ApiNames.mapUsers(lat: lat, lng: lng, radius: radiusKm, role: role),
      isauthorize: true,
    );

    final list = _extractList(response);
    return list
        .map((e) => MapUserModel.fromJson(Map<String, dynamic>.from(e)))
        .where(
          (user) => user.location.latitude != 0 || user.location.longitude != 0,
        )
        .toList();
  }

  List<dynamic> _extractList(dynamic response) {
    if (response is List) {
      return response;
    }
    if (response is Map) {
      final map = Map<String, dynamic>.from(response);
      final data = map['data'];
      if (data is List) {
        return data;
      }
      if (data is Map) {
        final dataMap = Map<String, dynamic>.from(data);
        if (dataMap['users'] is List) {
          return dataMap['users'] as List;
        }
      }
      if (map['users'] is List) {
        return map['users'] as List;
      }
    }
    return <dynamic>[];
  }
}
