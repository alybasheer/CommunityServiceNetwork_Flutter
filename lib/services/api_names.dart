import 'package:flutter/foundation.dart';

class ApiNames {
  static const _configuredBaseUrl = String.fromEnvironment('API_BASE_URL');

  static String get baseUrl {
    if (_configuredBaseUrl.isNotEmpty) {
      return _normalizeBaseUrl(_configuredBaseUrl);
    }

    if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
      return 'http://10.0.2.2:3000/';
    }

    return 'http://localhost:3000/';
  }

  static String _normalizeBaseUrl(String value) {
    return value.endsWith('/') ? value : '$value/';
  }

  static String endpoint(String path) => '$baseUrl${path.startsWith('/') ? path.substring(1) : path}';

  static String get signup => endpoint('authentication/signup');
  static String get login => endpoint('authentication/login');
  static String get voulnteerVerification => endpoint('volunteer/apply');
  static String get voulnteerApplications =>
      endpoint('admin/volunteer-applications');
  static String approveVolunteer(String id) =>
      endpoint('admin/volunteer-applications/$id/approve');
  static String rejectVolunteer(String id) =>
      endpoint('admin/volunteer-applications/$id/reject');
  static String get getLocation => endpoint('authentication/location');
  static String get helpRequests => endpoint('help-requests');
  static String get myHelpRequests => endpoint('help-requests/mine');
  static String get assignedHelpRequests => endpoint('help-requests/assigned');
  static String get openHelpRequests => endpoint('help-requests/open');
  static String nearbyHelpRequests({
    required double latitude,
    required double longitude,
    double radiusMeters = 10000,
  }) =>
      endpoint(
        'help-requests/nearby?latitude=$latitude&longitude=$longitude&radiusMeters=$radiusMeters',
      );
  static String acceptHelpRequest(String id) =>
      endpoint('help-requests/$id/accept');
  static String resolveHelpRequest(String id) =>
      endpoint('help-requests/$id/resolve');
  static String cancelHelpRequest(String id) =>
      endpoint('help-requests/$id/cancel');
  static String get adminHelpRequests => endpoint('help-requests/admin/all');
}
