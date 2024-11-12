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

  TextEditingController categoryNameController = TextEditingController();
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
        backgroundColor: AppConstant.appMainColor,
        title: Text("Edit Category "+widget.categoriesModel.categoryName),
      ),
      body: Container(
        child: Column(
          children: [
            GetBuilder(
              init: EditCategoryController(
                  categoriesModel: widget.categoriesModel),
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
                      errorWidget: (context, url, error) =>
                      const Icon(Icons.error),
                    ),
                    Positioned(
                      right: 10,
                      top: 0,
                      child: InkWell(
                        onTap: () async {
                          EasyLoading.show();
                          await editCategory.deleteImagesFromStorage(
                              editCategory.categoryImg.value.toString());
                          await editCategory.deleteImageFromFireStore(
                              editCategory.categoryImg.value.toString(),
                              widget.categoriesModel.categoryId);
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
                    : const SizedBox.shrink();
              },
            ),

            //
            const SizedBox(height: 10.0),
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

            ElevatedButton(
              onPressed: () async {
                EasyLoading.show();
                CategoriesModel categoriesModel = CategoriesModel(
                  categoryId: widget.categoriesModel.categoryId,
                  categoryName: categoryNameController.text.trim(),
                  categoryImg: widget.categoriesModel.categoryImg,
                  createdAt: widget.categoriesModel.createdAt,
                  updatedAt: DateTime.now().toString(),
                );

                await FirebaseFirestore.instance
                    .collection('categories')
                    .doc(categoriesModel.categoryId)
                    .update(categoriesModel.toMap());

                EasyLoading.dismiss();
              },
              child: const Text("Update"),
            )
          ],
        ),
      ),
    );
  }
}