import 'dart:async';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:get/get.dart';

import '../../MainScreen.dart';
import '../../logging/logger_helper.dart';
import '../../utils/app-constant.dart';
import '../../utils/image_strings.dart';

import '../../controllers/GetUserDataController.dart';

import 'package:firebase_auth/firebase_auth.dart';

import '../admin-panel/AdminMainScreen.dart';
import 'WelcomeScreen.dart';



class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<StatefulWidget> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final TAG = "Myy SplashScreen ";

  User? user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    TLoggerHelper.info("${TAG} inside initState");
    super.initState();
    Timer(const Duration(seconds: 3), () {
      loggedIn(context);

      ///Get.offAll(()=>MainScreen());
      ///Get.offAll(()=>WelcomeScreen());
      //Get.to(()=>MainScreen());
      //Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => MainScreen()));
    });
    //or

    /*Future.delayed(const Duration(seconds: 3)).then((val) {
             Get.offAll(()=>MainScreen());
            //Get.to(()=>MainScreen());
            //Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => MainScreen()));
          });*/
  }

  Future<void> loggedIn(BuildContext context) async{
    if (user != null) {
      final GetUserDataController getUserDataController = Get.put(GetUserDataController());
      var userData = await getUserDataController.getUserData(user!.uid);
      TLoggerHelper.info("${TAG} inside user!.uid = "+user!.uid.toString());
      TLoggerHelper.info("${TAG} inside userData = "+userData.toString());
      TLoggerHelper.info("${TAG} inside userData[0] = "+userData[0].toString());
      TLoggerHelper.info("${TAG} inside userData[0][isAdmin] = "+userData[0]["isAdmin"].toString());

      if (userData[0]["isAdmin"] == true) {
        //if admin
        Get.offAll(() => AdminMainScreen());
      } else {
        //if user
        Get.offAll(() => MainScreen());
      }
    } else {
      Get.offAll(() => WelcomeScreen());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstant.appMainColor,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white, size: 35),
        backgroundColor: AppConstant.appMainColor,
        elevation: 0,
      ),
      body: Container(
        child: Column(
          children: [
            Expanded(
              child: Container(
                //width: MediaQuery.of(context).size.width
                width: Get.width,
                alignment: Alignment.center,
                child: Lottie.asset(TImages.emptycartAnimation3),
              ),
            ),
            Container(
              width: Get.width,
              alignment: Alignment.center,
              margin: const EdgeInsets.only(bottom: 20),
              child: Text(
                AppConstant.appPoweredBy,
                style: const TextStyle(
                    color: AppConstant.appTextColor,
                    fontSize: 12,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
