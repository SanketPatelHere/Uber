import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/cupertino.dart';
import '../../controllers/BannerController.dart';
import '../../logging/logger_helper.dart';
import '../../models/CategoriesModel.dart';
import '../../utils/app-constant.dart';
import '../../utils/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_card/image_card.dart';

import 'AllSingleCategoryProductScreen.dart';

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
        ),
        body:
        FutureBuilder(
          future: FirebaseFirestore.instance.collection("categories").get(),
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

            if(snapshot.data!=null){
              return
                Padding(
                  padding: EdgeInsets.all(10),
                  child: GridView.builder(
                      itemCount: snapshot.data!.docs.length,
                      shrinkWrap: true,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 3, //number of logical pixels between each child along the cross axis
                        mainAxisSpacing: 3, //number of logical pixels between each child along the main axis
                        childAspectRatio: 1.19, //ratio of the cross-axis to the main-axis extent of each child
                      ),
                      itemBuilder: (context, index){
                  var data = snapshot.data!.docs[index];
                  CategoriesModel categoriesModel = CategoriesModel(
                    categoryId: data["categoryId"],
                    categoryImg: data["categoryImg"],
                    categoryName: data["categoryName"],
                    createdAt: data["createdAt"],
                    updatedAt: data["updatedAt"],
                  );

                    return Row(
                      children: [
                        GestureDetector(
                          onTap: ()=>Get.to(()=>AllSingleCategoryProductScreen(categoryId:categoriesModel.categoryId, categoryName: categoriesModel.categoryName)),
                          child: Padding(
                            padding: EdgeInsets.all(5),
                            child: Container(
                              //decoration:BoxDecoration(color: Colors.red),
                              child: FillImageCard(
                                color: TColors.grey2,
                                borderRadius: 15,
                                width: Get.width/2.3,
                                heightImage: Get.height/10,
                                //imageProvider: AssetImage(TImages.productImage1),
                                imageProvider: NetworkImage(categoriesModel.categoryImg),
                                //imageProvider: CachedNetworkImage(imageUrl: imageUrls, fit: BoxFit.contain, width: Get.width-25,height:110,),
                                //tags: [_tag('Category', () {}), _tag('Product', () {})],
                                title: Container(
                                    //color: TColors.grey2, //color or decoration
                                    decoration:BoxDecoration(color: TColors.grey),
                                    child: Center(
                                        child: Text(
                                          categoriesModel.categoryName,
                                          style: Theme.of(context).textTheme.bodyMedium
                                          //style: TextStyle(fontSize: 13, color: Colors.black),
                                        )
                                    )
                                ),
                                //description: Text("data"),
                                //footer: Text("footer"),
                              ),
                            ),
                          ),
                        )
                      ],
                    );
                 }

                ),
                );
            }

            return Container();

          }
      )

    );
  }
}
