import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/cupertino.dart';
import '../../controllers/CartController.dart';
import '../../controllers/GetProductLengthController.dart';
import '../../controllers/GetUserLengthController.dart';
import '../../logging/logger_helper.dart';
import '../../models/OrderModel.dart';
import '../../models/ProductModel.dart';
import '../../utils/app-constant.dart';
import '../../utils/colors.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'AddProductScreen.dart';
import 'AddReviewScreen.dart';
import 'AllProductDetailScreen.dart';
import 'SpecificCustomerScreen.dart';


class AllProductsScreen extends StatefulWidget {

  AllProductsScreen({
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _AllProductsScreen();
}

class _AllProductsScreen extends State<AllProductsScreen> {
  final TAG = "Myy AllProductsScreen ";
  final CarouselController carouselController = CarouselController();
  final CartController cartController = Get.put(CartController());

  @override
  Widget build(BuildContext context) {
    TLoggerHelper.info("${TAG} inside build");
    User? user = FirebaseAuth.instance.currentUser;
    GetProductLengthController getProductLengthController = Get.put(GetProductLengthController());

    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: TColors.white, size: 35),
          backgroundColor: AppConstant.appMainColor,
          title: Obx((){
            return Text("Products (${getProductLengthController.productControllerLength.toString()})",
                style: TextStyle(color: AppConstant.appTextColor));
          }),
          centerTitle: true,
          actions: [
            GestureDetector(
              onTap: ()=>Get.to(()=>AddProductScreen()),
              child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Icon(Icons.add),
              ),
            )
          ],
        ),

        body:
        //FutureBuilder(
        StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection("products")
                //.orderBy("createdAt ", descending: true) //for show new order at top
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
                return Center(child: Text("No any Products found!"));
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

                          var productData = snapshot.data!.docs[index];
                          ProductModel productModel = ProductModel(
                            categoryId: productData["categoryId"],
                            categoryName: productData["categoryName"],
                            createdAt: productData["createdAt"],
                            updatedAt: productData["updatedAt"],
                            deliveryTime: productData["deliveryTime"],
                            productId: productData["productId"],
                            productName: productData["productName"],
                            productDescription: productData["productDescription"],
                            fullPrice: productData["fullPrice"],
                            salePrice: productData["salePrice"],
                            isSale: productData["isSale"],
                            productImage: productData["productImage"],
                          );
                          
                          return Card(
                            color: AppConstant.appTextColor,
                            elevation: 5,
                            child: ListTile(
                              //onTap: ((){ Get.to()=>SpecificCustomerScreen(snapshot.data!.docs[index]["uId"], customerName:snapshot.data!.docs[index]["customerName"]));
                              onTap: (){
                                Get.to(()=>AllProductDetailScreen(productModel: productModel));
                              },
                              leading: CircleAvatar(
                               /*errorListerner:(error){
                                  Icon(Icons.error),
                                },*/
                                //backgroundColor: AppConstant.appTextColor,
                                //child: Text("N"),
                                backgroundImage:NetworkImage(productModel.productImage[0]),
                                //backgroundImage:CachedNetworkImage(imageUrl:orderModel.productImage[0]),
                              ),
                              //title: Text("New Dress for womens"),
                              title:Text(productModel.productName, style: Theme.of(context).textTheme.bodyMedium),
                              subtitle:Text(productModel.productDescription, style: Theme.of(context).textTheme.bodyMedium),
                              trailing:Icon(Icons.arrow_forward_ios),
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
