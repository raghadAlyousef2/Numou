
import 'package:flutter/material.dart';
import 'package:numou/features/history/widgets/water_level_chart.dart';

import '../../../Models/device.dart';

class WaterLevelChartWidget extends StatelessWidget {
 const  WaterLevelChartWidget({required this.device, super.key});

 final  Device device;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      // Increased padding for more internal space
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            device.name,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          // Increased space between text and divider
          const Divider(
            color: Colors.black,
            thickness: 2,
          ),
          const SizedBox(height: 12),
          // Space below the divider
          device.deviceHistories.isEmpty
              ? const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text('No Record found'),
                )
              : SizedBox(
                  height: 300, // Set a height for the chart
                  child: WaterLevelChart(
                      histories: device.deviceWaterLevelHistories),
                ),
          //const implement chart here  //const WaterLevelChart(), // The line chart widget
        ],
      ),
    );
  }
}


