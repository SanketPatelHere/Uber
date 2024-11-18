
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


//for category image upload
/*
AddProductImagesController same as AddCategoryImagesController
only difference is .child("product-images") and .child("category-images")
 */
class AddCategoryImagesController extends GetxController {
  final TAG = "Myy AddCategoryImagesController ";
  final ImagePicker _picker = ImagePicker();
  RxList<XFile> selectedImages = <XFile>[].obs; //for select image from camera or gallery
  final RxList<String> arrImageUrl = <String>[].obs; //for upload multiple images in storage
  //final Rx<String> arrImageUrl =  ''.obs; //for upload single image in storage
  final FirebaseStorage storageRef = FirebaseStorage.instance;

  Future<void> showImagePickerDialog() async{
    PermissionStatus status;
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidDeviceInfo = await deviceInfo.androidInfo;
    TLoggerHelper.info("${TAG} showImagePickerDialog deviceInfo = "+deviceInfo.toString());
    TLoggerHelper.info("${TAG} showImagePickerDialog androidDeviceInfo = "+androidDeviceInfo.toString());

    //for old device permission
    if(androidDeviceInfo.version.sdkInt<=32)
    {
      status = await Permission.storage.request();
    }
    //for new device permission
    else
    {
      status = await Permission.mediaLibrary.request();
    }

    //when user granted permission
    if(status==PermissionStatus.granted)
    {
      //come into this when user granted permission
      TLoggerHelper.info("${TAG} showImagePickerDialog user mediaLibrary permission granted");
      Get.defaultDialog(
        title: "Choose Image",
        middleText: "Pick an image from the camera or gallery",
        actions: [
          ElevatedButton(onPressed: (){
               selectImages("Camera");
              },
              child: Text(" Camera ")),
          ElevatedButton(onPressed: (){
              selectImages("Gallery");
              },
              child: Text(" Gallery ")),
        ]
      );
    }
    //when user denied permission
    if(status==PermissionStatus.denied)
    {
      TLoggerHelper.info("${TAG} showImagePickerDialog user mediaLibrary permission denied");
      openAppSettings();
    }
    //when user permanent denied permission
    if(status==PermissionStatus.permanentlyDenied)
    {
      TLoggerHelper.info("${TAG} showImagePickerDialog user mediaLibrary permission permanentlyDenied");
    }
  }

  Future<void> selectImages(String type) async{
    TLoggerHelper.info("${TAG} inside selectImages");
    Get.back(); //for close dialog
    List<XFile> imgs = [];
    if(type=="Gallery"){
      try{
        //imgs = await _picker.pickMultiImage(imageQuality:80);
        imgs = await ImagePicker().pickMultiImage(imageQuality:80);
        TLoggerHelper.info("${TAG} selectImages imgs = "+imgs.toString()); //[Instance of 'XFile']
        update();
      }
      catch(e){
        TLoggerHelper.info("${TAG} selectImages Error in catch e = "+e.toString());
      }
    }
    else{
      final img = await ImagePicker().pickImage(source: ImageSource.camera, imageQuality: 70, maxWidth: 512, maxHeight: 512);
      //final img = await _picker.pickImage(source:ImageSource.camera, imageQuality:80);
      TLoggerHelper.info("${TAG} selectImages img = "+img.toString()); //[Instance of 'XFile']
      if(img!=null){
        imgs.add(img);
        update();
      }
    }

    if (imgs.isNotEmpty) {
      selectedImages.addAll(imgs);
      update();
      TLoggerHelper.info("${TAG} selectImages length = "+selectedImages.length.toString());
    }

  }

  void removeImages(int index){
    selectedImages.removeAt(index);
    update();
  }


  //todo for upload images in storage start
  Future<void> uploadFunction(List<XFile> images)async{
    TLoggerHelper.info("${TAG} inside uploadFunction images = "+images.toString());
    arrImageUrl.clear();
    for(int i=0;i<images.length;i++){
      dynamic imageUrl = await uploadFile(images[i]);
      arrImageUrl.add(imageUrl.toString());
    }
    update();
    TLoggerHelper.info("${TAG} inside uploadFile arrImageUrl = "+arrImageUrl.toString());
  }

  Future<String> uploadFile(XFile image)async{
    TLoggerHelper.info("${TAG} inside uploadFile image = "+image.toString());
    TaskSnapshot reference = await storageRef
      .ref()
      .child("category-images")
      .child(image.name+DateTime.now().toString())
      .putFile(File(image.path));

    Future<String> imgDownloadUrl = reference.ref.getDownloadURL();
    TLoggerHelper.info("${TAG} inside uploadFile imgDownloadUrl = "+imgDownloadUrl.toString());
    return await imgDownloadUrl;

  }
//todo for upload images in storage end



}