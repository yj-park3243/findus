import 'package:findus/constants/common_sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../app/app_controller.dart';

class Pizza extends GetView<AppController> {
  const Pizza({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(10),
        child: AppBar(
          // centerTitle: true,
          // leading: const Icon(Icons.person),
          // title: const Text('Information'),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Align(
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(),
                  Text(
                    "용주 : DB, 서버, 앱, api",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'SF-Pro-Regular',
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "혜윤 : 앱, 디자인",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'SF-Pro-Regular',
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "뭉크 : 기획, 운영, 마케팅",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'SF-Pro-Regular',
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "테카 : 어드민, 마케팅",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'SF-Pro-Regular',
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
