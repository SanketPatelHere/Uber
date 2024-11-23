import 'package:flutter/material.dart';

import '../../utils/colors.dart';

class TOutlineButtonTheme{
  //._() = private constructor = for avoid creating instance
  TOutlineButtonTheme._();

  static final lightOutlineButtonTheme = OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
          elevation: 0,
          foregroundColor: TColors.black,
          side: const BorderSide(color: TColors.primary),
          textStyle: const TextStyle(fontSize: 16, color:TColors.black, fontWeight: FontWeight.w600),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
  );

  static final darkOutlineButtonTheme = OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      elevation: 0,
      foregroundColor: TColors.white,
      side: const BorderSide(color: TColors.primary),
      textStyle: const TextStyle(fontSize: 16, color:TColors.white, fontWeight: FontWeight.w600),
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
    ),
  );

}