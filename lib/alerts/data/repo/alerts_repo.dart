import 'package:fyp_source_code/alerts/data/model/alert_model.dart';
import 'package:fyp_source_code/network/api_service.dart';
import 'package:fyp_source_code/services/api_names.dart';

class AlertsRepo {
  final DioHelper _dioHelper = DioHelper();

  Future<List<AlertModel>> getAlerts({
    double? latitude,
    double? longitude,
    double radiusKm = 10,
  }) async {
    final response = await _dioHelper.get(
      url: ApiNames.alerts(lat: latitude, lng: longitude, radius: radiusKm),
      isauthorize: true,
    );

    return _extractList(
      response,
    ).map((e) => AlertModel.fromJson(Map<String, dynamic>.from(e))).toList();
  }

  Future<AlertModel> createAlert(Object? reqBody) async {
    final response = await _dioHelper.post(
      url: ApiNames.alertsBase,
      reqBody: reqBody,
      isauthorize: true,
    );

    if (response is Map) {
      final map = Map<String, dynamic>.from(response);
      final data = map['data'];
      if (data is Map) {
        final dataMap = Map<String, dynamic>.from(data);
        if (dataMap['alert'] is Map) {
          return AlertModel.fromJson(
            Map<String, dynamic>.from(dataMap['alert']),
          );
        }
        return AlertModel.fromJson(dataMap);
      }
      if (map['alert'] is Map) {
        return AlertModel.fromJson(Map<String, dynamic>.from(map['alert']));
      }
      return AlertModel.fromJson(map);
    }

    throw Exception('Unexpected response format for alert');
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
        if (dataMap['alerts'] is List) {
          return dataMap['alerts'] as List;
        }
      }
      if (map['alerts'] is List) {
        return map['alerts'] as List;
      }
    }
    return <dynamic>[];
  }
}
