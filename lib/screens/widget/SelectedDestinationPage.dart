
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

import 'PredictionPlaceUi.dart';


/*
use google places api =
for google places api for textbox search
https://developers.google.com/maps/documentation/places/web-service/autocomplete
or
without key but package not implement
https://pub.dev/packages/google_places_flutter
https://fredrick-m.medium.com/google-places-api-with-flutter-ebac822a7546
 */
class SelectedDestinationPage extends StatefulWidget {

  const SelectedDestinationPage({super.key});


  @override
  State<StatefulWidget> createState() => _SelectedDestinationPage();


}

class _SelectedDestinationPage extends State<SelectedDestinationPage> {
  final TAG = "Myy SelectedDestinationPage ";
  TextEditingController pickUpTextController = TextEditingController();
  TextEditingController destinationTextController = TextEditingController();
  List<PredictionModel> dropOffPredictionPlaceList = [];

  //Places API - Place AutoComplete
  searchPlace(String userInput) async{

    TLoggerHelper.info("${TAG} searchPlace userInput = "+userInput);

    if(userInput.length>1){
      /*String placesApiUrl = "https://maps.googleapis.com/maps/api/place/autocomplete/json
          ?input=amoeba
      &location=37.76999%2C-122.44696
      &radius=500
      &types=establishment
      &key=YOUR_API_KEY";*/

      String placesApiUrl = "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$userInput&key=$googleMapKey&components=country:IN";
      var responseFromPlaceApi = await GoogleMapMethods.sendRequestToAPI(placesApiUrl);
      TLoggerHelper.info("${TAG} searchPlace responseFromPlaceApi = "+responseFromPlaceApi);

      //"error_message" : "You must enable Billing on the Google Cloud
      if(responseFromPlaceApi=="error"){
        return;
      }
      if(responseFromPlaceApi["result"]=="OK"){
          var predictionResultInJson = responseFromPlaceApi["predictions"];
          TLoggerHelper.info("${TAG} searchPlace predictionResultInJson = "+predictionResultInJson);
          var predictionResultInNormalFormat = (predictionResultInJson as List).map((eachPredictedPlace)=>
              PredictionModel.fromMap(eachPredictedPlace)).toList();
          TLoggerHelper.info("${TAG} searchPlace predictionResultInNormalFormat = "+predictionResultInNormalFormat.toString());

          setState(() {
            dropOffPredictionPlaceList = predictionResultInNormalFormat;
          });

      }

      TLoggerHelper.info("${TAG} searchPlace dropOffPredictionPlaceList = "+dropOffPredictionPlaceList.toString());



    }
  }

  @override
  Widget build(BuildContext context) {
    TLoggerHelper.info("${TAG} inside build");

    String pickUpAddressUser = Provider.of<AppInfo>(context, listen: false).pickUpLocation!.humanReadableAddress??"";
    pickUpTextController.text = pickUpAddressUser;

    return Scaffold(
        backgroundColor: AppConstant.appTextColor,
      appBar: AppBar(
        backgroundColor: AppConstant.appMainColor,
        title: const Text("Destination Page"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [

              //input text layout
              Card(
                  elevation: 14,
                  child: Container(
                    height: 232,
                    decoration: const BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.white,
                          blurRadius: 5.0,
                          spreadRadius: 0.5,
                          offset: Offset(0.7, 0.7),
                        ),
                      ]
                    ),
                    child: Padding(
                        padding: const EdgeInsets.only(left: 24,top: 40, bottom: 20, right: 24),
                        child: Column(
                          children: [
                            const SizedBox(height: 6),

                             Stack(
                               children: [
                                 GestureDetector(
                                   onTap: (){
                                     Navigator.pop(context);
                                   },
                                   child: const Icon(Icons.arrow_back, color: Colors.black),
                                 ),
                                 const Center(
                                   child: Text("Search Destination",
                                     style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,color: AppConstant.appTextColor2 ),),

                                 )
                               ],
                             ),

                            const SizedBox(height: 10),

                            //pickup textfield with icon
                            Row(
                              children: [
                                Icon(Icons.location_on_outlined, color:Colors.red),
                                const SizedBox(height: 10),
                                Expanded(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.grey,
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(2),
                                        child: TextField(
                                          controller: pickUpTextController,
                                          decoration: InputDecoration(
                                            fillColor: Colors.white12,
                                            filled: true,
                                            border: InputBorder.none,
                                            isDense: true,
                                            contentPadding: const EdgeInsets.only(left: 11, top: 9, bottom: 9),
                                          ),
                                        ),
                                      ),
                                    ),
                                )
                              ],
                            ),
                            const SizedBox(height: 10),

                            //destination textfield with icon
                            Row(
                              children: [
                                Icon(Icons.location_on, color:Colors.green),
                                const SizedBox(height: 10),
                                Expanded(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.grey,
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(2),
                                      child: TextField(
                                        controller: destinationTextController,
                                        onChanged: (userInput){
                                          searchPlace(userInput);
                                        },
                                        decoration: InputDecoration(
                                          hintText: "search destination here...",
                                          fillColor: Colors.white12,
                                          filled: true,
                                          border: InputBorder.none,
                                          isDense: true,
                                          contentPadding: const EdgeInsets.only(left: 11, top: 9, bottom: 9),
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            )


                          ],
                        ),
                    ),
                  ),
              ),

              //display prediction result for destination place
            (dropOffPredictionPlaceList.length>0)
                ?Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    child: ListView.separated(
                         itemCount: dropOffPredictionPlaceList.length,
                         shrinkWrap: true,
                         physics: const ClampingScrollPhysics(),
                         separatorBuilder: (BuildContext context, int index)=> const SizedBox(height: 3),
                         itemBuilder: (context,index){
                           Card(
                             elevation: 4,
                             child: PredictionPlaceUi(predictionPlacesData:dropOffPredictionPlaceList[index]),
                           );
                         },
                    ),
                )
                :Container()
          ],

        ),
      )


    );
  }




}

