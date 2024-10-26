
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:get/get.dart';

import '../../controllers/GoogleSignInController.dart';
import '../../logging/logger_helper.dart';
import '../../utils/app-constant.dart';
import '../../utils/image_strings.dart';

import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';

import 'SignInScreen.dart';

class WelcomeScreen extends StatefulWidget {
   WelcomeScreen({super.key});

  @override
  State<StatefulWidget> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>{
  final TAG = "Myy WelcomeScreen ";
  final GoogleSignInController _googleSignInController = Get.put(GoogleSignInController());

  @override
  Widget build(BuildContext context) {
    TLoggerHelper.info("${TAG} inside build");
    return KeyboardVisibilityBuilder(
        builder: (context, isKeyboardVisible) {
          return Scaffold(
            appBar: AppBar(
              iconTheme: IconThemeData(color: Colors.white, size: 35),
              backgroundColor: AppConstant.appSecondaryColor,
              title: Text("Login Option", style: TextStyle(color: AppConstant.appTextColor)),
              centerTitle: true,
              elevation: 0,
            ),
            body: Container(
                width: Get.width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 5),
                    Column(
                      children: [
                        //show image when keyboard hide
                        Lottie.asset(TImages.emptycartAnimation3, width: 220),
                      ],
                    ),

                    SizedBox(height: 5),
                    Container(
                      margin: EdgeInsets.only(top: 20),
                      child: Text("Happy Shopping",
                          style: TextStyle(color: AppConstant.appTextColor2, fontSize: 16, fontWeight: FontWeight.bold))
                    ),

                    SizedBox(height: 50),
                    Material(
                      child: Container(
                        width: Get.width/1.2,
                        height: Get.height/12,
                        decoration: BoxDecoration(
                          color: AppConstant.appSecondaryColor,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: TextButton.icon(
                            icon: Image.asset(TImages.google,
                              width:Get.width/12,
                              height: Get.height/12),
                            label: Text("Sign In with google", style: TextStyle(color: AppConstant.appTextColor)),
                            onPressed: (){
                              _googleSignInController.signInWithGoogle();
                              //_googleSignInController.signInWithGoogle2();
                            },
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Material(
                      child: Container(
                        width: Get.width/1.2,
                        height: Get.height/12,
                        decoration: BoxDecoration(
                          color: AppConstant.appSecondaryColor,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: TextButton.icon(
                          icon: Icon(Icons.email, color: AppConstant.appTextColor, size: 35),
                          label: Text("Sign In with email", style: TextStyle(color: AppConstant.appTextColor)),
                          onPressed: (){
                            Get.to(()=>SignInScreen());
                          },
                        ),
                      ),
                    ),


                  ],
                ),
              ),
          );
        }
    );

  }

}