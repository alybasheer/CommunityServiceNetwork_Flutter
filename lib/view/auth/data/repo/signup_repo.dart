import 'package:fyp_source_code/view/auth/data/models/signin_model.dart';
import 'package:fyp_source_code/network/api_service.dart';
import 'package:fyp_source_code/services/api_names.dart';

class RegisterRepo {
  final DioHelper _dioHelper = DioHelper();
  Future<SignupModel> postData(Object? reqdata) async {
    try {
      
      final response = await _dioHelper.post(
        url: ApiNames.signup,
        reqBody: reqdata,
      );

      if (response is Map<String, dynamic>) {
        return SignupModel.fromJson(response);
      } else if (response is Map) {
        return SignupModel.fromJson(Map<String, dynamic>.from(response));
      } else {
        throw Exception('Invalid response from server');
      }
    } catch (e) {
      rethrow;
    }
  }
}
