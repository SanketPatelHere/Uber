
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

import '../logging/logger_helper.dart';

class CategoryDropDownController extends GetxController {
  final TAG = "Myy CategoryDropDownController ";
  RxList<Map<String, dynamic>> categories = <Map<String, dynamic>>[].obs;
  RxString? selectedCategoryId;
  RxString? selectedCategoryName;

  @override
  void onInit() {
    TLoggerHelper.info("${TAG} inside onInit");
    super.onInit();
    fetchCategories();
  }

  Future<void> fetchCategories() async {
    TLoggerHelper.info("${TAG} inside fetchCategories");
    try{
      QuerySnapshot<Map<String,dynamic>> querySnapshot =
          await FirebaseFirestore.instance
          .collection("categories")
          .get();
      List<Map<String,dynamic>> categoriesList = [];
      querySnapshot.docs.forEach((DocumentSnapshot<Map<String,dynamic>> document){
        categoriesList.add({
          "categoryId":document.id, //or
          //"categoryId":document["categoryId"],
          "categoryName":document["categoryName"],
          "categoryImg":document["categoryImg"],
        });
      });

      categories.value = categoriesList;
      update();
      //[{categoryId: MjQq7z6D7vq3aeNy2lVk, categoryName: winter, categoryImg: https://www.bartonsrewards.com.au/images/banner1.png}, {categoryId: wVktwAwB24PvR4vrpKp2, categoryName: Summer, categoryImg: https://www.bartonsrewards.com.au/images/banner2.png}]
      TLoggerHelper.info("${TAG} fetchCategories categories.value = "+categories.value.toString());

    }
    catch(e){
      TLoggerHelper.info("${TAG} Error in fetchCategories e = "+e.toString());
    }
  }

  //set selected category id
  void setSelectedCategory(String? categoryId){
    TLoggerHelper.info("${TAG} setSelectedCategory categoryId = "+categoryId.toString());
    selectedCategoryId = categoryId?.obs;
    update();
  }

  //fetch category name
  Future<String?> getCategoryName(String? categoryId) async {
    TLoggerHelper.info("${TAG} getCategoryName categoryId = "+categoryId.toString());
    try{
     DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore.instance
        .collection("categories")
        .doc(categoryId)
        .get();

     if(snapshot.exists){

       TLoggerHelper.info("${TAG} getCategoryName snapshot.data().categoryName = "+snapshot.data()?["categoryName"]+" of categoryId = "+categoryId.toString());
       return snapshot.data()?["categoryName"];
     }
     else{
       return null;
     }
    }
    catch(e){
      TLoggerHelper.info("${TAG} Error in getCategoryName e = "+e.toString());
      //return null;
      return null;
    }
  }

  //set selected category name
  void setSelectedCategoryName(String? categoryName){
    TLoggerHelper.info("${TAG} setSelectedCategoryName categoryName = "+categoryName.toString());
    selectedCategoryName = categoryName?.obs;
    update();
  }

  //set old value
  void setOldValue(String? categoryId){
    //TLoggerHelper.info("${TAG} setOldValue categoryId = "+categoryId.toString());
    selectedCategoryId = categoryId?.obs;
    TLoggerHelper.info("${TAG} setOldValue selectedCategoryId = "+selectedCategoryId.toString());
    update();
  }

}