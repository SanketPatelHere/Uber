
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../logging/logger_helper.dart';

class GetOrderLengthController extends GetxController {
      final TAG = "Myy GetOrderLengthController ";
      final FirebaseFirestore firestore = FirebaseFirestore.instance;
      late StreamSubscription<QuerySnapshot<Map<String, dynamic>>> orderControllerSubscription;

      final Rx<int> orderControllerLength = Rx<int>(0);


      @override
    void onInit() {
        TLoggerHelper.info("${TAG} inside onInit");
        super.onInit();

        orderControllerSubscription = firestore
          .collection("orders")
          .where("isAdmin", isEqualTo: false) //get all user count, not admin count
          .snapshots()
          .listen((snapshot){
            TLoggerHelper.info("${TAG} inside snapshot size = "+snapshot.size.toString());
            orderControllerLength.value = snapshot.size;
          });
    }

    @override
  void onClose() {
      TLoggerHelper.info("${TAG} inside onInit");
      orderControllerSubscription.cancel();
      super.onClose();
  }
    
}