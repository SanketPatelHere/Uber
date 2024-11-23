import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:flutter/cupertino.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../../controllers/AddProductImagesController.dart';
import '../../controllers/CartController.dart';
import '../../controllers/CategoryDropDownController.dart';
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

import 'AddProductScreen.dart';
import 'AddReviewScreen.dart';
import 'AllProductDetailScreen.dart';
import 'AllProductsScreen.dart';
import 'DropDownCategoriesWidget.dart';
import 'SpecificCustomerScreen.dart';


class AddProductScreen extends StatefulWidget {

  AddProductScreen({
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _AddProductScreen();
}

class _AddProductScreen extends State<AddProductScreen> {
  final TAG = "Myy AddProductScreen ";
  final CarouselController carouselController = CarouselController();
  final CartController cartController = Get.put(CartController());
  CategoryDropDownController categoryDropDownController = Get.put(CategoryDropDownController()); //no need of this
  final IsSaleController isSaleController = Get.put(IsSaleController());


  TextEditingController productNameController = TextEditingController();
  TextEditingController fullPriceController = TextEditingController();
  TextEditingController salePriceController = TextEditingController();
  TextEditingController deliveryTimeController = TextEditingController();
  TextEditingController productDescriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    TLoggerHelper.info("${TAG} inside build");
    User? user = FirebaseAuth.instance.currentUser;
    AddProductImagesController addProductImagesController = Get.put(AddProductImagesController());
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: TColors.white, size: 35),
        backgroundColor: AppConstant.appMainColor,
        title:  Text("Add Product", style: TextStyle(color: AppConstant.appTextColor)),
        centerTitle: true,
      ),

