import 'package:dio/dio.dart';
import 'package:fyp_source_code/network/exceptions.dart';
import 'package:fyp_source_code/network/get_dio.dart';

class DioHelper {
  Dio dio = getDio();

  void _handleErrorResponse(String url, Response response) {
    if (response.statusCode == 404) {
      throw FetchDataExceptions('Endpoint not found: $url');
    }
    final errorMsg =
        response.data is Map && response.data['message'] != null
            ? response.data['message'].toString()
            : (response.statusMessage ?? 'Error: ${response.statusCode}');
    print(
      'API ERROR: url=$url status=${response.statusCode} dataType=${response.data.runtimeType} data=${response.data}',
    );
    throw FetchDataExceptions('Error : $errorMsg');
  }

  //get
  Future<dynamic> get({required String url, bool isauthorize = false}) async {
    try {
      Response response = await dio.get(
        url,
        options: getOptions(isauthorize: isauthorize),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        return response.data;
      } else if (response.statusCode == 400) {
        throw BadRequestException('Bad request');
      } else if (response.statusCode == 401) {
        throw UnauthorizedException('Unauthorized Request');
      } else {
        _handleErrorResponse(url, response);
      }
    } on DioException catch (e) {
      throw FetchDataExceptions(e.message ?? 'Network Error');
    }
  }

  //get
  Future<dynamic> put({
    required String url,
    Object? reqBody,
    bool isauthorize = false,
    bool isFormData = false,
  }) async {
    try {
      Response response = await dio.put(
        url,
        options: getOptions(isFormData: isFormData, isauthorize: isauthorize),
        data: reqBody,
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        return response.data;
      } else if (response.statusCode == 400) {
        throw BadRequestException('Bad request');
      } else if (response.statusCode == 401) {
        throw UnauthorizedException('Unauthorized Request');
      } else {
        _handleErrorResponse(url, response);
      }
    } on DioException catch (e) {
      throw FetchDataExceptions(e.message ?? 'Network Error');
    }
  }

  Future<dynamic> post({
    required String url,
    Object? reqBody,
    bool isauthorize = false,
  }) async {
    try {
      Response response = await dio.post(
        url,
        options: getOptions(isauthorize: isauthorize),
        data: reqBody,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return response.data;
      } else if (response.statusCode == 400) {
        throw BadRequestException('Bad request');
      } else if (response.statusCode == 401) {
        throw UnauthorizedException('Unathorized Request');
      } else {
        final errorMsg =
            response.data is Map && response.data['message'] != null
                ? response.data['message'].toString()
                : (response.statusMessage ?? response.data.toString());
        print(
          'API ERROR: url=$url status=${response.statusCode} dataType=${response.data.runtimeType} data=${response.data}',
        );
        throw FetchDataExceptions('Error : $errorMsg');
      }
    } on DioException catch (e) {
      throw FetchDataExceptions(e.message ?? 'Network Error');
    }
  }
}
