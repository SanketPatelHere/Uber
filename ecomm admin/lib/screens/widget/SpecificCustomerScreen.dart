import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/cupertino.dart';
import '../../controllers/CartController.dart';
import '../../logging/logger_helper.dart';
import '../../models/OrderModel.dart';
import '../../utils/app-constant.dart';
import '../../utils/colors.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'AddReviewScreen.dart';
import 'SpecificOrderDetailScreen.dart';


class SpecificCustomerScreen extends StatefulWidget {
  String docId;
  String customerName;
  SpecificCustomerScreen({
    super.key,
    required this.docId,
    required this.customerName,
  });

  @override
  State<StatefulWidget> createState() => _SpecificCustomerScreen();
}

class _SpecificCustomerScreen extends State<SpecificCustomerScreen> {
  final TAG = "Myy SpecificCustomerScreen ";
  final CarouselController carouselController = CarouselController();
  final CartController cartController = Get.put(CartController());

  @override
  Widget build(BuildContext context) {
    TLoggerHelper.info("${TAG} inside build");
    User? user = FirebaseAuth.instance.currentUser;

    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: TColors.white, size: 35),
          backgroundColor: AppConstant.appMainColor,
          title: Text(widget.customerName, style: TextStyle(color: AppConstant.appTextColor),),
          centerTitle: true,
        ),

      body:
      //FutureBuilder(
      StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("orders")
              .doc(user!.uid)
              .collection("confirmOrders")
              .orderBy("createdAt", descending: true) //for show new order at top
          //.get(),
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
                        //for add data in reference for order's orderModel
                        OrderModel orderModel = OrderModel(
                          categoryName: data["categoryName"],
                          createdAt: DateTime.now().toString(), //date of order placed
                          //updatedAt: DateTime.now().toString(),
                          updatedAt: data["updatedAt"], //date of product added into cart added
                          deliveryTime: data["deliveryTime"],
                          productId: data["productId"],
                          productName: data["productName"],
                          productDescription: data["productDescription"],
                          fullPrice: data["fullPrice"],
                          salePrice: data["salePrice"],
                          isSale: data["isSale"],
                          productImage: data["productImage"],
                          productQuantity: data["productQuantity"],
                          //productTotalPrice: double.parse(data.fullPrice)
                          productTotalPrice: double.parse(data["productTotalPrice"].toString()),

                          status: data["status"],
                          categoryId: data["categoryId"],
                          customerId: data["customerId"],
                          customerName: data["customerName"],
                          customerPhone: data["customerPhone"],
                          customerAddress: data["customerAddress"],
                          customerDeviceToken: data["customerDeviceToken"],
                        );


                        //for calculate product price
                        cartController.fetchProductPrice();

                        return Card(
                          color: AppConstant.appTextColor,
                          elevation: 5,
                          child: ListTile(
                            onTap: (){
                              Get.to(()=>SpecificOrderDetailScreen(docId:widget.docId, orderModel:orderModel));
                            },
                            leading: CircleAvatar(
                              backgroundColor: AppConstant.appTextColor,
                              //child: Text("N"),
                              backgroundImage:NetworkImage(orderModel.productImage[0]),
                              //backgroundImage:CachedNetworkImage(imageUrl:orderModel.productImage[0]),
                            ),
                            //title: Text("New Dress for womens"),
                            title: Text(orderModel.productName),
                            subtitle: Container(
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(orderModel.productTotalPrice.toString()),

                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text("Qty: "+orderModel.productQuantity.toString()),
                                      SizedBox(width: 15),
                                      //status = true => Delivered, Review
                                      orderModel.status!=true
                                          ?Text("Pending...", style:  Theme.of(context).textTheme.labelMedium!.apply(color: TColors.red),)
                                          :Text("Delivered...", style:  Theme.of(context).textTheme.labelMedium!.apply(color: TColors.green),)

                                    ],
                                  ),

                                ],

                              ),
                            ),
                            //status = true => Delivered, Review
                            trailing: orderModel.status==true
                                ?ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: AppConstant.appMainColor,
                                    padding: EdgeInsets.all(6)
                                ),
                                onPressed: ()=>Get.to(()=>AddReviewScreen(orderModel:orderModel)),
                                child: Text("Review", style:  Theme.of(context).textTheme.labelMedium!.apply(color: TColors.white),))
                                :SizedBox.shrink(),
                          ),
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
