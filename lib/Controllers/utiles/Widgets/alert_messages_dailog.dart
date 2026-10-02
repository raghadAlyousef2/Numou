import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../services/translation_service.dart';

class AlertMessagesDialog {
  static Future<void> errorMessageDialog(String englishMessage) async {


    Get.defaultDialog(
        title: 'تنبيه',
        content: Center(
          child: Column(
            children: [
              Text(englishMessage),
            ],
          ),
        ),
      actions: [
        ElevatedButton(onPressed: (){
          Get.back();
        }, child: const Icon(Icons.verified_outlined))
      ]

    );
  }
}
