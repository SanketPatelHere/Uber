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


class EditProductScreen extends StatefulWidget {
  ProductModel productModel;
  EditProductScreen({super.key, required this.productModel});

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final TAG = "Myy EditProductScreen ";
  IsSaleController isSaleController = Get.put(IsSaleController());
  CategoryDropDownController categoryDropDownController = Get.put(CategoryDropDownController());

  TextEditingController productNameController = TextEditingController();
  TextEditingController salePriceController = TextEditingController();
  TextEditingController fullPriceController = TextEditingController();
  TextEditingController deliveryTimeController = TextEditingController();
  TextEditingController productDescriptionController = TextEditingController();

  @override
  void initState() {
    TLoggerHelper.info("${TAG} inside initState");
    super.initState();

    //for default value set in controller then textformfield
    productNameController.text = widget.productModel.productName;
    salePriceController.text = widget.productModel.salePrice;
    fullPriceController.text = widget.productModel.fullPrice;
    deliveryTimeController.text = widget.productModel.deliveryTime;
    productDescriptionController.text = widget.productModel.productDescription;
  }

  @override
  Widget build(BuildContext context) {
    TLoggerHelper.info("${TAG} inside build");
    return GetBuilder<EditProductController>(
      init: EditProductController(productModel: widget.productModel),
      builder: (controller) {
        return Scaffold(
          appBar: AppBar(
            iconTheme: IconThemeData(color: TColors.white, size: 35),
            backgroundColor: AppConstant.appMainColor,
            title:  Text("Edit Product ${widget.productModel.productName}", style: TextStyle(color: AppConstant.appTextColor)),
            centerTitle: true,
          ),
          body: SingleChildScrollView(
            child: Container(
              child: Column(
                children: [
                  SingleChildScrollView(
                    child: Container(
                      width: MediaQuery.of(context).size.width - 20,
                      height: Get.height / 4.0,
                      child: GridView.builder(
                        itemCount: controller.images.length,
                        physics: const BouncingScrollPhysics(),
                        gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 2,
                          crossAxisSpacing: 2,
                        ),
                        itemBuilder: (BuildContext context, int index) {
                          return Stack(
                            children: [
                              CachedNetworkImage(
                                imageUrl: controller.images[index],
                                fit: BoxFit.contain,
                                height: Get.height / 5.5,
                                width: Get.width / 2,
                                placeholder: (context, url) =>
                                    Center(child: CupertinoActivityIndicator()),
                                errorWidget: (context, url, error) =>
                                    Icon(Icons.error),
                              ),
                              Positioned(
                                right: 10,
                                top: 0,
                                child: InkWell(
                                  onTap: () async {
                                    EasyLoading.show();
                                    await controller.deleteImagesFromStorage(
                                        controller.images[index].toString());
                                    await controller.deleteImagesFromFireStore(
                                        controller.images[index].toString(),
                                        widget.productModel.productId);
                                    EasyLoading.dismiss();
                                  },
                                  child: CircleAvatar(
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
                    ),
                  ),

                  //drop down
                  //show defualt selected edit categories dropdown
                  GetBuilder<CategoryDropDownController>(
                    init: CategoryDropDownController(),
                    builder: (categoriesDropDownController) {
                      return Column(
                        children: [
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 0.0),
                            child: Card(
                              elevation: 10,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: DropdownButton<String>(
                                  value: categoriesDropDownController
                                      .selectedCategoryId?.value,
                                  items: categoriesDropDownController.categories
                                      .map((category) {
                                    return DropdownMenuItem<String>(
                                      value: category['categoryId'],
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          CircleAvatar(
                                            backgroundImage: NetworkImage(
                                              category['categoryImg']
                                                  .toString(),
                                            ),
                                          ),
                                          const SizedBox(width: 20),
                                          Text(category['categoryName']),
                                        ],
                                      ),
                                    );
                                  }).toList(),
                                  onChanged: (String? selectedValue) async {
                                    categoriesDropDownController
                                        .setSelectedCategory(selectedValue);
                                    String? categoryName =
                                    await categoriesDropDownController
                                        .getCategoryName(selectedValue);
                                    categoriesDropDownController
                                        .setSelectedCategoryName(categoryName);
                                  },
                                  hint: const Text(
                                    'Select a category',
                                  ),
                                  isExpanded: true,
                                  elevation: 10,
                                  underline: const SizedBox.shrink(),
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),

                  //isSale
                  //show defualt selected edit isSale
                  GetBuilder<IsSaleController>(
                    init: IsSaleController(),
                    builder: (isSaleController) {
                      return Card(
                        elevation: 10,
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Is Sale"),
                              Switch(
                                value: isSaleController.isSale.value,
                                activeColor: AppConstant.appMainColor,
                                onChanged: (value) {
                                  isSaleController.toggleIsSale(value);
                                },
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  ),


                  //todo form start
                  //form
                  //for productName
                  SizedBox(height: 10.0),
                  Container(
                    height: 65,
                    margin: EdgeInsets.symmetric(horizontal: 10.0),
                    child: TextFormField(
                      cursorColor: AppConstant.appMainColor,
                      textInputAction: TextInputAction.next,
                      controller: productNameController,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 10.0,
                        ),
                        hintText: "Product Name",
                        hintStyle: TextStyle(fontSize: 12.0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(10.0),
                          ),
                        ),
                      ),
                    ),
                  ),

                  //for fullPrice
                  SizedBox(height: 10.0),
                  Container(
                    height: 65,
                    margin: EdgeInsets.symmetric(horizontal: 10.0),
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      cursorColor: AppConstant.appMainColor,
                      textInputAction: TextInputAction.next,
                      controller: fullPriceController,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 10.0,
                        ),
                        hintText: "Full Price",
                        hintStyle: TextStyle(fontSize: 12.0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(10.0),
                          ),
                        ),
                      ),
                    ),
                  ),

                  //for salePrice
                  GetBuilder<IsSaleController>(
                    init: IsSaleController(),
                    builder: (isSaleController) {
                      return isSaleController.isSale.value
                          ? Container(
                        height: 65,
                        margin: EdgeInsets.symmetric(horizontal: 10.0),
                        child: TextFormField(
                          keyboardType: TextInputType.number,
                          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                          cursorColor: AppConstant.appMainColor,
                          textInputAction: TextInputAction.next,
                          controller: salePriceController,
                          //controller: salePriceController..text = widget.productModel.salePrice, //issue reinitiate old value when keyboard close
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 10.0,
                            ),
                            hintText: "Sale Price",
                            hintStyle: TextStyle(fontSize: 12.0),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(10.0),
                              ),
                            ),
                          ),
                        ),
                      )
                          : SizedBox.shrink();
                    },
                  ),
                  // Obx(() {
                  //   return isSaleController.isSale.value
                  //       ? Container(
                  //           height: 65,
                  //           margin: EdgeInsets.symmetric(horizontal: 10.0),
                  //           child: TextFormField(
                  //             cursorColor: AppConstant.appMainColor,
                  //             textInputAction: TextInputAction.next,
                  //             controller: salePriceController
                  //               ..text = productModel.salePrice,
                  //             decoration: InputDecoration(
                  //               contentPadding: EdgeInsets.symmetric(
                  //                 horizontal: 10.0,
                  //               ),
                  //               hintText: "Sale Price",
                  //               hintStyle: TextStyle(fontSize: 12.0),
                  //               border: OutlineInputBorder(
                  //                 borderRadius: BorderRadius.all(
                  //                   Radius.circular(10.0),
                  //                 ),
                  //               ),
                  //             ),
                  //           ),
                  //         )
                  //       : SizedBox.shrink();
                  // }),

                  //for deliveryTime

                  //for deliveryTime
                  SizedBox(height: 10.0),
                  Container(
                    height: 65,
                    margin: EdgeInsets.symmetric(horizontal: 10.0),
                    child: TextFormField(
                      cursorColor: AppConstant.appMainColor,
                      textInputAction: TextInputAction.next,
                      controller: deliveryTimeController,
                      //controller: deliveryTimeController..text = widget.productModel.deliveryTime,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 10.0,
                        ),
                        hintText: "Delivery Time",
                        hintStyle: TextStyle(fontSize: 12.0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(10.0),
                          ),
                        ),
                      ),
                    ),
                  ),

                  //for productDescription
                  SizedBox(height: 10.0),
                  Container(
                    height: 65,
                    margin: EdgeInsets.symmetric(horizontal: 10.0),
                    child: TextFormField(
                      cursorColor: AppConstant.appMainColor,
                      textInputAction: TextInputAction.next,
                      controller: productDescriptionController,
                      //controller: productDescriptionController..text = widget.productModel.productDescription, //issue reinitiate old value when keyboard close
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 10.0,
                        ),
                        hintText: "Product Desc",
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
                      //product Model

                      EasyLoading.show();
                      ProductModel newProductModel = ProductModel(
                        productId: widget.productModel.productId,
                        categoryId: categoryDropDownController
                            .selectedCategoryId
                            .toString(),
                        productName: productNameController.text.trim(),
                        categoryName: categoryDropDownController
                            .selectedCategoryName
                            .toString(),
                        salePrice: salePriceController.text != ''
                            ? salePriceController.text.trim()
                            : '',
                        fullPrice: fullPriceController.text.trim(),
                        productImage: widget.productModel.productImage,
                        deliveryTime: deliveryTimeController.text.trim(),
                        isSale: isSaleController.isSale.value,
                        productDescription:
                        productDescriptionController.text.trim(),
                        createdAt: widget.productModel.createdAt,
                        updatedAt: DateTime.now().toString(),
                      );

                      await FirebaseFirestore.instance
                          .collection('products')
                          .doc(widget.productModel.productId)
                          .update(newProductModel.toMap());

                      EasyLoading.dismiss();
                    },
                    child: Text(" Update "),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}