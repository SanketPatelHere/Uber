import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:flutter/cupertino.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../controllers/CalculateProductRatingController.dart';
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

import 'AddReviewScreen.dart';
import 'SpecificCustomerScreen.dart';


class AllProductDetailScreen extends StatefulWidget {
    ProductModel productModel;
    AllProductDetailScreen({
      super.key,
      required this. productModel,
    });

  @override
  State<StatefulWidget> createState() => _AllProductDetailScreen();
}

class _AllProductDetailScreen extends State<AllProductDetailScreen> {
  final TAG = "Myy AllProductDetailScreen ";
  final CarouselController carouselController = CarouselController();
  final CartController cartController = Get.put(CartController());

  @override
  Widget build(BuildContext context) {
    TLoggerHelper.info("${TAG} inside build");
    User? user = FirebaseAuth.instance.currentUser;
    GetProductLengthController getProductLengthController = Get.put(GetProductLengthController());
    final CalculateProductRatingController calculateProductRatingController = Get.put(CalculateProductRatingController(widget.productModel.productId));

    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: TColors.white, size: 35),
          backgroundColor: AppConstant.appMainColor,
          title: Obx((){
            return Text("Products (${getProductLengthController.productControllerLength.toString()})",
                style: TextStyle(color: AppConstant.appTextColor));
          }),
          centerTitle: true,
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

                return SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.only(top: 10, bottom: 10, left: 10, right: 10),
                    child: Container(
                      child: Column(
                        children: [

                          //for order's product image slider
                          CarouselSlider(
                              items:widget.productModel.productImage.map((imageUrls)=>

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
                                          Text("Product Name : "+widget.productModel.productName),
                                          Icon(Icons.favorite_border_outlined)
                                        ],
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: Container(
                                      alignment: Alignment.topLeft,
                                      child: widget.productModel.isSale==true && widget.productModel.salePrice!=""
                                          ?Text("Sale Price : "+widget.productModel.salePrice)
                                          :Text("Full Price : "+widget.productModel.fullPrice),
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
                                      child: Text("Category : "+widget.productModel.categoryName),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: Container(
                                      alignment: Alignment.topLeft,
                                      child: Text("Product Description : "+widget.productModel.productDescription),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: Container(
                                      alignment: Alignment.topLeft,
                                      child: Text("Product Id : "+widget.productModel.productId.toString()),
                                    ),
                                  ),

                                  Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: Container(
                                      alignment: Alignment.topLeft,
                                      child: widget.productModel.isSale==true
                                          ?Text("Product Sale : "+"True")
                                          :Text("Product Sale : "+"False")
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: Container(
                                      alignment: Alignment.topLeft,
                                      child: Text("Product Delivery Time : "+widget.productModel.deliveryTime.toString()),
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
                                                sendMessageOnWhastapp(productModel: widget.productModel);
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

  //send message from admin to specific user
  Future<void> sendMessageOnWhastapp({required ProductModel productModel}) async{
    final number = "919106123343";
    //final number = productModel.customerPhone.toString();
    final message = "Ecomm \n This is order enquiry for product \n ${productModel.productName} \n ${productModel.productId} \n price : ${productModel.fullPrice}";

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
