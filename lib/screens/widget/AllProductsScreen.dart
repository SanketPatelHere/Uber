import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_swipe_action_cell/core/cell.dart';
import 'package:get/get.dart';
import 'package:flutter/cupertino.dart';
import '../../controllers/CartController.dart';
import '../../controllers/CategoryDropDownController.dart';
import '../../controllers/GetProductLengthController.dart';
import '../../controllers/GetUserLengthController.dart';
import '../../controllers/IsSaleController.dart';
import '../../logging/logger_helper.dart';
import '../../models/OrderModel.dart';
import '../../models/ProductModel.dart';
import '../../utils/app-constant.dart';
import '../../utils/colors.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../utils/image_strings.dart';
import 'AddProductScreen.dart';
import 'AddReviewScreen.dart';
import 'AllProductDetailScreen.dart';
import 'EditProductScreen.dart';
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

                          return SwipeActionCell(
                              key: ObjectKey(productModel.productId),
                              trailingActions: [
                              SwipeAction(
                              title: "Delete",
                              forceAlignmentToBoundary: true, //align end
                              performsFirstActionWithFullSwipe: true, //drag cell a long distance
                              onTap: (CompletionHandler handler) async{
                                Get.defaultDialog(
                                    title: "Delete Product",
                                    //middleText: "Pick an image from the camera or gallery",
                                    content: Text("Are you sure you want to delete this product?"),
                                    textCancel: "Cancel",
                                    textConfirm: "Delete",
                                    contentPadding: EdgeInsets.all(10),
                                    confirmTextColor: TColors.white,
                                  onCancel: (){
                                    //Get.back(); //for close dialog
                                  },
                                  onConfirm: ()async{
                                      Get.back(); //for close dialog
                                    EasyLoading.show(status: "Please Wait");

                                    //for remove images from storage
                                    await deleteImagesFromStorage(productModel.productImage.toString());
                                    //for remove whole product from firebasefirestore
                                    await FirebaseFirestore.instance
                                        .collection("products")
                                        .doc(productModel.productId)
                                        .delete();

                                    EasyLoading.dismiss();
                                  },

                                );
                              }
                              )
                              ],
                              child: Card(
                                  //color: AppConstant.appTextColor,
                                  elevation: 5,
                                  child: ListTile(
                                  //for product detail screen
                                  //onTap: ((){ Get.to()=>SpecificCustomerScreen(snapshot.data!.docs[index]["uId"], customerName:snapshot.data!.docs[index]["customerName"]));
                                  onTap: (){
                                  Get.to(()=>AllProductDetailScreen(productModel: productModel));
                                  },

                                  leading: CircleAvatar(

                                  backgroundImage: productModel.productImage.length>0?NetworkImage(productModel.productImage[0]):AssetImage(TImages.imgNotAvailable),
                                  //backgroundImage:CachedNetworkImage(imageUrl:orderModel.productImage[0]),
                                  ),
                                  //title: Text("New Dress for womens"),
                                  title:Text(productModel.productName, style: Theme.of(context).textTheme.labelLarge),
                                  //title:Text(productModel.productName),
                                  subtitle:Text(productModel.productDescription, style: Theme.of(context).textTheme.bodyMedium),
                                  //subtitle:Text(productModel.productDescription),
                                  trailing:GestureDetector(
                                    //for edit product
                                    onTap: (){
                                    //for set categoryid default selected dropdown
                                    final editProductCategory = Get.put(CategoryDropDownController());
                                    editProductCategory.setOldValue(productModel.categoryId);

                                    //for set isSale  default selected value
                                    final isSaleController = Get.put(IsSaleController());
                                    isSaleController.setIsSaleOldValue(productModel.isSale);

                                    Get.to(()=>EditProductScreen(productModel:productModel));

                                    },
                                    child: Icon(Icons.edit)),
                                  )
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

  //delete images start
  //1.from storage
  Future deleteImagesFromStorage(String imageUrl) async{
    TLoggerHelper.info("${TAG} inside deleteImagesFromStorage imageUrl = "+imageUrl.toString());
    final FirebaseStorage storage = FirebaseStorage.instance;
    try{
      //remove by passing url
      Reference reference = storage.refFromURL(imageUrl);
      await reference.delete();
    }
    catch(e){
      TLoggerHelper.info("${TAG} inside deleteImagesFromStorage Error in catch e = "+e.toString());
    }
  }
//delete images end


}
