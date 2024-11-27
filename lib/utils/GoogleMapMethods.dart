

import 'dart:convert';

import 'package:aaa/models/AddressModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../utils/global.dart';
import "package:http/http.dart" as http;

import '../logging/logger_helper.dart';


//https://console.cloud.google.com/apis/dashboard?inv=1&invt=Abikwg&project=ecomm-18247
//https://developers.google.com/maps/documentation/geocoding/requests-reverse-geocoding

/*
Provider = a package and design pattern that helps manage an app's state
a widely used state management solution in Flutter applications.
It simplifies the process of managing and sharing state across different parts of the widget tree.

Provider = 	The most basic form of provider. It takes a value and exposes it, whatever the value is.
ListenableProvider 	A specific provider for Listenable object. ListenableProvider will listen to the object and ask widgets which depend on it to rebuild whenever the listener is called.
ChangeNotifierProvider 	A specification of ListenableProvider for ChangeNotifier. It will automatically call ChangeNotifier.dispose when needed.
ValueListenableProvider 	Listen to a ValueListenable and only expose ValueListenable.value.
StreamProvider 	Listen to a Stream and expose the latest value emitted.
FutureProvider 	Takes a Future and updates dependents when the future completes.
 */
class GoogleMapMethods
{
    static final TAG = "Myy GoogleMapMethods ";
    //Reverse Geocoding = translating a human-readable address into a location on a map
    static Future<String> convertGeoGraphicCoOrdinatesIntoHumanReadableAddress(Position position, BuildContext context) async{
      String humanReadableAddress = "";
      String myApiKey = "AIzaSyCXB2gsB33hSm-HZnGqRk0leojAKLC7E2E";
      //https://maps.googleapis.com/maps/api/geocode/json?latlng=40.714224,-73.961452&key=YOUR_API_KEY
      String geoCodingApiUrl = "https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=$myApiKey";

      var responseFromAPI = await sendRequestToAPI(geoCodingApiUrl);
      if(responseFromAPI!="error"){
        humanReadableAddress = responseFromAPI["results"][0]["formatted_address"];

        AddressModel addressModel = AddressModel();
        addressModel.humanReadableAddress = humanReadableAddress;
        addressModel.placeName = humanReadableAddress;
        addressModel.placeID = responseFromAPI["results"][0]["place_id"];;
        addressModel.latitudePosition = position.latitude.toString();
        addressModel.longitudePosition = position.longitude.toString();

      }

      return humanReadableAddress;

    }

    //call http api for get map info
  static sendRequestToAPI(String apiUrl) async{
    http.Response responseFromAPI = await http.get(Uri.parse(apiUrl));
    TLoggerHelper.info("${TAG} sendRequestToAPI responseFromAPI = "+responseFromAPI.toString());

    try{
      if(responseFromAPI.statusCode == 200){
        String dataFromApi = responseFromAPI.body;
        TLoggerHelper.info("${TAG} sendRequestToAPI dataFromApi = "+dataFromApi);
        var dataDecoded = jsonDecode(dataFromApi);
        TLoggerHelper.info("${TAG} sendRequestToAPI dataDecoded = "+dataDecoded);
        return dataDecoded;
      }
    }
    catch(e){
      return "error";
    }
  }

}