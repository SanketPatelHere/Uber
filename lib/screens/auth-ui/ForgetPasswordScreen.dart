
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:get/get.dart';

import '../../controllers/ForgetPasswordController.dart';
import '../../logging/logger_helper.dart';
import '../../utils/TLoaders.dart';
import '../../utils/app-constant.dart';
import '../../utils/image_strings.dart';



import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';


class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({super.key});

  @override
  State<StatefulWidget> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen>{
  final TAG = "Myy ForgetPasswordScreen ";

  final ForgetPasswordController forgetPasswordController = Get.put(ForgetPasswordController());
  TextEditingController userEmail = TextEditingController();

  @override
  Widget build(BuildContext context) {
    TLoggerHelper.info("${TAG} inside build");
    return KeyboardVisibilityBuilder(
        builder: (context, isKeyboardVisible) {
          return Scaffold(
            appBar: AppBar(
              iconTheme: IconThemeData(color: Colors.white, size: 35),
              backgroundColor: AppConstant.appSecondaryColor,
              title: Text("Forget Password", style: TextStyle(color: AppConstant.appTextColor),),
            ),
            body: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Container(
                child: Column(
                  children: [
                    SizedBox(height: 5),
                    isKeyboardVisible
                        //?SizedBox.shrink() //for hide image when keyboard open
                        ?Text("Welcome to app") //for hide image when keyboard open, and show text
                        : Column(
                      children: [
                        //show image when keyboard hide
                         Lottie.asset(TImages.emptycartAnimation3, width: 220),

                      ],
                    ),

                    SizedBox(height: Get.height/12),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 5),
                      width: Get.width,
                      child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: TextFormField(
                            controller: userEmail,
                            cursorColor: AppConstant.appSecondaryColor,
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              hintText: "Email",
                              prefixIcon: Icon(Icons.email),
                              contentPadding: EdgeInsets.only(top: 2, left: 8),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))
                            ),
                          ),
                      ),
                    ),

                    SizedBox(height: 20),
                    Material(
                      child: Container(
                        width: Get.width/2,
                        height: Get.height/20,
                        decoration: BoxDecoration(
                          color: AppConstant.appSecondaryColor,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: TextButton(
                            child: Text("Submit", style: TextStyle(color: AppConstant.appTextColor)),
                          onPressed: () async{
                            String email = userEmail.text.trim();

                            if(email.isEmpty){
                              TLoaders.errorSnakeBar(title: "Error", message: "Please enter all details");
                            }
                            else{
                                String email = userEmail.text.trim();
                                forgetPasswordController.forgetPasswordMethod(email);
                            }
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }
    );

  }

}