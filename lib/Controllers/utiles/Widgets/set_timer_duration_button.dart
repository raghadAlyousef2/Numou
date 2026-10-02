
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../Controllers/firebase_data_controller.dart';
import '../../Controllers/water_heater_controller.dart';
class SetTimerDurationButton extends StatelessWidget {
    SetTimerDurationButton({required this.controller, required this.optionNumber,required this.color ,required this.duration,required this.name,required this.buttonCallBack,  super.key});
  var fcontroller = Get.put(FirebaseDataController());
  final Function buttonCallBack;
  final String  name;
  final int duration;
  final Color color;
  final int optionNumber;
  final WaterHeaterController controller;
  @override
  Widget build(BuildContext context) {
    final theme=Theme.of(context).colorScheme;
    return
      Padding(
        padding: const EdgeInsets.all(3.0),
        child: ElevatedButton(
          onPressed: ()=>  fcontroller.user.value.isOwner=='false'?null: buttonCallBack(duration,optionNumber),
          style: ElevatedButton.styleFrom(
            elevation: 10,
            backgroundColor: color,
            side :  controller.selectedTimerOption.value==optionNumber  ? const BorderSide(color: Colors.black,):null ,

            minimumSize: const Size(98, 20),
            padding: const EdgeInsets.symmetric(vertical: 15,horizontal: 22),
            shape:  StadiumBorder(
              side: BorderSide(color: theme.surfaceDim),
            ),
          ),
          child:  Text(
            name,
            style: TextStyle(
                fontSize: 16,
                color: theme.tertiary,
                fontWeight: FontWeight.w800),
          ),
        ),
      );
  }
}

