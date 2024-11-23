
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../logging/logger_helper.dart';

class GetUserLengthController extends GetxController {
      final TAG = "Myy GetUserLengthController ";
      final FirebaseFirestore firestore = FirebaseFirestore.instance;
      late StreamSubscription<QuerySnapshot<Map<String, dynamic>>> userControllerSubscription;

      final Rx<int> userControllerLength = Rx<int>(0);


      @override
    void onInit() {
        TLoggerHelper.info("${TAG} inside onInit");
        super.onInit();

        userControllerSubscription = firestore
          .collection("users")
          .where("isAdmin", isEqualTo: false) //get all user count, not admin count
          .snapshots()
          .listen((snapshot){
            userControllerLength.value = snapshot.size;
          });
    }

    @override
  void onClose() {
      TLoggerHelper.info("${TAG} inside onInit");
      userControllerSubscription.cancel();
      super.onClose();
  }
    
}