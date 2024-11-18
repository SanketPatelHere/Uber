
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../utils/app-constant.dart';


import 'package:firebase_auth/firebase_auth.dart';


import 'package:google_sign_in/google_sign_in.dart';

import '../auth-ui/WelcomeScreen.dart';
import 'AllCategoriesScreen.dart';
import 'AllOrderScreen.dart';
import 'AllProductsScreen.dart';
import 'AllUsersScreen.dart';

class MyDrawerWidget extends StatefulWidget {
  const MyDrawerWidget({super.key});

  @override
  State<StatefulWidget> createState() => _MyDrawerWidgetState();
}

class _MyDrawerWidgetState extends State<MyDrawerWidget> {
  final TAG = "Myy MyDrawerWidget ";


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: Get.height/25),
      child: Drawer(
          //backgroundColor:Colors.green,
          backgroundColor:AppConstant.appSecondaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(15),
              bottomRight: Radius.circular(15),
            ),
          ),
         child: Wrap(
            runSpacing: 10,
            children: [
                Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                    child: ListTile(
                      titleAlignment: ListTileTitleAlignment.center,
                      leading: CircleAvatar(
                        radius: 22,
                        backgroundColor: AppConstant.appMainColor,
                        child: Text("SR", style: TextStyle(color: AppConstant.appTextColor)),
                      ),
                      title: Text("Ecomm Admin", style: TextStyle(color: AppConstant.appTextColor)),
                      subtitle: Text("Version 1.0.0", style: TextStyle(color: AppConstant.appTextColor)),
                    ),
                ),

              Divider(
                indent: 10,
                endIndent: 10,
                thickness: 1.5,
                color: Colors.grey.shade500,
              ),

              //Home
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: ListTile(
                  titleAlignment: ListTileTitleAlignment.center,
                  leading: Icon(Icons.home, color: AppConstant.appTextColor),
                  title: Text("Home", style: TextStyle(color: AppConstant.appTextColor)),
                  trailing: Icon(Icons.arrow_forward, color: AppConstant.appTextColor),
                ),
              ),

              //Users
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: ListTile(
                  titleAlignment: ListTileTitleAlignment.center,
                  leading: Icon(Icons.person, color: AppConstant.appTextColor),
                  title: Text("Users", style: TextStyle(color: AppConstant.appTextColor)),
                  trailing: Icon(Icons.arrow_forward, color: AppConstant.appTextColor),
                  onTap: (){
                    Get.back(); //for close drawer
                    Get.to(()=>AllUsersScreen());
                  },
                ),
              ),

              //Orders
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: ListTile(
                  titleAlignment: ListTileTitleAlignment.center,
                  leading: Icon(Icons.shopping_bag_outlined, color: AppConstant.appTextColor),
                  title: Text("Orders", style: TextStyle(color: AppConstant.appTextColor)),
                  trailing: Icon(Icons.arrow_forward, color: AppConstant.appTextColor),
                  onTap: (){
                    Get.back(); //for close drawer
                    Get.to(()=>AllOrderScreen());
                  },
                ),
              ),

              //Reviews
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: ListTile(
                  titleAlignment: ListTileTitleAlignment.center,
                  leading: Icon(Icons.reviews, color: AppConstant.appTextColor),
                  title: Text("Reviews", style: TextStyle(color: AppConstant.appTextColor)),
                  trailing: Icon(Icons.arrow_forward, color: AppConstant.appTextColor),
                ),
              ),


              //Products
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: ListTile(
                  titleAlignment: ListTileTitleAlignment.center,
                  leading: Icon(Icons.production_quantity_limits, color: AppConstant.appTextColor),
                  title: Text("Products", style: TextStyle(color: AppConstant.appTextColor)),
                  trailing: Icon(Icons.arrow_forward, color: AppConstant.appTextColor),
                  onTap: (){
                    Get.back(); //for close drawer
                    Get.to(()=>AllProductsScreen());
                  },
                ),
              ),

              //Categories
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: ListTile(
                  titleAlignment: ListTileTitleAlignment.center,
                  leading: Icon(Icons.category, color: AppConstant.appTextColor),
                  title: Text("Category", style: TextStyle(color: AppConstant.appTextColor)),
                  trailing: Icon(Icons.arrow_forward, color: AppConstant.appTextColor),
                  onTap: (){
                    Get.back(); //for close drawer
                    Get.to(()=>AllCategoriesScreen());
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: ListTile(
                  titleAlignment: ListTileTitleAlignment.center,
                  leading: Icon(Icons.help, color: AppConstant.appTextColor),
                  title: Text("Contact", style: TextStyle(color: AppConstant.appTextColor)),
                  trailing: Icon(Icons.arrow_forward, color: AppConstant.appTextColor),
                ),
              ),


              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: ListTile(
                  onTap: () async{
                    //for google sign out
                    GoogleSignIn googleSignIn = GoogleSignIn();
                    await googleSignIn.signOut();

                    //for email sign out(if login with email)
                    FirebaseAuth _auth = FirebaseAuth.instance;
                    await _auth.signOut();
                    Get.offAll(()=>WelcomeScreen());
                  },
                  titleAlignment: ListTileTitleAlignment.center,
                  leading: Icon(Icons.logout, color: AppConstant.appTextColor),
                  title: Text("Logout", style: TextStyle(color: AppConstant.appTextColor)),
                  trailing: Icon(Icons.arrow_forward, color: AppConstant.appTextColor),
                ),
              ),

            ],
        ),
      ),
    );
  }
}
