import 'package:fyp_source_code/help_requests/data/models/help_request_model.dart';
import 'package:fyp_source_code/network/api_service.dart';
import 'package:fyp_source_code/services/api_names.dart';

class HelpRequestRepo {
  final DioHelper _dioHelper = DioHelper();

  Future<HelpRequestModel> create(HelpRequestModel request) async {
    final response = await _dioHelper.post(
      url: ApiNames.helpRequests,
      reqBody: request.toCreateJson(),
      isauthorize: true,
    );
    return HelpRequestModel.fromJson(Map<String, dynamic>.from(response));
  }

  Future<List<HelpRequestModel>> mine() async {
    final response = await _dioHelper.get(
      url: ApiNames.myHelpRequests,
      isauthorize: true,
    );
    return _parseList(response);
  }

  Future<List<HelpRequestModel>> open() async {
    final response = await _dioHelper.get(
      url: ApiNames.openHelpRequests,
      isauthorize: true,
    );
    return _parseList(response);
  }

  Future<List<HelpRequestModel>> assigned() async {
    final response = await _dioHelper.get(
      url: ApiNames.assignedHelpRequests,
      isauthorize: true,
    );
    return _parseList(response);
  }

  Future<List<HelpRequestModel>> nearby({
    required double latitude,
    required double longitude,
    double radiusMeters = 10000,
  }) async {
    final response = await _dioHelper.get(
      url: ApiNames.nearbyHelpRequests(
        latitude: latitude,
        longitude: longitude,
        radiusMeters: radiusMeters,
      ),
      isauthorize: true,
    );
    return _parseList(response);
  }

  Future<HelpRequestModel> accept(String id) async {
    final response = await _dioHelper.patch(
      url: ApiNames.acceptHelpRequest(id),
      isauthorize: true,
    );
    return HelpRequestModel.fromJson(Map<String, dynamic>.from(response));
  }

  Future<HelpRequestModel> resolve(String id) async {
    final response = await _dioHelper.patch(
      url: ApiNames.resolveHelpRequest(id),
      isauthorize: true,
    );
    return HelpRequestModel.fromJson(Map<String, dynamic>.from(response));
  }

  Future<HelpRequestModel> cancel(String id) async {
    final response = await _dioHelper.patch(
      url: ApiNames.cancelHelpRequest(id),
      isauthorize: true,
    );
    return HelpRequestModel.fromJson(Map<String, dynamic>.from(response));
  }

  List<HelpRequestModel> _parseList(dynamic response) {
    if (response is List) {
      return response
          .map((e) => HelpRequestModel.fromJson(Map<String, dynamic>.from(e)))
          .toList();
    }
    if (response is Map && response['data'] is List) {
      return (response['data'] as List)
          .map((e) => HelpRequestModel.fromJson(Map<String, dynamic>.from(e)))
          .toList();
    }
    return [];
  }
}
