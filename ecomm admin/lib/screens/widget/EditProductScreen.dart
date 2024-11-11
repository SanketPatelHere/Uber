import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:flutter/cupertino.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../../controllers/AddProductImagesController.dart';
import '../../controllers/CartController.dart';
import '../../controllers/CategoryDropDownController.dart';
import '../../controllers/EditProductController.dart';
import '../../controllers/GetProductLengthController.dart';
import '../../controllers/GetUserLengthController.dart';
import '../../controllers/IsSaleController.dart';
import '../../controllers/IsSaleController.dart';
import '../../logging/logger_helper.dart';
import '../../models/OrderModel.dart';
import '../../models/ProductModel.dart';
import '../../services/GenerateIds.dart';
import '../../utils/TLoaders.dart';
import '../../utils/app-constant.dart';
import '../../utils/colors.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'EditProductScreen.dart';
import 'AddReviewScreen.dart';
import 'AllProductDetailScreen.dart';
import 'DropDownCategoriesWidget.dart';
import 'SpecificCustomerScreen.dart';


class EditProductScreen extends StatefulWidget  {
  ProductModel productModel;
  EditProductScreen({super.key, required this.productModel});

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}


class _EditProductScreenState extends State<EditProductScreen> {
  final TAG = "Myy EditProductScreen ";

  @override
  Widget build(BuildContext context) {
    TLoggerHelper.info("${TAG} inside build");
    return GetBuilder<EditProductController>(
        init: EditProductController(productModel:widget.productModel),
        builder: (controller){
          return Scaffold(
              appBar: AppBar(
                iconTheme: IconThemeData(color: TColors.white, size: 35),
                backgroundColor: AppConstant.appMainColor,
                title:  Text("Edit Product ${widget.productModel.productName}", style: TextStyle(color: AppConstant.appTextColor)),
                centerTitle: true,
              ),

              body: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Column(
                    children: [
                        SingleChildScrollView(
                          child: Container(
                            width: MediaQuery.of(context).size.width-20,
                            height: Get.height/3,
                            child: GridView.builder(
                              itemCount: controller.images.length,
                              physics: const BouncingScrollPhysics(),
                              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  mainAxisSpacing: 2,
                                  crossAxisSpacing: 2
                              ),
                              itemBuilder: (BuildContext context, int index){
                                TLoggerHelper.info("${TAG} inside controller.images.length = "+controller.images.length.toString());
                                TLoggerHelper.info("${TAG} inside index = "+index.toString());
                                return Stack(
                                  children: [
                                    //for show image from specific file path
                                    CachedNetworkImage(
                                        imageUrl: controller.images[index],
                                        fit: BoxFit.contain,
                                        width: Get.width/2,
                                        height: Get.height/5.5,
                                        placeholder: (context, url)=>Center(child: CupertinoActivityIndicator()),
                                        errorWidget: (context, url, eror) => Icon(Icons.error),
                                    ),
                                    //for remove image icon
                                    Positioned(
                                        top:0,
                                        right:10,
                                        child:InkWell(
                                          onTap: () async{
                                            EasyLoading.show();
                                            //uncomment this when storage on
                                            ///await controller.deleteImagesFromStorage(controller.images[index].toString());
                                            await controller.deleteImagesFromFireStore(controller.images[index].toString(), widget.productModel.productId);
                                            EasyLoading.dismiss();
                                          },
                                          child: CircleAvatar(
                                            backgroundColor: AppConstant.appSecondaryColor,
                                            child: Icon(Icons.close,
                                              color: AppConstant.appTextColor,),
                                          ),
                                        )
                                    )
                                  ],
                                );
                              },
                            ),
                          ),
                        )
                    ],
                  ),
                ),
              )
          );
        }
    );

  }

}

