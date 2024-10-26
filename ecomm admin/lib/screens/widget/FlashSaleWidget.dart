import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/cupertino.dart';
import '../../logging/logger_helper.dart';
import '../../models/ProductModel.dart';
import '../../utils/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_card/image_card.dart';

import 'ProductDetailScreen.dart';


class FlashSaleWidget extends StatefulWidget {
  const FlashSaleWidget({super.key});

  @override
  State<StatefulWidget> createState() => _FlashSaleWidgetState();
}

class _FlashSaleWidgetState extends State<FlashSaleWidget> {
  final TAG = "Myy FlashSaleWidget ";


  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: FirebaseFirestore.instance
            .collection("products")
            .where("isSale", isEqualTo: true) //if isSale=true
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
                padding: EdgeInsets.all(10),
                child: Container(
                  height: Get.height/5,
                  child: ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index){
                        TLoggerHelper.info("${TAG} productData docs length = "+snapshot.data!.docs.length.toString());

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
                                      borderRadius: 15,
                                      width: Get.width/2.5,
                                      heightImage: Get.height/13,
                                      //imageProvider: AssetImage(productModel.productImage[0]),
                                      imageProvider: NetworkImage(productModel.productImage[0]),
                                      //tags: [_tag('Category', () {}), _tag('Product', () {})],
                                      title: Center(child: Text(productModel.productName,
                                        overflow: TextOverflow.ellipsis,
                                        style: Theme.of(context).textTheme.bodyMedium,
                                      )
                                      ),
                                      //description: Text("data"),
                                      footer: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                              Text("Rs ${productModel.salePrice}",
                                                //style: TextStyle(fontSize: 16),
                                                style: Theme.of(context).textTheme.labelMedium,
                                              ),
                                              SizedBox(width: 2),
                                              Text(" ${productModel.fullPrice}",
                                                 style: Theme.of(context).textTheme.labelMedium!.apply(decoration: TextDecoration.lineThrough)
                                              ),

                                        ],
                                      ),
                                    ),
                                  ),
                              ),
                            ),
                          ],
                        );
                      }
                  ),
                ),
              );
            }

            return Container();

        }
    );

  }
}
