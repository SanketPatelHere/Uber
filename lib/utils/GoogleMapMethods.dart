

import 'dart:convert';

import 'package:aaa/models/AddressModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


import 'package:geocoding/geocoding.dart';
//import 'package:location/location.dart';
//import 'package:geocoder/geocoder.dart';
import 'package:flutter/services.dart';

//import 'package:geocode/geocode.dart';
//import 'package:flutter_geocoder/geocoder.dart';


import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../utils/global.dart';
import "package:http/http.dart" as http;

import '../logging/logger_helper.dart';


//https://console.cloud.google.com/apis/dashboard?inv=1&invt=Abikwg&project=ecomm-18247
//https://developers.google.com/maps/documentation/geocoding/requests-reverse-geocoding


/*
2 ways to find address from lat,long =
1.geocoding api - not free
2.using geocoder api - free, but package not implement, sdk error
3.using Google API - free


direct get address without api calling, direct function, using geocoding , no need of key
geocoding placemarkFromCoordinates - working
geocoding findAddressesFromCoordinates - not working

 */

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


    ////////////////////////////////////////////////////
    //Reverse Geocoding = translating a human-readable address into a location on a map
    //1.
    static Future<String> convertGeoGraphicCoOrdinatesIntoHumanReadableAddress(Position position, BuildContext context) async{

      /*await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high)
          .then((Position position) {
            //Latitude: 22.2832826, Longitude: 70.7739073
           TLoggerHelper.info("${TAG} Geolocator.getCurrentPosition position = "+position.toString());

      }).catchError((e) {
        debugPrint(e);
      });*/

      String humanReadableAddress = "";
      String myApiKey = "AIzaSyCXB2gsB33hSm-HZnGqRk0leojAKLC7E2E";
      //https://maps.googleapis.com/maps/api/geocode/json?latlng=40.714224,-73.961452&key=YOUR_API_KEY
      String geoCodingApiUrl = "https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=$myApiKey";

      var responseFromAPI = await sendRequestToAPI(geoCodingApiUrl);
      TLoggerHelper.info("${TAG} convertGeoGraphicCoOrdinatesIntoHumanReadableAddress responseFromAPI = "+responseFromAPI.toString());

      if(responseFromAPI!="error"){
        humanReadableAddress = responseFromAPI["results"][0]["formatted_address"];

        AddressModel addressModel = AddressModel();
        addressModel.humanReadableAddress = humanReadableAddress;
        addressModel.placeName = humanReadableAddress;
        addressModel.placeID = responseFromAPI["results"][0]["place_id"];;
        addressModel.latitudePosition = position.latitude.toString();
        addressModel.longitudePosition = position.longitude.toString();
        TLoggerHelper.info("${TAG} convertGeoGraphicCoOrdinatesIntoHumanReadableAddress placeID = "+addressModel.placeID.toString());

      }
      TLoggerHelper.info("${TAG} convertGeoGraphicCoOrdinatesIntoHumanReadableAddress humanReadableAddress = "+humanReadableAddress);

      return humanReadableAddress;

    }

    //call http api for get map info
    //2.
    static sendRequestToAPI(String apiUrl) async{
      http.Response responseFromAPI = await http.get(Uri.parse(apiUrl));
      TLoggerHelper.info("${TAG} sendRequestToAPI responseFromAPI = "+responseFromAPI.toString());

      try{
        if(responseFromAPI.statusCode == 200){
          String dataFromApi = responseFromAPI.body;
          /*
          sendRequestToAPI dataFromApi =
           "error_message" : "You must enable Billing on the Google Cloud Project at https://console.cloud.google.com/project/_/billing/enable Learn more at https://developers.google.com/maps/gmp-get-started",
          "results" : [],
          "status" : "REQUEST_DENIED"
           }
           */
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
    ////////////////////////////////////////////////////

    /*
    static getUserLocation() async {

      LocationData myLocation;
      String error;
      Location location = new Location();
      try {
        myLocation = await location.getLocation();
        TLoggerHelper.info("${TAG} getUserLocation myLocation = "+myLocation.toString());

      } on PlatformException catch (e) {
        if(e.code == 'PERMISSION_DENIED') {
          error = 'please grant permission';
          TLoggerHelper.info("${TAG} getUserLocation PERMISSION_DENIED error = "+error.toString());
        }
        if (e.code == 'PERMISSION_DENIED_NEVER_ASK') {
          error = 'permission denied- please enable it from app settings';
          TLoggerHelper.info("${TAG} getUserLocation PERMISSION_DENIED_NEVER_ASK error = "+error.toString());
        }
        myLocation = null;
      }
      currentLocation = myLocation;
      final coordinates = new Coordinates(
          myLocation.latitude, myLocation.longitude);
      var addresses = await Geocoder.local.findAddressesFromCoordinates(
          coordinates);
      var first = addresses.first;
      TLoggerHelper.info("${TAG} getUserLocation addresses first  = "+first.toString());
      TLoggerHelper.info("${TAG} getUserLocation locality  = "+first.locality.toString());
      TLoggerHelper.info("${TAG} getUserLocation adminArea  = "+first.adminArea.toString());
      TLoggerHelper.info("${TAG} getUserLocation subAdminArea  = "+first.subAdminArea.toString());
      TLoggerHelper.info("${TAG} getUserLocation featureName  = "+first.featureName.toString());
      TLoggerHelper.info("${TAG} getUserLocation thoroughfare  = "+first.thoroughfare.toString());
      TLoggerHelper.info("${TAG} getUserLocation subThoroughfare  = "+first.subThoroughfare.toString());
      print(' ${first.locality}, ${first.adminArea},${first.subLocality}, ${first.subAdminArea},${first.addressLine}, ${first.featureName},${first.thoroughfare}, ${first.subThoroughfare}');
      return first;
    }
    */


    /*getLocation() async
    {
      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      debugPrint('location: ${position.latitude}');
      final coordinates = new Coordinates(position.latitude, position.longitude);
      var address = await Geocoder.local.findAddressesFromCoordinates(coordinates); //error No implementation found for method findAddressesFromCoordinates on channel
      var first = addresses.first;
      print("${first.featureName} : ${first.addressLine}");
    }*/


    /*
    4.map maker = https://geocode.maps.co/
    free api 1 request per second
    1 Request/Second = 5,000 /day
    API Key:6746b68992f78113869146bsj2fb770
    Geocoding Plan:Free - 1 Request/Second

    Forward Geocode: https://geocode.maps.co/search?q=address&api_key=api_key
    Reverse Geocode: https://geocode.maps.co/reverse?lat=latitude&lon=longitude&api_key=api_key
    https://geocode.maps.co/reverse?lat=latitude&lon=longitude&api_key=6746b68992f78113869146bsj2fb770
     */
    //giving nearest location, not exact location
    //Rajkot West Taluka, Rajkot District, Gujarat, 360005, India
    static getAddressFromLatLngNearest(double lat, double lng) async {
      String host = 'https://maps.google.com/maps/api/geocode/json';
      //var mapApiKey =  "AIzaSyCXB2gsB33hSm-HZnGqRk0leojAKLC7E2E"; //my
      var mapApiKey =  "6746b68992f78113869146bsj2fb770"; //others,free demo

      //final url = '$_host?key=$mapApiKey&language=en&latlng=$lat,$lng';
      final url = 'https://geocode.maps.co/reverse?lat=${lat}&lon=${lng}&api_key=$mapApiKey';
      //https://maps.google.com/maps/api/geocode/json?key=6746b68992f78113869146bsj2fb770&language=en&latlng=22.2832528,70.773879 //not working //The provided API key is invalid
      //https://geocode.maps.co/reverse?lat=22.2832658&lon=70.7739153&api_key=6746b68992f78113869146bsj2fb770 //working
      TLoggerHelper.info("${TAG} getAddressFromLatLngNearest url = "+url);

      if(lat != null && lng != null){
        var response = await http.get(Uri.parse(url));
        TLoggerHelper.info("${TAG} getAddressFromLatLngNearest response = "+response.toString()); //Instance of 'Response'
        if(response.statusCode == 200) {
          Map data = jsonDecode(response.body);
          //{error_message: You must enable Billing on the Google Cloud Project at https://console.cloud.google.com/project/_/billing/enable Learn more at https://developers.google.com/maps/gmp-get-started, results: [], status: REQUEST_DENIED}
          //{error_message: The provided API key is invalid. , results: [], status: REQUEST_DENIED}
          /*
          {place_id: 219610136,
           lat: 22.28334502781552, lon: 70.77401200373136,
           display_name: Rajkot West Taluka, Rajkot District, Gujarat, 360005, India,
           address: {county: Rajkot West Taluka, state_district: Rajkot District,
            state: Gujarat, ISO3166-2-lvl4: IN-GJ, postcode: 360005,
            country: India, country_code: in},
            boundingbox: [22.2831711, 22.283699, 70.773722, 70.7741545]}
           */

          TLoggerHelper.info("${TAG} getAddressFromLatLngNearest data = "+data.toString());
          ///String _formattedAddress = data["results"][0]["formatted_address"];
          //String _formattedAddress = data["address"] as String;
          //String _formattedAddress = json.decode(data["address"]) as String;
          Map<String,dynamic> _formattedAddress1 = json.decode(response.body);
          String _formattedAddress = _formattedAddress1["display_name"]; //Rajkot West Taluka, Rajkot District, Gujarat, 360005, India
          TLoggerHelper.info("${TAG} getAddressFromLatLngNearest _formattedAddress = "+_formattedAddress.toString());
          return _formattedAddress;
        }
        else return null;
      }
      else return null;
    }


    static Future<void> getAddressFromLatLngExactFree(Position position) async {
      await placemarkFromCoordinates(position.latitude, position.longitude)
          .then((List<Placemark> placemarks) {
        Placemark place = placemarks[0];
        //giving data of 0th places
        /*
        0th====>
        Name: Pragati 115, Street: Pragati 115, ISO Country Code: IN,
        Country: India, Postal code: 360005,
        Administrative area: Gujarat,  Subadministrative area: ,
        Locality: Rajkot, Sublocality: Jagannath Plot,
        Thoroughfare: 150 Feet Ring Road, Subthoroughfare: 115,
         */
        TLoggerHelper.info("${TAG} getAddressFromLatLngExactFree place = "+place.toString());

          var currentAddress = '${place.street}, ${place.subLocality}, ${place.locality},${place.subAdministrativeArea},${place.country}, ${place.postalCode}';
          //Pragati 115, Jagannath Plot,, 360005
          TLoggerHelper.info("${TAG} getAddressFromLatLngExactFree currentAddress = "+currentAddress.toString());

          /*
           [
           0th====>Name: Pragati 115...., 
           1th====>Name: Pragati...,]
           */
      }).catchError((e) {
        TLoggerHelper.info("${TAG} getAddressFromLatLngExactFree error e = "+e.toString());
        debugPrint(e);
      });
    }

}


