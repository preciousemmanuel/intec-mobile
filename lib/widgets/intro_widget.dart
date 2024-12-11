import 'package:flutter/material.dart';
import 'package:intechpro/screens/login_screen.dart';
import 'package:intechpro/theme/cusotm_button_style.dart';
import 'package:intechpro/theme/custom_text_style.dart';
import 'package:intechpro/utils/size_utils.dart';
import 'package:intechpro/widgets/app_decoration.dart';
import 'package:intechpro/widgets/custom_elevated_button.dart';
import 'package:intechpro/widgets/custom_image_viewer.dart';
import 'package:intechpro/widgets/space.dart';

class IntroWidget extends StatelessWidget {
  final String text;
  final String? description;
  final String imagePath;
  IntroWidget(
      {Key? key, required this.text, required this.imagePath, this.description})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        VSpace(20.v),
        CustomImageView(
          imagePath: imagePath,
          fit: BoxFit.contain,
          width: 328.h,
          height: 275.v,
        ),
        VSpace(42.v),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 29),
          child: Text(
            text,
            style: CustomTextStyles.titleMediumWhiteBold,
          ),
        ),
        VSpace(10.v),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 35),
          child: Text(
            description ?? "",
            style: CustomTextStyles.bodyMediumGray200,
          ),
        ),
        VSpace(40.v),
        CustomElevatedButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const LoginScreen()),
            );
          },
          text: "Get Started",
          buttonStyle: CustomButtonStyles.none,
          decoration: AppDecoration.outlineDecorationGrayTL14,
          buttonTextStyle: CustomTextStyles.bodyMediumBlue200,
        )
      ],
    );
  }
}
