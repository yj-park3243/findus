import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:findus/constants/common_sizes.dart';
import 'package:findus/constants/style.dart';
import 'package:findus/global_widgets/circle_profile.dart';
import 'package:findus/modules/app/app.dart';
import 'package:findus/modules/setting/setting_controller.dart';
import 'package:findus/modules/setting/setting_edit_profile.dart';
import 'package:findus/modules/setting/setting_question.dart';
import 'package:findus/modules/setting/setting_Ban.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../auth/widgets/join_membership_1.dart';
import '../auth/widgets/join_membership_2.dart';

class Setting extends GetView<SettingController> {
  Setting({Key? key}) : super(key: key);
  final setting = Get.lazyPut(() => SettingController());

  @override
  Widget build(BuildContext context) {
    controller.context = context;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        // leadingWidth: 40,
        title: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text('프로필_설정'.tr, style: tapMenuTitleTextStyle),
        ),
      ),
      body: Obx(
        () => Padding(
            padding: const EdgeInsets.symmetric(horizontal: CommonGap.m),
            child: ListView(
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    InkWell(
                        onTap: () {
                          if (controller.auth.user.value?.profile_url != null) {
                            Get.to(() => Scaffold(
                                  backgroundColor: Colors.black,
                                  appBar: AppBar(
                                    leading: IconButton(
                                      onPressed: () {
                                        //Get.back();  F
                                      },
                                      icon: const Icon(Icons.close,
                                          color: Colors.white),
                                    ),
                                  ),
                                  body: Image.network(
                                    controller.auth.user.value!.profile_url!,
                                  ),
                                ));
                          }
                        },
                        child: Center(
                            child: InkWell(
                          onTap: () {
                            Get.to(() => SettingEditProfile());
                          },
                          child: CircleProfile(
                              controller.auth.user.value?.profile_url),
                        ))),
                    Container(
                      height: 5,
                      color: HexColor('#d3d3d33'),
                    ),
                    const SizedBox(
                      height: CommonGap.xs,
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: TextButton(
                          onPressed: () {
                            controller.nickName.text =
                                controller.auth.user.value?.user_nickname ?? '';
                            Get.to(() => SettingEditProfile());
                          },
                          child: Row(
                            children: [
                              SvgPicture.asset(
                                  'assets/find_us_images/common/profile.svg'),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(
                                '프로필_설정'.tr,
                                style: const TextStyle(color: Colors.black),
                              ),
                            ],
                          )),
                    ),
                    const Divider(),
                    //언어 설정버튼
                    Align(
                      alignment: Alignment.centerLeft,
                      child: TextButton(
                          onPressed: () async {
                            await controller.languagePopUp(context);
                          },
                          child: Row(
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
                    ),
                    const Divider(),
                    //로그아웃
                    Align(
                      alignment: Alignment.centerLeft,
                      child: TextButton(
                          onPressed: () {
                            Get.to(() => SettingQuestion());
                          },
                          child: Row(
                            children: [
                              const Icon(
                                EvaIcons.messageCircleOutline,
                                size: 22,
                                color: Colors.black,
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(
                                '문의하기'.tr,
                                style: const TextStyle(color: Colors.black),
                              ),
                            ],
                          )),
                    ),
                    const Divider(),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: TextButton(
                          onPressed: () async {
                            await controller.banUser();
                            Get.to(() => SettingBan());
                          },
                          child: Row(
                            children: [
                              const Icon(
                                Icons.block,
                                size: 22,
                                color: Colors.black,
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(
                                '차단_목록'.tr,
                                style: const TextStyle(color: Colors.black),
                              ),
                            ],
                          )),
                    ),
                    const Divider(),

                    //로그아웃
                    Align(
                      alignment: Alignment.centerLeft,
                      child: TextButton(
                          onPressed: () async {
                            await controller.logOutPopUp(context);
                          },
                          child: Row(
                            children: [
                              SvgPicture.asset(
                                'assets/find_us_images/common/logout.svg',
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(
                                '로그아웃'.tr,
                                style: const TextStyle(
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          )),
                    ),
                    const Divider(),
                    SizedBox(
                      height: CommonGap.m,
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        '약관_및_정책'.tr,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: CommonGap.xs,
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: TextButton(
                          onPressed: () async {
                            Get.to(() => JoinMemberShip_1(false));
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '서비스_이용_약관'.tr,
                                style: const TextStyle(
                                  color: Colors.black,
                                ),
                              ),
                              Icon(
                                Icons.navigate_next,
                                color: Colors.grey,
                              )
                            ],
                          )),
                    ),
                    const Divider(),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: TextButton(
                          onPressed: () async {
                            Get.to(() => JoinMemberShip_2(false));
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '개인정보_처리_방침'.tr,
                                style: const TextStyle(
                                  color: Colors.black,
                                ),
                              ),
                              Icon(
                                Icons.navigate_next,
                                color: Colors.grey,
                              )
                            ],
                          )),
                    ),
                    const SizedBox(
                      height: CommonGap.s,
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Text(
                        '${controller.appVersion.value}',
                        style: const TextStyle(
                            color: Colors.black26,
                            fontSize: 12,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(
                      height: CommonGap.xs,
                    ),
                  ],
                )
              ],
            )),
      ),
    );
  }
}
