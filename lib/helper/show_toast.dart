import 'package:flash/flash.dart';
import 'package:flutter/material.dart';

void showToast(BuildContext context, String message) {
  context.showToast(message, duration: const Duration(milliseconds: 1500));
}
