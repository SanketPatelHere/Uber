import 'package:flutter/material.dart';

class TColors{

    //class cannot be instantiated from outside of the library.
    TColors._(); //named private constructor, copy constructor
    //app bar colors
    //static const Color primary = Color(0xFF4b68ff);
    ///static const Color primary = Colors.blue;
    static const Color primary = Color(0XFFFFE400);
    //static const Color secondary = Color(0xFFFFE24B);
    ///static const Color secondary = Colors.yellow;
    static const Color secondary = Color(0XFF272727);
    //static const Color accent = Color(0xFFb0c7ff);
    static const Color accent = Colors.blueAccent;


    //gradient colors
    static const Gradient linearGradient = LinearGradient(
      begin: Alignment(0.0, 0.0),
      end: Alignment(0.707, -0.707),
        colors: [
          Color(0x0fff9a9e),
          Color(0x0ffad8c4),
          Color(0x0ffad8c4),
        ]
    );


    //text colors
    static const Color textPrimary = Color(0xFF333333);
    static const Color textSecondary = Color(0xFF6C7570);
    static const Color textWhite = Colors.white;
    static const Color transparent = Colors.transparent;
    static const Color orange = Colors.orange;
    static const Color red = Colors.red;
    static const Color green = Colors.green;

    //background colors
    static const Color light = Color(0xFFF6F6F6);
    static const Color dark = Color(0xFF272727);
    static const Color primaryBackground = Color(0xFFF3F5FF);

    //background container colors
    static const Color lightContainer = Color(0xFFF6F6F6);
    //static const Color darkContainer = TColors.white.withOpacity(0.1);
    static const Color darkContainer = Color(0xFF272727);

    //button colors
    static const Color buttonPrimary = Color(0xFF4b68ff);
    static const Color buttonSecondary = Color(0xFF6c7570);
    static const Color buttonDisabled = Color(0xFFC4C4C4);

    //border colors
    static const Color borderPrimary = Color(0xFFD9D9D9);
    static const Color borderSecondary = Color(0xFFE6E6E6);

    //Error and Validation Colors
    static const Color error = Color(0xFFD32F2F);
    static const Color success = Color(0xFF388E3C);
    static const Color warning = Color(0xFFF57C00);
    static const Color info = Color(0xFF197602);


    //Neutral Shades
    static const Color black = Colors.black;
    static const Color black12 = Colors.black12;
    static const Color darkerGrey = Color(0xFF4F4F4F);
    static const Color darkGrey = Color(0xFF939393);
    static const Color grey = Color(0xFFE0E0E0);
    static const Color grey2 = Color(0xFF968B8A);
    static const Color softGrey = Color(0xfff7f7f7);
    static const Color lightGrey = Color(0x0ff9f9f9);
    static const Color white = Colors.white;

    static const Color background = Color(0xFFfafafc);
    static const Color sliverBackground = Color(0xFFfafafc);
    static const Color menu1Color = Color(0xFFf9d263);
    static const Color menu2Color = Color(0xFFf2603d);
    static const Color menu3Color = Color(0xFF04abe6);
    static const Color tabbarViewColor = Color(0xFFfdfdfd);




}