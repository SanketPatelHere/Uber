
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../logging/logger_helper.dart';

class CalculateProductRatingController extends GetxController {
      final TAG = "Myy CalculateProductRatingController ";
      final String productId;
      RxDouble averageRating = 0.0.obs;
      CalculateProductRatingController(this.productId);

      @override
    void onInit() {
        TLoggerHelper.info("${TAG} inside onInit");
        super.onInit();
        calculateAvarageRating();
    }
    
    Future<void> calculateAvarageRating() async{
      TLoggerHelper.info("${TAG} inside calculateAvarageRating");
      /*var mysnapshots =  await FirebaseFirestore.instance
          .collection("products")
          .doc(productId)
          .collection("reviews")
          .snapshots();
          mysnapshots.listen((snapshots){

          });*/

      await FirebaseFirestore.instance
          .collection("products")
          .doc(productId)
          .collection("reviews")
          .snapshots()
          .listen((snapshots){
          if(snapshots.docs.isNotEmpty){
            double totalRating = 0;
            int numberOfReviews = 0;
            snapshots.docs.forEach((doc){
                  final ratingAsString = doc["rating"] as String;
                  //convert string rating to double
                  final rating = double.tryParse(ratingAsString);
                  if(rating!=null){
                      totalRating += rating;
                      numberOfReviews++;
                  }
            });

            if(numberOfReviews!=0){
                averageRating.value = totalRating/numberOfReviews;
            }
            else{
              averageRating.value = 0.0;
            }

          }
          else{
            averageRating.value = 0.0;
          }

          TLoggerHelper.info("${TAG} inside calculateAvarageRating averageRating.value = "+averageRating.value.toString());

      });

    }
}