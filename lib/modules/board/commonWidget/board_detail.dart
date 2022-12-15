import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:findus/constants/common_sizes.dart';
import 'package:findus/global_widgets/banner_ad.dart';
import 'package:findus/modules/board/board_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:like_button/like_button.dart';
import '../../../constants/style.dart';
import '../../../global_widgets/circle_profile_small.dart';
import '../../app/app.dart';

class BoardDetail extends GetView<BoardController> {
  var refreshKey = GlobalKey<RefreshIndicatorState>();

  @override
  Widget build(BuildContext context) {
    final comment = TextEditingController();
    BoardController boardController = Get.put(BoardController());
    final FirebaseAuth fire = FirebaseAuth.instance;

    return Obx(
      () => Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('자유_게시판'.tr, style: tapMenuTitleTextStyle),
          actions: [
            Visibility(
              visible: fire.currentUser!.uid ==
                  boardController.board.value?.auth_token,
              child: PopupMenuButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(CommonGap.m)),
                onSelected: (value) {
                  controller.onMenuItemSelected(value as int, context);
                },
                itemBuilder: (ctx) => [
                  controller.buildPopupMenuItem(
                      '편집'.tr, EvaIcons.editOutline, Options.edit.index),
                  controller.buildPopupMenuItem(
                      '삭제'.tr, EvaIcons.trash2Outline, Options.delete.index),
                ],
              ),
            ),

            Visibility(
              visible: fire.currentUser!.uid !=
                  boardController.board.value?.auth_token,
              child: PopupMenuButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(CommonGap.m)),
                onSelected: (value) {
                  controller.onMenuItemSelected(value as int, context);
                },
                itemBuilder: (ctx) => [
                  controller.buildPopupMenuItem(
                      '사용자_차단'.tr, Icons.block, Options.block.index),
                ],
              ),
            )
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Expanded(
                child: RefreshIndicator(
                  key: refreshKey,
                  onRefresh: () async {
                    controller.boardPage = 1;
                    await controller.getBoardDetail(
                        controller.board.value?.board_id as int,
                        controller.selectedBoardCategory.value);
                  },
                  child: ListView(
                    controller: controller.scrollController,
                    shrinkWrap: true,
                    keyboardDismissBehavior:
                        ScrollViewKeyboardDismissBehavior.onDrag,
                    children: [
                      Column(
                        children: [
                          Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              boardController.board.value?.subject ?? '',
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      if (controller.board.value?.profile_url !=
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
                                                    controller.board.value
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
                                        controller.board.value?.profile_url),
                                  ),
                                  const SizedBox(
                                    width: CommonGap.xxs,
                                  ),
                                  Text(
                                    controller.board.value?.author ?? '',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 10),
                                  ),
                                  const SizedBox(
                                    width: 2,
                                  ),
                                  Text(
                                    '${controller.board.value?.create_date}' ??
                                        '',
                                    style: const TextStyle(fontSize: 10),
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
                                    '${controller.board.value?.views ?? 0}',
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
                            height: 4,
                          ),
                        ],
                      ),
                      const Divider(),
                      Padding(
                        padding:
                            const EdgeInsets.symmetric(vertical: CommonGap.m),
                        child: Text(controller.board.value?.content ?? ''),
                      ),
                      const SizedBox(height: 50),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          LikeButton(
                            animationDuration:
                                const Duration(milliseconds: 500),
                            likeCountAnimationDuration:
                                const Duration(milliseconds: 200),
                            size: 30,
                            circleColor: const CircleColor(
                                start: Color(0xfff0ddff),
                                end: Color(0xffffb5e5)),
                            bubblesColor: const BubblesColor(
                              dotPrimaryColor: Color(0xffffb5e5),
                              dotSecondaryColor: Color(0xffff99cc),
                            ),
                            isLiked: controller.board.value?.is_like == 1,
                            onTap: (bool isLiked) {
                              return controller.saveBoardLike(
                                  controller.board.value?.board_id as int,
                                  isLiked);
                            },
                            likeBuilder: (bool isLiked) {
                              return Icon(
                                isLiked
                                    ? EvaIcons.heart
                                    : EvaIcons.heartOutline,
                                color: isLiked ? Colors.red : Colors.grey,
                                size: 30,
                              );
                            },
                            likeCount: controller.board.value?.recommend_cnt,
                            countBuilder:
                                (int? count, bool isLiked, String text) {
                              var color = isLiked ? Colors.black : Colors.black;
                              Widget result;
                              if (count == 0) {
                                result = Text(
                                  "0",
                                  style: TextStyle(
                                      color: color,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold),
                                );
                              } else {
                                result = Text(
                                  text,
                                  style: TextStyle(
                                      color: color,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold),
                                );
                              }
                              return result;
                            },
                          ),
                          Row(
                            children: [
                              const Icon(
                                Icons.comment_outlined,
                                size: 26,
                                color: Colors.grey,
                              ),
                              const SizedBox(
                                width: CommonGap.xxxs,
                              ),
                              Text(
                                '${controller.board.value?.comment_cnt ?? 0}',
                                style: const TextStyle(
                                    fontSize: 10,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          InkWell(
                            onTap: () {
                              controller.boardReport(
                                  1, controller.board.value?.board_id as int);
                            },
                            child: Row(
                              children: [
                                const Icon(
                                  EvaIcons.alertCircle,
                                  size: 26,
                                  color: Colors.redAccent,
                                ),
                                const SizedBox(
                                  width: CommonGap.xxxs,
                                ),
                                Text(
                                  '신고'.tr,
                                  style: const TextStyle(
                                      fontSize: 10,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: CommonGap.s,
                      ),
                      SizedBox(
                        height: Get.height / 10,
                        width: Get.width,
                        child: const Center(child: BannerAdWidget()),
                      ),
                      const SizedBox(
                        height: CommonGap.s,
                      ),
                      const Divider(),
                      const SizedBox(
                        height: CommonGap.xxxxs,
                      ),
                      ...boardController.comment.map((e) => Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(
                                height: CommonGap.xxxs,
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      InkWell(
                                          onTap: () {
                                            if (e.profile_url != null) {
                                              Get.to(() => Scaffold(
                                                    backgroundColor:
                                                        Colors.black,
                                                    appBar: AppBar(
                                                      leading: IconButton(
                                                        onPressed: () {
                                                          Get.back();
                                                        },
                                                        icon: const Icon(
                                                            Icons.close,
                                                            color:
                                                                Colors.white),
                                                      ),
                                                    ),
                                                    body: ListView(
                                                      children: [
                                                        Image.network(
                                                          e.profile_url ?? '',
                                                          fit: BoxFit.fill,
                                                        ),
                                                      ],
                                                    ),
                                                  ));
                                            }
                                          },
                                          child: CircleProfileSmall(
                                              e.profile_url)),
                                      const SizedBox(
                                        width: CommonGap.xxs,
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const SizedBox(
                                            height: CommonGap.xxs,
                                          ),
                                          Text(
                                            e.nick_name ?? 'Anonymous',
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12),
                                          ),
                                          const SizedBox(
                                            height: CommonGap.xxs,
                                          ),
                                          Text(
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: null,
                                            '${e.comment.toString()}',
                                            style:
                                                const TextStyle(fontSize: 12),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  if (fire.currentUser!.uid == e.auth_token &&
                                      e.use_yn == true)
                                    DropdownButton<String>(
                                      borderRadius:
                                          BorderRadius.circular(CommonGap.m),
                                      underline: const SizedBox(),
                                      icon: const Icon(
                                          EvaIcons.moreHorizontalOutline),
                                      items: [
                                        DropdownMenuItem(
                                          value: "삭제",
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: <Widget>[
                                              const Icon(
                                                EvaIcons.trash2Outline,
                                                size: 20,
                                              ),
                                              const SizedBox(
                                                  width: CommonGap.xxs),
                                              Text(
                                                "삭제".tr,
                                                style: const TextStyle(
                                                    fontSize: 12,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                      onChanged: (value) {
                                        if (value == '삭제') {
                                          controller.commentErase(
                                              controller.board.value?.board_id
                                                  as int,
                                              e.comment_id as int);
                                        }
                                      },
                                    )
                                  else
                                    DropdownButton<String>(
                                      borderRadius:
                                          BorderRadius.circular(CommonGap.m),
                                      underline: const SizedBox(),
                                      icon: const Icon(
                                          EvaIcons.moreHorizontalOutline),
                                      items: [
                                        DropdownMenuItem(
                                          value: "차단",
                                          child: Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.center,
                                            children: <Widget>[
                                              const Icon(
                                                Icons.block,
                                                size: 20,
                                              ),
                                              const SizedBox(
                                                  width: CommonGap.xxs),
                                              Text(
                                                "사용자_차단".tr,
                                                style: const TextStyle(
                                                    fontSize: 12,
                                                    fontWeight:
                                                    FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                        ),
                                        DropdownMenuItem(
                                          value: "신고",
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: <Widget>[
                                              const Icon(
                                                EvaIcons.alertCircle,
                                                color: Colors.redAccent,
                                                size: 20,
                                              ),
                                              const SizedBox(
                                                  width: CommonGap.xxs),
                                              Text(
                                                "신고".tr,
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                      onChanged: (value) {
                                        if (value == '신고') {
                                          controller.boardReport(
                                              2,
                                              e.comment_id
                                                  as int);
                                        }else if(value == '차단'){
                                          controller.banUserDialog('${e.auth_token}');
                                        }
                                      },
                                    ),
                                ],
                              ),
                              const SizedBox(
                                height: CommonGap.xxs,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        e.create_date.toString(),
                                        style: const TextStyle(
                                            fontSize: 8, color: Colors.grey),
                                      ),
                                    ],
                                  ),
                                  LikeButton(
                                    animationDuration:
                                        const Duration(milliseconds: 500),
                                    likeCountAnimationDuration:
                                        const Duration(milliseconds: 200),
                                    size: 20,
                                    circleColor: const CircleColor(
                                        start: Colors.blueAccent,
                                        end: Color(0xff0099cc)),
                                    bubblesColor: const BubblesColor(
                                      dotPrimaryColor: Color(0xff33b5e5),
                                      dotSecondaryColor: Color(0xff0099cc),
                                    ),
                                    isLiked: e.is_like == 1,
                                    onTap: (bool isLiked) {
                                      return controller.saveCommentLike(
                                          controller.board.value?.board_id
                                              as int,
                                          controller.board.value
                                              ?.board_category_id as int,
                                          e.comment_id as int,
                                          isLiked);
                                    },
                                    likeBuilder: (bool isLiked) {
                                      return Icon(
                                        isLiked
                                            ? Icons.thumb_up
                                            : Icons.thumb_up_alt_outlined,
                                        color: isLiked
                                            ? Colors.blueAccent
                                            : Colors.grey,
                                        size: 20,
                                      );
                                    },
                                    likeCount: e.comment_like_cnt,
                                    countBuilder: (int? count, bool isLiked,
                                        String text) {
                                      var color =
                                          isLiked ? Colors.black : Colors.black;
                                      Widget result;
                                      if (count == 0) {
                                        result = Text(
                                          "0",
                                          style: TextStyle(
                                              color: color,
                                              fontSize: 10,
                                              fontWeight: FontWeight.bold),
                                        );
                                      } else
                                        result = Text(
                                          text,
                                          style: TextStyle(
                                              color: color,
                                              fontSize: 10,
                                              fontWeight: FontWeight.bold),
                                        );
                                      return result;
                                    },
                                  ),
                                ],
                              ),
                              const Divider(),
                            ],
                          )),
                      const SizedBox(
                        height: CommonGap.xs,
                      ),
                    ],
                  ),
                ),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    child: SizedBox(
                      child: TextFormField(
                        style: const TextStyle(fontSize: 12),
                        controller: comment,
                        maxLength: 25,
                        maxLines: null,
                        decoration: InputDecoration(
                          hintText: "댓글을_입력해주세요".tr,
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.black12),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.black12),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 8),
                    child: IconButton(
                        onPressed: () {
                          //Get.to(() => BoardUpdatePage());
                          controller.writeComment(-1, comment.text);
                          comment.text = '';
                        },
                        icon: const Icon(
                          // EvaIcons.arrowRightOutline,
                          Icons.comment,
                          color: Colors.blueAccent,
                          size: 30,
                        )),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
