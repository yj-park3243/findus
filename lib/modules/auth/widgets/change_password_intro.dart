// 이메일 로그인 및 가입화면
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:findus/constants/common_sizes.dart';
import 'package:findus/modules/auth/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../setting/setting_edit_profile.dart';
import 'change_password.dart';

class ChangePasswordIntro extends GetView<AuthController> {
  const ChangePasswordIntro({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _email = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        title: Text('비밀번호_변경'.tr),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(CommonGap.m),
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  children: [
                    const SizedBox(
                      height: CommonGap.xs,
                    ),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Row(
                        children: [
                          const Icon(
                            EvaIcons.personDoneOutline,
                            color: Colors.blueAccent,
                          ),
                          const SizedBox(
                            width: CommonGap.xxs,
                          ),
                          Text(
                            '해당_계정의_비밀번호를_변경합니다'.tr,
                            style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'SF-Pro-Heavy'),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: CommonGap.xxxxl,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 4, left: 4),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              focusNode: controller.searchInputBoxNode,
                              controller: _email,
                              decoration: InputDecoration(
                                labelText: '이메일'.tr,
                                labelStyle: const TextStyle(fontSize: 12),
                                hintStyle: const TextStyle(fontSize: 12),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: CommonGap.xxxxl,
                    ),
                    ElevatedButton(
                        onPressed: () async {
                          if (!RegExp(
                                  r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
                              .hasMatch(_email.text)) {
                            Get.snackbar('알림'.tr, '양식에_맞지_않습니다'.tr);
                            return;
                          }

                          controller.sendPasswordResetEmail(_email.text);
                          if (_email.text.isEmpty) {
                            Get.snackbar('알림'.tr, '이메일을_입력해주세요'.tr);
                          } else {
                            Get.snackbar(
                                '알림'.tr, '인증_메일을_발송하였습니다_메일을_확인_후_링크를_눌러서비밀번호를_설정해주세요'.tr);
                            controller.searchInputBoxNode.unfocus();
                          }
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              EvaIcons.email,
                              size: 20,
                            ),
                            const SizedBox(
                              width: CommonGap.xs,
                            ),
                            Text('재설정_이메일_전송'.tr),
                          ],
                        )),

                    const SizedBox(
                      height: CommonGap.m,
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: SizedBox(
                        width: Get.width / 3,
                        child: OutlinedButton(
                            onPressed: () async {
                              Get.back();
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('로그인'.tr),
                                const SizedBox(
                                  width: CommonGap.xs,
                                ),
                                const Icon(
                                  EvaIcons.arrowIosForwardOutline,
                                  size: 20,
                                ),
                              ],
                            )),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
