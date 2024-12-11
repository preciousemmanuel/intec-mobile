import 'package:flutter/material.dart';
import 'package:intechpro/theme/theme_helper.dart';
import 'package:intechpro/utils/size_utils.dart';

class AppDecoration {
  // Fill decorations
  static BoxDecoration get fillBlack => BoxDecoration(
        color: appTheme.black900.withOpacity(0.1),
      );
  static BoxDecoration get fillBlack900 => BoxDecoration(
        color: appTheme.black900,
      );
  static BoxDecoration get fillBlue => BoxDecoration(
        color: appTheme.blue5002,
      );

  static BoxDecoration get outlineGray1003 => BoxDecoration(
        border: Border.all(
          color: appTheme.gray100,
          width: 4.h,
        ),
      );
  static BoxDecoration get outlineGreenA700 => BoxDecoration();
  static BoxDecoration get fillBlueGray => BoxDecoration(
        color: appTheme.blueGray900,
      );

  static BoxDecoration get fillGray20001 => BoxDecoration(
        color: appTheme.gray20001,
      );

  static BoxDecoration get outlineGray1001 => BoxDecoration(
        color: appTheme.gray5002,
        border: Border.all(
          color: appTheme.gray100,
          width: 1.h,
        ),
      );

  static BoxDecoration get outlineDecorationGrayTL14 => BoxDecoration(
        color: appTheme.white,
        borderRadius: BorderRadius.circular(30.h),
      );

  static BoxDecoration get outlineWhileRound200014 => BoxDecoration(
        color: appTheme.white,
        borderRadius: BorderRadius.circular(25.adaptSize),
      );

  static BoxDecoration get outlineGray200013 => BoxDecoration(
        color: appTheme.gray100,
        borderRadius: BorderRadius.circular(10.adaptSize),
        border: Border(
          bottom: BorderSide(
            color: appTheme.gray20001,
            width: 1.h,
          ),
        ),
      );

  static BoxDecoration get outlineGray500 => BoxDecoration(
        color: appTheme.gray5002,
        border: Border.all(
          color: appTheme.gray500,
          width: 1.h,
        ),
      );
  static BoxDecoration get fillGray5002 => BoxDecoration(
        color: appTheme.gray5002,
      );
  static BoxDecoration get fillBluegray700 => BoxDecoration(
        color: appTheme.blueGray700,
      );
  static BoxDecoration get fillDeepPurple => BoxDecoration(
        color: appTheme.deepPurple900,
      );
  static BoxDecoration get fillDeepPurpleA => BoxDecoration(
        color: appTheme.deepPurpleA20001,
      );
  static BoxDecoration get fillDeeppurpleA200 => BoxDecoration(
        color: appTheme.deepPurpleA200,
      );
  static BoxDecoration get fillErrorContainer => BoxDecoration(
        color: theme.colorScheme.errorContainer,
      );
  static BoxDecoration get fillGray => BoxDecoration(
        color: appTheme.gray5002,
      );

  static BoxDecoration get outlinePrimaryContainer3 => BoxDecoration(
        color: appTheme.gray100,
        border: Border.all(
          color: theme.colorScheme.primaryContainer,
          width: 2.h,
        ),
      );

  static BoxDecoration get outlineGray200012 => BoxDecoration(
        border: Border.all(
          color: appTheme.gray20001,
          width: 1.h,
        ),
      );
  static BoxDecoration get fillGray100 => BoxDecoration(
        color: appTheme.gray100,
      );
  static BoxDecoration get fillGray1003 => BoxDecoration(
        color: appTheme.gray100.withOpacity(0.6),
      );
  static BoxDecoration get fillGray10001 => BoxDecoration(
        color: appTheme.gray10001,
      );
  static BoxDecoration get fillGray200 => BoxDecoration(
        color: appTheme.gray200,
      );
  static BoxDecoration get fillGray50 => BoxDecoration(
        color: appTheme.gray50,
      );
  static BoxDecoration get fillGray500 => BoxDecoration(
        color: appTheme.gray500,
      );
  static BoxDecoration get fillGray5001 => BoxDecoration(
        color: appTheme.gray5001,
      );
  static BoxDecoration get fillGray90003 => BoxDecoration(
        color: appTheme.gray90003,
      );
  static BoxDecoration get fillGreen => BoxDecoration(
        color: appTheme.green700,
      );
  static BoxDecoration get fillGreen800 => BoxDecoration(
        color: appTheme.green800,
      );

