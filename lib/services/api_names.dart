class ApiNames {
  static const baseUrl = 'http://192.168.100.236:3000/';
  static const signup = 'authentication/signup';
  static const login = 'authentication/login';
  static const googleLogin = 'authentication/google-login';
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
}
