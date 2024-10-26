import 'package:flutter/material.dart';

class KeyboardUtil{

  //for when keyboard open and user navigate to another screen then hide keyboard
  static void hideKeyboard(BuildContext context){
    FocusScopeNode currentFocus = FocusScope.of(context);
    if(!currentFocus.hasPrimaryFocus){
      currentFocus.unfocus();
    }
  }
}