  static BoxDecoration get fillRed9002 => BoxDecoration(
        color: appTheme.red90002,
      );

  static BoxDecoration get fillIndigo => BoxDecoration(
        color: appTheme.indigo50002,
      );
  static BoxDecoration get fillIndigo800 => BoxDecoration(
        color: appTheme.indigo800,
      );
  static BoxDecoration get fillIndigoA => BoxDecoration(
        color: appTheme.indigoA20002,
      );
  static BoxDecoration get fillIndigoA400 => BoxDecoration(
        color: appTheme.indigoA400,
      );
  static BoxDecoration get fillOnErrorContainer => BoxDecoration(
        color: theme.colorScheme.onErrorContainer,
      );
  static BoxDecoration get fillOnPrimary => BoxDecoration(
        color: theme.colorScheme.onPrimary,
      );
  static BoxDecoration get fillPurple => BoxDecoration(
        color: appTheme.purple900,
      );
  static BoxDecoration get fillRed => BoxDecoration(
        color: appTheme.red5001,
      );
  static BoxDecoration get fillRed900 => BoxDecoration(
        color: appTheme.red900,
      );
  static BoxDecoration get fillRed90002 => BoxDecoration(
        color: appTheme.red90002,
      );

  static BoxDecoration get fillRed50 => BoxDecoration(
        color: appTheme.red50,
      );

  static BoxDecoration get fillGray900031 => BoxDecoration(
        color: appTheme.gray90003.withOpacity(0.5),
      );

  static BoxDecoration get outlineGray20001 => BoxDecoration(
        color: theme.colorScheme.onPrimary.withOpacity(1),
        border: Border.all(
          color: appTheme.gray20001,
          width: 1.h,
        ),
      );

  // Gradient decorations
  static BoxDecoration get gradientAmberAToAmber => BoxDecoration(
        border: Border.all(
          color: appTheme.amberA700,
          width: 1.h,
        ),
        gradient: LinearGradient(
          begin: Alignment(0.5, 0),
          end: Alignment(0.5, 1),
          colors: [
            appTheme.amberA700,
            appTheme.amber30001,
          ],
        ),
      );
  static BoxDecoration get gradientIndigoAToPrimary => BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment(0.5, 0),
          end: Alignment(0.5, 1),
          colors: [
            appTheme.indigoA20001,
            theme.colorScheme.primary,
          ],
        ),
      );

  static BoxDecoration get gradientFunBox => BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment(0.5, 0),
          end: Alignment(0.5, 1),
          colors: [
            appTheme.indigoA20001,
            appTheme.indigoMild,
          ],
        ),
      );

  // Outline decorations
  static BoxDecoration get outline => BoxDecoration(
        color: appTheme.gray200,
      );
  static BoxDecoration get outlineBlue => BoxDecoration(
        color: appTheme.gray100,
        border: Border.all(
          color: appTheme.blue200,
          width: 1.h,
        ),
        boxShadow: [
          BoxShadow(
            color: appTheme.black900.withOpacity(0.08),
            spreadRadius: 2.h,
            blurRadius: 2.h,
            offset: Offset(
              0,
              4,
            ),
          ),
        ],
      );
  static BoxDecoration get outlineBlue200 => BoxDecoration(
        color: appTheme.gray100,
        border: Border.all(
          color: appTheme.blue200,
          width: 1.h,
        ),
      );
  static BoxDecoration get outlineBlueGray => BoxDecoration(
        border: Border.all(
          color: appTheme.blueGray10001,
          width: 1.h,
        ),
      );
  static BoxDecoration get outlineGray => BoxDecoration(
        color: Colors.transparent,
        border: Border(
            bottom: BorderSide(
          color: appTheme.gray100,
          width: 1.h,
        )),
      );
  static BoxDecoration get outlineGray100 => BoxDecoration(
        color: appTheme.gray50,
        border: Border.all(
          color: appTheme.gray100,
          width: 1.h,
        ),
      );
  static BoxDecoration get outlineGray200 => BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: appTheme.gray200,
            width: 1.h,
          ),
        ),
      );
  static BoxDecoration get outlineGray2001 => BoxDecoration(
        color: theme.colorScheme.onPrimary,
        border: Border.all(
          color: appTheme.gray200,
          width: 1.h,
        ),
      );
  static BoxDecoration get outlineGreenA => BoxDecoration(
      color: appTheme.green500,
      border: Border.all(color: appTheme.greenA700, width: 1.adaptSize));

  static BoxDecoration get outlineRed5001 => BoxDecoration(
        color: appTheme.red900,
        border: Border.all(
          color: appTheme.red500,
          width: 1.h,
          strokeAlign: strokeAlignOutside,
        ),
      );

  static BoxDecoration get outlineIndigo => BoxDecoration(
        color: theme.colorScheme.onPrimary,
        border: Border.all(
          color: appTheme.indigo100,
          width: 1.h,
        ),
      );
  static BoxDecoration get outlineIndigo100 => BoxDecoration(
        color: appTheme.gray100,
        border: Border.all(
          color: appTheme.indigo100,
          width: 1.h,
        ),
      );
  static BoxDecoration get outlineIndigoA => BoxDecoration(
        color: appTheme.gray200,
        border: Border.all(
          color: appTheme.indigoA400,
          width: 1.h,
        ),
      );
  static BoxDecoration get outlinePrimaryContainer => BoxDecoration(
        color: appTheme.gray5002,
        border: Border.all(
          color: theme.colorScheme.primaryContainer,
          width: 1.h,
        ),
      );
  static BoxDecoration get outlineRed => BoxDecoration(
        color: appTheme.red90001,
        border: Border.all(
          color: appTheme.red700,
          width: 1.h,
        ),
      );
  static BoxDecoration get outlineRed500 => BoxDecoration();
  static BoxDecoration get outline1 => BoxDecoration(
        color: theme.colorScheme.onPrimaryContainer,
      );
}

