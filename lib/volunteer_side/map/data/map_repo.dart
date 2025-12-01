import 'package:fyp_source_code/network/api_service.dart';
import 'package:fyp_source_code/services/api_names.dart';
import 'package:fyp_source_code/utilities/reuse_components/storage_helper.dart';

class MapRepo {
  final dioHelper = DioHelper();
  Future<dynamic> updateCurrentLocation({
    required double lat,
    required double long,
  }) async {
    final response = dioHelper.post(
      url: ApiNames.getLocation,
      reqBody: {'latitude': lat.toDouble(), 'longitude': long.toDouble()},
      isauthorize: true,
    );
    return response;
  }
}
