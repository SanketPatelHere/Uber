// ignore_for_file: file_names, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/CategoryDropDownController.dart';
import '../../controllers/CategoryDropDownController.dart';
import '../../logging/logger_helper.dart';


class DropDownCategoriesWidget extends StatelessWidget {
  final TAG = "Myy DropDownCategoriesWidget ";
  const DropDownCategoriesWidget({super.key});

  //CategoryDropDownController categoryDropDownController = Get.put(CategoryDropDownController()); //no need of this

  @override
  Widget build(BuildContext context) {
    return
      GetBuilder<CategoryDropDownController>(
      init: CategoryDropDownController(),
      builder: (categoriesDropDownController) {
        return Column(
          children: [
            Container(
              //margin: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Card(
                elevation: 10,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: DropdownButton<String>(
                    value: categoriesDropDownController.selectedCategoryId?.value,
                    items:
                    categoriesDropDownController.categories.map((category) {
                      return DropdownMenuItem<String>(
                        value: category['categoryId'],
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            CircleAvatar(
                              backgroundImage: NetworkImage(
                                category['categoryImg'].toString(),
                              ),
                            ),
                            const SizedBox(width: 20),
                            Text(category['categoryName']),
                          ],
                        ),
                      );
                    }).toList(),
                    onChanged: (String? selectedValue) async {
                      TLoggerHelper.info("${TAG} onChanged selectedValue = "+selectedValue.toString());
                      //first set selected categoryId
                      categoriesDropDownController.setSelectedCategory(selectedValue);
                      //then get categoryName from firebase and set it in categoryName
                      String? categoryName = await categoriesDropDownController.getCategoryName(selectedValue);
                      TLoggerHelper.info("${TAG} onChanged categoryName = "+categoryName.toString());
                      categoriesDropDownController.setSelectedCategoryName(categoryName);
                    },
                    hint: const Text('Select a category',),
                    isExpanded: true,
                    elevation: 10,
                    underline: const SizedBox.shrink(),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}