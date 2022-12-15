import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../constants/common_sizes.dart';

class CircleProfile extends StatelessWidget {
  const CircleProfile(
    this.profile, {
    Key? key,
  }) : super(key: key);

  final String? profile;

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      clipBehavior: Clip.hardEdge,
      child: Padding(
        padding: const EdgeInsets.all(CommonGap.xxl),
        child: SizedBox(
            width: 80,
            height: 80,
            child: profile != null
                ? ClipOval(
                    child: Image.network(
                      profile!,
                      fit: BoxFit.cover,
                      width: 80,
                      height: 80,
                    ),
                  )
                : SvgPicture.asset('assets/find_us_images/common/reviewprofile.svg')),
      ),
    );
  }
}
