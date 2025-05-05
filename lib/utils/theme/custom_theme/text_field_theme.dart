import 'package:flutter/material.dart';

import '../../constants/sizes.dart';

class AppTextFormFieldTheme {
  AppTextFormFieldTheme._();

  static InputDecorationTheme lightInputDecorationTheme = InputDecorationTheme(
    errorMaxLines: 3,
    prefixIconColor: Colors.grey,
    suffixIconColor: Colors.grey,

    // constraints: const BoxConstraints.expand(height: 14.inputFieldHeight),
    labelStyle: const TextStyle().copyWith(fontSize: AppSizes.inputFieldTextSize, color: Colors.black),
    hintStyle: const TextStyle().copyWith(fontSize: AppSizes.inputFieldTextSize, color: Colors.black),
    errorStyle: const TextStyle().copyWith(fontStyle: FontStyle.normal),
    floatingLabelStyle: const TextStyle().copyWith(color: Colors.black.withOpacity(0.8)),
    border: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(AppSizes.inputFieldRadius),
      borderSide: const BorderSide(width: AppSizes.inputFieldBorderWidth, color: Colors.grey)
    ),
    enabledBorder: const OutlineInputBorder().copyWith(
        borderRadius: BorderRadius.circular(AppSizes.inputFieldRadius),
        borderSide: const BorderSide(width: AppSizes.inputFieldBorderWidth, color: Colors.grey)
    ),
    focusedBorder: const OutlineInputBorder().copyWith(
        borderRadius: BorderRadius.circular(AppSizes.inputFieldRadius),
        borderSide: const BorderSide(width: AppSizes.inputFieldBorderWidth, color: Colors.black12)
    ),
    errorBorder: const OutlineInputBorder().copyWith(
        borderRadius: BorderRadius.circular(AppSizes.inputFieldRadius),
        borderSide: const BorderSide(width: AppSizes.inputFieldBorderWidth, color: Colors.red)
    ),
    focusedErrorBorder: const OutlineInputBorder().copyWith(
        borderRadius: BorderRadius.circular(AppSizes.inputFieldRadius),
        borderSide: const BorderSide(width: AppSizes.inputFieldBorderWidth, color: Colors.orange)
    ),
  );

  static InputDecorationTheme darkInputDecorationTheme = InputDecorationTheme(
    errorMaxLines: 3,
    prefixIconColor: Colors.grey,
    suffixIconColor: Colors.grey,
    // constraints: const BoxConstraints.expand(height: 14.inputFieldHeight),
    labelStyle: const TextStyle().copyWith(fontSize: AppSizes.inputFieldTextSize, color: Colors.white),
    hintStyle: const TextStyle().copyWith(fontSize: AppSizes.inputFieldTextSize, color: Colors.white),
    errorStyle: const TextStyle().copyWith(fontStyle: FontStyle.normal),
    floatingLabelStyle: const TextStyle().copyWith(color: Colors.white.withOpacity(0.8)),
    border: const OutlineInputBorder().copyWith(
        borderRadius: BorderRadius.circular(AppSizes.inputFieldRadius),
        borderSide: const BorderSide(width: AppSizes.inputFieldBorderWidth, color: Colors.grey)
    ),
    enabledBorder: const OutlineInputBorder().copyWith(
        borderRadius: BorderRadius.circular(AppSizes.inputFieldRadius),
        borderSide: const BorderSide(width: AppSizes.inputFieldBorderWidth, color: Colors.grey)
    ),
    focusedBorder: const OutlineInputBorder().copyWith(
        borderRadius: BorderRadius.circular(AppSizes.inputFieldRadius),
        borderSide: const BorderSide(width: AppSizes.inputFieldBorderWidth, color: Colors.white)
    ),
    errorBorder: const OutlineInputBorder().copyWith(
        borderRadius: BorderRadius.circular(AppSizes.inputFieldRadius),
        borderSide: const BorderSide(width: AppSizes.inputFieldBorderWidth, color: Colors.red)
    ),
    focusedErrorBorder: const OutlineInputBorder().copyWith(
        borderRadius: BorderRadius.circular(AppSizes.inputFieldRadius),
        borderSide: const BorderSide(width: AppSizes.inputFieldBorderWidth, color: Colors.orange)
    ),
  );
}