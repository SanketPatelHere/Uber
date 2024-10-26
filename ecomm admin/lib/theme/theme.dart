
import 'package:flutter/material.dart';

import '../utils/colors.dart';
import 'custom_themes/appbar_theme.dart';
import 'custom_themes/bottom_sheet_theme.dart';
import 'custom_themes/checkbar_theme.dart';
import 'custom_themes/chip_theme.dart';
import 'custom_themes/elevated_button_theme.dart';
import 'custom_themes/outline_button_theme.dart';
import 'custom_themes/text_field_theme.dart';
import 'custom_themes/text_theme.dart';

class TAppTheme{
    TAppTheme._();

    //light theme
    static ThemeData lightTheme = ThemeData(
        useMaterial3:true,
        fontFamily: "Poppins",
        brightness: Brightness.light, //new after sdk update
        //primaryColor: Colors.blue,
        primaryColor: TColors.primary,
        textTheme: TTextTheme.lightTextTheme,
        chipTheme: TChipTheme.lightChipTheme,
        scaffoldBackgroundColor: Colors.white, //main background of screen
        appBarTheme: TAppBarTheme.lightAppBarTheme,
        checkboxTheme: TCheckboxTheme.lightCheckBoxTheme,
        bottomSheetTheme: TBottomSheetTheme.lightBottomSheetTheme,
        elevatedButtonTheme: TElevationButtonTheme.lightElevationButtonTheme,
        outlinedButtonTheme: TOutlineButtonTheme.lightOutlineButtonTheme,
        inputDecorationTheme: TTextFormFieldTheme.lightInputDecorationTheme,
        //colorScheme: ColorScheme(background: TColors.white), //comment this after main //new after sdk update
        /*colorScheme: ColorScheme( brightness: Brightness.light,
            primary: Color(0xFF0095FF),
            onPrimary: Color(0xFFFFFFFF),
            primaryContainer: Color(0xFFD3E4FF),
            onPrimaryContainer: Color(0xFF001C38),
            secondary: Color(0xFF006495),
            onSecondary: Color(0xFFFFFFFF), error: Color(0xFFFFFFFF), onError: Color(0xFFFFFFFF), surface: Color(0xFFFFFFFF), onSurface: Color(0xFFFFFFFF),),
        */

    );

    //dark theme
    static ThemeData darkTheme = ThemeData(
        //primarySwatch: Colors.deepPurple,
        primarySwatch: MaterialColor(0XFFFFE200, <int,Color>{
           50: Color(0X1AFFE200),
           100: Color(0X33FFE200),
           200: Color(0X4DFFE200),
           300: Color(0X66FFE200),
           400: Color(0X80FFE200),
           500: Color(0XFFFFE200),
           600: Color(0X99FFE200),
           700: Color(0XB3FFE200),
           800: Color(0XCCFFE200),
           900: Color(0XE6FFE200),
        }),
        useMaterial3:true,
        fontFamily: "Poppins",
        brightness: Brightness.dark,
        //backgroundColor: TColors.black,
        //primaryColor: Colors.blue,
        primaryColor: TColors.primary,
        textTheme: TTextTheme.darkTextTheme,
        chipTheme: TChipTheme.darkChipTheme,
        scaffoldBackgroundColor: Colors.black, //main background of screen
        appBarTheme: TAppBarTheme.darkAppBarTheme,
        checkboxTheme: TCheckboxTheme.darkCheckBoxTheme,
        bottomSheetTheme: TBottomSheetTheme.darkBottomSheetTheme,
        elevatedButtonTheme: TElevationButtonTheme.darkElevationButtonTheme,
        outlinedButtonTheme: TOutlineButtonTheme.darkOutlineButtonTheme,
        inputDecorationTheme: TTextFormFieldTheme.darkInputDecorationTheme,
    );
}