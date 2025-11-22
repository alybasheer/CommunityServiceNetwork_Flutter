import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';

import 'package:fyp_source_code/services/api_names.dart';

getDio() {
  Dio getDio = Dio();
  Options options = Options(
    contentType: 'application/json',
    sendTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 30),
    receiveDataWhenStatusError: true,
    validateStatus: (status) => status! < 500,
  );
  getDio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (RequestOptions options, handler) {
        print('Api Url ${options.uri}');
        print('base url is ${options.baseUrl}');
        print('Header ${options.headers}');
        // print('RequestBody ${jsonEncode(options.data)}');
        print("Method -- ${options.method}");

        // options.baseUrl = options.copyWith(baseUrl: ApiNames.baseUrl).baseUrl;
        return handler.next(options);
      },
      onResponse: (Response response, handler) {
        print("Response Data ${response.data}");
        return handler.next(response);
      },
      onError: (error, handler) {
        print("Status Code ${error.response?.statusCode}");
        print("Error body ${error.response?.data}");
        return handler.next(error);
      },
    ),
  );
  return getDio;
}
