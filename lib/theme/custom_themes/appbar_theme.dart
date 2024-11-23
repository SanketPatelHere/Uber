
import 'package:flutter/material.dart';

import '../../utils/colors.dart';

class TAppBarTheme{
  //._() = private constructor = for avoid creating instance
  TAppBarTheme._();

  static const lightAppBarTheme = AppBarTheme(
      elevation: 0,
      centerTitle: false,
      scrolledUnderElevation: 0,
      backgroundColor: TColors.transparent,
      surfaceTintColor: TColors.transparent,
      iconTheme: IconThemeData(color: TColors.black, size: 24),
      actionsIconTheme: IconThemeData(color: TColors.black, size: 24),
      titleTextStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: TColors.black),
  );

  static const darkAppBarTheme = AppBarTheme(
    elevation: 0,
    centerTitle: false,
    scrolledUnderElevation: 0,
    backgroundColor: TColors.transparent,
    surfaceTintColor: TColors.transparent,
    iconTheme: IconThemeData(color: TColors.black, size: 24),
    actionsIconTheme: IconThemeData(color: TColors.black, size: 24),
    titleTextStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: TColors.white),
  );
}