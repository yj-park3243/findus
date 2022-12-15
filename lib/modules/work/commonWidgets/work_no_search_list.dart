import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:findus/constants/common_sizes.dart';
import 'package:findus/model/work/Work_model.dart';
import 'package:findus/modules/board/board_controller.dart';
import 'package:findus/modules/work/work_controller.dart';
import 'package:findus/modules/work/commonWidgets/work_update.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WorkListNoSearhList extends GetView<WorkController> {
  var refreshKey = GlobalKey<RefreshIndicatorState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  BoardController boardController = Get.put(BoardController());

  @override
  Widget build(BuildContext context) {
    controller.context = context;
    return Scaffold(
      key: _scaffoldKey,
      body: GestureDetector(
        onTap: () {
          controller.searchInputBoxNode.unfocus();
        },
        onTapDown: (e) {
          controller.searchInputBoxNode.unfocus();
        },
        child: Scaffold(
          body:  Column(
            children: [
              Expanded(
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
                          heroTag: "noSearch",
                          onPressed: () {
                            Get.to(() => WorkUpdatePage());
                            controller.work.value = WorkData();
                          },
                          child: Icon(Icons.add),
                          backgroundColor: Colors.blueAccent,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          )
        ),
      ),
    );
  }
}
