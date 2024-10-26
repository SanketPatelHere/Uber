import 'package:flutter/material.dart';

import '../../logging/logger_helper.dart';
import '../../utils/app-constant.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../auth-ui/WelcomeScreen.dart';

class AdminMainScreen extends StatelessWidget {
  final TAG = "Myy AdminMainScreen ";
  const AdminMainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    TLoggerHelper.info("${TAG} inside build");
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white, size: 35),
        backgroundColor: AppConstant.appMainColor,
        title: Text(AppConstant.appMainNameAdmin),
        centerTitle: true,
        actions: [
          GestureDetector(
            onTap: () async{
              //for google sign out
                GoogleSignIn googleSignIn = GoogleSignIn();
                await googleSignIn.signOut();

                //for email sign out(if login with email)
                FirebaseAuth _auth = FirebaseAuth.instance;
                await _auth.signOut();
                Get.offAll(()=>WelcomeScreen());
            },
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Icon(Icons.logout),
            ),
          )
        ],
      ),
    );
  }



}