class BorderRadiusStyle {
  // Circle borders
  static BorderRadius get circleBorder25 => BorderRadius.circular(
        25.h,
      );
  static BorderRadius get circleBorder40 => BorderRadius.circular(
        40.h,
      );
  static BorderRadius get circleBorder50 => BorderRadius.circular(
        50.h,
      );
  static BorderRadius get circleBorder100 => BorderRadius.circular(
        100.h,
      );
  static BorderRadius get circleBorder5 => BorderRadius.circular(
        5.h,
      );
  static BorderRadius get circleBorder7 => BorderRadius.circular(
        7.h,
      );
  static BorderRadius get roundedBorder16 => BorderRadius.circular(
        16.h,
      );
  // Custom borders
  static BorderRadius get customBorderBL10 => BorderRadius.only(
        topLeft: Radius.circular(6.h),
        topRight: Radius.circular(6.h),
        bottomLeft: Radius.circular(10.h),
        bottomRight: Radius.circular(10.h),
      );
  static BorderRadius get customBorderBL30 => BorderRadius.vertical(
        bottom: Radius.circular(30.h),
      );

  // Rounded borders
  static BorderRadius get roundedBorder1 => BorderRadius.circular(
        1.h,
      );
  static BorderRadius get roundedBorder10 => BorderRadius.circular(
        10.h,
      );
  static BorderRadius get roundedBorder14 => BorderRadius.circular(
        14.h,
      );
  static BorderRadius get roundedBorder20 => BorderRadius.circular(
        20.h,
      );
  static BorderRadius get roundedBorder30 => BorderRadius.circular(
        30.h,
      );

  static BoxDecoration get outlineGray1003 => BoxDecoration(
        border: Border.all(
          color: appTheme.gray100,
          width: 4.h,
        ),
      );
}

// Comment/Uncomment the below code based on your Flutter SDK version.

// For Flutter SDK Version 3.7.2 or greater.

double get strokeAlignInside => BorderSide.strokeAlignInside;

double get strokeAlignCenter => BorderSide.strokeAlignCenter;

double get strokeAlignOutside => BorderSide.strokeAlignOutside;

// For Flutter SDK Version 3.7.1 or less.

// StrokeAlign get strokeAlignInside => StrokeAlign.inside;
//
// StrokeAlign get strokeAlignCenter => StrokeAlign.center;
//
// StrokeAlign get strokeAlignOutside => StrokeAlign.outside;
    