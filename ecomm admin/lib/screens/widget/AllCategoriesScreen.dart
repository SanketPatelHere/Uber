import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_swipe_action_cell/core/cell.dart';
import 'package:get/get.dart';
import 'package:flutter/cupertino.dart';
import '../../controllers/BannerController.dart';
import '../../controllers/EditCategoryController.dart';
import '../../logging/logger_helper.dart';
import '../../models/CategoriesModel.dart';
import '../../utils/app-constant.dart';
import '../../utils/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_card/image_card.dart';

import 'AddCategoryScreen.dart';
import 'AddProductScreen.dart';
import 'AllSingleCategoryProductScreen.dart';
import 'EditCategoryScreen.dart';

//https://github.com/Warisalikhan786/easy-shopping-admin-panel/blob/main/lib/screens/all_categories_screen.dart
class AllCategoriesScreen extends StatefulWidget {
  const AllCategoriesScreen({super.key});

  @override
  State<StatefulWidget> createState() => _AllCategoriesScreenState();
}

class _AllCategoriesScreenState extends State<AllCategoriesScreen> {
  final TAG = "Myy AllCategoriesScreen ";
  final CarouselController carouselController = CarouselController();
  final BannerController bannerController = Get.put(BannerController());

  @override
  Widget build(BuildContext context) {
    TLoggerHelper.info("${TAG} inside build");
    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: TColors.white, size: 35),
          backgroundColor: AppConstant.appMainColor,
          title: Text("All Categories", style: TextStyle(color: AppConstant.appTextColor),),
          centerTitle: true,
          actions: [
            GestureDetector(
              onTap: ()=>Get.to(()=>AddCategoryScreen()),
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
                .collection("categories")
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
              return Center(child: Text("No Category Found!"));
            }

            if (snapshot.data != null) {
              return ListView.builder(
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  final data = snapshot.data!.docs[index];

                  CategoriesModel categoriesModel = CategoriesModel(
                    categoryId: data['categoryId'],
                    categoryName: data['categoryName'],
                    categoryImg: data['categoryImg'],
                    createdAt: data['createdAt'],
                    updatedAt: data['updatedAt'],
                  );

                  return SwipeActionCell(
                    key: ObjectKey(categoriesModel.categoryId),

                    /// this key is necessary
                    trailingActions: <SwipeAction>[
                      SwipeAction(
                          title: "Delete",
                          onTap: (CompletionHandler handler) async {
                            await Get.defaultDialog(
                              title: "Delete Product",
                              content: const Text(
                                  "Are you sure you want to delete this product?"),
                              textCancel: "Cancel",
                              textConfirm: "Delete",
                              contentPadding: const EdgeInsets.all(10.0),
                              confirmTextColor: Colors.white,
                              onCancel: () {},
                              onConfirm: () async {
                                Get.back(); // Close the dialog
                                EasyLoading.show(status: 'Please wait..');
                                EditCategoryController editCategoryController = Get.put(EditCategoryController(categoriesModel: categoriesModel));

                                //for remove category image from storage
                                await editCategoryController.deleteImagesFromStorage(categoriesModel.categoryImg);
                                //for remove whole category from firebasefirestore
                                await editCategoryController.deleteWholeCategoryFromFireStore(categoriesModel.categoryId);

                                EasyLoading.dismiss();
                              },
                              buttonColor: Colors.red,
                              cancelTextColor: Colors.black,
                            );
                          },
                          color: Colors.red),
                    ],
                    child: Card(
                      elevation: 5,
                      child: ListTile(
                        onTap: () {},
                        leading: CircleAvatar(
                          backgroundColor: AppConstant.appSecondaryColor,
                          backgroundImage: CachedNetworkImageProvider(
                            categoriesModel.categoryImg.toString(),
                            errorListener: (err) {
                              // Handle the error here
                              const Icon(Icons.error);
                            },
                          ),
                        ),
                        title: Text(categoriesModel.categoryName),
                        subtitle: Text(categoriesModel.categoryId),
                        trailing: GestureDetector(
                            onTap: () => {
                              Get.to(() => EditCategoryScreen(categoriesModel: categoriesModel),)
                            },
                            child: const Icon(Icons.edit)),
                      ),
                    ),
                  );
                },
              );
            }

            return Container();
          },
        ),
    );
  }
}