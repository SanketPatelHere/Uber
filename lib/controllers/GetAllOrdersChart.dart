
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

import '../logging/logger_helper.dart';
import '../models/ChartData.dart';

class GetAllOrdersChart extends GetxController {
  final TAG = "Myy GetAllOrdersChart ";
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final RxList<ChartData> monthlyOrderData = RxList<ChartData>();

  @override
  void onInit() {
    TLoggerHelper.info("${TAG} inside onInit");
    super.onInit();
    fetchMonthlyOrders();
  }


  //  /orders/customerid/confirmOrders/orderid
  //  /orders/eAeeQi1zprTVNcy8UPi6ZgZhmm02/confirmOrders/1731994684092914_3808
  Future<void> fetchMonthlyOrders() async {
    TLoggerHelper.info("${TAG} inside fetchMonthlyOrders");
    final CollectionReference ordersCollection = _firestore.collection("orders");
    //for last 6 month data
    final DateTime dateMonthAgo = DateTime.now().subtract(const Duration(days:180)); //6 month = 180 days
    final QuerySnapshot allUserSnapshot = await ordersCollection.get(); //use this to find order id for pass in further loop
    final Map<String,int> monthlyCount = {};
    TLoggerHelper.info("${TAG} fetchMonthlyOrders dateMonthAgo = "+dateMonthAgo.toString()); //2024-05-23 10:47:45.436385


    //for get one by one, goto upto order's id=>confirmOrders and get createdAt
    for(QueryDocumentSnapshot userSnapshot in allUserSnapshot.docs) {
      TLoggerHelper.info("${TAG} fetchMonthlyOrders userSnapshot = " + userSnapshot.toString()); //Instance of '_JsonQueryDocumentSnapshot'
      TLoggerHelper.info("${TAG} fetchMonthlyOrders userSnapshot.id = " + userSnapshot.id.toString()); //eAeeQi1zprTVNcy8UPi6ZgZhmm02

      final QuerySnapshot userOrdersSnapshot = await ordersCollection
          .doc(userSnapshot.id)
          .collection('confirmOrders')
          .where("createdAt", isGreaterThanOrEqualTo: dateMonthAgo) //for last 6 month data
          .get();

      TLoggerHelper.info("${TAG} fetchMonthlyOrders userOrdersSnapshot = " + userOrdersSnapshot.toString()); //Instance of '_JsonQuerySnapshot'
      TLoggerHelper.info("${TAG} fetchMonthlyOrders userOrdersSnapshot docs = " + userOrdersSnapshot.docs.toString()); //[]

      //issue not comes into this
      //for store createdAt(year and month) in monthlyCount
      userOrdersSnapshot.docs.forEach((order) {
        TLoggerHelper.info("${TAG} fetchMonthlyOrders order = " + order.toString());

        //19 November 2024 at 11:08:43 UTC+5:30 and 2024-11-19 11:08:04.096794
        final Timestamp timestamp = order["createdAt"];
        TLoggerHelper.info("${TAG} fetchMonthlyOrders timestamp = " + timestamp.toString());
        //final DateTime dateTime = order["createdAt"];
        final DateTime orderDate = timestamp.toDate();
        TLoggerHelper.info("${TAG} fetchMonthlyOrders orderDate = " + orderDate.toString());
        final String monthYearKey = "${orderDate.year}-${orderDate.month}";
        TLoggerHelper.info("${TAG} fetchMonthlyOrders monthYearKey = " + monthYearKey.toString());

        //key = value
        //monthYearKey = 2024-01 = 100 orders //for order count of particlular month wise
        monthlyCount[monthYearKey] = (monthlyCount[monthYearKey] ?? 0) + 1;
        TLoggerHelper.info("${TAG} fetchMonthlyOrders monthlyCount[monthYearKey] = " + monthlyCount[monthYearKey].toString());
        //TLoggerHelper.info("${TAG} fetchMonthlyOrders monthlyCount[monthYearValue] = "+ (monthlyCount[monthYearKey]).toString());

      });
    }

        //monthlyData = [2024-01,2024-02]
        final List<ChartData> monthlyData = monthlyCount.entries
            .map((entry)=>ChartData(entry.key, entry.value.toDouble()))
            .toList();
        //TLoggerHelper.info("${TAG} fetchMonthlyOrders monthlyData = "+monthlyData.toString());

        if(monthlyData.isEmpty){
          TLoggerHelper.info("${TAG} fetchMonthlyOrders monthlyData isEmpty monthlyData = "+monthlyData.toString()); //[]
          monthlyOrderData.add(ChartData("Data Not Found", 0));
        }
        else{
          TLoggerHelper.info("${TAG} fetchMonthlyOrders monthlyData isNotEmpty monthlyData = "+monthlyData.toString());
          //for sort of month wise
          monthlyData.sort((a,b)=>a.month.compareTo(b.month));
          monthlyOrderData.assignAll(monthlyData);
        }




  }


}