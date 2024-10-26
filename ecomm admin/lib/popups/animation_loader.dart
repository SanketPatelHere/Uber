import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../logging/logger_helper.dart';
import '../utils/colors.dart';
import '../utils/helper_functions.dart';
import '../utils/sizes.dart';

///A widget for displaying an animated loading indicator with optional text and action button
class TAnimationLoaderWidget extends StatelessWidget {
  final TAG = "Myy TAnimationLoaderWidget ";
  /// Default constructor for the TAnimationLoaderWidget
  /// - text: The text to be displayed below the animation
  /// - animation: The path to the Lottie animation file
  /// - showAction: Whether to show an action button below the text
  /// - actionText: The text to be displayed on the action button
  /// - onActionPressed: Callback function to be executed when the action button is pressed
  const TAnimationLoaderWidget({
    super.key,
    required this.text,
    required this.animation,
    this.showAction = false,
    this.actionText,
    this.onActionPressed
  });

  final String text;
  final String animation;
  final bool showAction;
  final String? actionText;
  final VoidCallback? onActionPressed;

  @override
  Widget build(BuildContext context) {
    TLoggerHelper.info("${TAG} inside build"); //for show log
    final dark = THelperFunctions.isDarkMode(context);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ///Lottie.network('https://raw.githubusercontent.com/xvrh/lottie-flutter/master/example/assets/Mobilo/A.json'), //working for show gif
          ///Lottie.network('https://telegram.org/file/464001484/1/bzi7gr7XRGU.10147/815df2ef527132dd23', decoder: LottieComposition.decodeGZip,),//working for show gif
          ///Lottie.network(width:MediaQuery.of(context).size.width*0.8, 'https://telegram.org/file/464001484/1/bzi7gr7XRGU.10147/815df2ef527132dd23', decoder: LottieComposition.decodeGZip),//working for show gif
          Lottie.asset(width:MediaQuery.of(context).size.width*0.8,animation), //display Lottie animation - json file //working for show gif
          const SizedBox(height: TSizes.defaultSpace),
          Text(
            text,
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: TSizes.defaultSpace),
          showAction
          ?SizedBox(
            width: 250,
              child: OutlinedButton(
                onPressed: onActionPressed,
                style: OutlinedButton.styleFrom(backgroundColor: TColors.dark),
                child: Text(
                  actionText!,
                  style:  Theme.of(context).textTheme.bodyMedium!.apply(color: TColors.light),
                ),
              ),
          )
          :const SizedBox()
        ],
      ),
    );
  }
}
