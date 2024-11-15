
import 'dart:math';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:uuid/uuid.dart';

import '../logging/logger_helper.dart';


class GenerateIds{
  static final TAG = "Myy GenerateIds ";
  static String generateProductId(){
    String formattedProductId;
    String uuid = const Uuid().v4(); //random id //109156be
    //String uuid = const Uuid().v6(); //time-based id //1ebbc608

    //PackageInfo packageInfo = await PackageInfo.fromPlatform();
    //TLoggerHelper.info("${TAG} packageInfo.appName = "+packageInfo.appName.toString()); //ecomm_4523f

    //customized id with app name
    formattedProductId = "ecomm_${uuid.substring(0,5)}";
    //ecomm_dacd7
    TLoggerHelper.info("${TAG} formattedProductId = "+formattedProductId.toString()); //ecomm_4523f

    return formattedProductId;

  }

  static String generateCategoryId(){
    String formattedCategoryId;
    String uuid = const Uuid().v4(); //random id //109156be
    //String uuid = const Uuid().v6(); //time-based id //1ebbc608

    //PackageInfo packageInfo = await PackageInfo.fromPlatform();
    //TLoggerHelper.info("${TAG} packageInfo.appName = "+packageInfo.appName.toString()); //ecomm_4523f

    //customized id with app name
    formattedCategoryId = "ecomm_${uuid.substring(0,5)}";
    //ecomm_dacd7
    TLoggerHelper.info("${TAG} formattedCategoryId = "+formattedCategoryId.toString()); //ecomm_4523f

    return formattedCategoryId;

  }
}