
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:flutter_easyloading/flutter_easyloading.dart';
import '../MainScreen.dart';
import '../logging/logger_helper.dart';
import '../models/OrderModel.dart';
import '../services/GetDeviceTokenController.dart';
import '../services/NotificationService.dart';
import '../services/SendNotificationService.dart';
import '../utils/TLoaders.dart';



import '../services/generateOrderId.dart';

void placeOrder(
    {
      required BuildContext context,
      required String customerName,
      required String customerPhone,
      required String customerAddress,
      required String customerDeviceToken,
    }) async{
  final TAG = "Myy placeOrder ";

  NotificationService notificationService = NotificationService();
  final user = FirebaseAuth.instance.currentUser;
  if(user!=null)
  {
    try
    {
      TLoggerHelper.info("${TAG} placeorder customerName = "+customerName);
      TLoggerHelper.info("${TAG} placeorder customerPhone = "+customerPhone);
      TLoggerHelper.info("${TAG} placeorder customerAddress = "+customerAddress);
      TLoggerHelper.info("${TAG} placeorder customerDeviceToken = "+customerDeviceToken);
      EasyLoading.show(status: "Please wait...");

      //for get whole list of cart
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection("cart")
          .doc(user.uid)
          .collection("cartOrder")
          .get();

      //for get whole list of cart
      List<QueryDocumentSnapshot> documents = querySnapshot.docs;

      for(var doc in documents)
      {
        Map<String, dynamic>? data = doc.data() as Map<String, dynamic>;
        String orderId = generateOrderId();
        TLoggerHelper.info("${TAG} placeorder orderId = "+orderId+" for productId = "+data["productId"]);

        //for add data in reference for order's orderModel
        OrderModel orderModel = OrderModel(
          categoryName: data["categoryName"],
          createdAt: DateTime.now().toString(), //date of order placed
          //createdAt:  data["createdAt"], //date of order placed
          //updatedAt: DateTime.now().toString(),
          updatedAt: data["updatedAt"], //date of product added into cart added
          deliveryTime: data["deliveryTime"],
          productId: data["productId"],
          productName: data["productName"],
          productDescription: data["productDescription"],
          fullPrice: data["fullPrice"],
          salePrice: data["salePrice"],
          isSale: data["isSale"],
          productImage: data["productImage"],
          productQuantity: data["productQuantity"],
          //productTotalPrice: double.parse(data.fullPrice)
          productTotalPrice: double.parse(data["productTotalPrice"].toString()),

          status: false,
          categoryId: user.uid,
          customerId: user.uid,
          customerName: customerName,
          customerPhone: customerPhone,
          customerAddress: customerAddress,
          customerDeviceToken: customerDeviceToken,
        );


        //no need of this inner for loop, without this also work
        for(var x=0;x<documents.length;x++) //for loop upto whole cart item object(categoryId to updatedAt)
            {
          //put this in outside of loop
          //for save confirmOrders outer parameters
          await FirebaseFirestore.instance
              .collection("orders")
              .doc(user.uid)
              .set({
            "uId":user.uid,
            "customerId":user.uid,
            "customerName":customerName,
            "customerPhone":customerPhone,
            "customerAddress":customerAddress,
            "customerDeviceToken":customerDeviceToken,
            "orderStatus":false,
            "createdAt":DateTime.now(),
          });

          //for save confirmOrders inner parameters
          //upload orders
          await FirebaseFirestore.instance
              .collection("orders")
              .doc(user.uid)
              .collection("confirmOrders")
              .doc(orderId)
              .set(orderModel.toMap());

          //for clear cart
          //for delete cart products
          await FirebaseFirestore.instance
              .collection("cart")
              .doc(user.uid)
              .collection("cartOrder")
              .doc(orderModel.productId.toString()) //or documents[x].productId
              .delete()
              .then((value){
            //TLoggerHelper.info("${TAG} placeorder and delete card orderId = "+orderId+" for productId = "+data["productId"]);
            TLoggerHelper.info("${TAG} placeorder and delete card orderId = "+orderId+" for productId = $orderModel.productId.toString()}");
          });



          EasyLoading.dismiss();
          Get.offAll(()=>MainScreen());

        }



        //for save notification(save same order object in notifications)
        await FirebaseFirestore.instance
            .collection("notifications")
            .doc(user.uid)
            .collection("notifications")
            .doc()
            .set({
          "title":"Order Successfully placed for product ${orderModel.productName}",
          "body":orderModel.productDescription,
          "isSeen":false,
          "createdAt":DateTime.now().toString(),
          "image":orderModel.productImage,
          "fullPrice":orderModel.fullPrice,
          "salePrice":orderModel.salePrice,
          "productQuantity":orderModel.productQuantity,
          "isSale":orderModel.isSale,
          "productId":orderModel.productId,

        });
      }

      //todo for send push notificationh after order start
      final GetDeviceTokenController getDeviceTokenController = Get.put(GetDeviceTokenController());
      var token1 = await getDeviceTokenController.deviceToken.toString();
      //for sent notification to user itself after order
      await SendNotificationService.sendNotificationUsingApi(
          //token:"dg70JOl-QdSP6fs_GwGCmd:APA91bFURnO5ew6thVHjVjnGrmpH2R6U_IdJlnyuMfBicZOdpSEQO1xtKpqB_Njh0zQWjSj1aKN6NgQ1FjKhnjnXV3dLe5g9fCW2-TmG7BJ4GiG3RvAlI2Rc6cq2n0pmr3q0o0tI9yIf",
          token: token1,
          title:"Order successfully placed",
          body:"notification body", //orderModel.productDescription,
          data:{
            "screen":"notification"
          }
      );

      //for sent notification to user to admin after order
      /*String? adminToken = await SendNotificationService.getAdminToken();
      await SendNotificationService.sendNotificationUsingApi(
        //token:"dg70JOl-QdSP6fs_GwGCmd:APA91bFURnO5ew6thVHjVjnGrmpH2R6U_IdJlnyuMfBicZOdpSEQO1xtKpqB_Njh0zQWjSj1aKN6NgQ1FjKhnjnXV3dLe5g9fCW2-TmG7BJ4GiG3RvAlI2Rc6cq2n0pmr3q0o0tI9yIf",
          token: adminToken,
          title:"Order successfully placed",
          body:"notification body", //orderModel.productDescription,
          data:{
            "screen":"notification"
          }
      );*/
      //todo for send push notificationh after order end

      TLoggerHelper.info("${TAG} placeorder completed");
      TLoaders.successSnakeBarTop(title: "Order confirmed ", message: "Thank you for your order!");



    }
    catch(e)
    {
      TLoggerHelper.info("Myy placeorder  Error in catch e = "+e.toString());
      throw Exception("Error in token");
    }
  }

}