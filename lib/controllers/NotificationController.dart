

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../logging/logger_helper.dart';



class NotificationController extends GetxController {
    final TAG = "Myy NotificationController ";

    User? user = FirebaseAuth.instance.currentUser;
    var notificationCount = 0.obs;
      @override
      void onInit() {
        TLoggerHelper.info("${TAG} inside onInit");
        super.onInit();
        fetchNotificationCount();
      }

      //for show only notification count
      void fetchNotificationCount() async{
        TLoggerHelper.info("${TAG} inside fetchNotificationCount");
        FirebaseFirestore.instance
        .collection("notifications")
        .doc(user!.uid)
        .collection("notifications")
        .where("isSeen", isEqualTo: false)
        .snapshots()
        .listen((QuerySnapshot querySnapshot){
          notificationCount.value = querySnapshot.docs.length;
          update();
        });
      }


}