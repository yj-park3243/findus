import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:findus/constants/common_sizes.dart';
import 'package:findus/global_widgets/loading_button.dart';
import 'package:findus/modules/board/board_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../app/app_controller.dart';

class SettingQuestion extends GetView<AppController> {
  const SettingQuestion({super.key});

  @override
  Widget build(BuildContext context) {
    final BoardController boardController = Get.find();
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('문의하기'.tr),
      ),
      body: Column(
        children: [
          Expanded(
            child: Align(
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.all(CommonGap.m),
                child: ListView(
                  children: [
                    Text(
                      "무엇을_도와드릴까요".tr,
                      style: const TextStyle(
                          fontSize: 20,
                          fontFamily: 'SF-Pro-Heavy',
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: CommonGap.s,
                    ),
                    Row(
                      children: [
                        const Icon(
                          Icons.circle,
                          color: Colors.black38,
                          size: 8,
                        ),
                        const SizedBox(
                          width: CommonGap.xxxs,
                        ),
                        Text(
                          "Findus_관리자에게_직접_문의해보세요".tr,
                          style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                              fontFamily: 'SF-Pro-Heavy',
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: CommonGap.xxs,
                    ),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Row(
                        children: [
                          const Icon(
                            Icons.circle,
                            size: 8,
                            color: Colors.black38,
                          ),
                          const SizedBox(
                            width: CommonGap.xxxs,
                          ),
                          Text(
                            "사용_중_궁금한_점,개선되어야할_점이_있다면_언제든지_문의해주세요\n비즈니스_관련_문의도_받습니다"
                                .tr,
                            style: const TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                                fontFamily: 'SF-Pro-Heavy',
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: CommonGap.m,
                    ),
                    TextFormField(
                        controller: boardController.reportController,
                        maxLines: 20,
                        style: const TextStyle(fontSize: 14),
                        decoration: InputDecoration(
                          hintText: '문의_내용을_입력해주세요'.tr,
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
                        )),
                    const SizedBox(
                      height: CommonGap.m,
                    ),
                    SizedBox(
                      height: 40,
                      child: LoadingButton(
                          onPressed: () {
                            boardController.saveReport(99, 0, '',
                                boardController.reportController.text);
                            Get.back();
                          },
                          style: ElevatedButton.styleFrom(),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '문의하기_버튼'.tr,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(
                                width: CommonGap.xxs,
                              ),
                              const Icon(
                                EvaIcons.messageCircleOutline,
                                size: 20,
                              )
                            ],
                          )),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
