import 'package:findus/constants/common_sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../app/app_controller.dart';

class InformationComingSoon extends GetView<AppController> {
  const InformationComingSoon({super.key});

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
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/findus_comingsoon.png',
                    height: 60,
                    width: 60,
                  ),
                  const SizedBox(
                    height: CommonGap.xl,
                  ),
                  Text(
                    "COMING SOON...",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'SF-Pro-Regular',
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
