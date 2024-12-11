import 'package:flutter/material.dart';
import 'package:intechpro/theme/theme_helper.dart';
import 'package:intechpro/utils/size_utils.dart';

/// A collection of pre-defined text styles for customizing text appearance,
/// categorized by different font families and weights.
/// Additionally, this class includes extensions on [TextStyle] to easily apply specific font families to text.

class CustomTextStyles {
  // Body text style
  static get bodyMediumGray500 => theme.textTheme.bodyMedium!
      .copyWith(color: appTheme.gray500, fontSize: 12.fSize);
  static get bodyMediumGray600 => theme.textTheme.bodyMedium!.copyWith(
        color: appTheme.gray600,
      );
  static get bodySmallBlack900 => theme.textTheme.bodySmall!.copyWith(
        color: appTheme.black900,
      );
  static get bodySmallGray5004 => theme.textTheme.bodySmall!.copyWith(
        color: appTheme.gray5004,
      );
  static get bodySmallBluegray700 => theme.textTheme.bodySmall!.copyWith(
        color: appTheme.blueGray700,
      );
  static get bodySmallDeeporange50 => theme.textTheme.bodySmall!.copyWith(
        color: appTheme.deepOrange50,
      );
  static get bodySmallGray500 => theme.textTheme.bodySmall!.copyWith(
        color: appTheme.gray500,
      );

  static get titleSmallInterGray5002 =>
      theme.textTheme.titleSmall!.inter.copyWith(
        color: appTheme.gray5002,
      );

  static get bodyMediumInterBluegray900 => theme.textTheme.bodyMedium!.inter
      .copyWith(color: appTheme.gray5002, fontSize: 12.fSize);

  static get bodyMediumGrey600 => theme.textTheme.bodyMedium!.inter
      .copyWith(color: appTheme.gray900, fontWeight: FontWeight.w600);

  static get headlineSmallBlack900_1 => theme.textTheme.headlineSmall!.copyWith(
        color: appTheme.black900,
      );

  static get bodyMediumIndigoA200 => theme.textTheme.bodyMedium!.copyWith(
        color: appTheme.indigoA200,
      );

  static get titleSmallRed300 => theme.textTheme.titleSmall!.copyWith(
        color: appTheme.red300,
        fontWeight: FontWeight.w700,
      );

  static get titleMediumGray5002Bold => theme.textTheme.titleMedium!.copyWith(
        color: appTheme.gray5002,
        fontSize: 18.fSize,
        fontWeight: FontWeight.w700,
      );

  static get labelLargeInterGray90002 =>
      theme.textTheme.labelLarge!.inter.copyWith(
        color: appTheme.gray90002,
        fontWeight: FontWeight.w500,
      );

  static get titleSmallGray600_1 => theme.textTheme.titleSmall!.copyWith(
        color: appTheme.gray600,
      );

  static get titleSmallIndigoA200 => theme.textTheme.titleSmall!.copyWith(
        color: appTheme.indigoA200,
        fontWeight: FontWeight.w500,
      );

  static get labelLargeGray900 => theme.textTheme.labelLarge!.copyWith(
        color: appTheme.gray900,
        fontWeight: FontWeight.w500,
      );

  static get titleMediumInterOnPrimaryMedium =>
      theme.textTheme.titleMedium!.inter.copyWith(
        color: theme.colorScheme.onPrimary,
        fontWeight: FontWeight.w500,
      );
  static get titleMediumInterBlack900 =>
      theme.textTheme.titleMedium!.inter.copyWith(
        color: appTheme.black900,
        fontSize: 18.fSize,
      );

  static get titleMedium16Black900 =>
      theme.textTheme.titleMedium!.inter.copyWith(
        color: appTheme.black900,
      );
  static get bodyMediumInterff333333 =>
      theme.textTheme.bodyMedium!.inter.copyWith(
        fontWeight: FontWeight.w400,
        color: Color(0XFF333333),
      );
  static get bodyMediumInterff27272a =>
      theme.textTheme.bodyMedium!.inter.copyWith(
        color: Color(0XFF27272A),
      );
  static get titleMediumInterGray700 =>
      theme.textTheme.titleMedium!.inter.copyWith(
        color: appTheme.gray700,
        fontWeight: FontWeight.w500,
      );
  static get titleSmallIndigoA200Bold => theme.textTheme.titleSmall!.copyWith(
        color: appTheme.indigoA20001,
        fontWeight: FontWeight.w700,
      );
  static get titleMediumBlue900Medium => theme.textTheme.titleMedium!.copyWith(
        color: appTheme.blue200,
        fontSize: 24.fSize,
        fontWeight: FontWeight.w500,
      );

