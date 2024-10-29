import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:flutter/cupertino.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../controllers/CalculateProductRatingController.dart';
import '../../controllers/CartController.dart';
import '../../logging/logger_helper.dart';
import '../../models/CartModel.dart';
import '../../models/OrderModel.dart';
import '../../utils/TLoaders.dart';
import '../../utils/app-constant.dart';
import '../../utils/colors.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'AddReviewScreen.dart';


class SpecificOrderDetailScreen extends StatefulWidget {
  String docId;
  OrderModel orderModel;
  SpecificOrderDetailScreen({
    super.key,
    required this.docId,
    required this.orderModel,
  });

  @override
  State<StatefulWidget> createState() => _SpecificOrderDetailScreen();
}

class _SpecificOrderDetailScreen extends State<SpecificOrderDetailScreen> {
  final TAG = "Myy SpecificOrderDetailScreen ";
  final CarouselController carouselController = CarouselController();
  final CartController cartController = Get.put(CartController());

  @override
  Widget build(BuildContext context) {
    TLoggerHelper.info("${TAG} inside build");
    User? user = FirebaseAuth.instance.currentUser;
    final CalculateProductRatingController calculateProductRatingController = Get.put(CalculateProductRatingController(widget.orderModel.productId));

    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: TColors.white, size: 35),
          backgroundColor: AppConstant.appMainColor,
          title: Text(widget.orderModel.customerName, style: TextStyle(color: AppConstant.appTextColor),),
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
              return SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.only(top: 10, bottom: 10, left: 10, right: 10),
                  child: Container(
                     child: Column(
                       children: [

                         //for order's product image slider
                         CarouselSlider(
                             items:widget.orderModel.productImage.map((imageUrls)=>

                                 ClipRRect(borderRadius: BorderRadius.circular(20),
                                   //height not work, image show at default image size
                                   child: CachedNetworkImage(imageUrl: imageUrls, fit: BoxFit.contain, width: Get.width-25,height:110,
                                     //child: CachedNetworkImage(imageUrl: imageUrls, fit: BoxFit.contain, width: Get.width-25,
                                     placeholder: (context,url){
                                       //load url
                                       //https://www.bartonsrewards.com.au/images/banner3.png
                                       TLoggerHelper.info("${TAG} inside placeholder url = "+url);
                                       return ColoredBox(color: Colors.white,
                                         child: Center(child: CupertinoActivityIndicator(),),
                                       );
                                     },
                                     errorWidget: (context,url,error){
                                       //not load url
                                       //https://www.bartons.net.au/service
                                       TLoggerHelper.info("${TAG} inside errorWidget url = "+url);
                                       return const Icon(Icons.error);
                                     },
                                   ),
                                 ),
                             ).toList(),
                             options: CarouselOptions(
                                 scrollDirection: Axis.horizontal,
                                 autoPlay: true,
                                 aspectRatio: 2.5, //16 / 9,
                                 //aspectRatio: 16/9, //16 / 9,
                                 viewportFraction: 1 //default 0.8, each page fills 80% of the carousel(fill in whole screen only 1)
                             )
                         ),

                         Padding(
                           padding: EdgeInsets.all(8),
                           child: Card(
                             elevation: 5,
                             shape: RoundedRectangleBorder(
                               borderRadius: BorderRadius.circular(10),
                             ),
                             child: Column(
                               children: [
                                 Padding(
                                   padding: const EdgeInsets.all(8),
                                   child: Container(
                                     alignment: Alignment.topLeft,
                                     child: Row(
                                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                       children: [
                                         Text("Product Name : "+widget.orderModel.productName),
                                         Icon(Icons.favorite_border_outlined)
                                       ],
                                     ),
                                   ),
                                 ),
                                 Padding(
                                   padding: const EdgeInsets.all(8),
                                   child: Container(
                                     alignment: Alignment.topLeft,
                                     child: widget.orderModel.isSale==true && widget.orderModel.salePrice!=""
                                         ?Text("Sale Price : "+widget.orderModel.salePrice)
                                         :Text("Full Price : "+widget.orderModel.fullPrice),
                                   ),
                                 ),
                                 Padding(
                                   padding: const EdgeInsets.all(8),
                                   child: Container(
                                     alignment: Alignment.topLeft,
                                     child: Text("Product Qty : "+widget.orderModel.productQuantity.toString()),
                                   ),
                                 ),
                                 Padding(
                                   padding: const EdgeInsets.all(8),
                                   child: Container(
                                     alignment: Alignment.topLeft,
                                     child: Text("Product Total Price : "+widget.orderModel.productTotalPrice.toString()),
                                   ),
                                 ),

                                 //for rating section start
                                 //calculateProductRatingController
                                 Obx(()=>
                                     Row(
                                       children: [
                                         Container(
                                           alignment: Alignment.center,
                                           child: RatingBar.builder(
                                             glow: false, //glow on touch
                                             ignoreGestures: true, //not changable
                                             initialRating: double.parse(calculateProductRatingController.averageRating.toString()),
                                             minRating: 1,
                                             itemCount: 5,
                                             itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                                             direction: Axis.horizontal,
                                             itemBuilder: (context, _)=>Icon(Icons.star, color: Colors.amber),
                                             onRatingUpdate: (value){  },
                                           ),
                                         ),
                                         SizedBox(width: 10),
                                         Text(calculateProductRatingController.averageRating.toString()),
                                       ],
                                     ),
                                 ),
                                 //for rating section end

                                 Padding(
                                   padding: const EdgeInsets.all(8),
                                   child: Container(
                                     alignment: Alignment.topLeft,
                                     child: Text("Category : "+widget.orderModel.categoryName),
                                   ),
                                 ),
                                 Padding(
                                   padding: const EdgeInsets.all(8),
                                   child: Container(
                                     alignment: Alignment.topLeft,
                                     child: Text("Product Description : "+widget.orderModel.productDescription),
                                   ),
                                 ),
                                 Padding(
                                   padding: const EdgeInsets.all(8),
                                   child: Container(
                                     alignment: Alignment.topLeft,
                                     child: Text("Product Id : "+widget.orderModel.productId.toString()),
                                   ),
                                 ),



                                 //User info
                                 Padding(
                                   padding: const EdgeInsets.all(8),
                                   child: Container(
                                     alignment: Alignment.topLeft,
                                     child: Text("User Name : "+widget.orderModel.customerName),
                                   ),
                                 ),
                                 Padding(
                                   padding: const EdgeInsets.all(8),
                                   child: Container(
                                     alignment: Alignment.topLeft,
                                     child: Text("User Phone : "+widget.orderModel.customerPhone),
                                   ),
                                 ),
                                 Padding(
                                   padding: const EdgeInsets.all(8),
                                   child: Container(
                                     alignment: Alignment.topLeft,
                                     child: Text("User Address : "+widget.orderModel.customerAddress),
                                   ),
                                 ),
                                 Padding(
                                   padding: const EdgeInsets.all(8),
                                   child: Container(
                                     alignment: Alignment.topLeft,
                                     child: Text("User Id : "+widget.orderModel.customerId),
                                   ),
                                 ),

                                 Row(
                                   //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                   children: [
                                     Padding(
                                       padding: const EdgeInsets.all(8),
                                       child: Material(
                                         child: Container(
                                           width: Get.width/3,
                                           height: Get.height/16,
                                           decoration: BoxDecoration(
                                             color: AppConstant.appSecondaryColor,
                                             borderRadius: BorderRadius.circular(20),
                                           ),
                                           child: TextButton.icon(
                                             //icon: Icon(Icons.email, color: AppConstant.appTextColor, size: 35),
                                             label: Text("Whatsapp", style: TextStyle(color: AppConstant.appTextColor)),
                                             onPressed: (){
                                               sendMessageOnWhastapp(orderModel: widget.orderModel);
                                             },
                                           ),
                                         ),
                                       ),
                                     ),
                                     SizedBox(width: 5),
                                     /*Padding(
                                       padding: const EdgeInsets.all(8),
                                       child: Material(
                                         child: Container(
                                           width: Get.width/3,
                                           height: Get.height/16,
                                           decoration: BoxDecoration(
                                             color: AppConstant.appSecondaryColor,
                                             borderRadius: BorderRadius.circular(20),
                                           ),
                                           child: TextButton.icon(
                                             //icon: Icon(Icons.email, color: AppConstant.appTextColor, size: 35),
                                             label: Text("Add To Cart", style: TextStyle(color: AppConstant.appTextColor)),
                                             onPressed: () async{
                                               //Get.to(()=>SignInScreen());
                                               await checkProductExistance(uId:user!.uid);
                                             },
                                           ),
                                         ),
                                       ),
                                     ),*/
                                   ],
                                 ),


                               ],
                             ),
                           ),
                         ),
                       ],
                     ),
                  ),
                ),
              );
            }

            return Container();

          }
      ),


    );
  }


  //check product exist or not
  Future<void> checkProductExistance({required String uId, int quantityIncrement =1}) async{
    TLoggerHelper.info("${TAG} checkProductExistance uId = "+uId);

    //reference to check product already exist or not, based on  productId query
    final DocumentReference documentReference = FirebaseFirestore.instance
        .collection("cart")
        .doc(uId)
        .collection("cartOrder")
        .doc(widget.orderModel.productId.toString());

    DocumentSnapshot snapshot = await documentReference.get();

    //product already exist - just add new quantity and price
    if(snapshot.exists){
      int currentQuantity = snapshot["productQuantity"]; //latest value get from firebase
      int updatedQuantity = currentQuantity + quantityIncrement;
      //100*1=100
      //100*2=200
      //100*3=300
      //double totalPrice = double.parse(widget.productModel.fullPrice)*updatedQuantity;
      double totalPrice = double.parse(widget.orderModel.isSale
          ?widget.orderModel.salePrice
          :widget.orderModel.fullPrice)*updatedQuantity;

      //for just add new quantity and price
      await documentReference.update({
        "productQuantity":updatedQuantity,
        "productTotalPrice":totalPrice,
      });
      TLoggerHelper.info("${TAG} checkProductExistance uId = "+uId+" "+widget.orderModel.productName+" updated");
      TLoaders.successSnakeBar(title: "Product "+widget.orderModel.productName, message: "updated successfully into cart");
    }
    //product not exist - add new whole product model
    else{

      //for creating path reference for cart and
      await FirebaseFirestore.instance.collection("cart").doc(uId).set({
        "uId":uId,
        "createdAt":DateTime.now()
      });

      //for add data in reference for cart's cartOrder
      CartModel cartModel = CartModel(
          categoryId: widget.orderModel.categoryId,
          categoryName: widget.orderModel.categoryName,
          createdAt: DateTime.now().toString(),
          updatedAt: DateTime.now().toString(),
          deliveryTime: widget.orderModel.deliveryTime,
          productId: widget.orderModel.productId,
          productName: widget.orderModel.productName,
          productDescription: widget.orderModel.productDescription,
          fullPrice: widget.orderModel.fullPrice,
          salePrice: widget.orderModel.salePrice,
          isSale: widget.orderModel.isSale,
          productImage: widget.orderModel.productImage,
          productQuantity: 1,
          //productTotalPrice: double.parse(widget.productModel.fullPrice)
          productTotalPrice: double.parse(widget.orderModel.isSale
              ?widget.orderModel.salePrice
              :widget.orderModel.fullPrice)
      );

      await documentReference.set(cartModel.toMap());
      TLoggerHelper.info("${TAG} checkProductExistance uId = "+uId+" "+widget.orderModel.productName+" saved");
      TLoaders.successSnakeBar(title: "Product "+widget.orderModel.productName, message: "added successfully into cart");

    }


  }


  //send message from admin to specific user
  Future<void> sendMessageOnWhastapp({required OrderModel orderModel}) async{
    //final number = "919106123343";
    final number = orderModel.customerPhone.toString();
    final message = "Ecomm \n This is order enquiry for product \n ${orderModel.productName} \n ${orderModel.productId} \n price : ${orderModel.fullPrice}";

    final url = "https://wa.me/$number?text=${Uri.encodeComponent(message)}";
    TLoggerHelper.info("${TAG} sendMessageOnWhastapp url = "+url);
    if(await canLaunch(url))
    {
      await launch(url);
    }
    else
    {
      TLoggerHelper.info("${TAG} sendMessageOnWhastapp Could not launch = "+url);
      throw "Could not launch $url";
    }

  }

}
