import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';

class CircleCheckbox extends StatefulWidget {
  const CircleCheckbox({Key? key, this.value = false, this.onChanged})
      : super(key: key);

  final bool value;
  final ValueChanged<bool>? onChanged;

  @override
  State<CircleCheckbox> createState() => _CircleCheckboxState();
}

class _CircleCheckboxState extends State<CircleCheckbox> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          if (widget.onChanged != null) {
            widget.onChanged!(!widget.value);
          }
        },
        child: widget.value
            ? SizedBox(
                width: 20,
                height: 20,
                child: SvgPicture.asset('assets/images/icons/checkbox.svg'))
            : SizedBox(
                width: 20,
                height: 20,
                child: SvgPicture.asset(
                    'assets/images/icons/checkbox_disable.svg')));
  }
}