  static get mediumindigoBold => theme.textTheme.titleMedium!.copyWith(
        color: appTheme.indigo50002,
        fontSize: 16.fSize,
        fontWeight: FontWeight.w600,
      );

  static get mediumGreyoBold => theme.textTheme.titleMedium!.copyWith(
        color: appTheme.gray500,
        fontSize: 16.fSize,
        fontWeight: FontWeight.w600,
      );

  static get titleLargeInterBlack900 => theme.textTheme.titleLarge!.inter
      .copyWith(color: appTheme.black900, fontWeight: FontWeight.w700);
  static get bodySmallGray5002 => theme.textTheme.bodySmall!.copyWith(
        color: appTheme.gray5002,
      );

  static get bodySmallGray800 => theme.textTheme.bodySmall!.copyWith(
        color: appTheme.gray800,
      );

  static get headlineSmallBlack900 => theme.textTheme.headlineSmall!.copyWith(
        color: appTheme.black900,
        fontWeight: FontWeight.w600,
      );
  static get bodySmallGray90003 => theme.textTheme.bodySmall!.copyWith(
        color: appTheme.gray90003,
      );

  static get labelLargeIndigoA200 => theme.textTheme.labelLarge!.copyWith(
        color: appTheme.indigoA200,
        fontWeight: FontWeight.w500,
      );

  static get titleMediumGray500_1 => theme.textTheme.titleMedium!
      .copyWith(color: appTheme.gray500, fontWeight: FontWeight.w500);

  static get redTitleMedium => theme.textTheme.titleMedium!.copyWith(
      color: appTheme.red300, fontSize: 14.fSize, fontWeight: FontWeight.w500);

  static get titleMediumOnPrimary18 => theme.textTheme.titleMedium!.copyWith(
        color: theme.colorScheme.onPrimary.withOpacity(1),
        fontSize: 18.fSize,
      );

  static get titleLargeGray90002 => theme.textTheme.titleLarge!.copyWith(
        color: appTheme.gray90002,
        fontWeight: FontWeight.w500,
      );

  static get bodySmallInterGray900 => theme.textTheme.bodySmall!.inter.copyWith(
        color: appTheme.gray900,
      );
  static get titleSmallInterGray600 =>
      theme.textTheme.titleSmall!.inter.copyWith(
        color: appTheme.gray600,
        fontWeight: FontWeight.w500,
      );

  static get bodySmallStoryTitle => theme.textTheme.bodySmall!.copyWith(
        color: appTheme.gray900,
        fontWeight: FontWeight.w700,
      );
  static get titleSmallInterGray90002 =>
      theme.textTheme.titleSmall!.inter.copyWith(
        color: appTheme.gray90002,
        fontWeight: FontWeight.w500,
      );

  static get labelLargeBlack900Medium => theme.textTheme.labelLarge!.copyWith(
        color: appTheme.black900,
        fontWeight: FontWeight.w500,
      );

  static get titleMediumInterBold =>
      theme.textTheme.titleMedium!.inter.copyWith(
        color: appTheme.black900,
        fontWeight: FontWeight.w700,
      );

  static get titleMediumInterOnPrimary =>
      theme.textTheme.titleMedium!.inter.copyWith(
        color: theme.colorScheme.onPrimary,
        fontWeight: FontWeight.w700,
      );
  static get titleSmallInter => theme.textTheme.titleSmall!.inter.copyWith(
        color: appTheme.black900,
        fontWeight: FontWeight.w500,
      );

  static get titleMediumInter => theme.textTheme.titleMedium!.inter.copyWith(
        color: appTheme.black900,
        fontWeight: FontWeight.w500,
      );

  static get titleMediumGray5004_1 => theme.textTheme.titleMedium!.copyWith(
        color: appTheme.gray5004,
      );

  static get bodySmallIndigoA200 => theme.textTheme.bodySmall!.copyWith(
        color: appTheme.indigoA200,
      );

  static get labelLargeBluegray700 => theme.textTheme.labelLarge!.copyWith(
        color: appTheme.blueGray700,
      );

  static get titleSmallInterBlack900 =>
      theme.textTheme.titleSmall!.inter.copyWith(
        color: appTheme.black900,
        fontWeight: FontWeight.w500,
      );

