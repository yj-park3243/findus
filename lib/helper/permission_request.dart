import 'package:flash/flash.dart';
import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_typedefs/rx_typedefs.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:get/get.dart';

Future<void> permissionRequest(
    {required BuildContext context,
    required Permission permission,
    Callback? callback}) async {
  if (await permission.request().isGranted) {
    if (callback != null) {
      callback();
    }
  } else {
    context.showFlashDialog(
        content: Center(
            child: Text(
          'permission_message'
              .trParams({'permissionName': permissionName[permission] ?? ''}),
          textAlign: TextAlign.center,
        )),
        onWillPop: () async {
          return false;
        },
        positiveActionBuilder: (context, flashController, _) {
          return TextButton(
            onPressed: () {
              flashController.dismiss();
              openAppSettings();
            },
            child: Text('yes'.tr),
          );
        },
        negativeActionBuilder: (context, flashController, _) {
          return TextButton(
            onPressed: () {
              flashController.dismiss();
            },
            child: Text('no'.tr),
          );
        });
  }
}

final Map<Permission, String> permissionName = {
  Permission.camera: 'camera'.tr,
  Permission.photos: 'photo_album'.tr,
};
