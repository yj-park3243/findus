import 'package:findus/core/env.dart';
import 'package:findus/service/auth_service.dart';
import 'package:get/get.dart';

class ApiClient extends GetConnect implements GetxService {
  String get apiHost => Env.apiUrl;
  late String token;
  late Map<String, String> _mainHeaders;
  final auth = Get.find<AuthService>();

  Map<String, String> get headers {
    Map<String, String> headers = {};
    if (auth.jwt != null) {
      headers['Authorization'] = '${auth.jwt}';
    }
    headers['content-type'] = 'application/json; charset=utf-8';
    headers['accept'] = 'application/json; charset=utf-8';
    return headers;
  }

  ApiClient() {
    baseUrl = apiHost;
    timeout = Duration(minutes: 5);
    _mainHeaders = {
      'Content-type': 'application/json; charset=UTF-8',
      // 'Authorization': 'Bearer ${token??''}',
    };
  }

  Future<Response> getData(
      String uri, Map<String, dynamic>? queryParameters) async {
    try {
      Response response = await get(uri, query: queryParameters, headers: headers);
      return response;
    } catch (e) {
      print("Error from the api client is " + e.toString());
      return Response(statusCode: 1, statusText: e.toString());
    }
  }

  Future<Response> postData(String uri,  {dynamic data}) async {
    try {
      Response response = await post(uri, data , headers: headers, );
      return response;
    } catch (e) {
      print("Error from the api client is " + e.toString());
      return Response(statusCode: 1, statusText: e.toString());
    }
  }
}
