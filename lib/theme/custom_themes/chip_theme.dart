
import 'package:flutter/material.dart';

import '../../utils/colors.dart';

class TChipTheme{
  TChipTheme._();

  static ChipThemeData lightChipTheme= ChipThemeData(
      disabledColor: TColors.grey.withOpacity(0.4),
      labelStyle: const TextStyle(color: TColors.black),
      selectedColor: TColors.primary,
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
      checkmarkColor: TColors.white,
  );

  static ChipThemeData darkChipTheme= ChipThemeData(
    //disabledColor: TColors.grey.withOpacity(0.4),
    disabledColor: TColors.darkerGrey,
    labelStyle: const TextStyle(color: TColors.white),
    selectedColor: TColors.primary,
    padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
    checkmarkColor: TColors.white,
  );

}