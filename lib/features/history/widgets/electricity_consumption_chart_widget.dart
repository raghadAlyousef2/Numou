import 'package:flutter/material.dart';

import 'electricity_consumption_chart.dart';

class ElectricityConsumptionChartWidget extends StatelessWidget {
  const ElectricityConsumptionChartWidget({ super.key});



  @override
  Widget build(BuildContext context) {
   var size =MediaQuery.of(context).size;
    return Container(
      padding: const EdgeInsets.all(14),
      // Increased padding for more internal space
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(20),
      ),
      child:  Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            ' Electricity Consumption',
            style: TextStyle(
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
           SizedBox(
            height: size.height*0.55, // Set a height for the chart
            child: const ElectricityConsumptionChart(),
          ),
          //const implement chart here  //const WaterLevelChart(), // The line chart widget
        ],
      ),
    );
  }
}