  static get titleMediumMedium_1 => theme.textTheme.titleMedium!.copyWith(
        fontWeight: FontWeight.w500,
        color: appTheme.black900,
      );

  static get titleSmallBlack900_1 => theme.textTheme.titleSmall!.copyWith(
        color: appTheme.black900,
      );

  static get bodySmallIndigoA20001 => theme.textTheme.bodySmall!.copyWith(
        color: appTheme.indigoA20001,
      );
  static get bodySmallOnPrimary => theme.textTheme.bodySmall!
      .copyWith(color: theme.colorScheme.onPrimary, fontSize: 14.fSize);

  static get bodySmallOnPrimaryC => theme.textTheme.bodySmall!.copyWith(
      color: theme.colorScheme.onPrimary,
      fontSize: 14.fSize,
      fontWeight: FontWeight.w600);

  static get bodySmallOnPrimary8 => theme.textTheme.bodySmall!.copyWith(
        color: theme.colorScheme.onPrimary,
        fontSize: 8.fSize,
      );

  static get bodyMediumBlue200 => theme.textTheme.titleMedium!.copyWith(
      color: appTheme.blue200, fontWeight: FontWeight.w500, fontSize: 16.fSize);

  static get bodyMediumGray200 => theme.textTheme.titleMedium!.copyWith(
      color: appTheme.gray100, fontWeight: FontWeight.w400, fontSize: 14.fSize);

  static get bodyMediumBlack500 => theme.textTheme.titleMedium!.copyWith(
      color: appTheme.black600,
      fontWeight: FontWeight.w500,
      fontSize: 12.fSize);

  static get titleLargeSemiBold => theme.textTheme.titleLarge!.copyWith(
      fontWeight: FontWeight.w600, color: appTheme.gray900, fontSize: 20.fSize);
  static get bodySmallPoppinsOnPrimary =>
      theme.textTheme.bodySmall!.poppins.copyWith(
        color: theme.colorScheme.onPrimary,
        fontSize: 8.fSize,
      );
  static get bodySmallffa1a1aa => theme.textTheme.bodySmall!.copyWith(
        color: Color(0XFFA1A1AA),
      );
  // Display text style
  static get displayMediumOnPrimary => theme.textTheme.displayMedium!.copyWith(
        color: theme.colorScheme.onPrimary,
        fontWeight: FontWeight.w500,
      );
  static get displaySmallffffffff => theme.textTheme.displaySmall!.copyWith(
        color: Color(0XFFFFFFFF),
      );
  // Headline text style
  static get headlineLargeGray5004 => theme.textTheme.headlineLarge!.copyWith(
        color: appTheme.gray5004,
      );
  static get headlineLargeGray900 => theme.textTheme.headlineLarge!.copyWith(
        color: appTheme.gray900,
      );
  static get headlineLargeOnPrimary => theme.textTheme.headlineLarge!.copyWith(
        color: theme.colorScheme.onPrimary,
      );

  static get headlineSmallOnPrimary => theme.textTheme.headlineSmall!.copyWith(
        color: theme.colorScheme.onPrimary,
        fontSize: 25.fSize,
      );
  static get headlineSmallOnPrimary25 =>
      theme.textTheme.headlineSmall!.copyWith(
        color: theme.colorScheme.onPrimary,
        fontSize: 25.fSize,
      );
  // Label text style
  static get labelLargeBlack900 => theme.textTheme.labelLarge!.copyWith(
        color: appTheme.black900,
        fontWeight: FontWeight.w500,
      );
  static get labelLargeBlack900Bold => theme.textTheme.labelLarge!.copyWith(
        color: appTheme.black900,
        fontWeight: FontWeight.w700,
      );
  static get labelLargeBlue200 => theme.textTheme.labelLarge!.copyWith(
        color: appTheme.blue200,
        fontWeight: FontWeight.w700,
      );

  static get labelLargeBluegray10001 => theme.textTheme.labelLarge!.copyWith(
        color: appTheme.blueGray10001,
        fontWeight: FontWeight.w700,
      );
  static get labelLargeBluegray10001Medium =>
      theme.textTheme.labelLarge!.copyWith(
        color: appTheme.blueGray10001,
        fontWeight: FontWeight.w500,
      );
  static get labelLargeGray500 => theme.textTheme.labelLarge!.copyWith(
        color: appTheme.gray500,
      );

