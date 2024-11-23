
import 'package:flutter/material.dart';

import '../../utils/colors.dart';

class TCheckboxTheme{
  TCheckboxTheme._();

  static CheckboxThemeData lightCheckBoxTheme = CheckboxThemeData(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      checkColor: WidgetStateProperty.resolveWith((states) {
           if(states.contains(WidgetState.selected)){
             return TColors.white;
           }
           else{
             return TColors.black;
           }
      }),
      fillColor: WidgetStateProperty.resolveWith((states) {
        if(states.contains(WidgetState.selected)){
          return TColors.primary;
        }
        else{
          return TColors.transparent;
        }
      }),
  );

  static CheckboxThemeData darkCheckBoxTheme = CheckboxThemeData(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
    checkColor: WidgetStateProperty.resolveWith((states) {
      if(states.contains(WidgetState.selected)){
        return TColors.white;
      }
      else{
        return TColors.black;
      }
    }),
    fillColor: WidgetStateProperty.resolveWith((states) {
      if(states.contains(WidgetState.selected)){
        return TColors.primary;
      }
      else{
        return TColors.transparent;
      }
    }),
  );
}