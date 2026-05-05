import 'package:dio/dio.dart';
import 'package:fyp_source_code/services/api_names.dart';
import 'package:fyp_source_code/utilities/reuse_components/storage_helper.dart';

Options getOptions({bool isFormData = false, bool isauthorize = false}) {
  final token = StorageHelper().readData('token')?.toString().trim();
  final hasToken = token != null && token.isNotEmpty;
  return Options(
    contentType:
        isFormData
            ? Headers.multipartFormDataContentType
            : Headers.jsonContentType,
    headers: {if (isauthorize && hasToken) "Authorization": "Bearer $token"},
    sendTimeout: const Duration(seconds: 45),
    receiveTimeout: const Duration(seconds: 90),
    receiveDataWhenStatusError: true,
    validateStatus: (status) => status! < 500,
  );
}

getDio() {
  Dio getDio = Dio();
  getDio.options.connectTimeout = const Duration(seconds: 45);
  getDio.options.receiveTimeout = const Duration(seconds: 90);
  getDio.options.sendTimeout = const Duration(seconds: 45);
  getDio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (RequestOptions options, handler) {
        print('Api Url ${options.uri}');
        print('base url is ${options.baseUrl}');
        final safeHeaders = Map<String, dynamic>.from(options.headers);
        if (safeHeaders.containsKey('Authorization')) {
          safeHeaders['Authorization'] = 'Bearer ***';
        }
        print('Header $safeHeaders');
        // print('RequestBody ${jsonEncode(options.data)}');
        print("Method -- ${options.method}");

        options.baseUrl =
            options.copyWith(baseUrl: ApiNames.normalizedBaseUrl).baseUrl;
        return handler.next(options);
      },
      onResponse: (Response response, handler) {
        print("Response Data ${_maskSensitiveData(response.data)}");

        return handler.next(response);
      },
      onError: (error, handler) {
        print("Status Code ${error.response?.statusCode}");
        print("Error body ${_maskSensitiveData(error.response?.data)}");
        return handler.next(error);
      },
    ),
  );
  return getDio;
}

dynamic _maskSensitiveData(dynamic data) {
  if (data is Map) {
    return data.map((key, value) {
      final normalizedKey = key.toString().toLowerCase();
      final isSensitive =
          normalizedKey.contains('token') ||
          normalizedKey.contains('authorization') ||
          normalizedKey.contains('password');

      return MapEntry(key, isSensitive ? '***' : _maskSensitiveData(value));
    });
  }

  if (data is List) {
    return data.map(_maskSensitiveData).toList();
  }

  return data;
}
