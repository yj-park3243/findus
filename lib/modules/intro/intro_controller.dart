import 'dart:io';

import 'package:findus/helper/check_app_version.dart';
import 'package:findus/helper/has_location_permission.dart';
import 'package:findus/modules/auth/auth_controller.dart';
import 'package:findus/routes.dart';
import 'package:findus/service/api_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';

class IntroController extends GetxController {
  IntroController({required this.context});
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final api = Get.find<ApiService>();
  final AuthController authController = Get.find();
  var isOnCloseApp = false;
  var isLoading = true.obs;
  BuildContext? context;
  late AsyncSnapshot snapshot;

  void onInit() {
    super.onInit();
  }

  @override
  void onReady() async {
      await determinePosition();
      isLoading.value = false;
      FlutterNativeSplash.remove();

      if(await checkBasicInformation()) await autoLogin();
    //}
  }

  Future<void> autoLogin() async {
    if(_auth.currentUser != null){
      authController.saveLoginUser(_auth.currentUser);
    }else{
      Get.offAllNamed(Routes.LOGIN);
    }
  }

  Future<bool> checkBasicInformation() async {
    if (!await AppChecker().checkAppVersion()) {
      Get.offAllNamed(Routes.VERSION_CHECK);
      return false;
    }
    return true;
  }
  onCloseApp(BuildContext context) {
    Get.snackbar( '알림', 'back_button_close_app_text'.tr);
    isOnCloseApp = true;
    Future.delayed(const Duration(milliseconds: 3000), () {
      isOnCloseApp = false;
    });
  }
}
