import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:store_redirect/store_redirect.dart';
import '../../constants/common_sizes.dart';
import '../../constants/env.dart';

class CheckVersion extends StatelessWidget {
  CheckVersion({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Container(
        width: Get.width * 0.8,
        padding: const EdgeInsets.all(CommonGap.s),
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.grey[300]!),
            borderRadius: BorderRadius.circular(CommonRadius.s)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.update,
              size: 40,
            ),
            const SizedBox(
              height: CommonGap.m,
            ),
            Text(
              '어플리케이션 업데이트를\n진행해주세요.',
              style: const TextStyle(height: 1.5, fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: CommonGap.m,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                    onPressed: () {
                      StoreRedirect.redirect(
                          androidAppId: "com.findus.findus",
                          iOSAppId: Env.iosAppId);
                    },
                    child: Text('업데이트'.tr))
              ],
            )
          ],
        ),
      )),
    );
  }
}
