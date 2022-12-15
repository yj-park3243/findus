import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:findus/constants/common_sizes.dart';
import 'package:findus/constants/style.dart';
import 'package:findus/global_widgets/banner_ad.dart';
import 'package:findus/global_widgets/circle_profile_small.dart';
import 'package:findus/modules/app/app.dart';
import 'package:findus/modules/board/board_controller.dart' hide Options;
import 'package:findus/modules/work/commonWidgets/work_map.dart';
import 'package:findus/modules/work/work_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../helper/show_toast.dart';

class WorkDetail extends GetView<WorkController> {
  final int? id;

  const WorkDetail(this.id);

  @override
  Widget build(BuildContext context) {
    BoardController boardController = Get.put(BoardController());
    final FirebaseAuth auth = FirebaseAuth.instance;
    final FirebaseAuth fire = FirebaseAuth.instance;
    var format = NumberFormat('###,###,###,###');

    return Obx(() => Scaffold(
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
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(CommonGap.m)),
                      onSelected: (value) {
                        controller.onMenuItemSelected(value as int, context);
                      },
                      itemBuilder: (ctx) => [
                        boardController.buildPopupMenuItem(
                            '편집'.tr, EvaIcons.editOutline, Options.edit.index),
                        boardController.buildPopupMenuItem('삭제'.tr,
                            EvaIcons.trash2Outline, Options.delete.index),
                      ],
                    ),
                  )),
              Visibility(
                visible: fire.currentUser!.uid !=
                    controller.work.value?.authToken,
                child: PopupMenuButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(CommonGap.m)),
                  onSelected: (value) {
                    controller.onMenuItemSelected(value as int, context);
                  },
                  itemBuilder: (ctx) => [
                    boardController.buildPopupMenuItem(
                        '사용자_차단'.tr, Icons.block, Options.block.index),
                  ],
                ),
              )
            ],
          ),
          body: Stack(
            children: [
              Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Expanded(
                        child: ListView(
                          shrinkWrap: true,
                          keyboardDismissBehavior:
                              ScrollViewKeyboardDismissBehavior.onDrag,
                          children: [
                            Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                controller.work.value?.subject ?? '',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 20),
                              ),
                            ),
                            const SizedBox(
                              height: CommonGap.xxs,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          color: Colors.white),
                                      child: InkWell(
                                        onTap: () {
                                          if (controller
                                                  .work.value?.profile_url !=
                                              null) {
                                            Get.to(() => Scaffold(
                                                  backgroundColor: Colors.black,
                                                  appBar: AppBar(
                                                    leading: IconButton(
                                                      onPressed: () {
                                                        Get.back();
                                                      },
                                                      icon: const Icon(
                                                          Icons.close,
                                                          color: Colors.white),
                                                    ),
                                                  ),
                                                  body: ListView(
                                                    children: [
                                                      Image.network(
                                                        controller.work.value
                                                                ?.profile_url ??
                                                            '',
                                                        fit: BoxFit.fill,
                                                      ),
                                                    ],
                                                  ),
                                                ));
                                          }
                                        },
                                        child: CircleProfileSmall(
                                            controller.work.value?.profile_url),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: CommonGap.xxs,
                                    ),
                                    Container(
                                      color: Colors.white,
                                      child: Row(
                                        children: [
                                          Text(
                                            controller
                                                    .work.value?.userNickname ??
                                                '',
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 10),
                                          ),
                                          const SizedBox(
                                            width: 2,
                                          ),
                                          Text(
                                            '${controller.work.value?.createDate}' ??
                                                '',
                                            style:
                                                const TextStyle(fontSize: 10),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    SvgPicture.asset(
                                        'assets/find_us_images/common/eye-solid.svg',
                                        height: 12,
                                        color: HexColor('#AAAAAA')),
                                    const SizedBox(
                                      width: CommonGap.xxxs,
                                    ),
                                    Text(
                                      '${controller.work.value?.views}',
                                      style: const TextStyle(
                                          fontSize: 10,
                                          color: Colors.grey,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: CommonGap.m,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Column(
                                  children: [
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Container(
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                color: Colors.grey[300]!),
                                            borderRadius:
                                                BorderRadius.circular(100),
                                            color: Colors.pinkAccent),
                                        child: Padding(
                                          padding: const EdgeInsets.all(14),
                                          child: Text(
                                            "일당".tr,
                                            style: const TextStyle(
                                                fontSize: 12,
                                                color: Colors.white,
                                                fontFamily: 'SF-Pro-Bold'),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: CommonGap.xxs,
                                    ),
                                    Text(
                                      '${controller.work.value?.workPay != null ? format.format(controller.work.value?.workPay) : ''} ${'원'.tr}',
                                      style: const TextStyle(
                                          color: Colors.pinkAccent,
                                          fontSize: 12,
                                          fontFamily: 'SF-Pro-Bold',
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Colors.grey[300]!),
                                        borderRadius:
                                            BorderRadius.circular(100),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(14),
                                        child: Text(
                                          "업종".tr,
                                          style: const TextStyle(
                                              fontSize: 12,
                                              color: Colors.blueAccent,
                                              fontFamily: 'SF-Pro-Bold',
                                              fontWeight: FontWeight.bold
                                              // fontStyle: FontStyle.italic,
                                              ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: CommonGap.xxs,
                                    ),
                                    Text(
                                      '${controller.work.value?.workCategoryName}',
                                      style: const TextStyle(
                                          color: Colors.blueAccent,
                                          fontSize: 12,
                                          fontFamily: 'SF-Pro-Bold',
                                          fontWeight: FontWeight.bold
                                          // fontStyle: FontStyle.italic,
                                          ),
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Colors.grey[300]!),
                                        borderRadius:
                                            BorderRadius.circular(100),
                                      ),
                                      child: const Padding(
                                          padding: EdgeInsets.all(14),
                                          child: Icon(
                                            EvaIcons.clockOutline,
                                            color: Colors.redAccent,
                                            size: 16,
                                          )),
                                    ),
                                    const SizedBox(
                                      height: CommonGap.xxs,
                                    ),
                                    Text(
                                      '[${(controller.work.value?.isEnd ?? false) ? 'D${controller.work.value?.dDay ?? ''}' : '마감'.tr}]',
                                      style: const TextStyle(
                                          color: Colors.redAccent,
                                          fontSize: 12,
                                          fontFamily: 'SF-Pro-Bold',
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: CommonGap.s,
                            ),
                            SizedBox(
                              height: Get.height / 10,
                              width: Get.width,
                              child: const Padding(
                                padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                                child: Center(child: BannerAdWidget()),
                              ),
                            ),
                            const SizedBox(
                              height: CommonGap.s,
                            ),
                            Column(
                              children: [
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        border: Border.all(color: Colors.grey)),
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.all(CommonGap.xxxs),
                                      child: Text(
                                        "근무지역".tr,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontFamily: 'SF-Pro-Heavy',
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Row(
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: CommonGap.xxxs),
                                              child: Text(
                                                '${controller.work.value?.regionName}',
                                                style: const TextStyle(
                                                    fontSize: 14,
                                                    fontFamily: 'SF-Pro-Regular'
                                                    // fontStyle: FontStyle.italic,
                                                    ),
                                              ),
                                            ),
                                            TextButton(
                                                onPressed: () {
                                                  Get.to(() => WorkMap());
                                                },
                                                child: Text(
                                                  '지도로보기'.tr,
                                                  style: const TextStyle(
                                                      fontSize: 14,
                                                      decoration: TextDecoration
                                                          .underline,
                                                      color: Colors.blueAccent,
                                                      fontFamily: 'SF-Pro-Bold',
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ))
                                          ],
                                        ),
                                        SizedBox(
                                          width: Get.width * 85 / 100,
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                left: CommonGap.xxxs),
                                            child: RichText(
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              strutStyle: const StrutStyle(
                                                  fontSize: 14.0),
                                              text: TextSpan(
                                                style: const TextStyle(
                                                    color: Colors.black),
                                                text:
                                                    '${controller.work.value?.workAddr1_ko}'
                                                    ' ${controller.work.value?.workAddr2_ko}',
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: CommonGap.xs,
                                        ),
                                        SizedBox(
                                          width: Get.width * 85 / 100,
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                left: CommonGap.xxxs),
                                            child: RichText(
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              strutStyle: const StrutStyle(
                                                  fontSize: 14.0),
                                              text: TextSpan(
                                                style: const TextStyle(
                                                    color: Colors.black),
                                                text:
                                                    '${controller.work.value?.workAddr1_en}'
                                                    ' ${controller.work.value?.workAddr2_en}',
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: CommonGap.m,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const Divider(),
                            Column(
                              children: [
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Padding(
                                    padding: const EdgeInsets.all(2),
                                    child: Container(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          border:
                                              Border.all(color: Colors.grey)),
                                      child: Padding(
                                        padding: const EdgeInsets.all(
                                            CommonGap.xxxs),
                                        child: Text(
                                          "연락처".tr,
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontFamily: 'SF-Pro-Heavy',
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: CommonGap.xxxs),
                                            child: Text(
                                              '${controller.work.value?.workPhone.toString().substring(0, 8)}-****',
                                              style: const TextStyle(
                                                  fontSize: 14,
                                                  fontFamily: 'SF-Pro-Regular'
                                                  // fontStyle: FontStyle.italic,
                                                  ),
                                            ),
                                          ),
                                          const SizedBox(
                                            width: CommonGap.xxs,
                                          ),
                                          SvgPicture.asset(
                                              'assets/find_us_images/common/copy.svg'),
                                          const SizedBox(
                                            width: CommonGap.xxxs,
                                          ),
                                          Text(
                                            '복사'.tr,
                                            style: const TextStyle(
                                                color: Colors.blueAccent),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        width: CommonGap.xxs,
                                      ),
                                      OutlinedButton(
                                        style: OutlinedButton.styleFrom(
                                          side: const BorderSide(
                                              color: Colors.white),
                                        ),
                                        onPressed: () async {
                                          Clipboard.setData(ClipboardData(
                                              text:
                                                  '${controller.work.value?.workPhone.toString()}'));
                                          //Get.snackbar('알림'.tr, '복사_완료'.tr, backgroundColor: Colors.white, margin: EdgeInsets.only(top: 5) );
                                          showToast(context, '복사_완료'.tr);
                                          // String message = "";
                                          // List<String> recipents = [(controller.work.value?.workPhone?? '').replaceAll("-", '')];
                                          //
                                          // await sendSMS(message: message, recipients: recipents, sendDirect: false)
                                          //     .catchError((onError) {
                                          //   print(onError);
                                          // });
                                        },
                                        child: Row(
                                          children: [

                                          ],
                                        ),
                                      ),
                                      OutlinedButton(
                                          onPressed: () {
                                            FlutterPhoneDirectCaller.callNumber(
                                              '${controller.work.value?.workPhone}',
                                            );
                                          },
                                          child: Row(
                                            children: [
                                              const Icon(
                                                EvaIcons.phone,
                                                color: Colors.grey,
                                                size: 14,
                                              ),
                                              const SizedBox(
                                                width: CommonGap.xxxs,
                                              ),
                                              Text(
                                                '전화걸기'.tr,
                                                style: const TextStyle(
                                                    fontSize: 10,
                                                    color: Colors.grey,
                                                    fontFamily: 'SF-Pro-Bold',
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ],
                                          ))
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const Divider(),
                            const SizedBox(
                              height: CommonGap.xs,
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(2),
                                    child: Container(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          border:
                                              Border.all(color: Colors.grey)),
                                      child: Padding(
                                        padding: const EdgeInsets.all(
                                            CommonGap.xxxs),
                                        child: Text(
                                          '상세요강'.tr,
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontFamily: 'SF-Pro-Heavy',
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: CommonGap.xs,
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: CommonGap.xxxs),
                              child: Container(
                                  color: Colors.white,
                                  child: Text(
                                      controller.work.value?.content ?? '')),
                            ),
                            const SizedBox(
                              height: CommonGap.xxxxl,
                            ),
                            InkWell(
                              onTap: () {
                                boardController.boardReport(
                                    3, controller.work.value?.workId as int);
                              },
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(left: CommonGap.xxxs),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    const Icon(
                                      EvaIcons.alertTriangle,
                                      size: 15,
                                      color: Colors.redAccent,
                                    ),
                                    const SizedBox(
                                      width: CommonGap.xxxs,
                                    ),
                                    Text(
                                      '허위글_신고하기'.tr,
                                      style: const TextStyle(
                                          color: Colors.redAccent,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: CommonGap.m,
                            )
                          ],
                        ),
                      ),
                    ],
                  )),
              Visibility(
                  visible: controller.work.value?.authToken ==
                          auth.currentUser?.uid &&
                      (controller.work.value?.dDay ?? 0) < 0,
                  child: Padding(
                    padding: const EdgeInsets.all(CommonGap.m),
                    child: Align(
                      alignment: Alignment.bottomRight,
                      child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                              backgroundColor: Colors.white),
                          onPressed: () {
                            controller.recruitClose(controller.work.value!);
                            Get.back();
                            Get.snackbar('알림', '게시글이 마감되었습니다'); //TODO: 몽골어 번역
                          },
                          child: Text(
                            '마감하기'.tr,
                            style: const TextStyle(
                                fontFamily: 'SF-Pro-Bold',
                                fontWeight: FontWeight.bold),
                          )),
                    ),
                  )),
            ],
          ),
        ));
  }
}