  static get labelMediumGray500 => theme.textTheme.labelMedium!.copyWith(
      color: appTheme.gray500, fontWeight: FontWeight.w500, fontSize: 14.fSize);
  static get labelLargeGray5002 => theme.textTheme.labelLarge!.copyWith(
        color: appTheme.gray5002,
        fontWeight: FontWeight.w500,
      );
  static get labelLargeGray5002_1 => theme.textTheme.labelLarge!.copyWith(
        color: appTheme.gray5002,
      );
  static get labelLargeGray500Bold => theme.textTheme.labelLarge!.copyWith(
        color: appTheme.gray500,
        fontWeight: FontWeight.w700,
      );
  static get labelLargeGray500Medium => theme.textTheme.labelLarge!.copyWith(
        color: appTheme.gray500,
        fontWeight: FontWeight.w500,
      );
  static get labelLargeGray600 => theme.textTheme.labelLarge!.copyWith(
        color: appTheme.gray600,
        fontWeight: FontWeight.w700,
      );
  static get labelLargeGray600Medium => theme.textTheme.labelLarge!.copyWith(
        color: appTheme.gray600,
        fontWeight: FontWeight.w500,
      );
  static get labelLargeGray800 => theme.textTheme.labelLarge!.copyWith(
        color: appTheme.gray800,
      );
  static get labelLargeGray800Bold => theme.textTheme.labelLarge!.copyWith(
        color: appTheme.gray800,
        fontWeight: FontWeight.w700,
      );
  static get labelLargeGreen700 => theme.textTheme.labelLarge!.copyWith(
        color: appTheme.green700,
        fontWeight: FontWeight.w500,
      );
  static get labelLargeIndigoA20001 => theme.textTheme.labelLarge!.copyWith(
        color: appTheme.indigoA20001,
      );
  static get labelLargeIndigoA20001Bold => theme.textTheme.labelLarge!.copyWith(
        color: appTheme.indigoA20001,
        fontWeight: FontWeight.w700,
      );
  static get labelLargeIndigoA20001Medium =>
      theme.textTheme.labelLarge!.copyWith(
        color: appTheme.indigoA20001,
        fontSize: 14.v,
        fontWeight: FontWeight.w500,
      );

  static get titleMediumBlack900_1 => theme.textTheme.titleMedium!.copyWith(
        color: appTheme.black900,
      );

  static get labelLargeInterff000000 =>
      theme.textTheme.labelLarge!.inter.copyWith(
        color: Color(0XFF000000),
        fontWeight: FontWeight.w500,
      );
  static get labelLargeInterff000000Bold =>
      theme.textTheme.labelLarge!.inter.copyWith(
        color: Color(0XFF000000),
        fontWeight: FontWeight.w700,
      );

  static get titleMediumInterGray5002 =>
      theme.textTheme.titleMedium!.inter.copyWith(
        color: appTheme.gray5002,
      );

  static get titleLargeBlack900_1 => theme.textTheme.titleLarge!.copyWith(
        color: appTheme.black900,
      );

  static get titleSmallGray90002Medium => theme.textTheme.titleSmall!.copyWith(
        color: appTheme.gray90002,
        fontWeight: FontWeight.w500,
      );

  static get titleMediumGray90002 => theme.textTheme.titleMedium!.copyWith(
        color: appTheme.gray90002,
        fontWeight: FontWeight.w500,
      );

  static get labelLargeGrayA20001Medium => theme.textTheme.labelLarge!.copyWith(
        color: appTheme.gray600,
        fontWeight: FontWeight.w500,
      );

  static get labelLargeInterBlack900 =>
      theme.textTheme.labelLarge!.inter.copyWith(
        color: appTheme.black900,
        fontWeight: FontWeight.w500,
      );
  static get labelLargeMedium => theme.textTheme.labelLarge!.copyWith(
        fontWeight: FontWeight.w500,
      );
  static get labelLargeRed200 => theme.textTheme.labelLarge!.copyWith(
        color: appTheme.red200,
        fontWeight: FontWeight.w700,
      );
  static get labelLargeffa1a1aa => theme.textTheme.labelLarge!.copyWith(
        color: Color(0XFFA1A1AA),
        fontWeight: FontWeight.w700,
      );
  // Title text style
  static get titleLargeBlack900 => theme.textTheme.titleLarge!.copyWith(
        color: appTheme.black900,
        fontWeight: FontWeight.w600,
      );
  static get titleLargeGray500 => theme.textTheme.titleLarge!.copyWith(
        color: appTheme.gray500,
      );
  static get titleLargeGray900 => theme.textTheme.titleLarge!.copyWith(
        color: appTheme.gray900,
        fontWeight: FontWeight.w700,
      );

