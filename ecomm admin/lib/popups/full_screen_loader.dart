import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../utils/colors.dart';
import '../utils/helper_functions.dart';
import 'animation_loader.dart';

//use /// or /** comment for check code main use comment where define
/**
 * A utility class for managing a full screen loading dialog
 * A utility class for managing a full screen loading dialog
 */
//or
///A utility class for managing a full screen loading dialog
class TFullScreenLoader {
  static final TAG = "Myy TFullScreenLoader ";


  ///Open a full screen loading dialog with a given text and animation
  ///This method does not return nothing
  ///
  ///Parameters:
  ///- text: The text to be displayed in the loading dialog
  ///- animation: The Lotti animation to be shown
  static void openLoadingDialog(String text, String animation)
  {
    final dark = THelperFunctions.isDarkMode(Get.context!);

    showDialog(
        context: Get.overlayContext!, //use Get.overlayContext for overlay dailogs
        barrierDismissible: false, //The dialog can not be dismissed by tapping outside it
        builder: (_) => PopScope(
            canPop: false, ///Diable popping with rthe back button
            child: Container(
              width: double.infinity,
              height: double.infinity,
              color: dark?TColors.dark:TColors.white,
                  child: Column(
                    children: [
                      const SizedBox(height: 250), //Adjust the spacing as needed
                      TAnimationLoaderWidget(text:text, animation:animation)
                    ],
              ),
            )
        )
    );
  }

  ///Stop the currently open loading dialog
  ///This method doesnot return anything
  static stopLoading()
  {
    Navigator.of(Get.overlayContext!).pop(); //Close the dialog using the Navigator
  }

}