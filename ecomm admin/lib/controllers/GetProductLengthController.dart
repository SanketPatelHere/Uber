
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../logging/logger_helper.dart';

class GetProductLengthController extends GetxController {
      final TAG = "Myy GetProductLengthController ";
      final FirebaseFirestore firestore = FirebaseFirestore.instance;
      late StreamSubscription<QuerySnapshot<Map<String, dynamic>>> productControllerSubscription;

      final Rx<int> productControllerLength = Rx<int>(0);


      @override
    void onInit() {
        TLoggerHelper.info("${TAG} inside onInit");
        super.onInit();

        productControllerSubscription = firestore
          .collection("products")
          .snapshots()
          .listen((snapshot){
            productControllerLength.value = snapshot.size;
          });
    }

    @override
  void onClose() {
      TLoggerHelper.info("${TAG} inside onInit");
      productControllerSubscription.cancel();
      super.onClose();
  }
    
}