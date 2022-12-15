// 이메일 로그인 및 가입화면
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:findus/constants/common_sizes.dart';
import 'package:findus/modules/auth/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'join_membership.dart';

class JoinMemberShipEnd extends GetView<AuthController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('회원가입'.tr),
        leading: Container(),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(CommonGap.m),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Icon(
                          EvaIcons.emailOutline,
                          size: 100,
                          color: Colors.blueAccent,
                        ),
                        Icon(
                          EvaIcons.plusCircle,
                          size: 40,
                          color: Colors.blueAccent,
                        ),
                      ],
                    ),
                  ),
                  Text(
                    "인증_메일을_발송하였습니다"
                        .tr,
                    style: TextStyle(fontFamily: 'SF-Pro-Regular'),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: CommonGap.m,
                  ),
                  Text(
                    "메일을_확인_후_인증을_진행해_주세요"
                        .tr,
                    style: TextStyle(fontFamily: 'SF-Pro-Regular'),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    "인증을_하지_않을_시_회원가입이_완료되지_않습니다"
                        .tr,
                    style: TextStyle(fontFamily: 'SF-Pro-Regular'),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.all(CommonGap.xxxxl),
                  child: SizedBox(
                      height: 40,
                      width: double.infinity,
                      child: OutlinedButton(
                          onPressed: () {
                            Get.back();
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('로그인'.tr),
                              const Icon(EvaIcons.arrowIosForwardOutline)
                            ],
                          ))),
                ))
          ],
        ),
      ),
    );
  }
}
