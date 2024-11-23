import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_swipe_action_cell/core/cell.dart';
import 'package:get/get.dart';
import 'package:flutter/cupertino.dart';
import '../../controllers/BannerController.dart';
import '../../controllers/CalculateProductRatingController.dart';
import '../../controllers/EditCategoryController.dart';
import '../../logging/logger_helper.dart';
import '../../models/CategoriesModel.dart';
import '../../models/ReviewModel.dart';
import '../../utils/app-constant.dart';
import '../../utils/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_card/image_card.dart';

import 'AddCategoryScreen.dart';
import 'AddProductScreen.dart';
import 'AllSingleCategoryProductScreen.dart';
import 'EditCategoryScreen.dart';

class AllReviewsScreen extends StatefulWidget {
  const AllReviewsScreen({super.key});

  @override
  State<StatefulWidget> createState() => _AllReviewsScreenState();
}

class _AllReviewsScreenState extends State<AllReviewsScreen> {
  final TAG = "Myy AllReviewsScreen ";

  //final CalculateProductRatingController calculateProductRatingController = Get.put(CalculateProductRatingController(widget.orderModel.productId));
  final CarouselController carouselController = CarouselController();
  final BannerController bannerController = Get.put(BannerController());

  @override
  Widget build(BuildContext context) {
    TLoggerHelper.info("${TAG} inside build");
    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: TColors.white, size: 35),
          backgroundColor: AppConstant.appMainColor,
          title: Text("All Reviews", style: TextStyle(color: AppConstant.appTextColor),),
          centerTitle: true,
          actions: [
            GestureDetector(
              //onTap: ()=>Get.to(()=>AddCategoriesScreen()),
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
                //.doc(productId)
                .doc("YZEBfQQnnvtv8BtzPtik")
                .collection("reviews")
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
              return Center(child: Text("No Reviews Found!"));
            }

            if (snapshot.data != null) {
              return ListView.builder(
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  final data = snapshot.data!.docs[index];

                  //for add data in reference for order's orderModel
                  ReviewModel reviewModel = ReviewModel(
                    customerId: data["customerId"],
                    customerName: data["customerName"],
                    customerPhone: data["customerPhone"],
                    customerDeviceToken: data["customerDeviceToken"],
                    feedback: data["feedback"],
                    rating: data["rating"],
                    createdAt: data["createdAt"],
                  );

                  return SwipeActionCell(
                    key: ObjectKey(reviewModel.customerId),

                    /// this key is necessary
                    trailingActions: <SwipeAction>[
                      SwipeAction(
                          title: "Delete",
                          onTap: (CompletionHandler handler) async {
                            await Get.defaultDialog(
                              title: "Delete Review",
                              content: const Text("Are you sure you want to delete this review?"),
                              textCancel: "Cancel",
                              textConfirm: "Delete",
                              contentPadding: const EdgeInsets.all(10.0),
                              confirmTextColor: Colors.white,
                              onCancel: () {},
                              onConfirm: () async {
                                Get.back(); // Close the dialog
                                EasyLoading.show(status: 'Please wait..');

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
                          backgroundImage:
                          CachedNetworkImageProvider(
                            //Icon(Icons.error).toString(),
                            Text(reviewModel.customerName[0]).toString(),
                            errorListener: (err) {
                              // Handle the error here
                              const Icon(Icons.error);
                            },
                          ),
                        ),
                        title: Text(reviewModel.customerName, style: Theme.of(context).textTheme.bodyMedium),
                        //title: Text(categoriesModel.categoryName),
                        subtitle:Text(reviewModel.feedback, style: Theme.of(context).textTheme.bodyMedium),
                        //subtitle: Text(categoriesModel.categoryId),
                        trailing: GestureDetector(
                            onTap: () => {
                              ///Get.to(() => EditCategoryScreen(categoriesModel: categoriesModel),)
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