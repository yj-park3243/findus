import 'package:findus/constants/common_sizes.dart';
import 'package:findus/constants/main_color.dart';
import 'package:findus/constants/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
class AddressTextField extends StatefulWidget {
  const AddressTextField({
    Key? key,
    required this.controller,
    required this.focusNode,
    required this.isEmpty,
  }) : super(key: key);
  final TextEditingController controller;
  final FocusNode focusNode;
  final bool isEmpty;

  @override
  State<AddressTextField> createState() => _AddressTextFieldState();
}

class _AddressTextFieldState extends State<AddressTextField> {
  @override
  void initState() {
    super.initState();
    widget.focusNode.addListener(focusListener);
  }

  void focusListener() {
    if (widget.focusNode.hasFocus == false) {
      setState(() {
        isReadOnly = true;
      });
    }
  }

  bool isReadOnly = true;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          height: CommonSize.textFieldHeight,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(CommonRadius.s),
                bottomLeft: Radius.circular(CommonRadius.s),
              ),
              color: MainColor.blue[50],
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: CommonGap.xxs),
              child: InkWell(
                  onTap: () {
                    callKeyboard();
                  },
                  child: const Icon(
                    Icons.keyboard_alt_outlined,
                    color: MainColor.blue,
                  )),
            ),
          ),
        ),
        Expanded(
          child: TextField(
            readOnly: isReadOnly,
            showCursor: true,
            controller: widget.controller,
            focusNode: widget.focusNode,
            inputFormatters: [
              LengthLimitingTextInputFormatter(70),
              FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9]'))
            ],
            textAlign: TextAlign.right,
            style: textFieldTextStyle,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.zero,
              hintText: '지갑주소',
              disabledBorder: _outlineInputBorder,
              enabledBorder: _outlineInputBorder,
              focusedBorder: _outlineInputBorder,
            ),
            onChanged: (value) {},
          ),
        ),
        _buildRemoveBtn(controller: widget.controller, visible: !widget.isEmpty)
      ],
    );
  }

  void callKeyboard() {
    setState(() {
      isReadOnly = !isReadOnly;
    });
    widget.focusNode.requestFocus();
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
          bottomRight: Radius.circular(CommonRadius.s),
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
