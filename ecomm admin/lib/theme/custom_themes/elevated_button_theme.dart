
import 'package:flutter/material.dart';

import '../../utils/colors.dart';

class TElevationButtonTheme{
  TElevationButtonTheme._();

  static final lightElevationButtonTheme = ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
          elevation: 0,
          foregroundColor: TColors.white,
          backgroundColor: TColors.primary,
          disabledForegroundColor: TColors.grey,
          disabledBackgroundColor: TColors.grey,
          side: const BorderSide(color: TColors.black),
          padding: const EdgeInsets.symmetric(vertical: 18),
          textStyle: const TextStyle(fontSize: 16, color: TColors.white,fontWeight: FontWeight.w600),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
         ),
  );

  static final darkElevationButtonTheme = ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
        elevation: 0,
        foregroundColor: TColors.black,
        backgroundColor: TColors.primary,
        disabledForegroundColor: TColors.grey,
        disabledBackgroundColor: TColors.grey,
        side: const BorderSide(color: TColors.primary),
        padding: const EdgeInsets.symmetric(vertical: 18),
        textStyle: const TextStyle(fontSize: 16, color: TColors.white,fontWeight: FontWeight.w600),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
  );
}