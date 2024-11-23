import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/cupertino.dart';
import '../../controllers/CartController.dart';
import '../../controllers/GetUserLengthController.dart';
import '../../logging/logger_helper.dart';
import '../../models/OrderModel.dart';
import '../../models/UserModel.dart';
import '../../utils/app-constant.dart';
import '../../utils/colors.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'AddReviewScreen.dart';
import 'SpecificCustomerScreen.dart';


class AllUsersScreen extends StatefulWidget {

  AllUsersScreen({
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _AllUsersScreen();
}

class _AllUsersScreen extends State<AllUsersScreen> {
  final TAG = "Myy AllUsersScreen ";
  final CarouselController carouselController = CarouselController();
  final CartController cartController = Get.put(CartController());

  @override
  Widget build(BuildContext context) {
    TLoggerHelper.info("${TAG} inside build");
    User? user = FirebaseAuth.instance.currentUser;
    GetUserLengthController getUserLengthController = Get.put(GetUserLengthController());

    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: TColors.white, size: 35),
          backgroundColor: AppConstant.appMainColor,
          title: Obx((){
            return Text("Users (${getUserLengthController.userControllerLength.toString()})",
                style: TextStyle(color: AppConstant.appTextColor));
          }),
          centerTitle: true,
        ),

        body:
        //FutureBuilder(
        StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection("users")
                .orderBy("createdOn", descending: true) //for show new order at top
                .snapshots(),
            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
              if(snapshot.hasError){
                return const Center(child: Text("No Data Found!"));
              }

              if(snapshot.connectionState==ConnectionState.waiting){
                return Container(
                    height: Get.height/5,
                    child: const Center(
                      child: CupertinoActivityIndicator(),
                    )
                );
              }

              if(snapshot.data!.docs.isEmpty){
                return Center(child: Text("No any Users found!"));
              }

              if(snapshot.data!=null){
                TLoggerHelper.info("${TAG} cartData size = "+snapshot.data!.size.toString());
                return Padding(
                  padding: EdgeInsets.only(top: 10, bottom: 10, left: 10, right: 10),
                  child: Container(
                      child:
                      ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                        shrinkWrap: true,
                        physics: BouncingScrollPhysics(),
                        itemBuilder: (context, index){

                          var data = snapshot.data!.docs[index];

                          UserModel userModel = UserModel(
                              uId: data["uId"],
                              username: data["username"],
                              email: data["email"],
                              phone: data["phone"],
                              userImg: data["userImg"],
                              userDeviceToken: data["userDeviceToken"],
                              country: data["country"],
                              userAddress: data["userAddress"],
                              street: data["street"],
                              city: data["city"],
                              isAdmin: data["isAdmin"],
                              isActive: data["isActive"],
                              createdOn: data["createdOn"],
                          );

                          return Card(
                            color: AppConstant.appTextColor,
                            elevation: 5,
                            child: ListTile(
                              //onTap: ((){ Get.to()=>SpecificCustomerScreen(snapshot.data!.docs[index]["uId"], customerName:snapshot.data!.docs[index]["customerName"]));
                              onTap: (){
                                Get.to(()=>SpecificCustomerScreen(docId:data["uId"], customerName:data["customerName"]));
                              },
                              leading: CircleAvatar(
                               /*errorListerner:(error){
                                  Icon(Icons.error),
                                },*/
                                backgroundColor: AppConstant.appTextColor,
                                //child: Text("N"),
                                backgroundImage:NetworkImage(userModel.userImg),
                                //backgroundImage:CachedNetworkImage(imageUrl:orderModel.productImage[0]),
                              ),
                              //title: Text("New Dress for womens"),
                              title:Text(userModel.username),
                              subtitle:Text(userModel.email),
                              trailing:Icon(Icons.edit),
                          )
                          );
                        },
                      )
                  ),
                );
              }

              return Container();

            }
        ),

    );
  }
}
