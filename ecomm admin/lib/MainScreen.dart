import 'package:flutter/material.dart';

import 'controllers/CartController.dart';
import 'controllers/FcmService.dart';
import 'controllers/NotificationController.dart';
import 'logging/logger_helper.dart';
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

import 'utils/colors.dart';

//github demo = https://github.com/Warisalikhan786/EasyShopping/blob/main/lib/controllers/google-sign-in-controller.dart
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
    TLoggerHelper.info("${TAG} inside build");
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
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white, size: 35),
        backgroundColor: AppConstant.appMainColor,
        title: Text(AppConstant.appMainName, style: TextStyle(color: AppConstant.appTextColor),),
        centerTitle: true,
        actions: [
          //for notification


          Obx((){
          return InkWell(
              onTap: () async{
                //todo for get firebase server key start
                //GetServerKey getServerKey = GetServerKey();
                //await getServerKey.getServerKeyToken();
                //final GetDeviceTokenController getDeviceTokenController = Get.put(GetDeviceTokenController());
                //var token1 = await getDeviceTokenController.deviceToken.toString();
                //TLoggerHelper.info("${TAG} notification token1 = "+token1);

                //for send push notification from app =
                /*await SendNotificationService.sendNotificationUsingApi(
                    //token:"dg70JOl-QdSP6fs_GwGCmd:APA91bFURnO5ew6thVHjVjnGrmpH2R6U_IdJlnyuMfBicZOdpSEQO1xtKpqB_Njh0zQWjSj1aKN6NgQ1FjKhnjnXV3dLe5g9fCW2-TmG7BJ4GiG3RvAlI2Rc6cq2n0pmr3q0o0tI9yIf",
                    //token: token1, //for specific user token send
                    token: "", //for all user send(topic)
                    title:"Order successfully placed",
                    body:"notification body", //orderModel.productDescription,
                    //data:{},
                    data:{
                      "screen":"notification"
                    }
                );*/

                //todo for get firebase server key end
                Get.to(()=>NotificationScreen());
              },
              child: Padding(
                padding: const EdgeInsets.all(10),
                //child: Icon(Icons.notifications, color: TColors.white, size: 35),
                child:  badges.Badge(
                  //badgeContent: Text('3'),
                  badgeContent: Text("${notificationController.notificationCount.value}",
                  style: TextStyle(color: Colors.white)),
                  position: badges.BadgePosition.topEnd(top: -12, end:-8),
                  showBadge: notificationController.notificationCount.value>0,
                  child: Icon(Icons.notifications, color: TColors.white, size: 35),
                  badgeAnimation: badges.BadgeAnimation.size(
                    animationDuration: Duration(seconds: 1),
                    colorChangeAnimationDuration: Duration(seconds: 1),
                    loopAnimation: false,
                    curve: Curves.fastOutSlowIn,
                    colorChangeAnimationCurve: Curves.easeInCubic,
                  ),
                ),
              )
            );
         }),

          Obx(() {
            return InkWell(
                onTap: () {
                  Get.to(() => CartScreen());
                },

            child: Padding(
                padding: const EdgeInsets.all(10),
                //child: Icon(Icons.notifications, color: TColors.white, size: 35),
                child:  badges.Badge(
                        //badgeContent: Text('3'),
                        badgeContent: Text("${cartController.cartCount.value}",
                        style: TextStyle(color: Colors.white)),
                        position: badges.BadgePosition.topEnd(top: -12, end:-8),
                        showBadge: cartController.cartCount.value>0,
                        child:Icon(Icons.shopping_cart, color: TColors.white, size: 35),
                        badgeAnimation: badges.BadgeAnimation.size(
                        animationDuration: Duration(seconds: 1),
                        colorChangeAnimationDuration: Duration(seconds: 1),
                        loopAnimation: false,
                        curve: Curves.fastOutSlowIn,
                        colorChangeAnimationCurve: Curves.easeInCubic,
                        ),
                )
            )
            );

          }
          ),
          //for cart

          //for logout
          /*GestureDetector(
            onTap: () async{
              //for google sign out
                GoogleSignIn googleSignIn = GoogleSignIn();
                await googleSignIn.signOut();

                //for email sign out(if login with email)
                FirebaseAuth _auth = FirebaseAuth.instance;
                await _auth.signOut();
                Get.offAll(()=>WelcomeScreen());
            },
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Icon(Icons.logout),
            ),
          )*/
        ],
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Container(
          child: Column(
            children: [
              SizedBox(height:Get.height/90),

              BannersWidget(),

              //heading
              HeadingWidget(
                headingTitle:"Categories",
                headingSubTitle:"According to new arrival",
                onTap:(){
                  Get.to(()=>AllCategoriesScreen());
                },
                buttonText:"See More >",
              ),

              CategoriesWidget(),

              //heading
              HeadingWidget(
                headingTitle:"Flash Sale",
                headingSubTitle:"According new arrival",
                onTap:(){
                  Get.to(()=>AllFlashProductScreen()); //show only sale products
                },
                buttonText:"See More >",
              ),

              FlashSaleWidget(), //show only sale products


              //heading
              HeadingWidget(
                headingTitle:"All Products",
                headingSubTitle:"According new arrival",
                onTap:(){
                  Get.to(()=>AllProductsScreen()); //show not sale products
                },
                buttonText:"See More >",
              ),

              //show not sale products
              AllProductsWidget(),

            ],
          ),
        ),
      ),
      drawer: MyDrawerWidget(),


    );
  }



}