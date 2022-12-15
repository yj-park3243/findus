import 'package:findus/modules/board/board_controller.dart' hide Options;
import 'package:findus/modules/work/commonWidgets/work_detail.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../constants/common_sizes.dart';
import '../../../../constants/style.dart';
import '../../../../global_widgets/circle_profile_small.dart';
import '../../app/app.dart';
import '../work_controller.dart';

class WorkDetailLoding extends GetView<WorkController> {
  final int? id;

  const WorkDetailLoding(this.id);

  @override
  Widget build(BuildContext context) {
    BoardController baordController = Get.put(BoardController());
    final FirebaseAuth fire = FirebaseAuth.instance;

    return Obx(
      () => controller.workDetailEnabled.value
          ? Scaffold(
              appBar: AppBar(
                centerTitle: true,
                title: Text(
                  '채용정보'.tr,
                  style: tapMenuTitleTextStyle,
                  textAlign: TextAlign.center,
                ),
                actions: [
                  Obx(() => Visibility(
                        visible: fire.currentUser!.uid ==
                            controller.work.value?.authToken,
                        child: PopupMenuButton(
                          onSelected: (value) {
                            controller.onMenuItemSelected(
                                value as int, context);
                          },
                          itemBuilder: (ctx) => [
                            baordController.buildPopupMenuItem(
                                '편집', Icons.edit, Options.edit.index),
                            baordController.buildPopupMenuItem(
                                '삭제', Icons.delete, Options.delete.index),
                          ],
                        ),
                      ))
                ],
              ),
              body: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: Column(
                      children: [
                        Expanded(
                          child: ListView(
                            controller: controller.workScrollController,
                            shrinkWrap: true,
                            keyboardDismissBehavior:
                                ScrollViewKeyboardDismissBehavior.onDrag,
                            children: [
                              Column(
                                children: [
                                  Align(
                                    alignment: Alignment.topLeft,
                                    child: Container(
                                      width: Get.width / 1.1,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(
                                            color: Colors.white, width: 3),
                                      ),
                                      child: Text(
                                        overflow: TextOverflow.ellipsis,
                                        controller.work.value?.subject ?? '',
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                                color: Colors.white),
                                            child: CircleProfileSmall(controller
                                                .work.value?.profile_url),
                                          ),
                                          SizedBox(
                                            width: CommonGap.xxxs,
                                          ),
                                          Container(
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              border: Border.all(
                                                  color: Colors.white,
                                                  width: 3),
                                            ),
                                            child: Row(
                                              children: [
                                                Text(
                                                  controller.work.value
                                                          ?.userNickname ??
                                                      '',
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 10),
                                                ),
                                                SizedBox(
                                                  width: 2,
                                                ),
                                                Text(
                                                  '${controller.work.value?.createDate}' ??
                                                      '',
                                                  style: const TextStyle(
                                                      fontSize: 10),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      Container(
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          border: Border.all(
                                              color: Colors.white, width: 3),
                                        ),
                                        child: Row(
                                          children: [
                                            SvgPicture.asset(
                                                'assets/find_us_images/common/eye-solid.svg',
                                                height: 12,
                                                color: HexColor('#AAAAAA')),
                                            SizedBox(
                                              width: CommonGap.xxxs,
                                            ),
                                            Text(
                                              '${controller.work.value?.views ?? 0}',
                                              style: TextStyle(
                                                  fontSize: 10,
                                                  color: Colors.grey,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 4,
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: CommonGap.m,
                              ),
                              Container(
                                  height: 0.5,
                                  color: Colors.white,
                                  child: const Divider()),
                              Container(
                                  height: 0.5,
                                  color: Colors.white,
                                  child: const Divider()),
                              SizedBox(
                                height: CommonGap.m,
                              ),
                              Container(
                                height: 20,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  border:
                                      Border.all(color: Colors.white, width: 3),
                                ),
                              ),
                              SizedBox(
                                height: CommonGap.s,
                              ),
                              Container(
                                height: 20,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  border:
                                      Border.all(color: Colors.white, width: 3),
                                ),
                              ),
                              SizedBox(
                                height: CommonGap.s,
                              ),
                              Container(
                                height: 20,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  border:
                                      Border.all(color: Colors.white, width: 3),
                                ),
                              ),
                              SizedBox(
                                height: CommonGap.s,
                              ),
                              Container(
                                height: 20,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  border:
                                      Border.all(color: Colors.white, width: 3),
                                ),
                              ),
                              SizedBox(
                                height: CommonGap.s,
                              ),
                              Container(
                                height: 20,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  border:
                                      Border.all(color: Colors.white, width: 3),
                                ),
                              ),
                              SizedBox(
                                height: CommonGap.s,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(right: 100),
                                child: Container(
                                  height: 20,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                        color: Colors.white, width: 3),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: CommonGap.s,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(right: 200),
                                child: Container(
                                  height: 20,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                        color: Colors.white, width: 3),
                                  ),
                                ),
                              ),
                              const Divider(),
                              SizedBox(
                                height: CommonGap.xxxxs,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )),
            )
          : WorkDetail(id),
    );
  }
}
