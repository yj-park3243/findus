

import 'package:findus/modules/intro/intro_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Intro extends StatelessWidget {
  Intro({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetX<IntroController>(
        init: IntroController(context: context),
        builder: (controller) {
          return WillPopScope(
            onWillPop: () async {
              return false;
              if (controller.isOnCloseApp == false) {
                return false;
              } else {
                return true;
              }
            },
            child: Scaffold(
              body: controller.isLoading.value
                  ? const Center(child: CircularProgressIndicator())
                  : SafeArea(
                top: false,
                child: Column(),
                ),
              ),
            );
        });
  }
}
