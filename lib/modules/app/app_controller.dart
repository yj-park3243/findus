import 'package:findus/routes.dart';
import 'package:findus/service/api_service.dart';
import 'package:findus/service/firebase_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AppController extends GetxController {
  final appData = GetStorage();
  BuildContext? context;
  final api = Get.find<ApiService>();
  final fs = Get.find<FirebaseService>();
  var selectedTabIndex = Tabs.MAP.obs;
  var isOnCloseApp = false;
  FirebaseService firebaseService = FirebaseService();
  var enabled = true.obs;

  BannerAd? bannerAd;

  @override
  void onInit() async {
    bottomNavigationLogSetScreen();

    ever(selectedTabIndex, (value) {
      bottomNavigationLogSetScreen();
      if (value == Tabs.MAP) {}
      if (value == Tabs.WORK) {
        Future.delayed(Duration(milliseconds: 500), () {
          enabled.value = false;
        });
      }
      if (value == Tabs.MYWORK) {}
      if (value == Tabs.SETTING) {}
    });
    delay();
    super.onInit();
  }

  Future<void> delay() async {
    // await Future.delayed(Duration(seconds:3),(){
    //   removeSplash();
    // });
  }

  @override
  void onReady() {}

  void bottomNavigationLogSetScreen() {
    // firebaseService.logSetScreen(
    //     screenName: selectedTabIndex.value.routeString);
  }

  void onCloseApp(BuildContext context) {
    Get.snackbar( '알림', '한번 더 누르면 종료됩니다.');
    isOnCloseApp = true;
    Future.delayed(const Duration(milliseconds: 3000), () {
      isOnCloseApp = false;
    });
  }
}

enum Tabs {
  MAP,
  WORK,
  MYWORK,
  SETTING;

  String get routeString {
    switch (this) {
      case Tabs.MAP:
        return Routes.MAP;
      case Tabs.WORK:
        return Routes.WORK;
      case Tabs.MYWORK:
        return Routes.MYWORK;
      case Tabs.SETTING:
        return Routes.SETTING;
    }
  }

  static Tabs getTabByIndex(int index) {
    switch (index) {
      case 0:
        return Tabs.MAP;
      case 1:
        return Tabs.WORK;
      case 2:
        return Tabs.MYWORK;
      case 3:
        return Tabs.SETTING;
      default:
        return Tabs.MAP;
    }
  }
}
