
import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

import '../logging/logger_helper.dart';
import "package:image_picker/image_picker.dart";

import '../models/CategoriesModel.dart';
import '../models/ProductModel.dart';

class EditCategoryController extends GetxController {
  final TAG = "Myy EditCategoryController ";
  CategoriesModel  categoriesModel ;
  EditCategoryController({required this.categoriesModel});
  RxList<String> categoryImg  = <String>[].obs;

    @override
    void onInit() {
      TLoggerHelper.info("${TAG} inside onInit");
      super.onInit();
      getRealTimeCategoryImg();
    }

    void getRealTimeCategoryImg(){
      TLoggerHelper.info("${TAG} inside getRealTimeCategoryImg for categoriesModel.categoryId = "+categoriesModel.categoryId);
      TLoggerHelper.info("${TAG} inside getRealTimeCategoryImg for categoriesModel.categoryName = "+categoriesModel.categoryName);
      TLoggerHelper.info("${TAG} inside getRealTimeCategoryImg for categoriesModel.categoryImg = "+categoriesModel.categoryImg.toString());
      FirebaseFirestore.instance
          .collection('categories')
          .doc(categoriesModel.categoryId)
          .snapshots()
          .listen((DocumentSnapshot snapshot){
        TLoggerHelper.info("${TAG} getRealTimeCategoryImg snapshot1 = "+snapshot.toString()); //Instance of '_JsonDocumentSnapshot'
         //if(snapshot.exists){
           TLoggerHelper.info("${TAG} getRealTimeCategoryImg snapshot = "+snapshot.toString());
           TLoggerHelper.info("${TAG} getRealTimeCategoryImg snapshot.data() = "+snapshot.data().toString()); //null
          final data = snapshot.data() as Map<String, dynamic>?;
           TLoggerHelper.info("${TAG} getRealTimeCategoryImg data = "+data.toString());
           if(data!=null && data["categoryImg"]!=null){
             categoryImg.value = List<String>.from(data["categoryImg"] as List<dynamic>);
             update();
             TLoggerHelper.info("${TAG} getRealTimeCategoryImg categoryImg.value = "+categoryImg.value.toString());
           }
         //}
      });

      TLoggerHelper.info("${TAG} getRealTimeCategoryImg categoryImg length = "+categoryImg.length.toString());

    }


    //delete images start
    //1.from storage
    Future deleteImagesFromStorage(String imageUrl) async{
      TLoggerHelper.info("${TAG} inside deleteImagesFromStorage imageUrl = "+imageUrl.toString());
      final FirebaseStorage storage = FirebaseStorage.instance;
      try{
        //remove by passing url
        Reference reference = storage.refFromURL(imageUrl);
        await reference.delete();
      }
      catch(e){
        TLoggerHelper.info("${TAG} inside deleteImagesFromStorage Error in catch e = "+e.toString());

      }
    }

    //2.from firestore
    Future deleteImageFromFireStore(String imageUrl, String categoryId) async{
      TLoggerHelper.info("${TAG} inside deleteImagesFromFireStore imageUrl = "+imageUrl.toString()+" and categoryId = "+categoryId);
      try{
        await FirebaseFirestore.instance
            .collection("categories")
            .doc(categoryId)
            .update({
                //remove by update at ""
                //"categoryImg": FieldValue.arrayRemove([imageUrl])
                "categoryImg": ""
            });

        update();
      }
      catch(e){
        TLoggerHelper.info("${TAG} inside deleteImagesFromFireStore Error in catch e = "+e.toString());
      }
    }
  //delete images end

//delete whole category from firestore
  Future<void> deleteWholeCategoryFromFireStore(String categoryId) async {
    TLoggerHelper.info("${TAG} inside deleteWholeCategoryFromFireStore categoryId = "+categoryId.toString());
    try {
      await FirebaseFirestore.instance
          .collection('categories')
          .doc(categoryId)
          .delete();
      update();
    } catch (e) {
      TLoggerHelper.info("${TAG} inside deleteWholeCategoryFromFireStore Error in catch e = "+e.toString());
    }
  }


}