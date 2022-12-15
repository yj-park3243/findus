import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';


class CircleProfileSmall extends StatelessWidget {
  const CircleProfileSmall(
      this.profile, {
        Key? key,
      }) : super(key: key);

  final String? profile;

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      clipBehavior: Clip.hardEdge,
      child: SizedBox(
          width: 40,
          height: 40,
          child: profile != null
              ? Image.network(
            profile!,
            fit: BoxFit.cover,
            width: 40,
            height: 40,
            errorBuilder: (context, error, stackTrace) => SvgPicture.asset('assets/find_us_images/common/reviewprofile.svg' ,),
          )
              : SvgPicture.asset('assets/find_us_images/common/reviewprofile.svg' )
      ),
    );
  }
}
