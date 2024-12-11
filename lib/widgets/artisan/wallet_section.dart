import 'package:flutter/material.dart';
import 'package:intechpro/constant/image_constant.dart';
import 'package:intechpro/utils/size_utils.dart';
import 'package:intechpro/widgets/custom_image_viewer.dart';

class WalletSection extends StatelessWidget {
  const WalletSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 327.h,
      height: 194.v,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
      child: Stack(children: [
        CustomImageView(
          imagePath: ImageConstant.walletImage,
          fit: BoxFit.contain,
          width: 327.h,
          height: 194.v,
        ),
        Row(
          children: [Text("Available Balance")],
        ),
        Text("30,000")
      ]),
    );
  }
}
