import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/cupertino.dart';
import '../../controllers/CartController.dart';
import '../../logging/logger_helper.dart';
import '../../models/OrderModel.dart';
import '../../utils/app-constant.dart';
import '../../utils/colors.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'AddReviewScreen.dart';


class SpecificCustomerScreen extends StatefulWidget {
  String docId;
  String customerName;
  SpecificCustomerScreen({
    super.key,
    required this.docId,
    required this.customerName,
  });

  @override
  State<StatefulWidget> createState() => _SpecificCustomerScreen();
}

class _SpecificCustomerScreen extends State<SpecificCustomerScreen> {
  final TAG = "Myy SpecificCustomerScreen ";
  final CarouselController carouselController = CarouselController();
  final CartController cartController = Get.put(CartController());

  @override
  Widget build(BuildContext context) {
    TLoggerHelper.info("${TAG} inside build");
    User? user = FirebaseAuth.instance.currentUser;

    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: TColors.white, size: 35),
          backgroundColor: AppConstant.appMainColor,
          title: Text(widget.customerName, style: TextStyle(color: AppConstant.appTextColor),),
          centerTitle: true,
        ),

        body: Text("")


    );
  }
}
