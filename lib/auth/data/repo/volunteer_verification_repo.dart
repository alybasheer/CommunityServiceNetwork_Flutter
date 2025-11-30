import 'package:fyp_source_code/auth/data/models/admin_verification_request.dart';
import 'package:fyp_source_code/network/api_service.dart';
import 'package:fyp_source_code/services/api_names.dart';

class VolunteerVerificationRepo {
  final DioHelper _dioHelper = DioHelper();

  /// Fetch all volunteer verification requests.
  /// Expects the API to return a List<Map<String, dynamic>>.
  Future<List<VolunteerVerification>> fetchAll() async {
    final response = await _dioHelper.get(
      url: ApiNames.voulnteerVerification,
      isauthorize: true,
    );

    if (response is List) {
      return response
          .map(
            (e) => VolunteerVerification.fromJson(Map<String, dynamic>.from(e)),
          )
          .toList();
    } else if (response is Map && response['data'] is List) {
      return (response['data'] as List)
          .map(
            (e) => VolunteerVerification.fromJson(Map<String, dynamic>.from(e)),
          )
          .toList();
    } else {
      throw Exception('Unexpected response format for verifications');
    }
  }

  /// Submit a new volunteer verification (apply)
Future<List<VolunteerVerification>> submit(Object? reqBody) async {
  final response = await _dioHelper.post(
    url: ApiNames.voulnteerVerification,
    reqBody: reqBody,
    isauthorize: true,
  );

  if (response is List) {
    return response
        .map((e) => VolunteerVerification.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  } else {
    throw Exception('Expected a list from API, got ${response.runtimeType}');
  }
}

}
