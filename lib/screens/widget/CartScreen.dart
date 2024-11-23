import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/cupertino.dart';
import '../../controllers/CartController.dart';
import '../../logging/logger_helper.dart';
import '../../models/CartModel.dart';
import '../../utils/app-constant.dart';
import '../../utils/colors.dart';

import 'package:flutter_swipe_action_cell/flutter_swipe_action_cell.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'CheckoutScreen.dart';


class CartScreen extends StatefulWidget {

  CartScreen({
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _CartScreen();
}

class _CartScreen extends State<CartScreen> {
  final TAG = "Myy CartScreen ";
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
          title: Text("Cart", style: TextStyle(color: AppConstant.appTextColor),),
          centerTitle: true,
        ),

        body:
        //FutureBuilder(
        StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection("cart")
                .doc(user!.uid)
                .collection("cartOrder")
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
                return Center(child: Text("Cart Empty!"));
              }

              if(snapshot.data!=null){
                TLoggerHelper.info("${TAG} cartData size = "+snapshot.data!.size.toString());
                return Padding(
                  padding: EdgeInsets.only(top: 10, bottom: 10, left: 10, right: 10),
                  child: Container(
                      child: ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                        shrinkWrap: true,
                        physics: BouncingScrollPhysics(),
                        itemBuilder: (context, index){

                          var cartData = snapshot.data!.docs[index];
                          CartModel cartModel = CartModel(
                            categoryId: cartData["categoryId"],
                            categoryName: cartData["categoryName"],
                            createdAt: cartData["createdAt"],
                            updatedAt: cartData["updatedAt"],
                            deliveryTime: cartData["deliveryTime"],
                            productId: cartData["productId"],
                            productName: cartData["productName"],
                            productDescription: cartData["productDescription"],
                            fullPrice: cartData["fullPrice"],
                            salePrice: cartData["salePrice"],
                            isSale: cartData["isSale"],
                            productImage: cartData["productImage"],
                            productQuantity: cartData["productQuantity"],
                            productTotalPrice: cartData["productTotalPrice"],
                          );

                          //for calculate product price
                          cartController.fetchProductPrice();

                          return SwipeActionCell(
                            key: ObjectKey(cartModel.productId),
                            trailingActions: [
                              SwipeAction(
                                  title: "Delete",
                                  forceAlignmentToBoundary: true, //align end
                                  performsFirstActionWithFullSwipe: true, //drag cell a long distance
                                  onTap: (CompletionHandler handler) async{
                                      await FirebaseFirestore.instance
                                          .collection("cart")
                                          .doc(user.uid)
                                          .collection("cartOrder")
                                          .doc(cartModel.productId)
                                          .delete();
                                  }
                              )
                            ],
                            child: Card(
                              color: AppConstant.appTextColor,
                              elevation: 5,
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: AppConstant.appTextColor,
                                  //child: Text("N"),
                                  backgroundImage:NetworkImage(cartModel.productImage[0]),
                                  //backgroundImage:CachedNetworkImage(imageUrl:cartModel.productImage[0]),
                                ),
                                //title: Text("New Dress for womens"),
                                title: Text(cartModel.productName),
                                subtitle: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(cartModel.productTotalPrice.toString()),
                                    SizedBox(width: 15),
                                    GestureDetector(
                                        onTap: ()async{
                                          if(cartModel.productQuantity>1)
                                          {
                                            await FirebaseFirestore.instance
                                                .collection("cart")
                                                .doc(user.uid)
                                                .collection("cartOrder")
                                                .doc(cartModel.productId)
                                                .update({
                                              "productQuantity":cartModel.productQuantity-1,
                                              "productTotalPrice":(double.parse(cartModel.isSale
                                                  ?cartModel.salePrice
                                                  :cartModel.fullPrice)*
                                                  (cartModel.productQuantity-1))
                                            });
                                          }

                                        },
                                        child: CircleAvatar(
                                          radius: 14,
                                          backgroundColor: AppConstant.appMainColor,
                                          child: Text("-", style: TextStyle(color: AppConstant.appTextColor)),
                                        ),
                                    ),
                                    SizedBox(width: 20),
                                    Text(cartModel.productQuantity.toString()),
                                    SizedBox(width: 20),
                                    GestureDetector(
                                      onTap: ()async{
                                        if(cartModel.productQuantity>0)
                                        {
                                          await FirebaseFirestore.instance
                                              .collection("cart")
                                              .doc(user.uid)
                                              .collection("cartOrder")
                                              .doc(cartModel.productId)
                                              .update({
                                            "productQuantity":cartModel.productQuantity+1,
                                            //"productTotalPrice":(double.parse(cartModel.fullPrice)* (cartModel.productQuantity+1)),
                                            "productTotalPrice":(double.parse(cartModel.isSale
                                              ?cartModel.salePrice
                                              :cartModel.fullPrice)* (cartModel.productQuantity+1)),
                                            //or
                                            /*"productTotalPrice":(double.parse(cartModel.fullPrice)+(double.parse(cartModel.fullPrice)*
                                                (cartModel.productQuantity+1)))*/
                                          });
                                        }

                                      },
                                      child: CircleAvatar(
                                        radius: 14,
                                        backgroundColor: AppConstant.appMainColor,
                                        child: Text("+", style: TextStyle(color: AppConstant.appTextColor)),
                                      ),
                                    ),

                                  ],
                                ),
                              ),
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
      bottomNavigationBar: Container(
        //color: TColors.grey,
        margin: EdgeInsets.all(8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Obx(()=>
            Text("Total: Rs. ${cartController.totalPrice.value.toStringAsFixed(2)}",
                  style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            SizedBox(width: 15),
            Padding(
               padding: EdgeInsets.all(3),
               child:  Material(
                 child: Container(
                   width: Get.width/2.5,
                   height: Get.height/18,
                   decoration: BoxDecoration(
                     color: AppConstant.appMainColor,
                     borderRadius: BorderRadius.circular(20),
                   ),
                   child: TextButton(
                     child: Text("Checkout", style: TextStyle(color: AppConstant.appTextColor)),
                     onPressed: (){
                       Get.to(()=>CheckoutScreen());
                       ///Get.to(()=>CheckoutScreenWithPayment());
                     },
                   ),
                 ),
               ),
            )
          ],
        ),
      ),

    );
  }
}
