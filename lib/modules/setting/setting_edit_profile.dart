import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:findus/constants/common_sizes.dart';
import 'package:findus/constants/style.dart';
import 'package:findus/global_widgets/circle_profile.dart';
import 'package:findus/helper/permission_request.dart';
import 'package:findus/modules/setting/setting_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:image_picker/image_picker.dart';
import '../app/app.dart';

class SettingEditProfile extends GetView<SettingController> {
  SettingEditProfile({Key? key}) : super(key: key);
  final setting = Get.lazyPut(() => SettingController());

  @override
  Widget build(BuildContext context) {
    controller.nickName.text = controller.auth.user.value?.user_nickname ?? '';
    controller.context = context;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('프로필'.tr, style: tapMenuTitleTextStyle),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: CommonGap.m),
        child: Obx(() => ListView(
              shrinkWrap: true,
              children: [
                Column(
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        InkWell(
                            onTap: () {
                              if (controller.auth.user.value!.profile_url !=
                                  null) {
                                Get.to(() => Scaffold(
                                      backgroundColor: Colors.black,
                                      appBar: AppBar(
                                        leading: IconButton(
                                          onPressed: () {
                                            Get.back();
                                          },
                                          icon: const Icon(Icons.close,
                                              color: Colors.white),
                                        ),
                                      ),
                                      body: ListView(
                                        children: [
                                          Image.network(
                                            controller.auth.user.value
                                                    ?.profile_url ??
                                                '',
                                            fit: BoxFit.fill,
                                          ),
                                        ],
                                      ),
                                    ));
                              }
                            },
                            child: CircleProfile(
                                controller.auth.user.value?.profile_url)),
                        SizedBox(
                          height: 30,
                          child: controller.isLoadingProfile.value
                              ? const Center(
                                  child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ))
                              : ElevatedButton(
                                  child: Text(
                                    '편집'.tr,
                                    style: const TextStyle(
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'SF-Pro-Bold'),
                                  ),
                                  onPressed: () async {
                                    // controller.fs.logSelectedContent(
                                    //     contentType: '버튼',
                                    //     itemId: '/my_info_01');
                                    await showMaterialModalBottomSheet(
                                        expand: false,
                                        shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(
                                                    CommonRadius.m),
                                                topRight: Radius.circular(
                                                    CommonRadius.m))),
                                        // barrierColor: Colors.black12,
                                        context: context,
                                        builder: (context) {
                                          return Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: CommonGap.xxxxl,
                                                top: CommonGap.m),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              children: [
                                                Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    SizedBox(
                                                      width: 70,
                                                      height: 70,
                                                      child: IconButton(
                                                          onPressed: () async {
                                                            permissionRequest(
                                                                context:
                                                                    context,
                                                                permission:
                                                                    Permission
                                                                        .photos,
                                                                callback:
                                                                    () async {
                                                                  Get.back();
                                                                  final XFile?
                                                                      image =
                                                                      await controller
                                                                          .picker
                                                                          .pickImage(
                                                                              source: ImageSource.gallery);
                                                                  if (image !=
                                                                      null)
                                                                    controller.profileUpload(
                                                                        context,
                                                                        image);
                                                                });
                                                          },
                                                          icon: const Icon(
                                                            Icons
                                                                .image_outlined,
                                                            size: 50,
                                                          )),
                                                    ),
                                                    Text('앨범에서_선택'.tr),
                                                  ],
                                                ),
                                                Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    SizedBox(
                                                      width: 70,
                                                      height: 70,
                                                      child: IconButton(
                                                          onPressed: () async {
                                                            permissionRequest(
                                                                context:
                                                                    context,
                                                                permission:
                                                                    Permission
                                                                        .camera,
                                                                callback:
                                                                    () async {
                                                                  Get.back();

                                                                  final XFile?
                                                                      image =
                                                                      await controller
                                                                          .picker
                                                                          .pickImage(
                                                                              source: ImageSource.camera);
                                                                  if (image !=
                                                                      null) {
                                                                    controller.profileUpload(
                                                                        context,
                                                                        image);
                                                                  }
                                                                });
                                                          },
                                                          icon: const Icon(
                                                            Icons
                                                                .photo_camera_outlined,
                                                            size: 50,
                                                          )),
                                                    ),
                                                    Text('사진촬영'.tr),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          );
                                        });
                                  },
                                ),
                        ),
                        SizedBox(
                          height: CommonGap.m,
                        ),
                        Container(
                          height: 5,
                          color: HexColor('#d3d3d33'),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: CommonGap.xxl,
                    ),
                    Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          '닉네임'.tr,
                          style:
                              TextStyle(fontSize: 12, color: Colors.grey[700]),
                        )),
                    _buildRow(
                      modify: true,
                      enabled: controller.enabledNickName.value,
                      textEditingController: controller.nickName,
                      saveFuntion: () => controller.submitNickName(context),
                      editFuntion: () => controller.editNickName(),
                    ),
                    const SizedBox(
                      height: CommonGap.xxl,
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        '이메일'.tr,
                        style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                      ),
                    ),
                    const SizedBox(
                      height: CommonGap.xs,
                    ),
                    Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          '${controller.auth.user.value?.email}',
                          style: TextStyle(fontSize: 14),
                        )),
                    Divider(
                      thickness: 1.5,
                    ),
                  ],
                ),
              ],
            )),
      ),
    );
  }

  Widget _buildRow({
    // required String title,
    required bool modify,
    required bool enabled,
    required TextEditingController textEditingController,
    required VoidCallback saveFuntion,
    required VoidCallback editFuntion,
  }) {
    final children = [
      SizedBox(
        child: SizedBox(),
      ),
      Expanded(
          child: SizedBox(
        height: 30,
        child: TextFormField(
          style: TextStyle(fontSize: 14),
          enabled: enabled,
          controller: textEditingController,
          inputFormatters: [
            LengthLimitingTextInputFormatter(10),
            FilteringTextInputFormatter.deny(RegExp(r'[ ]')),
          ],
          decoration: const InputDecoration(
            enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey)),
            focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey)),
          ),
        ),
      )),
    ];
    if (modify && !enabled) {
      children.add(TextButton(
          onPressed: editFuntion,
          child: const Icon(
            Icons.edit,
            color: Colors.blueAccent,
          )));
    }
    if (enabled) {
      children.add(TextButton(
          onPressed: saveFuntion,
          child: Text(
            '저장_설정'.tr,
            style: TextStyle(color: Colors.blueAccent, fontSize: 14),
          )));
    }
    return Container(
      height: 40,
      child: Row(children: children),
    );
  }
}
