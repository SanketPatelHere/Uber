
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../logging/logger_helper.dart';



class BannerController extends GetxController {
      final TAG = "Myy BannerController ";
      //RxList<String> bannerUrls = RxList<String>(); //or
      RxList<String> bannerUrls = RxList<String>([]);
      
      ///static BannerController get instance => Get.find();
      @override
    void onInit() {
        TLoggerHelper.info("${TAG} inside onInit");
        super.onInit();
        fetchBannerUrls();
    }
    
    //fetch banners 
    Future<void> fetchBannerUrls() async{
          try{
            QuerySnapshot bannerSnapshot = await FirebaseFirestore.instance.collection("banners").get();

            if(bannerSnapshot.docs.isNotEmpty)
            {
              bannerUrls.value = bannerSnapshot.docs
                  .map((doc) => doc["imageUrl"] as String).toList();

              //[https://www.bartonsrewards.com.au/images/banner1.png, https://www.bartonsrewards.com.au/images/banner2.png, https://www.bartonsrewards.com.au/images/banner3.png, https://www.bartons.net.au/service]
              TLoggerHelper.info("${TAG} bannerUrls = " + bannerUrls.toString());
              //[https://www.bartonsrewards.com.au/images/banner1.png, https://www.bartonsrewards.com.au/images/banner2.png, https://www.bartonsrewards.com.au/images/banner3.png, https://www.bartons.net.au/service]
              TLoggerHelper.info("${TAG} bannerUrls value = " + bannerUrls.value.toString());
            }
          }catch(e){
            TLoggerHelper.info("${TAG} Error in catch e = "+e.toString());
          }
    }
}