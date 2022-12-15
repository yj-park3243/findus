// 이메일 로그인 및 가입화면
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:findus/constants/common_sizes.dart';
import 'package:findus/model/version.dart';
import 'package:findus/modules/auth/auth_controller.dart';
import 'package:findus/modules/auth/widgets/change_password_intro.dart';
import 'package:findus/modules/setting/setting_controller.dart';
import 'package:findus/service/Storage_service.dart';
import 'package:findus/service/api_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login_facebook/flutter_login_facebook.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../global_widgets/loading_button.dart';
import '../../routes.dart';
import 'widgets/join_membership.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _email = TextEditingController();
  final _passWd = TextEditingController();
  final api = Get.find<ApiService>();
  final storage = Get.find<StorageService>();
  final FacebookLogin _facebookSignIn = FacebookLogin();
  final AuthController authController = Get.find();
  final SettingController settingController = Get.put(SettingController());


  var isLoading = false.obs;
  var versionList = <VersionModel>[];

  @override
  void dispose() {
    _email.dispose();
    _passWd.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _email.text = '';
    _passWd.text = '';
    return Scaffold(
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
                  Image.asset(
                    'assets/splash_2.png',
                    height: Get.height / 4,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black12),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: CommonGap.xs, top: 6),
                          child: TextField(
                            decoration: InputDecoration(
                              icon: SvgPicture.asset(
                                'assets/find_us_images/common/email.svg',
                              ),
                              hintText: '이메일'.tr,
                              hintStyle: const TextStyle(
                                  fontSize: 12, fontFamily: 'SF-Pro-Regular'),
                              border: InputBorder.none,
                            ),
                            controller: _email,
                          ),
                        ),
                        const Divider(),
                        Padding(
                          padding: const EdgeInsets.only(left: CommonGap.xs, bottom: 6),
                          child: TextField(
                            decoration: InputDecoration(
                              icon: SvgPicture.asset(
                                'assets/find_us_images/common/password.svg',
                              ),
                              hintText: '비밀번호'.tr,
                              hintStyle: const TextStyle(
                                  fontSize: 12, fontFamily: 'SF-Pro-Regular'),
                              border: InputBorder.none,
                            ),
                            controller: _passWd,
                            obscureText: true,
                          ),
                        ),
                        // controller: _email,
                      ],
                    ),
                  ),
                  const Padding(padding: EdgeInsets.all(CommonGap.s)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Expanded(
                          flex: 1,
                          child: Obx(
                            () => LoadingButton(
                              isLoading: isLoading.value,
                              onPressed: () {
                                _login(
                                    email: _email.text.trim(),
                                    passWord: _passWd.text.trim(),
                                    context: context);
                              },
                              style: ElevatedButton.styleFrom(),
                              child: Text(
                                "로그인".tr,
                                style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'SF-Pro-Heavy'),
                              ),
                            ),
                          )),
                    ],
                  ),
                  const SizedBox(
                    height: CommonGap.m,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '비밀번호를_잊으셨나요'.tr,
                        style: const TextStyle(fontFamily: 'SF-Pro-Semibold'),
                      ),
                      TextButton(
                          onPressed: () {
                            Get.to(() => const ChangePasswordIntro());
                          },
                          child: Text(
                            '비밀번호_찾기'.tr,
                            style: const TextStyle(
                                decoration: TextDecoration.underline,
                                fontFamily: 'SF-Pro-Semibold'),
                          )),
                    ],
                  ),
                  const Divider(
                    thickness: 1,
                  ),
                  SizedBox(
                    height: CommonGap.xxs,
                  ),
                  TextButton(
                      onPressed: () async {
                        await settingController.languagePopUp(context);
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            'assets/find_us_images/common/language.svg',
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(
                            '언어_설정'.tr,
                            style: const TextStyle(
                              color: Colors.black,
                            ),
                          ),
                        ],
                      )),
                  const SizedBox(
                    height: CommonGap.m,
                  ),
                  /* OutlinedButton(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(EvaIcons.facebook),
                        Text(
                          '페이스북으로_로그인'.tr,
                          style: const TextStyle(fontFamily: 'SF-Pro-Heavy'),
                        ),
                      ],
                    ),
                    onPressed: () {
                      signInWithFacebook();
                    },
                  ),*/
                  SizedBox(
                    height: Get.height / 15
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '아직_회원이_아니신가요'.tr,
                        style: const TextStyle(fontFamily: 'SF-Pro-Semibold'),
                      ),
                      TextButton(
                          onPressed: () {
                            Get.to(() => JoinMemberShip());
                          },
                          child: Text(
                            '회원가입'.tr,
                            style: const TextStyle(
                                decoration: TextDecoration.underline,
                                fontFamily: 'SF-Pro-Semibold'),
                          )),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ));
  }

  void myDialog({required String msg}) {
    Get.dialog(AlertDialog(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(32.0))),
      icon: const Icon(
        EvaIcons.alertTriangleOutline,
        size: 30,
        color: Colors.blueAccent,
      ),
      content: Text(
        msg,
        style: const TextStyle(fontFamily: 'Malgun Gothic', fontSize: 18),
      ),
      actions: [
        TextButton(
            onPressed: () {
              Get.back();
            },
            child: const Text('close'))
      ],
    ));
  }

  void _login(
      {required String email,
      required String passWord,
      required BuildContext context}) async {
    isLoading.value = true;
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: email, password: passWord) //아이디와 비밀번호로 로그인 시도
          .then((value) {
        if (value.user!.emailVerified) {
          authController.saveLoginInfo(value);
        } else {
          Get.snackbar('알림'.tr, '인증_메일을_발송하였습니다'.tr);
          value.user!.sendEmailVerification();
        }
        return value;
      });
    } on FirebaseAuthException catch (e) {
      //로그인 예외처리
      if (e.code == 'user-not-found') {
        Get.snackbar('알림'.tr, '등록되지_않은_이메일입니다'.tr);
      } else if (e.code == 'wrong-password') {
        Get.snackbar('알림'.tr, '비밀번호가_틀렸습니다'.tr);
      } else {
        Get.snackbar('알림'.tr, e.code);
      }
    }
    isLoading.value = false;
  }



  Future signInWithFacebook() async {
    FacebookLoginResult result = await _facebookSignIn.logIn(permissions: [
      FacebookPermission.userFriends,
      FacebookPermission.email,
      FacebookPermission.publicProfile
    ]);
    // Create a credential from the access token
    final facebookAuthCredential =
        FacebookAuthProvider.credential(result.accessToken!.token);

    // Once signed in, return the UserCredential
    final authResult = await FirebaseAuth.instance
        .signInWithCredential(facebookAuthCredential);
    final user = authResult.user;

    print(user);
    print('>>>>>>');
    print('Facebook: login');

    if (user != null) {
      Get.offAllNamed(Routes.APP);
    }

    return;
  }
}
