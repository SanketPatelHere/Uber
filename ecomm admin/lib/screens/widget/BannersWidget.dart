import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/cupertino.dart';
import '../../controllers/BannerController.dart';
import '../../logging/logger_helper.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cached_network_image/cached_network_image.dart';

class BannersWidget extends StatefulWidget {
  const BannersWidget({super.key});

  @override
  State<StatefulWidget> createState() => _BannersWidgetState();
}

class _BannersWidgetState extends State<BannersWidget> {
  final TAG = "Myy BannersWidget ";
  final CarouselController carouselController = CarouselController();
  final BannerController bannerController = Get.put(BannerController());

  @override
  Widget build(BuildContext context) {
    TLoggerHelper.info("${TAG} inside build");
    return Container(
      child: Obx((){
          return
            CarouselSlider(
            items:bannerController.bannerUrls.map((imageUrls)=>

              ClipRRect(borderRadius: BorderRadius.circular(20),
              //height not work, image show at default image size
              child: CachedNetworkImage(imageUrl: imageUrls, fit: BoxFit.contain, width: Get.width-25,height:110,
              //child: CachedNetworkImage(imageUrl: imageUrls, fit: BoxFit.contain, width: Get.width-25,
              placeholder: (context,url){
                //load url
                //https://www.bartonsrewards.com.au/images/banner3.png
                TLoggerHelper.info("${TAG} inside placeholder url = "+url);
                return ColoredBox(color: Colors.white,
                  child: Center(child: CupertinoActivityIndicator(),),
                );
              },
              errorWidget: (context,url,error){
                //not load url
                //https://www.bartons.net.au/service
                TLoggerHelper.info("${TAG} inside errorWidget url = "+url);
                return const Icon(Icons.error);
              },
              ),
              ),
              ).toList(),
           options: CarouselOptions(
                scrollDirection: Axis.horizontal,
                autoPlay: true,
                aspectRatio: 2.5, //16 / 9,
                //aspectRatio: 16/9, //16 / 9,
                viewportFraction: 1 //default 0.8, each page fills 80% of the carousel(fill in whole screen only 1)
              )
          );
      }
      )
    );
  }
}
