class ApiNames {
  static const baseUrl = 'http://localhost:3000/';
  static const signup = 'http://localhost:3000/authentication/signup';
  static const login = 'http://localhost:3000/authentication/login';
  static const voulnteerVerification = 'http://localhost:3000/volunteer/apply';
  static const voulnteerApplications =
      'http://localhost:3000/admin/volunteer-applications';
  static String approveVolunteer(String id) =>
      'http://localhost:3000/admin/volunteer-applications/$id/approve';
  static String rejectVolunteer(String id) =>
      'http://localhost:3000/admin/volunteer-applications/$id/reject';
  static const getLocation = 'http://localhost:3000/authentication/location';
}
