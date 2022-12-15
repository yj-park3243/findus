// 이메일 로그인 및 가입화면
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:findus/constants/common_sizes.dart';
import 'package:findus/modules/auth/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../setting/setting_edit_profile.dart';
import '../login.dart';

class ChangePassword extends GetView<AuthController> {
  const ChangePassword({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                    SizedBox(
                      height: CommonGap.xxxxl,
                    ),
                    Row(
                      children: [
                        Icon(
                          EvaIcons.swapOutline,
                          color: Colors.blueAccent,
                        ),
                        SizedBox(
                          width: CommonGap.xxs,
                        ),
                        Text(
                          '새 비밀번호를 입력해주세요.',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: CommonGap.xxxxl,
                    ),
                    Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black12),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: CommonGap.xs,
                                  right: CommonGap.xs,
                                  top: 18,
                                  bottom: 18),
                              child: SvgPicture.asset(
                                'assets/find_us_images/common/email_black.svg',
                              ),
                            ),
                            Text(
                              'hyeyun@google.com',
                              style: TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.bold),
                            ),
                          ],
                        )
                      // controller: _email,
                    ),
                    SizedBox(
                      height: CommonGap.xs,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black12),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: TextField(
                        decoration: InputDecoration(
                          icon: Padding(
                            padding: const EdgeInsets.only(left: CommonGap.xs),
                            child: SvgPicture.asset(
                              'assets/find_us_images/common/password_black.svg',
                            ),
                          ),
                          hintText: '비밀번호',
                          hintStyle: TextStyle(fontSize: 12),
                          border: InputBorder.none,
                        ),
                        // controller: _passWd,
                        obscureText: true,
                      ),
                      // controller: _email,
                    ),
                  ],
                ),
              ),
              SizedBox(
                  height: 40,
                  width: double.infinity,
                  child: ElevatedButton(
                      onPressed: () {
                        myDialog();
                      },
                      child: Text('다음'),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueAccent)))
            ],
          ),
        ),
      ),
    );
  }

  void myDialog() {
    Get.dialog(AlertDialog(
      title: SvgPicture.asset(
        'assets/find_us_images/common/password-change.svg',
        height: Get.height / 5,
      ),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(32.0))),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '축하드립니다!',
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 16,
                color: Colors.blueAccent,
                fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: CommonGap.m,
          ),
          Text(
            '비밀번호 재설정이 완료되었습니다.',
            style: TextStyle(
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
      actions: [
        TextButton(
            onPressed: () {
              Get.to(() => Login());
              Get.snackbar('알림', '비밀번호 재 설정이 완료되었습니다.\n로그인을 해주세요.');
            },
            child: Text('확인'))
      ],
    ));
  }
}
