import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/cupertino.dart';
import '../../models/CategoriesModel.dart';
import '../../utils/colors.dart';
import '../../utils/helper_functions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_card/image_card.dart';

import 'AllSingleCategoryProductScreen.dart';


class CategoriesWidget extends StatefulWidget {
  const CategoriesWidget({super.key});

  @override
  State<StatefulWidget> createState() => _CategoriesWidgetState();
}

class _CategoriesWidgetState extends State<CategoriesWidget> {
  final TAG = "Myy CategoriesWidget ";


  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);

    return
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
              return Padding(
                padding: EdgeInsets.all(8),
                child: Container(
                  height: Get.height/5,
                  child: ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
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
                                    child: FillImageCard(
                                      color: TColors.grey2,
                                     //color:dark?TColors.dark:TColors.white,
                                      borderRadius: 15,
                                      width: Get.width/3,
                                      heightImage: Get.height/12,
                                      //imageProvider: AssetImage(TImages.productImage1),
                                      imageProvider: NetworkImage(categoriesModel.categoryImg),
                                      //tags: [_tag('Category', () {}), _tag('Product', () {})],
                                      //title: Center(child: Text(categoriesModel.categoryName, style: TextStyle(fontSize: 16),)),
                                      title: Center(child: Text(categoriesModel.categoryName, style: Theme.of(context).textTheme.titleMedium)),
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
                ),
              );
            }

            return Container();

        }
    );

  }
}
