
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/analytic_controller.dart';
class TabButton extends StatelessWidget {
   const TabButton({required this.controller, required this.title ,required this.index,required this.size,super.key});
   final String title;
   final int index;
   final Size size;
   final AnalyticsController  controller;
  @override
  Widget build(BuildContext context) {
    return Flexible(
      flex: 3,
      child: GestureDetector(
        onTap: () => controller.changeIndex(index),
        child: Obx(() {
          return Container(
            height: size.height * 0.08,  // Adjusted height
            decoration: _containerDecoration(size, controller.selectedIndex.value == index),
            child: Center(
              child: Text(
                title,
                style: _textStyle(size, controller.selectedIndex.value == index),
                textAlign: TextAlign.center,
              ),
            ),
          );
        }),
      ),
    );
  }
   // Container decoration for styling
   BoxDecoration _containerDecoration(Size size, bool isSelected) {
     return BoxDecoration(
       color: isSelected ? const Color(0xFF1183B7) : Colors.grey[300],  // Change color based on selection
       borderRadius: BorderRadius.circular(size.width * 0.05),
       boxShadow: const [
         BoxShadow(
           color: Colors.black26,
           offset: Offset(2, 2),
           blurRadius: 4,
         ),
       ],
     );
   }

   // Text styling for the container content
   TextStyle _textStyle(Size size, bool isSelected) {
     return TextStyle(
       fontSize: size.width * 0.035,
       fontWeight: FontWeight.w500,
       color: isSelected ? Colors.white : Colors.black,  // Change text color based on selection
     );
   }

}
