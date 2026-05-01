class ApiNames {
  static const baseUrl = 'https://backendforwehelp.onrender.com/';
  static const signup = 'authentication/signup';
  static const login = 'authentication/login';
  static const voulnteerVerification = 'volunteer/apply';
  static const voulnteerApplications = 'admin/volunteer-applications';
  static String approveVolunteer(String id) =>
      'admin/volunteer-applications/$id/approve';
  static String rejectVolunteer(String id) =>
      'admin/volunteer-applications/$id/reject';
  static const getLocation = 'authentication/location';
  static const volunteerStatus = 'volunteer/status';
  // Chat System Endpoints
  static const chatConversations = 'chat/conversations';
  static String chatConversation(String otherUserId, {int limit = 50}) =>
      'chat/conversation/$otherUserId?limit=$limit';
  static const chatUnreadCount = 'chat/unread-count';
  static String markChatAsRead(String senderId) => 'chat/mark-read/$senderId';
  static const coordinationContacts = 'chat/coordination/contacts';
  static const helpRequests = 'help-requests';
  static const helpRequestsSos = 'help-requests/sos';
  static const activeHelpRequests = 'help-requests/my/active';
  static String acceptHelpRequest(String id) => 'help-requests/$id/accept';
  static String resolveHelpRequest(String id) => 'help-requests/$id/resolve';
  static String releaseHelpRequest(String id) => 'help-requests/$id/release';
  static String rateHelpRequest(String id) => 'help-requests/$id/rating';
  static String nearbyVolunteers({
    required double lat,
    required double lng,
    double radius = 10,
    bool onlineOnly = true,
  }) {
    return _withQuery('help-requests/nearby-volunteers', {
      'lat': lat,
      'lng': lng,
      'radius': radius,
      'onlineOnly': onlineOnly,
    });
  }

  static const alertsBase = 'alerts';
  static String alerts({double? lat, double? lng, double? radius}) {
    return _withQuery(alertsBase, {'lat': lat, 'lng': lng, 'radius': radius});
  }

  static const communitiesBase = 'communities';
  static String communities({
    String? category,
    String? status,
    double? lat,
    double? lng,
    double? radius,
  }) {
    return _withQuery(communitiesBase, {
      'category': category,
      'status': status,
      'lat': lat,
      'lng': lng,
      'radius': radius,
    });
  }

  static String joinCommunity(String id) => 'communities/$id/join';
  static String startCommunity(String id) => 'communities/$id/start';
  static String deleteCommunity(String id) => 'communities/$id';
  static String communityMessages(String id) => 'communities/$id/messages';

  static String mapUsers({
    double? lat,
    double? lng,
    double? radius,
    String? role,
  }) {
    return _withQuery('map/users', {
      'lat': lat,
      'lng': lng,
      'radius': radius,
      'role': role,
    });
  }

  static String _withQuery(String path, Map<String, dynamic> query) {
    final params = <String, String>{};
    query.forEach((key, value) {
      if (value == null) {
        return;
      }
      final text = value.toString();
      if (text.isEmpty) {
        return;
      }
      params[key] = text;
    });
    if (params.isEmpty) {
      return path;
    }
    return '$path?${Uri(queryParameters: params).query}';
  }
}
