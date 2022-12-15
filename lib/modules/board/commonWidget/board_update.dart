import 'package:findus/constants/common_sizes.dart';
import 'package:findus/global_widgets/custom_text_form_field.dart';
import 'package:findus/global_widgets/custom_textarea.dart';
import 'package:findus/helper/validator_util.dart';
import 'package:findus/modules/board/board_controller.dart';
import 'package:flash/flash.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../constants/style.dart';

class BoardUpdatePage extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final _title = TextEditingController();
  final _content = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final BoardController boardController = Get.find();
    _title.text = boardController.board.value?.subject ?? '';
    _content.text = boardController.board.value?.content ?? '';
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('글쓰기'.tr, style: tapMenuTitleTextStyle),
        actions: [
          TextButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  await boardController.writeBoard(
                      boardController.board.value?.board_id ?? -1,
                      _title.text,
                      _content.text);
                  Get.back();
                  boardController.board.value?.board_id != null
                      ? Get.snackbar('알림'.tr, '게시글이_수정되었습니다'.tr)
                      : Get.snackbar('알림'.tr, '게시글이_등록되었습니다'.tr);
                }
              },
              child: Text(
                boardController.board.value?.board_id != null
                    ? "편집".tr
                    : "등록".tr,
                style: const TextStyle(color: Colors.blueAccent),
              ))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(CommonGap.m),
        child: Form(
          key: _formKey,
          child: ListView(
            shrinkWrap: true,
            children: [
              CustomTextFormField(
                controller: _title,
                hint: "제목을_입력해주세요".tr,
                funValidator: validateTitle(),
              ),
              const SizedBox(
                height: CommonGap.xxs,
              ),
              CustomTextArea(
                controller: _content,
                hint: "내용을_입력해주세요__10글자_이상".tr,
                funValidator: validateContent(),
              ),
              // homepage -> detailpage -> detailpage
              // CustomElevatedButton(
              //   text:
              //       "글 ${boardController.board.value.board_id != null ? "수정" : "등록"}하기",
              //   funPageRoute: () async {
              //     if (_formKey.currentState!.validate()) {
              //       await boardController.writeBoard(
              //           boardController.board.value.board_id ?? -1,
              //           _title.text,
              //           _content.text);
              //       // 같은 page가 있으면 이동할 때 덮어씌우기 이게 최고!!
              //       Get.back(); // 상태관리 GetX 라이브러리 - Obs
              //     }
              //   },
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
