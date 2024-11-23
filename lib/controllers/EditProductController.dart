
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

import '../models/ProductModel.dart';

class EditProductController extends GetxController {
  final TAG = "Myy EditProductController ";
  ProductModel productModel;
  EditProductController({required this.productModel});
  RxList<String> images = <String>[].obs;

    @override
    void onInit() {
      TLoggerHelper.info("${TAG} inside onInit");
      super.onInit();
      getRealTimeImages();
    }

    void getRealTimeImages(){
      TLoggerHelper.info("${TAG} inside getRealTimeImages for productModel.productId = "+productModel.productId);
      TLoggerHelper.info("${TAG} inside getRealTimeImages for productModel.productName = "+productModel.productName);
      TLoggerHelper.info("${TAG} inside getRealTimeImages for productModel.productImage = "+productModel.productImage.toString());
      FirebaseFirestore.instance
          .collection('products')
          .doc(productModel.productId)
          .snapshots()
          .listen((DocumentSnapshot snapshot){
        TLoggerHelper.info("${TAG} getRealTimeImages snapshot1 = "+snapshot.toString()); //Instance of '_JsonDocumentSnapshot'
         //if(snapshot.exists){
           TLoggerHelper.info("${TAG} getRealTimeImages snapshot = "+snapshot.toString());
           TLoggerHelper.info("${TAG} getRealTimeImages snapshot.data() = "+snapshot.data().toString()); //null
          final data = snapshot.data() as Map<String, dynamic>?;
           TLoggerHelper.info("${TAG} getRealTimeImages data = "+data.toString());
           if(data!=null && data["productImage"]!=null){
             images.value = List<String>.from(data["productImage"] as List<dynamic>);
             update();
             TLoggerHelper.info("${TAG} getRealTimeImages images.value = "+images.value.toString());
           }
         //}
      });

      TLoggerHelper.info("${TAG} getRealTimeImages images length = "+images.length.toString());

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
    Future deleteImagesFromFireStore(String imageUrl, String productId) async{
      TLoggerHelper.info("${TAG} inside deleteImagesFromFireStore imageUrl = "+imageUrl.toString()+" and productId = "+productId);
      try{
        await FirebaseFirestore.instance
            .collection("products")
            .doc(productId)
            .update({
                //remove by passing url at specific productId
                "productImage": FieldValue.arrayRemove([imageUrl])
            });

        update();
      }
      catch(e){
        TLoggerHelper.info("${TAG} inside deleteImagesFromFireStore Error in catch e = "+e.toString());

      }
    }
  //delete images end


}