import 'dart:io';
import 'dart:math';
import 'package:dio/dio.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../constants/env.dart';

class AppChecker {
  final dio = Dio();

  Future<bool> checkAppVersion() async {
    final packageInfo = await PackageInfo.fromPlatform();
    try {
      String deviceCode;
      if (Platform.isAndroid) {
        deviceCode = 'G';
      } else {
        deviceCode = 'A';
      }
      final res = await dio.post('${Env.apiUrl}/version');
      if (deviceCode == 'G') {
        final apiVersion = res.data['payload']['version'][0]['VERSION_VALUE'];
        if (isNeedUpdate(packageInfo.version, apiVersion)) {
          return false;
        }
      } else if (deviceCode == 'A') {
        final apiVersion = res.data['payload']['version'][1]['VERSION_VALUE'];
        if (isNeedUpdate(packageInfo.version, apiVersion)) {
          return false;
        }
      }
    } catch (e) {
      print(e);
    }
    return true;
  }

  bool isNeedUpdate(String appVersion, String apiVersion) {
    bool isNeedUpdate = false;
    try {
      final sAppVersion =
          appVersion.split('.').map((e) => int.parse(e)).toList();
      final sApiVersion =
          apiVersion.split('.').map((e) => int.parse(e)).toList();
      print(sAppVersion);
      print(sApiVersion);
      int app = 0;
      int api = 0;
      for (var i = 0; i < 3; i++) {
        app = (app + sAppVersion[i] * pow(10, 2-i)) as int;
        api = (api + sApiVersion[i] * pow(10, 2-i)) as int;
        print(app);
        print(api);
      }
      print(app);
      print(api);
      if ( app < api) isNeedUpdate = true;
    } catch (e) {
      print(e);
    }

    return isNeedUpdate;
  }
}
