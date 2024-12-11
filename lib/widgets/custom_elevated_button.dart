import 'package:flutter/material.dart';
import 'package:intechpro/theme/cusotm_button_style.dart';
import 'package:intechpro/theme/theme_helper.dart';
import 'package:intechpro/utils/size_utils.dart';
import 'package:intechpro/widgets/base_button.dart';

class CustomElevatedButton extends BaseButton {
  CustomElevatedButton({
    Key? key,
    this.decoration,
    this.leftIcon,
    this.rightIcon,
    EdgeInsets? margin,
    VoidCallback? onPressed,
    ButtonStyle? buttonStyle,
    Alignment? alignment,
    TextStyle? buttonTextStyle,
    bool? isDisabled,
    this.loading = false,
    double? height,
    double? width,
    required String text,
  }) : super(
          text: text,
          onPressed: onPressed,
          buttonStyle: buttonStyle,
          isDisabled: isDisabled,
          buttonTextStyle: buttonTextStyle,
          height: height,
          width: width,
          alignment: alignment,
          margin: margin,
        );

  final BoxDecoration? decoration;

  final Widget? leftIcon;

  final Widget? rightIcon;
  final bool? loading;

  @override
  Widget build(BuildContext context) {
    return alignment != null
        ? Align(
            alignment: alignment ?? Alignment.center,
            child: buildElevatedButtonWidget,
          )
        : buildElevatedButtonWidget;
  }

  Widget get buildElevatedButtonWidget => Container(
        height: this.height ?? 60.v,
        width: this.width ?? double.maxFinite,
        margin: margin,
        decoration:
            decoration ?? CustomButtonStyles.gradientIndigoAToPrimaryDecoration,
        child: ElevatedButton(
          style: buttonStyle,
          onPressed: isDisabled ?? false ? null : onPressed ?? () {},
          child: loading!
              ? SizedBox(
                  width: 30.v,
                  height: 30.v,
                  child: CircularProgressIndicator(
                      color: theme.colorScheme.onPrimary),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    leftIcon ?? const SizedBox.shrink(),
                    Text(
                      text,
                      style: buttonTextStyle ??
                          TextStyle(
                              color: appTheme.gray100,
                              fontSize: 18.fSize,
                              fontWeight: FontWeight.w600),
                      //theme.textTheme.titleLarge,
                    ),
                    rightIcon ?? const SizedBox.shrink(),
                  ],
                ),
        ),
      );
}
