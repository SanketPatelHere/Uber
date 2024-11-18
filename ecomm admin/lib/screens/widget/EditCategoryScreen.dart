import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
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
import '../../controllers/EditCategoryController.dart';
import '../../controllers/EditProductController.dart';
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

import 'AllCategoriesScreen.dart';
import 'EditCategoryScreen.dart';
import 'AddReviewScreen.dart';
import 'AllProductDetailScreen.dart';
import 'DropDownCategoriesWidget.dart';
import 'SpecificCustomerScreen.dart';


class EditCategoryScreen extends StatefulWidget  {
  CategoriesModel  categoriesModel;
  EditCategoryScreen({super.key, required this.categoriesModel});

  @override
  State<EditCategoryScreen> createState() => _EditCategoryScreenState();
}


class _EditCategoryScreenState extends State<EditCategoryScreen> {
  final TAG = "Myy EditCategoryScreen ";
  var imageUrl = "";

  TextEditingController categoryNameController = TextEditingController();
  AddCategoryImagesController addCategoryImagesController = Get.put(AddCategoryImagesController());


  @override
  void initState() {
    super.initState();
    TLoggerHelper.info("${TAG} inside initState");
    categoryNameController.text = widget.categoriesModel.categoryName;
  }

  @override
  Widget build(BuildContext context) {
    TLoggerHelper.info("${TAG} inside build");
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: TColors.white, size: 35),
        backgroundColor: AppConstant.appMainColor,
        title:  Text("Edit Category", style: TextStyle(color: AppConstant.appTextColor)),
        centerTitle: true,
      ),
      body: Container(
        child: Column(
          children: [

            SizedBox(height: 10),
            //for show Images
            GetBuilder<EditCategoryController>(
              init: EditCategoryController(categoriesModel: widget.categoriesModel),
              builder: (editCategory) {
                return editCategory.categoryImg.value != ''
                    ? Stack(
                  children: [
                    CachedNetworkImage(
                      imageUrl: editCategory.categoryImg.value.toString(),
                      fit: BoxFit.contain,
                      width: Get.width / 2,
                      height: Get.height / 5.5,
                      placeholder: (context, url) => const Center(
                          child: CupertinoActivityIndicator()),
                      errorWidget: (context, url, error) => const Icon(Icons.error),
                    ),
                    Positioned(
                      right: 10,
                      top: 0,
                      child: InkWell(
                        onTap: () async {
                          EasyLoading.show();
                          await editCategory.deleteImagesFromStorage(editCategory.categoryImg.value.toString());
                          await editCategory.deleteImageFromFireStore(editCategory.categoryImg.value.toString(), widget.categoriesModel.categoryId);
                          EasyLoading.dismiss();
                        },
                        child: CircleAvatar(
                          backgroundColor: AppConstant.appSecondaryColor,
                          child: const Icon(
                            Icons.close,
                            color: AppConstant.appTextColor,
                          ),
                        ),
                      ),
                    ),
                  ],
                )
                    //code for add image selection
                    ///: const SizedBox.shrink();
                    :   //for Select Images layout
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Row(
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
                                //for upload images in storage - need to  uncomment this when storage on
                                ///await addProductImagesController.uploadFunction(addProductImagesController.selectedImages);
                                TLoggerHelper.info("${TAG} inside uploadFile final arrImageUrl = "+addCategoryImagesController.arrImageUrl.toString());
                                //widget.categoriesModel.categoryImg.value = addCategoryImagesController.selectedImages[index].path
                                editCategory.categoryImg.value = addCategoryImagesController.arrImageUrl.toString();

                                if(editCategory.categoryImg.value != ''){
                                  //if image remove and select new image then comes here
                                  imageUrl =  editCategory.categoryImg.value;

                                }
                                else{
                                  //bydefault image
                                  imageUrl = widget.categoriesModel.categoryImg;
                                }
                                TLoggerHelper.info("${TAG} new widget.categoriesModel.categoryImg = "+widget.categoriesModel.categoryImg);
                                TLoggerHelper.info("${TAG} new editCategory.categoryImg.value = "+editCategory.categoryImg.value);
                                TLoggerHelper.info("${TAG} new imageUrl = "+imageUrl);


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

                    ],
                  ),
                );

              },
            ),

            //todo form start
            //Category Name
            const SizedBox(height: 10.0),
            Container(
              height: 65,
              margin: const EdgeInsets.symmetric(horizontal: 10.0),
              child: TextFormField(
                cursorColor: AppConstant.appMainColor,
                textInputAction: TextInputAction.next,
                controller: categoryNameController,
                //controller: categoryNameController..text = widget.categoriesModel.categoryName, //issue reinitiate old value when keyboard close
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

                EasyLoading.show();
                CategoriesModel categoriesModel = CategoriesModel(
                  categoryId: widget.categoriesModel.categoryId,
                  categoryName: categoryNameController.text.trim(),
                  //categoryImg: widget.categoriesModel.categoryImg,
                  categoryImg: imageUrl,
                  createdAt: widget.categoriesModel.createdAt,
                  updatedAt: DateTime.now().toString(),
                );

                await FirebaseFirestore.instance
                    .collection('categories')
                    .doc(categoriesModel.categoryId)
                    .update(categoriesModel.toMap());

                EasyLoading.dismiss();
                TLoggerHelper.info("${TAG} Category Updated Successfully");
                TLoaders.successSnakeBar(title: "Success", message: "Category Updated Successfully");
                //Get.to(AllProductsScreen());
                Get.off(AllCategoriesScreen());

              },
              child: const Text("Update"),
            )
          ],
        ),
      ),
    );
  }
}