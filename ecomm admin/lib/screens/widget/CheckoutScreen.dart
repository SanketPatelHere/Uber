import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/cupertino.dart';
import '../../controllers/CartController.dart';
import '../../controllers/placeorder.dart';
import '../../logging/logger_helper.dart';
import '../../models/CartModel.dart';
import '../../services/getCustomerDeviceToken.dart';
import '../../services/getserverkey.dart';
import '../../utils/TLoaders.dart';
import '../../utils/app-constant.dart';
import '../../utils/colors.dart';

import 'package:flutter_swipe_action_cell/flutter_swipe_action_cell.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';


class CheckoutScreen extends StatefulWidget {

  CheckoutScreen({
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _CheckoutScreen();
}

class _CheckoutScreen extends State<CheckoutScreen> {
  final TAG = "Myy CheckoutScreen ";
  final CarouselController carouselController = CarouselController();
  final CartController cartController = Get.put(CartController());

  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController addressController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    TLoggerHelper.info("${TAG} inside build");
    User? user = FirebaseAuth.instance.currentUser;

    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: TColors.white, size: 35),
          backgroundColor: AppConstant.appMainColor,
          title: Text("Checkout", style: TextStyle(color: AppConstant.appTextColor),),
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
                                    Text("Qty: "+cartModel.productQuantity.toString()),

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
                       //Get.to(()=>SignInScreen());
                       showCustomBottomSheet();
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


  void showCustomBottomSheet(){
      Get.bottomSheet(
          Container(
                height: 300,
              //height: Get.height*0.8,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(16)
                ),
              ),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 10),
                  Padding(
                      padding: const EdgeInsets.only(top: 5, bottom: 5, left: 10,  right: 10),
                      child: Container(
                        height: 55,
                        child: TextFormField(
                          controller: nameController,
                          decoration: InputDecoration(
                            labelText: "Name",
                            //label: "sss",
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 10
                            ),
                            hintStyle: TextStyle(
                              fontSize: 12
                            )
                          ),
                        ),
                      ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 5, bottom: 5, left: 10,  right: 10),
                    child: Container(
                      height: 55,
                      child: TextFormField(
                        controller: phoneController,
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                            labelText: "Phone",
                            //label: "sss",
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 10
                            ),
                            hintStyle: TextStyle(
                                fontSize: 12
                            )
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 5, bottom: 5, left: 10,  right: 10),
                    child: Container(
                      height: 55,
                      child: TextFormField(
                        controller: addressController,
                        textInputAction: TextInputAction.done,
                        decoration: InputDecoration(
                            labelText: "Address",
                            //label: "sss",
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 10
                            ),
                            hintStyle: TextStyle(
                                fontSize: 12
                            )
                        ),
                      ),
                    ),
                  ),

                  /*Material(
                    child: Container(
                      width: Get.width/2,
                      height: Get.height/18,
                      decoration: BoxDecoration(
                        color: AppConstant.appSecondaryColor,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: TextButton(
                          child: Text("Confirm Order",
                          style: TextStyle(color: AppConstant.appTextColor),),
                          onPressed: (){},
                      ),
                    ),
                  ),*/

                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppConstant.appMainColor,
                      padding: EdgeInsets.fromLTRB(10,10,10,10)
                    ),
                    child: Text("Place Order",
                      style: TextStyle(color: Colors.white),),
                      onPressed: () async{

                         //todo for get firebase server key start
                          GetServerKey getServerKey = GetServerKey();
                          await getServerKey.getServerKeyToken();
                          //todo for get firebase server key end

                          if(nameController.text!="" && phoneController.text!="" && addressController.text!="")
                          {
                              String name = nameController.text.trim();
                              String phone = phoneController.text.trim();
                              String address = addressController.text.trim();

                              String customerDeviceToken = await getCustomerDeviceToken();
                              TLoggerHelper.info("${TAG}  placeorder name = "+name);
                              TLoggerHelper.info("${TAG}  placeorder phone = "+phone);
                              TLoggerHelper.info("${TAG}  placeorder address = "+address);
                              TLoggerHelper.info("${TAG}  placeorder customerDeviceToken = "+customerDeviceToken);

                              placeOrder(
                                context: context,
                                customerName: name,
                                customerPhone: phone,
                                customerAddress: address,
                                customerDeviceToken: customerDeviceToken,
                              );
                          }
                          else
                          {
                            TLoaders.errorSnakeBar(title: "Error in placeorder ", message: "please fill all details");
                            TLoggerHelper.info("${TAG}  please fill all details");
                          }
                      },
                  ),
                  SizedBox(height: 10),

                ],
              ),
            ),
          ),

        backgroundColor: Colors.transparent,
        isDismissible: true,
        enableDrag: true,
        elevation: 6,
      );
  }
}
