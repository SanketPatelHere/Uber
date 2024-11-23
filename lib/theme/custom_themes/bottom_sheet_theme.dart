
import 'package:flutter/material.dart';

import '../../utils/colors.dart';

class TBottomSheetTheme{
    TBottomSheetTheme._();
    static BottomSheetThemeData lightBottomSheetTheme = BottomSheetThemeData(
        showDragHandle: true,
        //backgroundColor: Colors.white,
        backgroundColor: TColors.white,
        modalBackgroundColor: TColors.white,
        constraints: const BoxConstraints(minWidth: double.infinity), //full width
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    );

    static BottomSheetThemeData darkBottomSheetTheme = BottomSheetThemeData(
        showDragHandle: true,
        //backgroundColor: Colors.black,
        backgroundColor: TColors.black,
        modalBackgroundColor: TColors.black,
        constraints: const BoxConstraints(minWidth: double.infinity),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    );
}