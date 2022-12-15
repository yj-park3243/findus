import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:findus/constants/common_sizes.dart';
import 'package:findus/modules/setting/setting_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SettingBan extends GetView<SettingController> {
  const SettingBan({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('차단_목록'.tr),
      ),
      body: Obx(() => Column(
            children: [
              Expanded(
                child: controller.banUserList.isEmpty
                    ? Center(
                        child: Icon(
                        EvaIcons.personDeleteOutline,
                        size: 150,
                      ))
                    : Align(
                        alignment: Alignment.center,
                        child: Padding(
                          padding: const EdgeInsets.all(CommonGap.m),
                          child: ListView.builder(
                            itemCount: controller.banUserList == null
                                ? 0
                                : controller.banUserList?.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Padding(
                                padding:
                                    const EdgeInsets.only(right: 8.0, left: 8),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                            '${controller.banUserList?[index].userNickname}'),
                                        OutlinedButton(
                                            onPressed: () {
                                              controller.deleteBan(controller
                                                      .banUserList?[index]
                                                      .banId ??
                                                  0);
                                            },
                                            child: Text(
                                              '차단_해제'.tr,
                                              style: TextStyle(fontSize: 14),
                                            )),
                                      ],
                                    ),
                                    Divider(
                                      thickness: 1,
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ),
              ),
            ],
          )),
    );
  }
}
