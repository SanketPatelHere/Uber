import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/cupertino.dart';
import '../../controllers/CalculateProductRatingController.dart';
import '../../controllers/CartController.dart';
import '../../logging/logger_helper.dart';
import '../../models/CartModel.dart';
import '../../models/ProductModel.dart';
import '../../models/ReviewModel.dart';
import '../../utils/TLoaders.dart';
import '../../utils/app-constant.dart';
import '../../utils/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import 'package:url_launcher/url_launcher.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:badges/badges.dart' as badges;

import 'CartScreen.dart';

class ProductDetailScreen extends StatefulWidget {

  ProductModel productModel;
  ProductDetailScreen({
    super.key,
    required this. productModel,
  });

  @override
  State<StatefulWidget> createState() => _ProductDetailScreen();
}

class _ProductDetailScreen extends State<ProductDetailScreen> {
  final TAG = "Myy ProductDetailScreen ";
  User? user = FirebaseAuth.instance.currentUser;
  final CarouselController carouselController = CarouselController();
  CartController cartController = Get.put(CartController()); //use only for get cart count

  @override
  Widget build(BuildContext context) {
    TLoggerHelper.info("${TAG} inside build");
    final CalculateProductRatingController calculateProductRatingController = Get.put(CalculateProductRatingController(widget.productModel.productId));

    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: TColors.white, size: 35),
          backgroundColor: AppConstant.appMainColor,
          title: Text("Product Details", style: TextStyle(color: AppConstant.appTextColor),),
          centerTitle: true,
          actions: [

            Obx(() {
                return InkWell(
                        onTap: () {
                        Get.to(() => CartScreen());
                        },

                        child: Padding(
                              padding: const EdgeInsets.all(10),
                              //child: Icon(Icons.notifications, color: TColors.white, size: 35),
                              child:  badges.Badge(
                                  //badgeContent: Text('3'),
                                  badgeContent: Text("${cartController.cartCount.value}",
                                  style: TextStyle(color: Colors.white)),
                                  position: badges.BadgePosition.topEnd(top: -12, end:-8),
                                  showBadge: cartController.cartCount.value>0,
                                  child:Icon(Icons.shopping_cart, color: TColors.white, size: 35),
                                  badgeAnimation: badges.BadgeAnimation.size(
                                  animationDuration: Duration(seconds: 1),
                                  colorChangeAnimationDuration: Duration(seconds: 1),
                                  loopAnimation: false,
                                  curve: Curves.fastOutSlowIn,
                                  colorChangeAnimationCurve: Curves.easeInCubic,
                                  ),
                              )
                        )
              );

              }
            ),

           /* InkWell(
              onTap: () {
                Get.to(()=>CartScreen());
              },
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Icon(Icons.shopping_cart, color: TColors.white, size: 35),
              ),
            )*/
          ],
        ),
        body: Container(
          child: Column(
            children: [
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
                                    Text(widget.productModel.productName),
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

                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                                        label: Text("Add To Cart", style: TextStyle(color: AppConstant.appTextColor)),
                                        onPressed: () async{
                                          //Get.to(()=>SignInScreen());
                                          await checkProductExistance(uId:user!.uid);
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),


                          ],
                        ),
                      ),
                  ),

                  //for reviews section start
                  FutureBuilder(
                  future: FirebaseFirestore.instance
                      .collection("products")
                      .doc(widget.productModel.productId)
                      .collection("reviews")
                      //.doc(user!.uid)
                      .get(),
                  builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
                    if(snapshot.hasError){
                      return const Center(child: Text("No any data found!"));
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
                      return Center(child: Text("No any Reviews found!"));
                    }

                    if(snapshot.data!=null){
                      return  ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                        shrinkWrap: true,
                        physics: BouncingScrollPhysics(),
                        itemBuilder: (context, index){

                          var data = snapshot.data!.docs[index];
                          //for add data in reference for order's orderModel
                          ReviewModel reviewModel = ReviewModel(
                              customerId: data["customerId"],
                              customerName: data["customerName"],
                              customerPhone: data["customerPhone"],
                              customerDeviceToken: data["customerDeviceToken"],
                              feedback: data["feedback"],
                              rating: data["rating"],
                              createdAt: data["createdAt"],
                          );


                          return Padding(
                            padding: EdgeInsets.all(8),
                            child: Card(
                              elevation: 5,
                              child: ListTile(
                                leading: CircleAvatar(child: Text(reviewModel.customerName[0]),),
                                title: Text(reviewModel.customerName),
                                subtitle: Text(reviewModel.feedback),
                                trailing: Text(reviewModel.rating),
                                //or
                               /* trailing:  RatingBar(
                                  initialRating: double.parse(reviewModel.rating),
                                  minRating: 1,
                                  direction: Axis.horizontal,
                                  allowHalfRating: true,
                                  itemCount: 5,
                                  itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                                  ratingWidget: RatingWidget(
                                    full:  Icon(Icons.star, color: Colors.orange,),
                                    half:  Icon(Icons.star, color: Colors.deepOrange,),
                                    empty:  Icon(Icons.star, color: Colors.yellow,),
                                  ),
                                  onRatingUpdate: (rating) {
                                    print(rating);
                                    TLoggerHelper.info("${TAG} onRatingUpdate rating = "+rating.toString());
                                    ///setState(() {});
                                  },
                                ),*/
                              ),
                            ),
                          );
                        },
                      );

                    }

                    return Container();

                  }
                  )

                  //for reviews section start



            ],
          ),
        )

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
        .doc(widget.productModel.productId.toString());

        DocumentSnapshot snapshot = await documentReference.get();

        //product already exist - just add new quantity and price
        if(snapshot.exists){
            int currentQuantity = snapshot["productQuantity"]; //latest value get from firebase
            int updatedQuantity = currentQuantity + quantityIncrement;
            //100*1=100
            //100*2=200
            //100*3=300
            //double totalPrice = double.parse(widget.productModel.fullPrice)*updatedQuantity;
            double totalPrice = double.parse(widget.productModel.isSale
            ?widget.productModel.salePrice
            :widget.productModel.fullPrice)*updatedQuantity;

            //for just add new quantity and price
            await documentReference.update({
              "productQuantity":updatedQuantity,
              "productTotalPrice":totalPrice,
            });
            TLoggerHelper.info("${TAG} checkProductExistance uId = "+uId+" "+widget.productModel.productName+" updated");
            TLoaders.successSnakeBar(title: "Product "+widget.productModel.productName, message: "updated successfully into cart");
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
              categoryId: widget.productModel.categoryId,
              categoryName: widget.productModel.categoryName,
              createdAt: DateTime.now().toString(),
              updatedAt: DateTime.now().toString(),
              deliveryTime: widget.productModel.deliveryTime,
              productId: widget.productModel.productId,
              productName: widget.productModel.productName,
              productDescription: widget.productModel.productDescription,
              fullPrice: widget.productModel.fullPrice,
              salePrice: widget.productModel.salePrice,
              isSale: widget.productModel.isSale,
              productImage: widget.productModel.productImage,
              productQuantity: 1,
              //productTotalPrice: double.parse(widget.productModel.fullPrice)
              productTotalPrice: double.parse(widget.productModel.isSale
                  ?widget.productModel.salePrice
                  :widget.productModel.fullPrice)
          );

          await documentReference.set(cartModel.toMap());
          TLoggerHelper.info("${TAG} checkProductExistance uId = "+uId+" "+widget.productModel.productName+" saved");
          TLoaders.successSnakeBar(title: "Product "+widget.productModel.productName, message: "added successfully into cart");

        }


    }

     Future<void> sendMessageOnWhastapp({required ProductModel productModel}) async{
        final number = "919106123343";
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
