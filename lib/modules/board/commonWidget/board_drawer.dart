import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:findus/modules/board/board_controller.dart';
import 'package:findus/modules/work/work_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../constants/common_sizes.dart';

class BoardDrawer extends StatelessWidget {
  final BoardController controller = Get.find();
  WorkController workController = Get.put(WorkController());

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Obx(() => ListView(
            shrinkWrap: true,
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            children: [
              Column(
                children: [
                  const SizedBox(
                    height: CommonGap.m,
                  ),
                  UserAccountsDrawerHeader(
                    accountName: Text(
                      "${controller.auth.user.value?.user_nickname}",
                      style: const TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                    accountEmail: Text(
                      '${controller.auth.user.value?.email}',
                      style: const TextStyle(color: Colors.grey, fontSize: 10),
                    ),
                    currentAccountPicture: CircleAvatar(
                        backgroundImage: NetworkImage(controller
                                .auth.user.value?.profile_url ??
                            'https://d1lxadfckgn2by.cloudfront.net/profile/reviewprofile.png')),
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(40),
                      bottomRight: Radius.circular(40),
                    )),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(CommonGap.s),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: InkWell(
                            onTap: () {
                              controller.enabled.value = true;
                              Navigator.pop(context);
                              controller.bestBoardPage = 1;
                              controller.boardPage = 1;
                              controller.selectedBoardCategory.value = 0;
                              controller.boardTitle.value = "내가_쓴_글".tr;
                              controller.getBoardList();
                              controller.getBestBoardList();
                            },
                            child: Text(
                              '내가_쓴_글'.tr,
                              style: const TextStyle(
                                  color: Colors.black, fontSize: 14),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(CommonGap.s),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: InkWell(
                            onTap: () {
                              controller.selectedBoardCategory.value = 3;
                              controller.boardTitle.value = "내가_쓴_공고".tr;
                              workController.workEnabled.value = true;
                              workController.my_work = 1;
                              workController.getWorkCategory();
                              Navigator.pop(context);
                            },
                            child: Text(
                              '내가_쓴_공고'.tr,
                              style: const TextStyle(
                                  color: Colors.black, fontSize: 14),
                            ),
                          ),
                        ),
                      ),
                      Divider()
                    ],
                  ),
                  ...controller.boardCategory.map((e) => ListTile(
                        title: Text(e.category_name),
                        onTap: () {
                          controller.selectedBoardCategory.value =
                              e.board_category_id;
                          controller.boardTitle.value = e.category_name;
                          if (e.board_category_id != 3) {
                            controller.bestBoardPage = 1;
                            controller.boardPage = 1;
                            controller.enabled.value = true;
                            controller.getBoardList();
                            controller.getBestBoardList();
                          } else {
                            workController.workEnabled.value = true;
                            workController.my_work = 0;
                            workController.page = 1;
                            workController.getWorkCategory();
                          }
                          Navigator.pop(context);
                        },
                      ))
                ],
              )
            ],
          )),
    );
  }
}