  static get titleLargeGray900SemiBold => theme.textTheme.titleLarge!.copyWith(
        color: appTheme.gray900,
        fontWeight: FontWeight.w600,
      );

  static get titleLargeBlack => theme.textTheme.titleLarge!.copyWith(
        color: appTheme.black900,
        fontWeight: FontWeight.w600,
      );
  static get titleLargeGray900_1 => theme.textTheme.titleLarge!.copyWith(
        color: appTheme.gray900,
      );
  static get titleLargeIndigoA20001 => theme.textTheme.titleLarge!.copyWith(
        color: appTheme.indigoA20001,
      );
  static get titleLargeOnPrimary => theme.textTheme.titleLarge!.copyWith(
        color: theme.colorScheme.onPrimary,
        fontWeight: FontWeight.w600,
      );
  static get titleLarge30 => theme.textTheme.titleMedium!.copyWith(
        color: appTheme.black900,
        fontSize: 30.fSize,
      );
  static get titleMedium18 => theme.textTheme.titleMedium!.copyWith(
        color: appTheme.black900,
        fontSize: 18.fSize,
      );

  static get titleLargeBlack900SemiBold => theme.textTheme.titleLarge!.copyWith(
        color: appTheme.black900,
        fontWeight: FontWeight.w600,
      );

  static get titleMediumff18181bMedium => theme.textTheme.titleMedium!.copyWith(
        color: appTheme.gray90003,
        fontWeight: FontWeight.w500,
      );

  static get titleMediumWhiteBold => theme.textTheme.titleMedium!.copyWith(
      color: appTheme.white, fontWeight: FontWeight.w700, fontSize: 24.fSize);

  static get titleMediumWhite16 => theme.textTheme.titleMedium!
      .copyWith(fontSize: 16.fSize, color: appTheme.gray5002);

  static get titleMediumBlack900 => theme.textTheme.titleMedium!.copyWith(
        color: appTheme.black900,
      );
  static get titleMediumBlack900Bold => theme.textTheme.titleMedium!.copyWith(
        color: appTheme.black900,
        fontSize: 18.fSize,
        fontWeight: FontWeight.w700,
      );

  static get titleMediumBlack90020Bold => theme.textTheme.titleMedium!.copyWith(
        color: appTheme.black900,
        fontSize: 20.fSize,
        fontWeight: FontWeight.w700,
      );

  static get titleMediumBold18 => theme.textTheme.titleMedium!.copyWith(
        fontSize: 18.fSize,
        fontWeight: FontWeight.w700,
      );

  static get labelLargeGray800_1 => theme.textTheme.labelLarge!.copyWith(
        color: appTheme.gray800,
      );
  static get titleMediumBold => theme.textTheme.titleMedium!.copyWith(
        fontSize: 18.fSize,
        fontWeight: FontWeight.w700,
      );
  static get titleMediumBoldWhite => theme.textTheme.titleMedium!.copyWith(
        fontSize: 18.fSize,
        color: theme.colorScheme.onPrimary,
        fontWeight: FontWeight.w700,
      );
  static get titleMediumGray500 => theme.textTheme.titleMedium!.copyWith(
        color: appTheme.gray500,
        fontSize: 18.fSize,
      );

  static get titleMediumSGray500 => theme.textTheme.titleMedium!.copyWith(
        color: appTheme.gray500,
        fontSize: 12.fSize,
      );
  static get titleMediumGray5002 => theme.textTheme.titleMedium!.copyWith(
        color: appTheme.gray5002,
        fontSize: 18.fSize,
        fontWeight: FontWeight.w700,
      );

