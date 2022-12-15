import 'package:findus/constants/common_sizes.dart';
import 'package:findus/constants/main_color.dart';
import 'package:findus/constants/style.dart';
import 'package:flutter/material.dart';

class AmountTextField extends StatelessWidget {
  AmountTextField({
    Key? key,
    required this.coinCode,
    required this.controller,
    required this.focusNode,
    required this.isEmpty,
  }) : super(key: key);
  final String coinCode;
  final TextEditingController controller;
  final FocusNode focusNode;
  final bool isEmpty;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          height: CommonSize.textFieldHeight,
          decoration: BoxDecoration(
            color: MainColor.blue[50],
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(CommonRadius.s),
              bottomLeft: Radius.circular(CommonRadius.s),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: CommonGap.xxs),
            child: Center(
                child: Text(
              coinCode,
              style: const TextStyle(color: Colors.grey),
            )),
          ),
        ),
        Expanded(
          child: TextField(
            readOnly: true,
            showCursor: true,
            controller: controller,
            focusNode: focusNode,
            textAlign: TextAlign.right,
            style: textFieldTextStyle,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.zero,
              hintText: '수량',
              disabledBorder: _outlineInputBorder,
              enabledBorder: _outlineInputBorder,
              focusedBorder: _outlineInputBorder,
            ),
          ),
        ),
        _buildRemoveBtn(controller: controller, visible: !isEmpty)
      ],
    );
  }

  Container _buildRemoveBtn(
      {required TextEditingController controller, required bool visible}) {
    return Container(
      constraints: const BoxConstraints(minWidth: 12),
      padding: const EdgeInsets.only(right: CommonGap.xxxs),
      height: CommonSize.textFieldHeight,
      decoration: BoxDecoration(
        color: MainColor.blue[50],
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(CommonRadius.s),
          bottomRight: const Radius.circular(CommonRadius.s),
        ),
      ),
      child: Visibility(
        visible: visible,
        child: InkWell(
          onTap: () {
            controller.text = '';
          },
          child: Icon(
            Icons.cancel,
            size: 18,
            color: Colors.grey[800],
          ),
        ),
      ),
    );
  }

  final _outlineInputBorder = const OutlineInputBorder(
      borderSide: BorderSide.none,
      borderRadius: BorderRadius.only(
          topLeft: Radius.circular(0),
          bottomLeft: Radius.circular(0),
          topRight: Radius.circular(0),
          bottomRight: Radius.circular(0)));
}
