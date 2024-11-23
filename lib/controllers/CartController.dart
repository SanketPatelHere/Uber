

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../logging/logger_helper.dart';



class CartController extends GetxController {
    final TAG = "Myy CartController ";

    RxDouble totalPrice = 0.0.obs;
    User? user = FirebaseAuth.instance.currentUser;
    var cartCount = 0.obs;

    final FirebaseAuth _auth = FirebaseAuth.instance;
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
      @override
      void onInit() {
        TLoggerHelper.info("${TAG} inside onInit");
        super.onInit();
        fetchProductPrice();
        fetchCartCount();
      }

    //for show only cart count
    void fetchCartCount() async{
      TLoggerHelper.info("${TAG} inside fetchCartCount");
      FirebaseFirestore.instance
          .collection("cart")
          .doc(user!.uid)
          .collection("cartOrder")
         // .where("isSeen", isEqualTo: false)
          .snapshots()
          .listen((QuerySnapshot querySnapshot){
        cartCount.value = querySnapshot.docs.length;
        update();
      });

      TLoggerHelper.info("${TAG} inside fetchCartCount cartCount.value = "+cartCount.value.toString());
    }
      
      //for calculate product price
      void fetchProductPrice() async{
        final QuerySnapshot<Map<String, dynamic>> snapshot =
            await FirebaseFirestore.instance
                .collection("cart")
                .doc(user!.uid)
                .collection("cartOrder")
                .get();

          double sum = 0.0;
          double count = 0;
          //RxDouble sum = 0.0.obs;

          for(final doc in snapshot.docs)
          {
              final data = doc.data();
              if(data.containsKey("productTotalPrice"))
              {
                  //sum = sum + (data["productTotalPrice"] as num).toDouble();
                  //sum +=  (data["productTotalPrice"] as num).toDouble();
                  sum +=  (data["productTotalPrice"]).toDouble();
                  //sum +=  (data["productTotalPrice"]);
              }
          }

        //totalPrice = sum as RxDouble;
        totalPrice.value = sum;

      }


}