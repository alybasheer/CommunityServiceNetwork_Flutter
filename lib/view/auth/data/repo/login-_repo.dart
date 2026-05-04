import 'package:fyp_source_code/view/auth/data/models/signin_model.dart';
import 'package:fyp_source_code/network/api_service.dart';
import 'package:fyp_source_code/services/api_names.dart';

class LoginRepo {
  final dioHelper = DioHelper();
  Future<SignupModel> loginRepo(Object? reqData) async {
    final Map<String, dynamic> respone = await dioHelper.post(
      url: ApiNames.login,
      reqBody: reqData,
    );
    return SignupModel.fromJson(respone);
  }
}