  static get titleMediumGray200 => theme.textTheme.titleMedium!.copyWith(
        color: appTheme.blue200,
        fontSize: 16.fSize,
        fontWeight: FontWeight.w600,
      );
  static get titleMediumGray500218 => theme.textTheme.titleMedium!.copyWith(
        color: appTheme.gray5002,
        fontSize: 18.fSize,
      );
  static get titleMediumGray5002Medium => theme.textTheme.titleMedium!.copyWith(
        color: appTheme.gray5002,
        fontSize: 18.fSize,
        fontWeight: FontWeight.w500,
      );
  static get titleMediumGray5002_1 => theme.textTheme.titleMedium!.copyWith(
        color: appTheme.gray5002,
      );
  static get titleMediumGray600 => theme.textTheme.titleMedium!.copyWith(
        color: appTheme.gray600,
        fontSize: 18.fSize,
      );
  static get titleMediumGray600Medium => theme.textTheme.titleMedium!.copyWith(
        color: appTheme.gray600,
        fontWeight: FontWeight.w500,
      );
  static get titleMediumGray90003 => theme.textTheme.titleMedium!.copyWith(
        color: appTheme.gray90003,
        fontWeight: FontWeight.w500,
      );
  static get titleMediumIndigoA20001 => theme.textTheme.titleMedium!.copyWith(
        color: appTheme.indigoA20001,
        fontSize: 18.fSize,
      );
  static get titleMediumIndigoA20001Medium =>
      theme.textTheme.titleMedium!.copyWith(
        color: appTheme.indigoA20001,
        fontWeight: FontWeight.w500,
      );
  static get titleMediumMedium => theme.textTheme.titleMedium!.copyWith(
        fontWeight: FontWeight.w500,
      );
  static get titleMediumMedium18 => theme.textTheme.titleMedium!.copyWith(
        fontSize: 18.fSize,
        fontWeight: FontWeight.w500,
      );
  static get titleMediumOnPrimary => theme.textTheme.titleMedium!.copyWith(
        color: theme.colorScheme.onPrimary,
        fontWeight: FontWeight.w500,
      );

  static get titleMediumPoppinsOnPrimary =>
      theme.textTheme.titleMedium!.poppins.copyWith(
        color: theme.colorScheme.onPrimary,
        fontWeight: FontWeight.w500,
      );
  static get titleMediumRed5001 => theme.textTheme.titleMedium!.copyWith(
        color: appTheme.red5001,
      );
  static get titleMediumff18181b => theme.textTheme.titleMedium!.copyWith(
        color: Color(0XFF18181B),
        fontSize: 18.fSize,
      );

  static get titleSmallInterGray90003 =>
      theme.textTheme.titleSmall!.inter.copyWith(
        color: appTheme.gray90003,
        fontWeight: FontWeight.w500,
      );
  static get titleMediumffffffff => theme.textTheme.titleMedium!.copyWith(
        color: Color(0XFFFFFFFF),
        fontSize: 18.fSize,
      );
  static get titleSmallBlack900 => theme.textTheme.titleSmall!.copyWith(
        color: appTheme.black900,
      );

  static get titleSmallBlack900Medium => theme.textTheme.titleSmall!.copyWith(
        color: appTheme.black900,
        fontWeight: FontWeight.w500,
      );
  static get titleSmallBluegray300 => theme.textTheme.titleSmall!.copyWith(
        color: appTheme.blueGray300,
        fontWeight: FontWeight.w500,
      );
  static get titleSmallBluegray700 => theme.textTheme.titleSmall!.copyWith(
        color: appTheme.blueGray700,
        fontWeight: FontWeight.w500,
      );
  static get titleSmallBold => theme.textTheme.titleSmall!.copyWith(
        fontWeight: FontWeight.w700,
      );
  static get titleSmallGray500 => theme.textTheme.titleSmall!.copyWith(
        color: appTheme.gray500,
      );

  static get titleSmallGray5002 => theme.textTheme.titleSmall!.copyWith(
        color: appTheme.gray5002,
        fontWeight: FontWeight.w500,
      );
  static get titleSmallGray5002Bold => theme.textTheme.titleSmall!.copyWith(
        color: appTheme.gray5002,
        fontWeight: FontWeight.w700,
      );

