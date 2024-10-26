import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/cupertino.dart';
import '../../controllers/BannerController.dart';
import '../../logging/logger_helper.dart';
import '../../models/ProductModel.dart';
import '../../utils/app-constant.dart';
import '../../utils/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_card/image_card.dart';

import 'ProductDetailScreen.dart';

class AllSingleCategoryProductScreen extends StatefulWidget {
  String categoryId;
  String categoryName;
   AllSingleCategoryProductScreen({
    super.key,
    required this. categoryId,
    required this. categoryName
  });

  @override
  State<StatefulWidget> createState() => _AllSingleCategoryProductScreenState();
}

class _AllSingleCategoryProductScreenState extends State<AllSingleCategoryProductScreen> {
  final TAG = "Myy AllSingleCategoryProductScreen ";
  final CarouselController carouselController = CarouselController();
  final BannerController bannerController = Get.put(BannerController());

  @override
  Widget build(BuildContext context) {
    TLoggerHelper.info("${TAG} inside build");
    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.white, size: 35),
          backgroundColor: AppConstant.appMainColor,
          title: Text(widget.categoryName+" Products", style: TextStyle(color: AppConstant.appTextColor),),
          centerTitle: true,
        ),
        body: Padding(
          padding: EdgeInsets.all(10),
          child: FutureBuilder(
            future: FirebaseFirestore.instance.collection("products")
                .where("categoryId", isEqualTo: widget.categoryId)
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
                return Center(child: Text("No Category Found!"));
              }

              if(snapshot.data!=null){
                return
                  GridView.builder(
                      itemCount: snapshot.data!.docs.length,
                      shrinkWrap: true,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 3, //number of logical pixels between each child along the cross axis
                        mainAxisSpacing: 3, //number of logical pixels between each child along the main axis
                        childAspectRatio: 1.19, //ratio of the cross-axis to the main-axis extent of each child
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
                                  child: FillImageCard(
                                    color: TColors.grey2,
                                    borderRadius: 20,
                                    width: Get.width/2.3,
                                    heightImage: Get.height/10,
                                    //imageProvider: AssetImage(TImages.productImage1),
                                    imageProvider: NetworkImage(productModel.productImage[0]),
                                    //tags: [_tag('Category', () {}), _tag('Product', () {})],
                                    title: Center(child: Text(productModel.productName,
                                    overflow: TextOverflow.ellipsis,
                                    style: Theme.of(context).textTheme.bodyMedium,
                                    )
                                    )
                                    //description: Text("data"),
                                    //footer: Text("footer"),
                                  ),
                                ),
                              ),
                            )
                          ],
                        );
                }

              );
              }

              return Container();

            }
                ),
        )

    );
  }
}
