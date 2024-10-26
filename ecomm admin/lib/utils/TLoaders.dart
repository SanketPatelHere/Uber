import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:get/get.dart';

import 'colors.dart';
import 'helper_functions.dart';

class TLoaders {
  final TAG = "Myy TLoaders ";

  static hideSnackBar() => ScaffoldMessenger.of(Get.context!).hideCurrentSnackBar();

  //for toast message
  static customToast({required message})
  {
    final dark = THelperFunctions.isDarkMode(Get.context!);
    ScaffoldMessenger.of(Get.context!).showSnackBar(
      SnackBar(
          elevation: 0,
          duration: const Duration(seconds: 3),
          backgroundColor: Colors.transparent,
          content: Container(
            padding: const EdgeInsets.all(12.0),
            margin: const EdgeInsets.symmetric(horizontal: 30),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: dark?TColors.darkerGrey.withOpacity(0.9):TColors.grey.withOpacity(0.9),
            ),
            child: Center(child: Text(message, style: Theme.of(Get.context!).textTheme.labelMedium)),
          )
      )
    );
  }

  //for dialog
  //for show snackbar on bottom
  static successSnakeBar({required title, message = "", duration = 3})
  {
    Get.snackbar(
        title,
        message,
        isDismissible: true,
        shouldIconPulse: true,
        colorText: TColors.white,
        backgroundColor: Colors.green.shade500,
        snackPosition: SnackPosition.BOTTOM,
        duration: Duration(seconds: duration),
        margin: const EdgeInsets.all(10),
        icon: const Icon(Iconsax.check, color: TColors.white)
    );
  }

  //for show snackbar on top
  static successSnakeBarTop({required title, message = "", duration = 3})
  {
    Get.snackbar(
        title,
        message,
        isDismissible: true,
        shouldIconPulse: true,
        colorText: TColors.white,
        backgroundColor: Colors.green.shade500,
        snackPosition: SnackPosition.TOP,
        duration: Duration(seconds: duration),
        margin: const EdgeInsets.all(10),
        icon: const Icon(Iconsax.check, color: TColors.white)
    );
  }

  static warningSnakeBar({required title, message = "", duration = 3})
  {
    Get.snackbar(
        title,
        message,
        isDismissible: true,
        shouldIconPulse: true,
        colorText: TColors.white,
        backgroundColor: TColors.orange,
        snackPosition: SnackPosition.BOTTOM,
        duration: Duration(seconds: duration),
        margin: const EdgeInsets.all(10),
        icon: const Icon(Iconsax.warning_2, color: TColors.white)
    );
  }

  static errorSnakeBar({required title, message = "", duration = 3})
  {
    Get.snackbar(
        title,
        message,
        isDismissible: true,
        shouldIconPulse: true,
        colorText: TColors.white,
        backgroundColor: Colors.red.shade500,
        snackPosition: SnackPosition.BOTTOM,
        duration: Duration(seconds: duration),
        margin: const EdgeInsets.all(20),
        icon: const Icon(Iconsax.warning_2, color: TColors.white)
    );
  }

}
