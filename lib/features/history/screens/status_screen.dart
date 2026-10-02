
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/analytic_controller.dart';
import '../widgets/tab_button.dart';
import 'device_history_screen.dart';
import 'electricity_consumption_screen.dart';
import 'water_consumption_screen.dart'; // Import your file if needed
class StatusScreen extends StatelessWidget {
  StatusScreen({super.key});

  final AnalyticsController controller = Get.put(AnalyticsController());

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery
        .of(context)
        .size;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // Removes the back button
        title: Padding(
          padding: EdgeInsets.symmetric(horizontal: size.width * 0.01),
          // Reduced left and right padding
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            // Distribute space evenly
            children: [
              TabButton(title: 'History',
                index: 0,
                size: size,
                controller: controller,),
              const SizedBox(width: 10), // Spacing between widgets
              TabButton(title: 'Water \nConsumption',
                index: 1,
                size: size,
                controller: controller,),
              const SizedBox(width: 10), // Spacing between widgets
              TabButton(title: 'Electricity \nConsumption',
                index: 2,
                size: size,
                controller: controller,),
            ],
          ),
        ),
        toolbarHeight: size.height *
            0.10, // Adjusted AppBar height to fit larger buttons
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(size.width * 0.00),
          child: Container(
            width: size.width *0.95,
            height: size.height * 0.75, // Adjusted height to fit the content
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(size.width * 0.1),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black87,
                  offset: Offset(2, 2),
                  blurRadius: 4,
                ),
              ],
            ),
            child: Padding(
              padding: EdgeInsets.all(size.width * 0.05),
              child: Obx(() {
                return IndexedStack(
                  index: controller.selectedIndex.value,
                  children: const [
                    DeviceHistoryScreen(),
                    WaterConsumptionScreen(),
                    ElectricityConsumptionScreen(),
                  ],
                );
              }),
            ),
          ),
        ),
      ),
    );
  }

// Helper function to create tabs


}