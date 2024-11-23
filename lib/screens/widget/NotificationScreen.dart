import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/cupertino.dart';
import '../../controllers/CartController.dart';
import '../../controllers/placeorder.dart';
import '../../logging/logger_helper.dart';
import '../../services/getserverkey.dart';
import '../../utils/TLoaders.dart';
import '../../utils/app-constant.dart';
import '../../utils/colors.dart';

import 'package:flutter_swipe_action_cell/flutter_swipe_action_cell.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';


class NotificationScreen extends StatefulWidget {

  final RemoteMessage? message;

  NotificationScreen({
    super.key, this.message
  });

  @override
  State<StatefulWidget> createState() => _NotificationScreen();
}

class _NotificationScreen extends State<NotificationScreen> {
  final TAG = "Myy NotificationScreen ";



  @override
  Widget build(BuildContext context) {
    TLoggerHelper.info("${TAG} inside build");
    User? user = FirebaseAuth.instance.currentUser;
    TLoggerHelper.info("${TAG}  user uid = "+user!.uid);

    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: TColors.white, size: 35),
          backgroundColor: AppConstant.appMainColor,
          title: Text("Notifications", style: TextStyle(color: AppConstant.appTextColor),),
          centerTitle: true,
        ),

       body:
           //notifications/userid/notifications/docid/
           ///notifications/eAeeQi1zprTVNcy8UPi6ZgZhmm02/notifications/56JWPjLHUgxR3fsSt8Ev
       StreamBuilder(
           stream: FirebaseFirestore.instance
               .collection("notifications")
               //.doc()
               .doc(user!.uid) //error = null check operator used on a null value
               //.doc("eAeeQi1zprTVNcy8UPi6ZgZhmm02")
               //.doc("56JWPjLHUgxR3fsSt8Ev")
               .collection("notifications")
               //.get(),
               .snapshots(),
           builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
             if(snapshot.hasError){
               return const Center(child: Text("No Data Found!"));
             }

             if(snapshot.connectionState==ConnectionState.waiting){
               return Container(
                   height: Get.height/5,
                   child: const Center(
                     child: CupertinoActivityIndicator(),
                   )
               );
             }

             if(snapshot.data!.docs.isEmpty){
               return Center(child: Text("No any Notifications Found!"));
             }

             if(snapshot.data!=null){
               return ListView.builder(
                       itemCount: snapshot.data!.docs.length,
                       shrinkWrap: true,
                       //scrollDirection: Axis.horizontal,
                       itemBuilder: (context, index){
                          var docId = snapshot.data!.docs[index].id;
                          TLoggerHelper.info("${TAG} notifcation data length = "+snapshot.data!.docs.length.toString());
                          TLoggerHelper.info("${TAG} notifcation click docId = "+docId);
                          TLoggerHelper.info("${TAG} notifcation title = "+snapshot.data!.docs[index]["title"]);

                            return  GestureDetector(
                              onTap: () async{
                                //for change seen status of notification on click of notification
                                await   FirebaseFirestore.instance
                                    .collection("notifications")
                                    .doc(user!.uid)
                                    .collection("notifications")
                                    .doc(docId)
                                    .update({"isSeen": true});
                              },
                              child: Card(
                                margin: EdgeInsets.only(left: 12,right: 12,top: 5,bottom: 5),
                                color: snapshot.data!.docs[index]["isSeen"]
                                    ?Colors.green.withOpacity(0.3):Colors.blue.withOpacity(0.3),
                                  elevation: snapshot.data!.docs[index]["isSeen"]?0:5,
                                  child: ListTile(
                                    leading: snapshot.data!.docs[index]["isSeen"]? Icon(Icons.done): const Icon(Icons.notification_add),
                                    //title: Text(widget.message!.notification!.title.toString()??""),
                                    title: Text(snapshot.data!.docs[index]["title"].toString()??""),
                                    //subtitle: Text(widget.message!.notification!.body.toString()??""),
                                    subtitle: Text(snapshot.data!.docs[index]["body"].toString()??""),
                                    //trailing: Text(widget.message!.data["screen"].toString()??""),
                                    //trailing: Text(snapshot.data!.docs[index]["screen"].toString()??""),
                                  )
                              ),
                            );

                       }

               );
             }

             return Container();

           }
       ),
       /* body:
        widget.message!=null
        ?Card(
          elevation: 5,
          child: ListTile(
            leading: const Icon(Icons.notifications_active),
            title: Text(widget.message!.notification!.title.toString()??""),
            subtitle: Text(widget.message!.notification!.body.toString()??""),
            trailing: Text(widget.message!.data["screen"].toString()??""),
          ),
        )
        :Center(child: Text("No any Notification"),)*/

    );
  }

}

