import 'package:flutter/material.dart';
import '../../logging/logger_helper.dart';
import '../../utils/app-constant.dart';

class HeadingWidget extends StatelessWidget{
      final TAG = "Myy HeadingWidget ";
      final String headingTitle;
      final String headingSubTitle;
      final VoidCallback onTap;
      final String buttonText;

      HeadingWidget({
        super.key,
        required this.headingTitle,
        required this.headingSubTitle,
        required this.onTap,
        required this.buttonText,
    });

    @override
    Widget build(BuildContext context) {
      TLoggerHelper.info("${TAG} inside build");
      return Container(
        margin: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
        child: Padding(
            padding: EdgeInsets.all(7),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //Text("Categories", style: TextStyle(fontWeight: FontWeight.bold, color: TColors.grey.shade800)),
                    //Text(headingTitle, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.grey.shade800,)),
                    Text(headingTitle, style:  Theme.of(context).textTheme.headlineSmall),
                    //Text(headingSubTitle, style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14, color: Colors.grey.shade800)),
                    Text(headingSubTitle, style: Theme.of(context).textTheme.bodyMedium),
                  ],
                ),

                GestureDetector(
                  onTap: onTap,
                  child: Container(
                    //width: 90,
                    //width: Get.width/4,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: AppConstant.appSecondaryColor,
                        width: 1.5
                      ),
                    ),
                    child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Text(buttonText,
                            style: TextStyle(fontWeight:FontWeight.w500, fontSize: 13, color: AppConstant.appSecondaryColor)),
                    ),
                  ),
                )
              ],
            ),
        ),
      );
    }

}