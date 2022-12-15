import 'package:flutter/material.dart';

class Radiobox extends StatelessWidget {
  const Radiobox({Key? key, required this.isOn}) : super(key: key);
  final bool isOn;

  @override
  Widget build(BuildContext context) {
    return isOn
        ? const Icon(Icons.radio_button_checked)
        : const Icon(Icons.radio_button_unchecked);
  }
}
