
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

import '../logging/logger_helper.dart';

class GetAllOrdersChart extends GetxController {
  final TAG = "Myy GetAllOrdersChart ";

  @override
  void onInit() {
    TLoggerHelper.info("${TAG} inside onInit");
    super.onInit();
    fetchCategories();
  }

  Future<void> fetchCategories() async {
    TLoggerHelper.info("${TAG} inside fetchCategories");

  }


}