  static get titleSmallGray500Medium => theme.textTheme.titleSmall!.copyWith(
      color: appTheme.gray500, fontWeight: FontWeight.w500, fontSize: 14.fSize);
  static get titleSmallGray500AppMedium => theme.textTheme.titleSmall!.copyWith(
      color: appTheme.black900,
      fontWeight: FontWeight.w500,
      fontSize: 14.fSize);
  static get titleSmallGray600 => theme.textTheme.titleSmall!.copyWith(
        color: appTheme.gray600,
      );
  static get titleSmallGray90003 => theme.textTheme.titleSmall!.copyWith(
        color: appTheme.gray90003,
        fontWeight: FontWeight.w500,
      );
  static get titleSmallGreen700 => theme.textTheme.titleSmall!.copyWith(
        color: appTheme.green700,
        fontWeight: FontWeight.w500,
      );
  static get titleSmallGreenA700 => theme.textTheme.titleSmall!.copyWith(
        color: appTheme.greenA700,
        fontWeight: FontWeight.w500,
      );
  static get titleSmallIndigoA20001 => theme.textTheme.titleSmall!.copyWith(
        color: appTheme.indigoA20001,
        fontWeight: FontWeight.w500,
      );
  static get titleSmallIndigoA20001Bold => theme.textTheme.titleSmall!.copyWith(
        color: appTheme.indigoA20001,
        fontWeight: FontWeight.w700,
      );

  static get labelLargeInterGray90002_1 =>
      theme.textTheme.labelLarge!.inter.copyWith(
        color: appTheme.gray90002,
      );

  static get titleLargeGray5002 => theme.textTheme.titleLarge!.copyWith(
        color: appTheme.gray5002,
        fontWeight: FontWeight.w500,
      );

  static get titleSmallGray5002_1 => theme.textTheme.titleSmall!.copyWith(
        color: appTheme.gray5002,
      );

  static get titleLargeInterGray500 =>
      theme.textTheme.titleLarge!.inter.copyWith(
        color: appTheme.gray500,
        fontWeight: FontWeight.w500,
      );
  static get titleLargeInterGray5002 =>
      theme.textTheme.titleLarge!.inter.copyWith(
        color: appTheme.gray5002,
        fontWeight: FontWeight.w500,
      );
  static get titleMediumIndigoA20001Bold =>
      theme.textTheme.titleMedium!.copyWith(
        color: appTheme.indigoA20001,
        fontWeight: FontWeight.w700,
      );
  static get titleSmallMedium => theme.textTheme.titleSmall!.copyWith(
        fontWeight: FontWeight.w500,
      );
  static get titleSmallOnPrimary => theme.textTheme.titleSmall!.copyWith(
        color: theme.colorScheme.onPrimary,
      );
  static get titleSmallOnPrimaryBold => theme.textTheme.titleSmall!.copyWith(
        color: theme.colorScheme.onPrimary,
        fontWeight: FontWeight.w700,
      );
  static get titleSmallOnPrimaryMedium => theme.textTheme.titleSmall!.copyWith(
        color: theme.colorScheme.onPrimary,
        fontWeight: FontWeight.w500,
      );
  static get titleSmallRed200 => theme.textTheme.titleMedium!.copyWith(
        color: appTheme.red200,
        fontWeight: FontWeight.w700,
      );
  static get titleSmallRed500 => theme.textTheme.titleSmall!.copyWith(
        color: appTheme.red500,
        fontWeight: FontWeight.w500,
      );

  static get labelLargeGray600Bold => theme.textTheme.labelLarge!.copyWith(
        color: appTheme.gray600,
        fontWeight: FontWeight.w700,
      );

  static get titleSmallRed700 => theme.textTheme.titleSmall!.copyWith(
        color: appTheme.red500,
        fontWeight: FontWeight.w700,
      );
  static get titleBoldGray900 => theme.textTheme.titleMedium!.copyWith(
      color: appTheme.gray900, fontWeight: FontWeight.w700, fontSize: 18.fSize);

  static get titleMediumGray900 => theme.textTheme.titleMedium!.copyWith(
      color: appTheme.gray900, fontWeight: FontWeight.w400, fontSize: 14.fSize);

  static get titleMedium400900 => theme.textTheme.titleMedium!.copyWith(
      color: appTheme.black900,
      fontWeight: FontWeight.w500,
      fontSize: 14.fSize);

  static get titleSmallBlack => theme.textTheme.titleSmall!.copyWith(
      color: appTheme.black900,
      fontWeight: FontWeight.w600,
      fontSize: 12.fSize);

  static get titlexSmallBlack => theme.textTheme.titleSmall!.copyWith(
      color: appTheme.black900,
      fontWeight: FontWeight.w400,
      fontSize: 12.fSize);
}

extension on TextStyle {
  TextStyle get inter {
    return copyWith(
      fontFamily: 'Inter',
    );
  }

  TextStyle get mukta {
    return copyWith(
      fontFamily: 'Mukta',
    );
  }

  TextStyle get poppins {
    return copyWith(
      fontFamily: 'Poppins',
    );
  }
}
