import 'package:flutter/material.dart';
import '../../logging/logger_helper.dart';
import '../../models/OrderModel.dart';
import '../../models/ReviewModel.dart';
import '../../utils/TLoaders.dart';
import '../../utils/app-constant.dart';
import '../../utils/colors.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class AddReviewScreen extends StatefulWidget {

  OrderModel orderModel;
  AddReviewScreen({
    super.key,
    required this. orderModel,
  });

  @override
  State<StatefulWidget> createState() => _AddReviewScreen();
}

class _AddReviewScreen extends State<AddReviewScreen> {
  final TAG = "Myy AddReviewScreen ";
  double productRating = 0;

  @override
  Widget build(BuildContext context) {
    TLoggerHelper.info("${TAG} inside build");
    User? user = FirebaseAuth.instance.currentUser;
    TextEditingController feedbackController = TextEditingController();


    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: TColors.white, size: 35),
          backgroundColor: AppConstant.appMainColor,
          title: Text("Add Review", style: TextStyle(color: AppConstant.appTextColor),),
          centerTitle: true,
        ),

        body:Container(
          alignment: Alignment.center,
          margin: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
                const Text("Add your rating and review"),
              RatingBar.builder(
                initialRating: 0,
                minRating: 1,
                direction: Axis.horizontal,
                allowHalfRating: true,
                itemCount: 5,
                itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                /*ratingWidget: RatingWidget(
                  full:  Icon(Icons.star, color: Colors.orange,),
                  half:  Icon(Icons.star, color: Colors.deepOrange,),
                  empty:  Icon(Icons.star, color: Colors.yellow,),
                ),*/
                /*ratingWidget: RatingWidget(
                  full: _image('assets/heart.png'),
                  half: _image('assets/heart_half.png'),
                  empty: _image('assets/heart_border.png'),
                ),*/
                itemBuilder:(context, _)=>const Icon(Icons.star, color: Colors.amber),
                  onRatingUpdate: (rating) {
                    print(rating);
                    productRating = rating;
                    TLoggerHelper.info("${TAG} onRatingUpdate rating = "+rating.toString());
                    TLoggerHelper.info("${TAG} onRatingUpdate productRating = "+productRating.toString());
                    setState(() {});
                  },
                ),
              SizedBox(height: 25),
              const Text("Feedback"),
              SizedBox(height: 20),
              TextFormField(
                controller: feedbackController,
                decoration: InputDecoration(
                    label: Text("Share your feedback"),
                   hintText: "Enter your feedback",
                  hintStyle: Theme.of(context).textTheme.labelMedium!.apply(color: TColors.grey2),
                ),
              ),
              SizedBox(height: 25),

              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: AppConstant.appMainColor,
                      padding: EdgeInsets.fromLTRB(15,15,15,15)
                  ),
                  onPressed: () async{
                    String feedback = feedbackController.text.trim();
                    TLoggerHelper.info("${TAG} onPressed productRating = "+productRating.toString());
                    TLoggerHelper.info("${TAG} onPressed feedback = "+feedback.toString());

                    if(feedback.toString()!="")
                    {
                      EasyLoading.show(status: "Please wait...");

                      ReviewModel reviewModel = ReviewModel(
                          customerId: widget.orderModel.customerId,
                          customerName: widget.orderModel.customerName,
                          customerPhone: widget.orderModel.customerPhone,
                          customerDeviceToken: widget.orderModel.customerDeviceToken,
                          feedback: feedback,
                          rating: productRating.toString(),
                          createdAt: DateTime.now().toString()
                      );

                      await FirebaseFirestore.instance
                          .collection("products")
                          .doc(widget.orderModel.productId)
                          .collection("reviews")
                          .doc(user!.uid)
                          .set(reviewModel.toMap());

                      EasyLoading.dismiss();
                      TLoaders.successSnakeBar(title: "Success", message: "Review added successfully");
                    }
                    else
                    {
                      TLoaders.errorSnakeBar(title: "Error in add review ", message: "please fill all details");
                      TLoggerHelper.info("${TAG}  please fill all details");
                    }



                    
                  },
                  child: Text("Done",
                      //style:  Theme.of(context).textTheme.labelMedium!.apply(color: TColors.black)
                  )
              )
            ],
          ),
        )
    );
  }
}
