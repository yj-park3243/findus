import 'package:dio/dio.dart';

import 'package:findus/core/env.dart';
import 'package:findus/routes.dart';
import 'package:get/instance_manager.dart';
import 'package:get/state_manager.dart';
import 'package:get/route_manager.dart';
import 'auth_service.dart';


class ApiService extends GetxService {
  String get apiHost => Env.apiUrl;
  var dio = Dio();
  final auth = Get.find<AuthService>();

  Future<ApiService> init() async {
    dio.options.baseUrl = '$apiHost/';
    dio.interceptors.add(InterceptorsWrapper(onRequest: (options, handler) {
      if (Env.devMode != 'prod') {
        print(options.uri);
      }
      return handler.next(options); //continue
    }, onResponse: (response, handler) {
      if (Env.devMode == 'dev') {
        print('response.statusCode ${response.statusCode}');
        print('response.data ${response.data}');
      }
      return handler.next(response); // continue
    }, onError: (DioError e, handler) {
      if (Env.devMode == 'dev') {
        print(e);
        print(e.message);
        print(e.response!.data);
        print(e.requestOptions.uri);
      }
      if (e.response?.statusCode == 401) {
        auth.logOut();
        Get.offAllNamed(Routes.INTRO);
        Get.showSnackbar(GetBar(
          duration: Duration(milliseconds: 1500),
          snackPosition: SnackPosition.TOP,
          snackStyle: SnackStyle.GROUNDED,
          // title: '서버 통신 에러',
          message: '로그인이 만료되었습니다',
        ));
      } else {
        print(e);
        Get.showSnackbar(GetBar(
          duration: Duration(milliseconds: 1500),
          snackPosition: SnackPosition.TOP,
          snackStyle: SnackStyle.GROUNDED,
          // title: '서버 통신 에러',
          message: '서버와 통신을 실패했습니다.',
        ));
      }
      return handler.next(e); //continue
    }));

    return this;
  }

  Map<String, String> get headers {
    Map<String, String> headers = {};
    if (auth.getJwt() != null) {
      headers['Authorization'] = '${auth.getJwt()}';
    }
    headers['content-type'] = 'application/json; charset=utf-8';
    headers['accept'] = 'application/json; charset=utf-8';
    return headers;
  }

  Future<Response> postWithHearder(String path, {dynamic data}) {
    print("post data >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
    print(data);
    print("post data >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
    return dio.post(path,  data: data, options: Options(headers: headers));
  }

  Future<Response> getWithHearder(
      String url, {
        Map<String, dynamic>? queryParameters,
      }) {
    return dio.get(url,
        queryParameters: queryParameters, options: Options(headers: headers));
  }

}
