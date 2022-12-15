import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:findus/constants/common_sizes.dart';
import 'package:findus/modules/board/board_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../../global_widgets/circle_profile_small.dart';
import '../../../model/board.dart';
import '../../app/app.dart';
import '../loadingWidget/board_detail_loading.dart';
import 'board_update.dart';

class BoardListNew extends GetView<BoardController> {
  @override
  Widget build(BuildContext context) {
    controller.context = context;
    var refreshKey = GlobalKey<RefreshIndicatorState>();
    return Obx(
      () => controller.boardList.isEmpty
          ? Column(
              children: [
                Expanded(
                  child: RefreshIndicator(
                    key: refreshKey,
                    onRefresh: () async {
                      controller.boardPage = 1;
                      await controller.getBoardList();
                    },
                    child: Stack(
                      children: [
                        Align(
                          alignment: Alignment.center,
                          child: Column(
                            children: [
                              SizedBox(height: Get.height / 4),
                              Icon(
                                EvaIcons.fileTextOutline,
                                size: 50,
                              ),
                              SizedBox(
                                height: CommonGap.m,
                              ),
                              Text(
                                '게시물이_없습니다'.tr,
                                style: TextStyle(fontFamily: 'SF-Pro-Semibold'),
                              ),
                            ],
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: Padding(
                            padding: const EdgeInsets.all(CommonGap.m),
                            child: FloatingActionButton(
                              heroTag: "boardNew",
                              onPressed: () {
                                Get.to(() => BoardUpdatePage());
                                controller.board.value = BoardModel();
                              },
                              child: Icon(Icons.add),
                              backgroundColor: Colors.blueAccent,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            )
          : Column(
              children: [
                Expanded(
                  child: RefreshIndicator(
                    key: refreshKey,
                    onRefresh: () async {
                      controller.boardPage = 1;
                      await controller.getBoardList();
                    },
                    child: Stack(
                      children: [
                        ListView.separated(
                          controller: controller.boardScrollController,
                          keyboardDismissBehavior:
                              ScrollViewKeyboardDismissBehavior.onDrag,
                          itemCount: controller.boardList.length,
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () {
                                controller.getBoardDetail(
                                    controller.boardList[index].board_id!,
                                    controller.selectedBoardCategory.value);
                                Get.to(() => BoardDetailLoading(
                                    controller.boardList[index].board_id));
                              },
                              child: ListTile(
                                title: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Align(
                                      alignment: Alignment.bottomLeft,
                                      child: Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            0, 10, 0, 0),
                                        child: Column(
                                          children: [
                                            Row(
                                              children: [
                                                CircleProfileSmall(controller
                                                    .boardList[index]
                                                    .profile_url),
                                                SizedBox(
                                                  width: CommonGap.xxs,
                                                ),
                                                Row(
                                                  children: [
                                                    Text(
                                                      "${controller.boardList[index].author}",
                                                      style: const TextStyle(
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.black,
                                                          fontFamily:
                                                              'SF-Pro-Regular'),
                                                    ),
                                                    SizedBox(
                                                      width: CommonGap.xxxs,
                                                    ),
                                                    Text(
                                                      "${controller.boardList[index].create_date}",
                                                      style: const TextStyle(
                                                          fontSize: 10,
                                                          color: Colors.grey,
                                                          fontFamily:
                                                              'SF-Pro-Regular'
                                                          // fontStyle: FontStyle.italic,
                                                          ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      height: CommonGap.s,
                                    ),
                                    Text(
                                      "${controller.boardList[index].subject}",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 18,
                                          color: Colors.black,
                                          fontFamily: 'SF-Pro-Regular'),
                                    ),
                                    SizedBox(
                                      height: CommonGap.xxxs,
                                    ),
                                    Text(
                                      controller.boardList[index].content ?? '',
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          fontWeight: FontWeight.w300,
                                          fontSize: 12,
                                          color: Colors.black54,
                                          fontFamily: 'SF-Pro-Regular'),
                                    ),
                                    SizedBox(
                                      height: CommonGap.s,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Row(
                                          children: [
                                            Icon(
                                              EvaIcons.heart,
                                              size: 20,
                                              color: Colors.redAccent,
                                            ),
                                            SizedBox(
                                              width: CommonGap.xxxs,
                                            ),
                                            Text(
                                              "${controller.boardList[index].recommend_cnt} ",
                                              style: const TextStyle(
                                                  fontSize: 10,
                                                  color: Colors.grey,
                                                  fontFamily: 'SF-Pro-Regular'
                                                  // fontStyle: FontStyle.italic,
                                                  ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Icon(Icons.comment, size: 18),
                                            SizedBox(
                                              width: CommonGap.xxxs,
                                            ),
                                            Text(
                                              '${controller.boardList[index].comment_cnt ?? 0}',
                                              style: TextStyle(
                                                  fontSize: 10,
                                                  color: Colors.grey,
                                                  fontFamily: 'SF-Pro-Regular'),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            SvgPicture.asset(
                                              'assets/find_us_images/common/eye-solid.svg',
                                              height: 16,
                                              width: 16,
                                              color: HexColor('#AAAAAA'),
                                            ),
                                            SizedBox(
                                              width: CommonGap.xxxs,
                                            ),
                                            Text(
                                              "${controller.boardList[index].views}",
                                              style: const TextStyle(
                                                  fontSize: 10,
                                                  color: Colors.grey,
                                                  fontFamily: 'SF-Pro-Regular'
                                                  // fontStyle: FontStyle.italic,
                                                  ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                          separatorBuilder: (BuildContext context, int index) =>
                              const Divider(),
                        ),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: Padding(
                            padding: const EdgeInsets.all(CommonGap.m),
                            child: FloatingActionButton(
                              heroTag: "boardNew2",
                              onPressed: () {
                                Get.to(() => BoardUpdatePage());
                                controller.board.value = BoardModel();
                              },
                              child: Icon(Icons.add),
                              backgroundColor: Colors.blueAccent,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
