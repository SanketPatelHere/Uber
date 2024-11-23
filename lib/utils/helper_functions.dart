import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class THelperFunctions{

  //keys for sp
  static String userLoggedInKey = "LOGGEDINKEY";
  static String userNameKey = "USERNAMEKEY";
  static String userEmailKey = "USEREMAILKEY";
  static String userPasswordKey = "USERPASSWORDKEY";
  static final localStorage = GetStorage();

  //saving data to sp
  static Future<bool> saveUserLoggedInStatus(bool isUserLoggedIn) async{
    SharedPreferences sp = await SharedPreferences.getInstance();
    return await sp.setBool(userLoggedInKey, isUserLoggedIn);
  }

  static Future<bool> saveUserNameSp(String isUserName) async{
    SharedPreferences sp = await SharedPreferences.getInstance();
    return await sp.setString(userNameKey, isUserName);
  }

  static Future<bool> saveUserEmailSp(String userEmail) async{
    SharedPreferences sp = await SharedPreferences.getInstance();
    return await sp.setString(userEmailKey, userEmail);
  }

  static Future<bool> saveUserPasswordSp(String userPassword) async{
    SharedPreferences sp = await SharedPreferences.getInstance();
    return await sp.setString(userPasswordKey, userPassword);
  }

  //geting data from sp
  //for check user is signin or not
  static Future<bool?> getUserLoggedInstatus() async{
    SharedPreferences sp = await SharedPreferences.getInstance();
    return sp.getBool(userLoggedInKey); //return true when signin
    //or
    //return localStorage.read("userLoggedInKey");
  }

  static Future<String?> getUserNameFromSp() async{
    SharedPreferences sp = await SharedPreferences.getInstance();
    //await sp.reload(); //not work
    return sp.getString(userNameKey);
  }
  static Future<String?> getUserEmailFromSp() async{
    SharedPreferences sp = await SharedPreferences.getInstance();
    //await sp.reload(); //not work
    return sp.getString(userEmailKey);
  }





  static void nextScreen(context, page){
    Navigator.push(context, MaterialPageRoute(builder: (context)=>page));
  }

  static void nextScreenReplace(context, page){
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>page));
  }

  static void showSnackbar(context, color, message){
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
              message,
              style: const TextStyle(fontSize: 14),
            ),
          backgroundColor: color,
          duration: const Duration(seconds: 2),
          action: SnackBarAction(
            label: "OK",
            onPressed: (){},
            textColor: Colors.white,
          ),
        )
    );
  }


  static Color? getColor(String value){
      if(value=="Green"){
        return Colors.green;
      }
      else if(value=="Red"){
        return Colors.red;
      }
      else if(value=="Blue"){
        return Colors.blue;
      }
      else if(value=="Pink"){
        return Colors.pink;
      }
      else if(value=="Grey"){
        return Colors.grey;
      }
      else if(value=="Purple"){
        return Colors.purple;
      }
      else if(value=="Black"){
        return Colors.black;
      }
      else if(value=="White"){
        return Colors.white;
      }
      else if(value=="Yellow"){
        return Colors.yellow;
      }
      else{
        return null;
      }

  }

  static void showSnackBar(String message){
    ScaffoldMessenger.of(Get.context!).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  static void showAlert(String title, String message){
    showDialog(
        context: Get.context!,
        builder: (BuildContext context)
        {
          return AlertDialog(
            title: Text(title),
            content: Text(message),
            actions: [
              TextButton(
                  onPressed: ()=>Navigator.of(context).pop(),
                  child: const Text("OK"))
            ],
          );
        }
    );
  }

  static void navigateToScreen(BuildContext context, Widget screen){
    Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => screen),
    );
  }

  //hello,5 = 5=hello=as it is, 3=hel
  static String tuncateText(String text, int maxLength){
    if(text.length <= maxLength){
      return text;
    }
    else{
      return "${text.substring(0, maxLength)}...";
    }
  }

  static bool isDarkMode(BuildContext context){
    return Theme.of(context).brightness == Brightness.dark;
  }

  static Size screenSize(){
    return MediaQuery.of(Get.context!).size;
  }

  static double screenWidth(){
    return MediaQuery.of(Get.context!).size.width;
  }

  static double screenHeight(){
    return MediaQuery.of(Get.context!).size.height;
    //return RouteData.of(context!).context?.height;;
  }

  static String formattedDate(DateTime date, {String formate = "dd MM yyyy"}){
    return DateFormat(formate).format(date);
  }

  static List<T> removeDuplicates<T>(List<T> list){
    return list.toSet().toList();
  }

  static List<Widget> wrapWidgets(List<Widget> widgets, int rowSize){
    final wrappedList = <Widget>[];
    for(var i=0;i<widgets.length; i+=rowSize) //i++ means rowSize++ means i=i+rowSize
    {
                                                          //list size, nth number
      final rowChildren = widgets.sublist(i, i+rowSize > widgets.length?widgets.length:i+rowSize);
      wrappedList.add(Row(children: rowChildren));
    }
    return wrappedList;
  }
}