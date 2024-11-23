import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/cupertino.dart';
import '../../controllers/CartController.dart';
import '../../controllers/GetOrderLengthController.dart';
import '../../logging/logger_helper.dart';
import '../../models/OrderModel.dart';
import '../../utils/app-constant.dart';
import '../../utils/colors.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'AddReviewScreen.dart';
import 'SpecificCustomerScreen.dart';


class AllOrderScreen extends StatefulWidget {

  AllOrderScreen({
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _AllOrderScreen();
}

class _AllOrderScreen extends State<AllOrderScreen> {
  final TAG = "Myy AllOrderScreen ";
  final CarouselController carouselController = CarouselController();
  final CartController cartController = Get.put(CartController());

  @override
  Widget build(BuildContext context) {
    TLoggerHelper.info("${TAG} inside build");
    User? user = FirebaseAuth.instance.currentUser;
    GetOrderLengthController getOrderLengthController = Get.put(GetOrderLengthController());

    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: TColors.white, size: 35),
          backgroundColor: AppConstant.appMainColor,
          title: Obx((){
            return Text("Orders (${getOrderLengthController.orderControllerLength.toString()})",
                              style: TextStyle(color: AppConstant.appTextColor));
          }),
          centerTitle: true,
        ),

        body:
        //FutureBuilder(
        StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection("orders")
                .orderBy("createdAt", descending: true) //for show new order at top
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
                return Center(child: Text("No any Orders found!"));
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
                          //for calculate product price
                          cartController.fetchProductPrice();

                          return Card(
                            color: AppConstant.appTextColor,
                            elevation: 5,
                            child: ListTile(
                              //onTap: ((){ Get.to()=>SpecificCustomerScreen(snapshot.data!.docs[index]["uId"], customerName:snapshot.data!.docs[index]["customerName"]));
                              onTap: (){
                                Get.to(()=>SpecificCustomerScreen(docId:data["uId"], customerName:data["customerName"]));
                              },
                              leading: CircleAvatar(
                                backgroundColor: AppConstant.appTextColor,
                                child: Text(data["customerName"][0]),
                                //backgroundImage:NetworkImage((data["customerName"][0])),
                                //backgroundImage:CachedNetworkImage(imageUrl:orderModel.productImage[0]),
                              ),
                              //title: Text("New Dress for womens"),
                              title:Text(data["customerName"]),
                              subtitle:Text(data["customerPhone"]),
                              trailing:InkWell(
                                  /*onTap: (){
                                    showBottomSheet();
                                  },*/
                                  child: Icon(Icons.more_horiz_outlined)
                              ),
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