/*
//for pass in postman url
//https://fcm.googleapis.com/v1/projects/easyshopping-ce06a/messages-send
//https://fcm.googleapis.com/v1/projects/ecomm-18247/messages-send
auth = server key =ya29.c.c0ASRK0GaSEjqmppthkpkQ4W7
Content-Type : application/json
Authorization: Bearer ya29.c.c0ASRK0GaSEjqmppthkpkQ4W7vWQej56P2anJ0Qw_iWNaIKE80V8nhYQbchWy2jIbi_r25i9CMw63lUtnj-6FKgPLKiLoz9fxRSWZq532G0czVLEn_T3xcHFnpxpGOb4TCPMs1ePkmaq7Gv935G_eMq-u8l3miCHVjDxJzI4Fey1scdqaRe7z4xFJWWEA-hHMB7Hz8TMNwV-xtb8RY0tnahemHTqJG3JxrmUKBDOYBS2BVfOx6UT9StettFvy_LcIAspYutj9rNmivbugnvWyYJBEQYi1Z4Yb8F6mDRckhwjbvrwO-PzFOa0UclCgd8_BErZ3sT_jRYjOqH8HYrfKeUyq5W-ksM5TjDW1QBCTx503SklEUZN6jNIcPRqtAIwL391ABtusdhSi4rMBn4diUcYBqBBejWubO2ZujIa1reV134esOZqk-b4v03I1MRSW134VRWfma6Swc9a9cpqkr7j5kW__w88vy4t5q-I_5vQrzJZ71UZyuQxfXQl77l4qY76U8rs4cdxoF5cxhdsy3UiXuV5a3afF9hlm9t1gU14J1WOnjavwFhYFac20Rf8x2yiytipWYU0xq1-u49oXhdn7yq82wdbfMmuhBJWfwUkjxwWS9lrbSkXZ94nszp_XY92hI9FgMgMr74zXy-IqIhOJt77seu3_77kZUh8_UletXbzeMQaJa1hxsmzsw2dZIFVm_wv9xYU8hJb_Vh4IOm8Yrjnmmve-vwlbWIFd5cdfbep4WBO60mcJo9rdf7Vv-7B-m85ijy_y9JU_ctzIhr7RlUzwWBJOyfVcQaaixq6cZ7Rqx0-_26-z-oS2fjhjcxFtdhtc8tOrRrku5r_dbjBMUFptw8SB7WgwJXdebuXMOU13yO9eu0F3u2FiU53Jt_nzpX2uFRFlxeS0SdvqaiM-m6OvOoZipt1peweahg6jp6wtb9n

{
  "message":{
    "token":"eRcZ0IfWRMGC4MYXuOk1Dj:APA91bFLkxrqMlSQCozFvZMrLvqsIZguwwCWet4Bmc-jQOvwrx_gddH2ujk2VeoB8_GCDfxwR3Am6JL6c185H6NC7qavKTno3hv_RzvlWTKcskDZZp_sC6TdGjYPkjG4fH0svS2aIjCS",
    "notification":{
      "title":"FCM Message",
      "body":"This is test message"
    }
    }
}


OAuth client created
Client ID=
472201750510-g7fbfl3v94i8cuj784chjpuu3la5o1d9.apps.googleusercontent.com
Client secret=
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
 */
