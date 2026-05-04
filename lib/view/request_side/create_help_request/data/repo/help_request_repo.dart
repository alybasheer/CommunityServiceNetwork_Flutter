import 'package:fyp_source_code/network/api_service.dart';
import 'package:fyp_source_code/view/request_side/create_help_request/data/model/help_request.dart';
import 'package:fyp_source_code/services/api_names.dart';

class HelpRequestRepo {
  final DioHelper _dioHelper = DioHelper();

  Future<HelpRequest> createRequest(Object? reqBody) async {
    final response = await _dioHelper.post(
      url: ApiNames.helpRequests,
      reqBody: reqBody,
      isauthorize: true,
    );

    return _parseRequest(response);
  }

  Future<HelpRequest> createSos(Object? reqBody) async {
    final response = await _dioHelper.post(
      url: ApiNames.helpRequestsSos,
      reqBody: reqBody,
      isauthorize: true,
    );

    return _parseRequest(response);
  }

  Future<List<HelpRequest>> getOpenRequests({
    double? latitude,
    double? longitude,
    double radiusKm = 10,
  }) async {
    String url = ApiNames.helpRequests;
    if (latitude != null && longitude != null) {
      url = '$url?lat=$latitude&lng=$longitude&radius=$radiusKm';
    }

    final response = await _dioHelper.get(url: url, isauthorize: true);
    return _parseRequests(response);
  }

  Future<List<HelpRequest>> getMyActiveRequests() async {
    final response = await _dioHelper.get(
      url: ApiNames.activeHelpRequests,
      isauthorize: true,
    );

    return _parseRequests(response);
  }

  Future<List<NearbyVolunteer>> getNearbyVolunteers({
    required double latitude,
    required double longitude,
    double radiusKm = 10,
    bool onlineOnly = true,
  }) async {
    final response = await _dioHelper.get(
      url: ApiNames.nearbyVolunteers(
        lat: latitude,
        lng: longitude,
        radius: radiusKm,
        onlineOnly: onlineOnly,
      ),
      isauthorize: true,
    );

    return _extractList(response, listKeys: const ['volunteers', 'users'])
        .map((e) => NearbyVolunteer.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }

  Future<HelpRequest> acceptRequest(String id) async {
    final response = await _dioHelper.patch(
      url: ApiNames.acceptHelpRequest(id),
      isauthorize: true,
    );

    return _parseRequest(response);
  }

  Future<HelpRequest> releaseRequest(String id) async {
    final response = await _dioHelper.patch(
      url: ApiNames.releaseHelpRequest(id),
      isauthorize: true,
    );

    return _parseRequest(response);
  }

  Future<HelpRequest> resolveRequest(String id) async {
    final response = await _dioHelper.patch(
      url: ApiNames.resolveHelpRequest(id),
      isauthorize: true,
    );

    return _parseRequest(response);
  }

  Future<dynamic> rateRequest(
    String id, {
    required int score,
    String? comment,
  }) async {
    return _dioHelper.post(
      url: ApiNames.rateHelpRequest(id),
      reqBody: {'score': score, if (comment != null) 'comment': comment},
      isauthorize: true,
    );
  }

  HelpRequest _parseRequest(dynamic response) {
    if (response is Map) {
      final responseMap = Map<String, dynamic>.from(response);
      final data = responseMap['data'];

      if (data is Map) {
        final dataMap = Map<String, dynamic>.from(data);
        if (dataMap['request'] is Map) {
          return HelpRequest.fromJson(
            Map<String, dynamic>.from(dataMap['request']),
          );
        }
        if (dataMap['helpRequest'] is Map) {
          return HelpRequest.fromJson(
            Map<String, dynamic>.from(dataMap['helpRequest']),
          );
        }
        return HelpRequest.fromJson(dataMap);
      }

      if (responseMap['request'] is Map) {
        return HelpRequest.fromJson(
          Map<String, dynamic>.from(responseMap['request']),
        );
      }

      return HelpRequest.fromJson(responseMap);
    }

    throw Exception('Unexpected response format for help request');
  }

  List<HelpRequest> _parseRequests(dynamic response) {
    return _extractList(
      response,
      listKeys: const ['requests', 'helpRequests', 'data'],
    ).map((e) => HelpRequest.fromJson(Map<String, dynamic>.from(e))).toList();
  }

  List<dynamic> _extractList(
    dynamic response, {
    required List<String> listKeys,
  }) {
    if (response is List) {
      return response;
    }

    if (response is Map) {
      final responseMap = Map<String, dynamic>.from(response);
      final data = responseMap['data'];

      if (data is List) {
        return data;
      }

      if (data is Map) {
        final dataMap = Map<String, dynamic>.from(data);
        for (final key in listKeys) {
          if (dataMap[key] is List) {
            return dataMap[key] as List;
          }
        }
      }

      for (final key in listKeys) {
        if (responseMap[key] is List) {
          return responseMap[key] as List;
        }
      }
    }

    return <dynamic>[];
  }
}
