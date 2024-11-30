import 'dart:async';

import 'package:aaa/appinfo/AppInfo.dart';
import 'package:aaa/models/PredictionModel.dart';
import 'package:aaa/utils/GoogleMapMethods.dart';
import 'package:aaa/utils/global.dart';
import 'package:aaa/utils/image_strings.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../logging/logger_helper.dart';
import '../../utils/app-constant.dart';
import '../../utils/global.dart';

import '../auth-ui/SignInScreen.dart';
import 'package:get/get.dart';


class PredictionPlaceUi extends StatefulWidget {
  PredictionModel? predictionPlacesData;
  PredictionPlaceUi({super.key, this.predictionPlacesData});

  @override
  State<StatefulWidget> createState() => _PredictionPlaceUi();


}

class _PredictionPlaceUi extends State<PredictionPlaceUi> {
  final TAG = "Myy PredictionPlaceUi ";

  @override
  Widget build(BuildContext context) {
    TLoggerHelper.info("${TAG} inside build");


    return ElevatedButton(
        onPressed: (){},
        style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
        child: SizedBox(
          child: Column(
            children: [
              const SizedBox(height: 10),
              Row(
                children: [
                  const Icon(Icons.share_location, color: Colors.grey),
                  const SizedBox(width: 14),
                  Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(widget.predictionPlacesData!.main_text.toString(),
                            overflow: TextOverflow.ellipsis,
                             style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold,color: AppConstant.appTextColor2 ),
                            ),
                          const SizedBox(height: 5),
                          Text(widget.predictionPlacesData!.secondary_text.toString(),
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold,color: AppConstant.appTextColor2 ),
                          ),
                        ],
                      )
                  )

                ],
              )
            ],
          ),
        ));
  }




}

