
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:firebase_auth/firebase_auth.dart';

import '../../controllers/SignUpController.dart';
import '../../services/GetDeviceTokenController.dart';
import '../../services/NotificationService.dart';
import '../../logging/logger_helper.dart';
import '../../utils/TLoaders.dart';
import '../../utils/app-constant.dart';

import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';

import 'SignInScreen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<StatefulWidget> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen>{
  final TAG = "Myy SignUpScreen ";

   final SignUpController signUpController = Get.put(SignUpController());
  final GetDeviceTokenController getDeviceTokenController = Get.put(GetDeviceTokenController());
   TextEditingController userName = TextEditingController();
   TextEditingController userEmail = TextEditingController();
   TextEditingController userPhone = TextEditingController();
   TextEditingController userCity = TextEditingController();
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
              title: Text("Sign Up", style: TextStyle(color: AppConstant.appTextColor),),
            ),
            body: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Container(
                child: Column(
                  children: [
                    SizedBox(height: 10),
                    Container(
                      alignment: Alignment.center,
                      child: Text("Welcome to app",
                      style: TextStyle(color: AppConstant.appSecondaryColor, fontWeight: FontWeight.bold, fontSize: 16)
                      )
                    ),

                    //SizedBox(height: Get.height/12),
                    SizedBox(height: Get.height/30),
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
                        child: TextFormField(
                          controller: userName,
                          cursorColor: AppConstant.appSecondaryColor,
                          keyboardType: TextInputType.name,
                          decoration: InputDecoration(
                              hintText: "Username",
                              prefixIcon: Icon(Icons.person),
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
                        child: TextFormField(
                          controller: userPhone,
                          cursorColor: AppConstant.appSecondaryColor,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                              hintText: "Phone",
                              prefixIcon: Icon(Icons.phone),
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
                        child: TextFormField(
                          controller: userCity,
                          cursorColor: AppConstant.appSecondaryColor,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                              hintText: "City",
                              prefixIcon: Icon(Icons.location_city),
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
                            obscureText: SignUpController.isPasswordVisible.value,
                            cursorColor: AppConstant.appSecondaryColor,
                            keyboardType: TextInputType.visiblePassword,
                            decoration: InputDecoration(
                                hintText: "Password",
                                prefixIcon: Icon(Icons.password),
                                suffixIcon: GestureDetector(
                                    onTap: (){
                                      SignUpController.isPasswordVisible.toggle();
                                    },
                                    child: SignUpController.isPasswordVisible.value
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
                      child: Text("Forget Password", style: TextStyle(fontWeight: FontWeight.bold, color: AppConstant.appSecondaryColor)),
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
                              String name = userName.text.trim();
                              String email = userEmail.text.trim();
                              String phone = userPhone.text.trim();
                              String city = userCity.text.trim();
                              String password = userPassword.text.trim();
                              String userDeviceToken = getDeviceTokenController.deviceToken.toString();

                              //or get token using
                              NotificationService notificationService = NotificationService();
                              //String userDeviceToken2 = await notificationService.getDeviceToken();


                              if(name.isEmpty || email.isEmpty || phone.isEmpty || city.isEmpty
                                  || password.isEmpty){
                                TLoaders.errorSnakeBar(title: "Error", message: "Please enter all details");
                              }
                              else{
                                UserCredential? userCredential = await signUpController.signUpMethod(name,email,phone,city,password,userDeviceToken);
                                if(userCredential!=null){
                                  TLoaders.successSnakeBar(title: "Verification email sent", message: "Please check your email");
                                  FirebaseAuth.instance.signOut();
                                  Get.offAll(()=>SignInScreen());
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
                        Text("Already have an account? ", style: TextStyle(color: AppConstant.appSecondaryColor)),
                        GestureDetector(
                           onTap: ()=>Get.offAll(()=>SignInScreen()),
                            child: Text("Sign In ", style: TextStyle(color: AppConstant.appSecondaryColor, fontWeight: FontWeight.bold))),
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