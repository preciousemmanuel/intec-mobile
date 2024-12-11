import 'package:iconsax/iconsax.dart';
import 'package:intechpro/constant/image_constant.dart';
import 'package:intechpro/screens/login_screen.dart';
import 'package:intechpro/theme/theme_helper.dart';
import 'package:intechpro/utils/size_utils.dart';
import 'package:intechpro/widgets/app_decoration.dart';
import 'package:intechpro/widgets/intro_widget.dart';
import 'package:intechpro/widgets/space.dart';
import 'package:introduction_screen/introduction_screen.dart';

import 'package:flutter/material.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final introKey = GlobalKey<IntroductionScreenState>();
  final PageController _pageController = PageController(initialPage: 0);

  void _onIntroEnd(context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const LoginScreen()),
    );
  }

  Widget _buildNext() {
    return Container(
      alignment: Alignment.center,
      width: 50.h,
      height: 50.v,
      decoration: AppDecoration.outlineWhileRound200014,
      child: Icon(
        Iconsax.forward4,
        color: appTheme.blue200,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            backgroundColor: theme.primaryColor,
            body: Container(
              padding: EdgeInsets.symmetric(horizontal: 23.h),
              child: Column(
                children: [
                  SizedBox(
                    height: SizeUtils.height - 150,
                    child: PageView(
                      controller: _pageController,
                      children: [
                        IntroWidget(
                          text: "Get your wastes disposed properly at anytime!",
                          imagePath: ImageConstant.introOneImage,
                          description:
                              "Have your wastes disposed properly anytime by our Truck call-up service!",
                        ),
                        IntroWidget(
                          text:
                              "Let’s connect you to the best Artisans around you!",
                          imagePath: ImageConstant.introTwoImage,
                          description:
                              "Let’s help you find reliable artisans to fix your stuff ASAP!",
                        )
                      ],
                    ),
                  ),
                  const VSpace(40),
                  GestureDetector(
                      onTap: (() {
                        _pageController.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      }),
                      child: _buildNext()),
                  const VSpace(30),
                ],
              ),
            )));
  }
}
