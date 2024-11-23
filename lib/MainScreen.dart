import 'package:aaa/utils/global.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'controllers/CartController.dart';
import 'controllers/FcmService.dart';
import 'controllers/GetAllOrdersChart.dart';
import 'controllers/NotificationController.dart';
import 'logging/logger_helper.dart';
import 'models/ChartData.dart';
import 'screens/auth-ui/SignInScreen.dart';
import 'screens/widget/AllCategoriesScreen.dart';
import 'screens/widget/AllFlashProductScreen.dart';
import 'screens/widget/AllProductsScreen.dart';
import 'screens/widget/AllProductsWidget.dart';
import 'screens/widget/BannersWidget.dart';
import 'screens/widget/CartScreen.dart';
import 'screens/widget/CategoriesWidget.dart';
import 'screens/widget/FlashSaleWidget.dart';
import 'screens/widget/HeadingWidget.dart';
import 'screens/widget/MyDrawerWidget.dart';
import 'screens/widget/NotificationScreen.dart';
import 'services/NotificationService.dart';
import 'services/SendNotificationService.dart';
import 'services/getserverkey.dart';
import 'utils/app-constant.dart';
import 'package:get/get.dart';
import 'package:badges/badges.dart' as badges;
import 'package:syncfusion_flutter_charts/charts.dart';
import 'utils/colors.dart';

//github demo user app = https://github.com/Warisalikhan786/EasyShopping/blob/main/lib/controllers/google-sign-in-controller.dart
//github demo admin app = https://github.com/Warisalikhan786/easy-shopping-admin-panel/blob/main/lib/screens/main-screen.dart
class MainScreen extends StatefulWidget {

  const MainScreen({super.key});


  @override
  State<StatefulWidget> createState() => _MainScreen();


}

class _MainScreen extends State<MainScreen> {
  final TAG = "Myy MainScreen ";
  NotificationService notificationService = NotificationService();
  NotificationController notificationController = Get.put(NotificationController());
  CartController cartController = Get.put(CartController()); //use only for get cart count

  @override
  void initState()  {
    TLoggerHelper.info("${TAG} inside initState");
    super.initState();
    notificationService.requestNotificationPermission();
    notificationService.getDeviceToken();
    notificationService.firebaseInit(context); //initLocalNotification => //showNotification
    notificationService.setupInterfaceMessage(context); //handleMessage (for background and terminated app notifcation)
    ///FcmService.firebaseInit(); //now no need of this, because same use in notificationService.firebaseInit
  }

  @override
  Widget build(BuildContext context) {
    TLoggerHelper.info("${TAG} inside build");
    final GetAllOrdersChart getAllOrdersChart = Get.put(GetAllOrdersChart());
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppConstant.appMainColor,
        title: const Text("Admin Panel"),
        actions: [
          GestureDetector(
            onTap: () async {
              await FirebaseAuth.instance.signOut();
              Get.offAll(() => SignInScreen());
            },
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Icon(
                Icons.logout,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
      drawer: MyDrawerWidget(),
      body: Container(
        child: Column(
          children: [
            Obx(() {
              final monthlyData = getAllOrdersChart.monthlyOrderData;
              if (monthlyData.isEmpty) {

                TLoggerHelper.info("${TAG} if empty monthlyData = "+monthlyData.toString());
                return Container(
                  height: Get.height / 2,
                  child: Center(
                    child: CupertinoActivityIndicator(),
                  ),
                );
              }
              else {
                //associateMethods.showSnackBarMsg("my demo", context);

                TLoggerHelper.info("${TAG} if not empty monthlyData = "+monthlyData.toString()); // [Instance of 'ChartData']
                return SizedBox(
                  height: Get.height / 2,
                  child: SfCartesianChart(
                    tooltipBehavior: TooltipBehavior(enable: true),
                    primaryXAxis: CategoryAxis(arrangeByIndex: true),
                      //for dynamic data of users orders
                    series: <LineSeries<ChartData, String>>[
                      LineSeries<ChartData, String>(
                        dataSource: monthlyData,
                        width: 2.5,
                        color: AppConstant.appMainColor,
                        xValueMapper: (ChartData data, _) => data.month,
                        yValueMapper: (ChartData data, _) => data.value,
                        name: "Monthly Orders",
                        markerSettings: MarkerSettings(isVisible: true),
                      )
                    ],

                      //for demo fixed data
                      /*series: <LineSeries<SalesData, String>>[
                        LineSeries<SalesData, String>(
                            dataSource:  <SalesData>[
                              SalesData('Jan', 35),
                              SalesData('Feb', 28),
                              SalesData('Mar', 34),
                              SalesData('Apr', 32),
                              SalesData('May', 40),
                            *//*  SalesData('May', 40),
                              SalesData('May', 40),
                              SalesData('May', 40),
                              SalesData('May', 40)*//*
                            ],
                            xValueMapper: (SalesData sales, _) => sales.year,
                            yValueMapper: (SalesData sales, _) => sales.sales,
                            // Enable data label
                            dataLabelSettings: DataLabelSettings(isVisible: true)
                        )
                      ]*/
                  ),
                );
              }
            })
          ],
        ),
      ),
    );
  }
}

class SalesData {
  SalesData(this.year, this.sales);
  final String year; //month
  final double sales;
}
