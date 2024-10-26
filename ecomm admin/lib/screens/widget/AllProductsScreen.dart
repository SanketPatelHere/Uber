import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/cupertino.dart';
import '../../logging/logger_helper.dart';
import '../../models/ProductModel.dart';
import '../../utils/app-constant.dart';
import '../../utils/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_card/image_card.dart';

import 'ProductDetailScreen.dart';

class AllProductsScreen extends StatefulWidget {
  const AllProductsScreen({super.key});

  @override
  State<StatefulWidget> createState() => _AllProductsScreen();
}

class _AllProductsScreen extends State<AllProductsScreen> {
  final TAG = "Myy AllProductsScreen ";
  final CarouselController carouselController = CarouselController();

  @override
  Widget build(BuildContext context) {
    TLoggerHelper.info("${TAG} inside build");
    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: TColors.white, size: 35),
          backgroundColor: AppConstant.appMainColor,
          title: Text("All Products", style: TextStyle(color: AppConstant.appTextColor),),
          centerTitle: true,
        ),
        body:
        FutureBuilder(
            future: FirebaseFirestore.instance
                .collection("products")
                .where("isSale", isEqualTo: false) //if isSale=false
                .get(),
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
                return Center(child: Text("No Product Found!"));
              }

              if(snapshot.data!=null){
                TLoggerHelper.info("${TAG} productData size = "+snapshot.data!.size.toString());
                return Padding(
                  padding: EdgeInsets.only(top: 10, bottom: 10, left: 10, right: 10),
                  child: Container(
                    ///color: TColors.grey2,
                    //height: Get.height/2,
                    child:  GridView.builder(
                        itemCount: snapshot.data!.docs.length,
                        shrinkWrap: true,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 5, //number of logical pixels between each child along the cross axis
                          mainAxisSpacing: 5, //number of logical pixels between each child along the main axis
                          childAspectRatio: 0.60, //ratio of the cross-axis to the main-axis extent of each child
                        ),
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


                          return Row(
                            children: [
                              GestureDetector(
                                onTap: ()=>Get.to(()=>ProductDetailScreen(productModel:productModel)),
                                child: Padding(
                                  padding: EdgeInsets.all(5),
                                  child: Container(
                                    //decoration:BoxDecoration(color: Colors.red),
                                    child: FillImageCard(
                                      color: TColors.grey2,
                                      borderRadius: 15,
                                      width: Get.width/2.3,
                                      heightImage: Get.height/6,
                                      //imageProvider: AssetImage(TImages.productImage1),
                                      imageProvider: NetworkImage(productModel.productImage[0]),
                                      ///imageProvider: Image(fit: BoxFit.contain, image: NetworkImage(productModel.productImage[0]) ) as ImageProvider,
                                      //imageProvider: CachedNetworkImage(imageUrl: imageUrls, fit: BoxFit.contain, width: Get.width-25,height:110,),
                                      //tags: [_tag('Category', () {}), _tag('Product', () {})],
                                      title: Container(
                                        //color: TColors.grey, //color or decoration
                                          decoration:BoxDecoration(color: TColors.lightGrey),
                                          child: Center(
                                              child: Text(
                                                productModel.productName, style: Theme.of(context).textTheme.bodyMedium,
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 1,
                                              )
                                          )
                                      ),
                                      //description: Text("data"),
                                      footer: Center(child: Text("Price "+productModel.fullPrice, style: Theme.of(context).textTheme.bodyMedium)),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          );
                        }

                    ),

                  ),
                );
              }

              return Container();

            }
        )

    );
  }
}