      body:
        SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Column(
              children: [
                Padding(
                    padding: EdgeInsets.all(8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Select Images"),
                        ElevatedButton(
                            onPressed: (){
                              addProductImagesController.showImagePickerDialog();
                            },
                            child: Text(" Select Images ")
                        )
                      ],
                    ),
                ),
          
                //for show images
                //get builder show automatically change after data change(same as setstate and obx)
                GetBuilder<AddProductImagesController>(
                  init:AddProductImagesController(),
                  builder: (AddProductImagesController imageController) {
                    return imageController.selectedImages.length>0
                  ?Container(
                    width: MediaQuery.of(context).size.width-20,
                    height: Get.height/3, //for main height of images container
                    child: GridView.builder(
                        itemCount: imageController.selectedImages.length,
                        physics: const BouncingScrollPhysics(),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 20,
                            crossAxisSpacing: 10
                        ),
                        itemBuilder: (BuildContext context, int index){
                          return Stack(
                            children: [
                              //for show image from specific file path
                              Image.file(File(imageController.selectedImages[index].path),
                              fit: BoxFit.cover,
                              width: Get.width/2,
                              height: Get.height/4,
                              ),
                              //for remove image icon
                              Positioned(
                                  top:0,
                                  right:10,
                                  child:InkWell(
                                    onTap: (){
                                      imageController.removeImages(index);
                                      TLoggerHelper.info("${TAG} selectImages removeImage at index = "+index.toString());
                                      TLoggerHelper.info("${TAG} selectImages imageController selectedImages length = "+imageController.selectedImages.length.toString());
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
                  )
                  :SizedBox.shrink();
                },
                ),
          
                //show categories dropdown
                DropDownCategoriesWidget(),
          
                //isSale
                GetBuilder(
                    init:IsSaleController(),
                    builder: (isSaleController){
                      return Card(
                        child: Padding(
                            padding: EdgeInsets.all(8),
                            child: Row(
                              children: [
                                Text("Is Sale"),
                                Switch(
                                      activeColor: AppConstant.appMainColor,
                                      value: isSaleController.isSale.value,
                                      onChanged: (value){
                                         isSaleController.toggleIsSale(value);
                                      }
                                )
                              ],
                            ),
                        ),
                      );
                    }
                ),


                //todo form start
                //form
                //for productName
                SizedBox(height: 10),
                Container(
                  height: 65,
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  child: TextFormField(
                    cursorColor: AppConstant.appMainColor,
                    textInputAction: TextInputAction.next,
                    controller: productNameController,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(horizontal: 10),
                      hintText: "Product Name",
                      hintStyle: TextStyle(fontSize: 12),
                      border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10)))
                    ),
                  ),
                ),
          
                //for fullPrice
                SizedBox(height: 5),
                Container(
                  height: 65,
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    cursorColor: AppConstant.appMainColor,
                    textInputAction: TextInputAction.next,
                    controller: fullPriceController,
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(horizontal: 10),
                        hintText: "Full Price",
                        hintStyle: TextStyle(fontSize: 12),
                        border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10)))
                    ),
                  ),
                ),
          
                //for salePrice
                //SizedBox(height: 5),
                //use obx or GetBuilder
                Obx((){
                  return isSaleController.isSale.value
                      ?Container(
                    height: 65,
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      cursorColor: AppConstant.appMainColor,
                      textInputAction: TextInputAction.next,
                      controller: salePriceController,
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(horizontal: 10),
                          hintText: "Sale Price",
                          hintStyle: TextStyle(fontSize: 12),
                          border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10)))
                      ),
                    ),
                  )
                      :SizedBox.shrink();
                }),


                //for deliveryTime
                SizedBox(height: 10),
                Container(
                  height: 65,
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  child: TextFormField(
                    cursorColor: AppConstant.appMainColor,
                    textInputAction: TextInputAction.next,
                    controller: deliveryTimeController,
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(horizontal: 10),
                        hintText: "Delivery Time",
                        hintStyle: TextStyle(fontSize: 12),
                        border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10)))
                    ),
                  ),
                ),

                //for productDescription
                SizedBox(height: 10),
                Container(
                  height: 65,
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  child: TextFormField(
                    cursorColor: AppConstant.appMainColor,
                    textInputAction: TextInputAction.next,
                    controller: productDescriptionController,
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(horizontal: 10),
                        hintText: "Product Description",
                        hintStyle: TextStyle(fontSize: 12),
                        border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10)))
                    ),
                  ),
                ),
                //todo form end


                SizedBox(height: 10),
                ElevatedButton(
                    onPressed: () async{

                      try{
                        EasyLoading.show();
                        //for upload images in storage - need to  uncomment this when storage on
                        ///await addProductImagesController.uploadFunction(addProductImagesController.selectedImages);
                        TLoggerHelper.info("${TAG} inside uploadFile final arrImageUrl = "+addProductImagesController.arrImageUrl.toString());

                        String productId = await GenerateIds.generateProductId();
                        TLoggerHelper.info("${TAG} productId = "+productId.toString());
                        if(productNameController.text!="" && fullPriceController.text!="" &&
                            //salePriceController.text!="" &&
                            deliveryTimeController.text!="" &&
                            productDescriptionController.text!="")
                        {
                          ProductModel productModel = ProductModel(
                              productId: productId,
                              categoryId: categoryDropDownController.selectedCategoryId.toString(),
                              categoryName: categoryDropDownController.selectedCategoryName.toString(),
                              createdAt: DateTime.now().toString(),
                              updatedAt: DateTime.now().toString(),
                              deliveryTime: deliveryTimeController.text.trim(),
                              productName: productNameController.text.trim(),
                              productDescription: productDescriptionController.text.trim(),
                              fullPrice: fullPriceController.text.trim(),
                              salePrice: salePriceController.text!=""
                                  ?salePriceController.text.trim()
                                  :"",
                              isSale: isSaleController.isSale.value,
                              productImage: addProductImagesController.arrImageUrl //pass uploaded urls array of storage
                          );

                          await FirebaseFirestore.instance
                              .collection("products")
                              .doc(productId)
                              .set(productModel.toMap());
                          TLoggerHelper.info("${TAG} Product Uploaded Successfully");
                          TLoaders.successSnakeBar(title: "Success", message: "Product Uploaded Successfully");
                          //Get.to(AllProductsScreen());
                          Get.off(AllProductsScreen());
                          //Get.offAll(AllProductsScreen());
                        }
                        else
                        {
                          TLoaders.errorSnakeBar(title: "Error in Product Upload", message: "please fill all details");
                          TLoggerHelper.info("${TAG} Product Upload enter all field");
                        }


                        EasyLoading.dismiss();

                      }
                      catch(e){
                        EasyLoading.dismiss();
                        TLoggerHelper.info("${TAG} Error in catch Product Upload  e = "+e.toString());
                      }

                    },
                    child: Text(" Product Upload ")
                )
          
              ],
            ),
          ),
        )
    );
  }


}
