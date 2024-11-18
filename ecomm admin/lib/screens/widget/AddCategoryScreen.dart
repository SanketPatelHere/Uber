import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:flutter/cupertino.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../../controllers/AddCategoryImagesController.dart';
import '../../controllers/AddProductImagesController.dart';
import '../../controllers/CartController.dart';
import '../../controllers/CategoryDropDownController.dart';
import '../../controllers/GetProductLengthController.dart';
import '../../controllers/GetUserLengthController.dart';
import '../../controllers/IsSaleController.dart';
import '../../controllers/IsSaleController.dart';
import '../../logging/logger_helper.dart';
import '../../models/CategoriesModel.dart';
import '../../models/OrderModel.dart';
import '../../models/ProductModel.dart';
import '../../services/GenerateIds.dart';
import '../../utils/TLoaders.dart';
import '../../utils/app-constant.dart';
import '../../utils/colors.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'AddCategoryScreen.dart';
import 'AddReviewScreen.dart';
import 'AllCategoriesScreen.dart';
import 'AllProductDetailScreen.dart';
import 'AllProductsScreen.dart';
import 'DropDownCategoriesWidget.dart';
import 'SpecificCustomerScreen.dart';

class AddCategoriesScreen extends StatefulWidget {
  const AddCategoriesScreen({super.key});

  @override
  State<AddCategoriesScreen> createState() => _AddCategoriesScreenState();
}

class _AddCategoriesScreenState extends State<AddCategoriesScreen> {
  final TAG = "Myy AddCategoriesScreen ";
  TextEditingController categoryNameController = TextEditingController();
  //AddProductImagesController addProductImagesController = Get.put(AddProductImagesController());
  AddCategoryImagesController addCategoryImagesController = Get.put(AddCategoryImagesController());

  @override
  Widget build(BuildContext context) {
    TLoggerHelper.info("${TAG} inside build");
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: TColors.white, size: 35),
        backgroundColor: AppConstant.appMainColor,
        title:  Text("Add Category", style: TextStyle(color: AppConstant.appTextColor)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Container(
          child: Column(
            children: [

              //for Select Images layout
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Select Images"),
                    ElevatedButton(
                      onPressed: () {
                        addCategoryImagesController.showImagePickerDialog();
                      },
                      child: const Text("Select Images"),
                    )
                  ],
                ),
              ),

              //for show Images
              GetBuilder<AddCategoryImagesController>(
                init: AddCategoryImagesController(),
                builder: (imageController) {
                  return imageController.selectedImages.length > 0
                      ? Container(
                          width: MediaQuery.of(context).size.width - 20,
                          height: Get.height / 3.0,
                          child: GridView.builder(
                            itemCount: imageController.selectedImages.length,
                            physics: const BouncingScrollPhysics(),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisSpacing: 20,
                              crossAxisSpacing: 10,
                            ),
                            itemBuilder: (BuildContext context, int index) {
                              return Stack(
                                children: [
                                  Image.file(
                                    File(addCategoryImagesController.selectedImages[index].path),
                                    fit: BoxFit.cover,
                                    height: Get.height / 4,
                                    width: Get.width / 2,
                                  ),
                                  Positioned(
                                    right: 10,
                                    top: 0,
                                    child: InkWell(
                                      onTap: () {
                                        imageController.removeImages(index);
                                        print(imageController.selectedImages.length);
                                      },
                                      child: const CircleAvatar(
                                        backgroundColor:
                                            AppConstant.appSecondaryColor,
                                        child: Icon(
                                          Icons.close,
                                          color: AppConstant.appTextColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        )
                      : const SizedBox.shrink();
                },
              ),

              //todo form start
              //Category Name
              const SizedBox(height: 40.0),
              Container(
                height: 65,
                margin: const EdgeInsets.symmetric(horizontal: 10.0),
                child: TextFormField(
                  cursorColor: AppConstant.appMainColor,
                  textInputAction: TextInputAction.next,
                  controller: categoryNameController,
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 10.0,
                    ),
                    hintText: "Category Name",
                    hintStyle: TextStyle(fontSize: 12.0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(10.0),
                      ),
                    ),
                  ),
                ),
              ),
              //todo form end

              ElevatedButton(
                onPressed: () async {
                  try{
                    EasyLoading.show();
                    //for upload images in storage - need to  uncomment this when storage on
                    ///await addCategoryImagesController.uploadFunction(addCategoryImagesController.selectedImages);
                    TLoggerHelper.info("${TAG} savebutton uploadFile final arrImageUrl = "+addCategoryImagesController.arrImageUrl.toString());

                    String categoryId = GenerateIds.generateCategoryId();
                    TLoggerHelper.info("${TAG} savebutton addCategoryImagesController.arrImageUrl = "+addCategoryImagesController.arrImageUrl.toString());
                    String cateImg = "";
                    if(addCategoryImagesController.arrImageUrl.length>0){
                      TLoggerHelper.info("${TAG} savebutton addCategoryImagesController.arrImageUrl2 = "+addCategoryImagesController.arrImageUrl[0].toString());
                      cateImg = addCategoryImagesController.arrImageUrl[0].toString() as String; //not array, only 1 image
                      //image selected
                    }
                    else{
                      //no any image selected
                    }

                    TLoggerHelper.info("${TAG} savebutton cateImg = "+cateImg);
                    if(categoryNameController.text!="")
                    {
                      CategoriesModel categoriesModel = CategoriesModel(
                        categoryId: categoryId,
                        categoryName: categoryNameController.text.trim(),
                        categoryImg: cateImg,
                        createdAt: DateTime.now().toString(),
                        updatedAt: DateTime.now().toString(),
                      );
                      TLoggerHelper.info("${TAG} savebutton categoryId = "+categoryId);


                      FirebaseFirestore.instance
                          .collection('categories')
                          .doc(categoryId)
                          .set(categoriesModel.toMap());
                      TLoggerHelper.info("${TAG} Category Added Successfully");
                      TLoaders.successSnakeBar(title: "Success", message: "Category Added Successfully");
                      //Get.to(AllProductsScreen());
                      Get.off(AllCategoriesScreen());
                      //Get.offAll(AllProductsScreen());
                    }
                    else
                    {
                      TLoaders.errorSnakeBar(title: "Error in Category Upload", message: "please fill all details");
                      TLoggerHelper.info("${TAG} Category Upload enter all field");
                    }

                    EasyLoading.dismiss();
                  }
                  catch(e){
                    EasyLoading.dismiss();
                    TLoaders.errorSnakeBar(title: "Error in Category Upload", message: "Something went wrong");
                    TLoggerHelper.info("${TAG} Error in catch Category Upload  e = "+e.toString());
                  }
                },
                child: const Text("Save"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
