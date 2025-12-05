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
  /// Returns the submitted verification object
  Future<VolunteerVerification> submit(Object? reqBody) async {
    final response = await _dioHelper.post(
      url: ApiNames.voulnteerVerification,
      reqBody: reqBody,
      isauthorize: true,
    );

    print('📦 Submit Response Type: ${response.runtimeType}');
    print('📦 Submit Response: $response');

    if (response is Map) {
      final Map<String, dynamic> responseMap = Map<String, dynamic>.from(
        response,
      );

      // Check if response has nested 'data' object
      if (responseMap.containsKey('data') && responseMap['data'] is Map) {
        print('✅ Found nested data object');
        return VolunteerVerification.fromJson(
          Map<String, dynamic>.from(responseMap['data']),
        );
      }

      // Direct response object
      print('✅ Direct response object');
      return VolunteerVerification.fromJson(responseMap);
    } else if (response is List && response.isNotEmpty) {
      print('✅ List response, using first item');
      return VolunteerVerification.fromJson(
        Map<String, dynamic>.from(response[0]),
      );
    } else {
      throw Exception(
        'Expected a Map or List from API, got ${response.runtimeType}',
      );
    }
  }
}
