
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:get/get.dart';

import '../../MainScreen.dart';
import '../../utils/global.dart';
import '../admin-panel/AdminMainScreen.dart';
import '../../services/GetDeviceTokenController.dart';
import '../../controllers/GetUserDataController.dart';
import '../../controllers/SignInController.dart';
import '../../logging/logger_helper.dart';
import '../../utils/TLoaders.dart';
import '../../utils/app-constant.dart';
import '../../utils/image_strings.dart';

import 'package:firebase_auth/firebase_auth.dart';


import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';

import 'ForgetPasswordScreen.dart';
import 'SignUpScreen.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<StatefulWidget> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen>{
  final TAG = "Myy SignInScreen ";

  final SignInController signInController = Get.put(SignInController());
  final GetDeviceTokenController getDeviceTokenController = Get.put(GetDeviceTokenController());
  final GetUserDataController getUserDataController = Get.put(GetUserDataController());
  TextEditingController userEmail = TextEditingController();
  TextEditingController userPassword = TextEditingController();


  @override
  Widget build(BuildContext context) {
    TLoggerHelper.info("${TAG} inside build");
    return KeyboardVisibilityBuilder(
        builder: (context, isKeyboardVisible) {
          return Scaffold(
            appBar: AppBar(
              iconTheme: IconThemeData(color: Colors.white, size: 35),
              backgroundColor: AppConstant.appSecondaryColor,
              title: Text("Sign In", style: TextStyle(color: AppConstant.appTextColor),),
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

                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 5),
                      width: Get.width,
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Obx(()=>
                            TextFormField(
                              controller: userPassword,
                              //obscureText: true,
                              obscureText: SignInController.isPasswordVisible.value,
                              cursorColor: AppConstant.appSecondaryColor,
                              keyboardType: TextInputType.visiblePassword,
                              decoration: InputDecoration(
                                  hintText: "Password",
                                  prefixIcon: Icon(Icons.password),
                                  suffixIcon: GestureDetector(
                                      onTap: (){
                                        SignInController.isPasswordVisible.toggle();
                                      },
                                      child: SignInController.isPasswordVisible.value
                                          ?Icon(Icons.visibility_off)
                                          :Icon(Icons.visibility)),
                                  contentPadding: EdgeInsets.only(top: 2, left: 8),
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))
                              ),
                            ),
                      ),
                    ),
                    ),

                    SizedBox(height: 10),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 5),
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                        onTap: (){
                          Get.to(()=>ForgetPasswordScreen());
                        },
                          child: Text("Forget Password", style: TextStyle(fontWeight: FontWeight.bold, color: AppConstant.appSecondaryColor))),
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
                            child: Text("Sign In", style: TextStyle(color: AppConstant.appTextColor)),
                          onPressed: () async{
                            String email = userEmail.text.trim();
                            String password = userPassword.text.trim();
                            String userDeviceToken = getDeviceTokenController.deviceToken.toString();

                            if(email.isEmpty || password.isEmpty){
                              TLoaders.errorSnakeBar(title: "Error", message: "Please enter all details");
                            }
                            else{
                              UserCredential? userCredential = await signInController.signInMethod(email,password);

                              //todo for check user is admin or not start
                              //userData[0]["isAdmin"]==true
                              var userData = await getUserDataController.getUserData(userCredential!.user!.uid);
                              //todo for check user is admin or not end

                              if(userCredential.user!.emailVerified){
                                TLoggerHelper.info("${TAG} inside userData = "+userData.toString());
                                TLoggerHelper.info("${TAG} inside userData[0] = "+userData[0].toString());
                                TLoggerHelper.info("${TAG} inside userData[0][isAdmin] = "+userData[0]["isAdmin"].toString());

                                if(userData[0]["isAdmin"]==true){
                                    //admin
                                    TLoaders.successSnakeBar(title: "Success Admin Login", message: "Login Successfully");
                                    Get.offAll(()=>AdminMainScreen());
                                }
                                else{
                                   //user
                                  TLoaders.successSnakeBar(title: "Success User Login", message: "Login Successfully");
                                  Get.offAll(()=>MainScreen());
                                }


                                ////or other way/////
                                /*if(userData!=null){
                                      DatabaseReference ref = FirebaseDatabase.instance.ref().child("users").child(userCredential!.user!.uid);
                                      await ref.once().then((dataSnapshot){
                                       //userData[0][blockStatus] or (dataSnapshot.snapshot.value as Map)["blockStatus"]
                                      if((dataSnapshot.snapshot.value as Map)["blockStatus"]=="no")
                                      {
                                        myUserName = (dataSnapshot.snapshot.value as Map)["name"];
                                        myUserPhone = (dataSnapshot.snapshot.value as Map)["phone"];

                                        Navigator.push(context, MaterialPageRoute(builder: (c)=>const MainScreen()));

                                      }
                                      else
                                      {
                                          FirebaseAuth.instance.signOut();
                                          associateMethods.showSnackBarMsg("You are blocked. Contact admin: Sanketramani0@gmail.com", context);
                                      }
                                  });

                                }
                                else{
                                  FirebaseAuth.instance.signOut();
                                  associateMethods.showSnackBarMsg("Your record do not exists as a User.", context);
                                }*/
                                /////////


                              }
                              else{
                                TLoaders.errorSnakeBar(title: "Error", message: "Please verify your email before login");
                              }
                                                        }
                          },
                        ),
                      ),
                    ),

                    SizedBox(height: 10),
                     Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Don't have an account? ", style: TextStyle(color: AppConstant.appSecondaryColor)),
                        GestureDetector(
                            onTap: ()=>Get.offAll(()=>SignUpScreen()),
                            child: Text("Sign Up ", style: TextStyle(color: AppConstant.appSecondaryColor, fontWeight: FontWeight.bold))),
                      ],
                    )

                  ],
                ),
              ),
            ),
          );
        }
    );

  }

}