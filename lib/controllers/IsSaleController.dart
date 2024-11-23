
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

import '../logging/logger_helper.dart';

class IsSaleController extends GetxController {
  final TAG = "Myy IsSaleController ";
  RxBool isSale = false.obs;

  //set selected category id
  void toggleIsSale(bool value){
    TLoggerHelper.info("${TAG} setSelectedCategory toggleIsSale value = "+value.toString());
    isSale.value = value;
    update();
  }


  //setIsSaleOldValue
  void setIsSaleOldValue(bool value){
    TLoggerHelper.info("${TAG} setIsSaleOldValue value = "+value.toString());
    isSale.value = value;
    update();
  }

}