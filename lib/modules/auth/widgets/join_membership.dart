// 이메일 로그인 및 가입화면
import 'dart:io';

import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:findus/constants/common_sizes.dart';
import 'package:findus/modules/auth/auth_controller.dart';
import 'package:findus/modules/auth/widgets/join_membership_end.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../../../global_widgets/loading_button.dart';

class JoinMemberShip extends GetView<AuthController> {
  final _email = TextEditingController();
  final _password1 = TextEditingController();
  final _password2 = TextEditingController();
  final _nickName = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final passwordFormKey = GlobalKey<FormState>();

  bool validator() {
    if (controller.isChecked.value != true ||
        controller.isChecked_2.value != true ||
        controller.validatePassword1.value.isEmpty ||
        controller.validatePassword2.value.isEmpty ||
        controller.validatePassword1.value !=
            controller.validatePassword2.value ||
        controller.validateEmail.value.isEmpty ||
        controller.validateNickname.value.isEmpty) {
      print("111111");
      return false;
    } else if (controller.validateNickname.value.length > 10) {
      print("22222");
      return false;
    } else if (controller.validateNickname.value.length <= 1) {
      print("33333");
      return false;
    }
    print("44444");
    return true;
  }

  @override
  Widget build(BuildContext context) {
    controller.isChecked.value = false;
    controller.isChecked_2.value = false;
    return Scaffold(
        appBar: AppBar(
          title: Text(
            '회원가입'.tr,
            style: const TextStyle(fontFamily: 'SF-Pro-Regular'),
          ),
          centerTitle: true,
        ),
        body: Obx(
          () => SafeArea(
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
                          height: CommonGap.xxs,
                        ),
                        Row(
                          children: [
                            const Icon(
                              EvaIcons.edit2Outline,
                              color: Colors.blueAccent,
                            ),
                            const SizedBox(
                              width: CommonGap.xxs,
                            ),
                            Text(
                              '계정을_생성해주세요'.tr,
                              style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'SF-Pro-Heavy'),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: CommonGap.xxxxl,
                        ),
                        Form(
                          key: formKey,
                          child: Padding(
                            padding: const EdgeInsets.only(right: 4, left: 4),
                            child: TextFormField(
                              controller: _email,
                              onChanged: (val) {
                                controller.validateEmail.value = val.toString();
                              },
                              validator: (val) {
                                if (val.toString().isEmpty) {
                                  return '이메일은_필수사항_입니다'.tr;
                                }
                                if (!RegExp(
                                        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
                                    .hasMatch(val.toString())) {
                                  return '잘못된_이메일_형식입니다'.tr;
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                labelText: '이메일'.tr,
                                labelStyle: const TextStyle(
                                    fontSize: 12, fontFamily: 'SF-Pro-Light'),
                                hintStyle: const TextStyle(
                                    fontSize: 12, fontFamily: 'SF-Pro-Light'),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: CommonGap.m,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 4, left: 4),
                          child: TextField(
                            controller: _password1,
                            onChanged: (val) {
                              controller.validatePassword1.value =
                                  val.toString();
                            },
                            obscureText: true,
                            decoration: InputDecoration(
                              labelText: '비밀번호'.tr,
                              labelStyle: const TextStyle(
                                  fontSize: 12, fontFamily: 'SF-Pro-Light'),
                              hintStyle: const TextStyle(
                                  fontSize: 12, fontFamily: 'SF-Pro-Light'),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: CommonGap.m,
                        ),
                        Form(
                          key: passwordFormKey,
                          child: Padding(
                            padding: const EdgeInsets.only(right: 4, left: 4),
                            child: TextFormField(
                              controller: _password2,
                              onChanged: (val) {
                                controller.validatePassword2.value =
                                    val.toString();
                                passwordFormKey.currentState!.validate();
                              },
                              validator: (val) {
                                if (controller.validatePassword1.value !=
                                    controller.validatePassword2.value) {
                                  return "비밀번호가_다릅니다".tr;
                                }
                                return null;
                              },
                              obscureText: true,
                              decoration: InputDecoration(
                                labelText: '비밀번호_재확인'.tr,
                                labelStyle: const TextStyle(
                                    fontSize: 12, fontFamily: 'SF-Pro-Light'),
                                hintStyle: const TextStyle(
                                    fontSize: 12, fontFamily: 'SF-Pro-Light'),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: CommonGap.m,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 4, left: 4),
                          child: TextFormField(
                            controller: _nickName,
                            onChanged: (val) {
                              controller.validateNickname.value =
                                  val.toString();
                            },
                            validator: (val) {
                              if (val.toString().isEmpty) {
                                return '닉네임은 필수사항입니다.';
                              }
                              if (val.toString().length >= 10) {
                                return '닉네임은 최대 9글자 입니다.';
                              }
                              if (val.toString().length < 2) {
                                return '닉네임은 2글자 이상입니다.';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              labelText: '닉네임'.tr,
                              labelStyle: const TextStyle(
                                  fontSize: 12, fontFamily: 'SF-Pro-Light'),
                              hintStyle: const TextStyle(
                                  fontSize: 12, fontFamily: 'SF-Pro-Light'),
                            ),
                          ),

                        ),
                        const SizedBox(
                          height: 100,
                        ),
                        Row(
                          children: [
                            Checkbox(
                                activeColor: Colors.blueAccent,
                                value: controller.isChecked.value,
                                onChanged: (value) {
                                  if(controller.isChecked.value){
                                    controller.isChecked.value = false;
                                  }else{
                                    controller.showCheckBox();
                                  }
                                }),

                            RichText(
                                text: TextSpan(text: '파인드어스_이용약관_필수'.tr,  style: const TextStyle(
                                  color: Colors.black,
                                  height: 1.4,
                                  fontSize: 14.0,),)
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Checkbox(
                                activeColor: Colors.blueAccent,
                                value: controller.isChecked_2.value,
                                onChanged: (value) {
                                  if(controller.isChecked_2.value){
                                    controller.isChecked_2.value = false;
                                  }else{
                                    controller.showCheckBox_2();
                                  }
                                }),
                            RichText(
                              text: TextSpan(text: '파인드어스_개인정보_수집_동의_필수'.tr,  style: const TextStyle(
                                color: Colors.black,
                                height: 1.4,
                                fontSize: 14.0,),)
                              ),

                          ],
                        ),
                        const SizedBox(
                          height: CommonGap.m,
                        ),
                         SizedBox(
                            height: 40,
                            width: double.infinity,
                            child:
                            !validator()? ElevatedButton(
                                onPressed: () async {
                                  if (!formKey.currentState!.validate()) {
                                    return;
                                  }
                                  if (validator()) {
                                    var rst = await controller.checkNickName(
                                        _nickName.text, context);
                                    if (!rst) {
                                      Get.snackbar('알림', '이미 가입된 닉네임입니다.');
                                      return;
                                    } else {
                                      if (await controller.createUser(_email.text,
                                          _password1.text, _nickName.text, context)) {
                                        Get.off(() => JoinMemberShipEnd());
                                      }
                                    }
                                  } else if (controller.isChecked.value == false ||
                                      controller.isChecked_2.value == false) {
                                    Get.snackbar(
                                        '알림', '이용 약관에 동의하지 않을 시 회원가입이 제한됩니다.');
                                  } else {
                                    Get.snackbar('알림', '양식에 맞지 않습니다.');
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.grey),
                                child: Text(
                                  "회원가입".tr,
                                  style: const TextStyle(fontFamily: 'SF-Pro-Bold'),
                                )):
                            LoadingButton(
                                isLoading: controller.isLoading.value,
                                onPressed: () async {
                                  if (!formKey.currentState!.validate()) {
                                    return;
                                  }
                                  if (validator()) {
                                    var rst = await controller.checkNickName(
                                        _nickName.text, context);
                                    if (!rst) {
                                      Get.snackbar('알림'.tr, '이미_등록된_이메일입니다'.tr);
                                      return;
                                    } else {
                                      if (await controller.createUser(_email.text,
                                          _password1.text, _nickName.text, context)) {
                                        Get.off(() => JoinMemberShipEnd());
                                      }
                                    }
                                  } else if (controller.isChecked.value == false ||
                                      controller.isChecked_2.value == false) {
                                    Get.snackbar(
                                        '알림'.tr, '이용약관은_필수_사항입니다'.tr);
                                  } else {
                                    Get.snackbar('알림'.tr, '양식에_맞지_않습니다'.tr);
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blueAccent),
                                child: Text(
                                  "회원가입".tr,
                                  style: const TextStyle(fontFamily: 'SF-Pro-Bold'),
                                )))

                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
