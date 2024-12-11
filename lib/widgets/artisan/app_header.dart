import 'package:flutter/material.dart';
import 'package:intechpro/constant/image_constant.dart';
import 'package:intechpro/utils/size_utils.dart';
import 'package:intechpro/widgets/custom_image_viewer.dart';
import 'package:intechpro/widgets/space.dart';

class ArtisanAppHeader extends StatelessWidget {
  const ArtisanAppHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            CustomImageView(
              fit: BoxFit.contain,
              imagePath: ImageConstant.userImage,
              width: 60.h,
              height: 60.v,
            ),
            HSpace(11.h),
            Column(
              children: [
                Text("Abraham"),
                VSpace(10.v),
                Text("Artisan"),
              ],
            )
          ],
        ),
        CustomImageView(
          fit: BoxFit.contain,
          imagePath: ImageConstant.notifyImage,
          width: 27.h,
          height: 27.v,
        ),
      ],
    );
  }
}
