import 'package:dio/dio.dart';
import 'package:fyp_source_code/utilities/reuse_components/storage_helper.dart';

Options getOptions({bool isFormData = false, bool isauthorize = false}) {
  String? token = StorageHelper().readData('token');
  Map<String, dynamic> getheader() => {"Authorization": "Bearer $token"};
  return Options(
    contentType: isFormData ? null : 'application/json',
    headers: {
      if (isauthorize) ...getheader(),
      if (isFormData) 'Content-Type': 'multipart/form-data',
    },
    sendTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 30),
    receiveDataWhenStatusError: true,
    validateStatus: (status) => status! < 500,
  );
}

getDio() {
  Dio getDio = Dio();
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
