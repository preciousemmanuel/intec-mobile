import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intechpro/theme/custom_text_style.dart';
import 'package:intechpro/theme/theme_helper.dart';
import 'package:intechpro/utils/size_utils.dart';

class CustomTextFormField extends StatelessWidget {
  CustomTextFormField({
    Key? key,
    this.alignment,
    this.width,
    this.height,
    this.scrollPadding,
    this.controller,
    this.focusNode,
    this.autofocus = true,
    this.textStyle,
    this.obscureText = false,
    this.textInputAction = TextInputAction.next,
    this.textInputType = TextInputType.text,
    this.maxLines,
    this.hintText,
    this.hintStyle,
    this.prefix,
    this.prefixConstraints,
    this.suffix,
    this.suffixConstraints,
    this.contentPadding,
    this.borderDecoration,
    this.fillColor,
    this.filled = false,
    this.enabled = true,
    this.isStory = false,
    this.validator,
    this.onChange,
    this.focusDecoration,
    this.maxLength,
    this.onEditingComplete,
    this.inputFormatters,
    this.initiallyFocused = false,
    this.enableInteraction,
  }) : super(
          key: key,
        );

  final Alignment? alignment;

  final double? width;
  final double? height;

  final TextEditingController? scrollPadding;

  final TextEditingController? controller;

  final FocusNode? focusNode;
  final int? maxLength;

  final bool? autofocus;
  final bool? enabled;
  final bool? isStory;
  final TextStyle? textStyle;

  final bool? obscureText;

  final TextInputAction? textInputAction;

  final TextInputType? textInputType;

  final int? maxLines;

  final String? hintText;

  final TextStyle? hintStyle;

  final Widget? prefix;

  final BoxConstraints? prefixConstraints;

  final Widget? suffix;

  final BoxConstraints? suffixConstraints;

  final EdgeInsets? contentPadding;

  final InputBorder? borderDecoration;
  final InputBorder? focusDecoration;

  final Color? fillColor;

  final bool? filled;
  final FormFieldValidator<String>? validator;
  final Function(String val)? onChange;
  final Function()? onEditingComplete;
  final bool initiallyFocused;
  final List<TextInputFormatter>? inputFormatters;
  final bool? enableInteraction;
  @override
  Widget build(BuildContext context) {
    // Unfocus the TextFormField when the screen is first built
    if (!initiallyFocused) {
      FocusScope.of(context).requestFocus(FocusNode());
    }
    return alignment != null
        ? Align(
            alignment: alignment ?? Alignment.center,
            child: textFormFieldWidget(context),
          )
        : textFormFieldWidget(context);
  }

  Widget textFormFieldWidget(BuildContext context) => SizedBox(
        width: width ?? double.maxFinite,
        height: height ?? null,
        child: TextFormField(
          onEditingComplete: onEditingComplete,
          maxLength: maxLength,
          onChanged: onChange ?? (f) => f,
          enabled: enabled,
          scrollPadding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          controller: controller,
          focusNode: focusNode ?? FocusNode(),
          //autofocus: autofocus!,
          style: textStyle ?? theme.textTheme.titleSmall,
          obscureText: obscureText!,
          textInputAction: textInputAction,
          keyboardType: textInputType,
          maxLines: maxLines ?? 1,
          decoration: decoration,
          validator: validator,
          inputFormatters: inputFormatters,
          enableInteractiveSelection: enableInteraction,
          textAlign: isStory! ? TextAlign.center : TextAlign.start,
        ),
      );
  InputDecoration get decoration => InputDecoration(
        counterText: "",
        hintText: hintText ?? "",
        hintStyle: hintStyle ?? CustomTextStyles.titleSmallBluegray300,
        prefixIcon: prefix,
        prefixIconConstraints: prefixConstraints,
        suffixIcon: suffix,
        suffixIconConstraints: suffixConstraints,
        isDense: true,
        contentPadding: contentPadding ??
            EdgeInsets.only(
              top: 19.v,
              right: 19.h,
              bottom: 19.v,
              left: 19.v,
            ),
        fillColor: fillColor,
        filled: filled,
        border: borderDecoration ??
            OutlineInputBorder(
              borderRadius: BorderRadius.circular(30.h),
              borderSide: BorderSide(
                color: appTheme.gray200,
                width: 1,
              ),
            ),
        enabledBorder: borderDecoration ??
            OutlineInputBorder(
              borderRadius: BorderRadius.circular(30.h),
              borderSide: BorderSide(
                color: appTheme.gray200,
                width: 1,
              ),
            ),
        focusedBorder: focusDecoration ??
            OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.h),
              borderSide: BorderSide(
                color: theme.colorScheme.primary,
                width: 2,
              ),
            ),
      );
}

/// Extension on [CustomTextFormField] to facilitate inclusion of all types of border style etc
extension TextFormFieldStyleHelper on CustomTextFormField {
  static OutlineInputBorder get fillGrayTL6 => OutlineInputBorder(
        borderRadius: BorderRadius.circular(6.h),
        borderSide: BorderSide.none,
      );
  static OutlineInputBorder get fillGray => OutlineInputBorder(
        borderRadius: BorderRadius.circular(14.h),
        borderSide: BorderSide.none,
      );
  static OutlineInputBorder get fillGray5 => OutlineInputBorder(
        borderRadius: BorderRadius.circular(30.h),
        borderSide: BorderSide.none,
      );
  static OutlineInputBorder get outlineIndigoTL10 => OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.h),
        borderSide: BorderSide(
          color: appTheme.indigo100,
          width: 1,
        ),
      );
  static OutlineInputBorder get fillGrayTL8 => OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.h),
        borderSide: BorderSide.none,
      );
  static OutlineInputBorder get fillBlue => OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.h),
        borderSide: BorderSide.none,
      );
  static OutlineInputBorder get fillGrayTL14 => OutlineInputBorder(
        borderRadius: BorderRadius.circular(14.h),
        borderSide: BorderSide.none,
      );

  static OutlineInputBorder get fillGrayTL15 => OutlineInputBorder(
        borderRadius: BorderRadius.circular(14.h),
        borderSide: BorderSide(color: appTheme.gray20001, width: 1),
      );
}
