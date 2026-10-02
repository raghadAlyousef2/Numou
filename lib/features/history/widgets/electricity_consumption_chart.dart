// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:syncfusion_flutter_charts/charts.dart';
// import '../../../Controllers/firebase_data_controller.dart';
// import '../modals/electricity_consumption_history.dart'; // Import your ElectricityConsumptionHistory model
//
// class ElectricityConsumptionChart extends StatelessWidget {
//
//   const ElectricityConsumptionChart({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     var controller = Get.find<FirebaseDataController>();
//     var devices=controller.user.value.devices;
//     final sortedHistories = _getSortedData(histories);
//
//     return SfCartesianChart(
//       primaryXAxis: DateTimeAxis(
//         // Set the zoom range limits
//         minimum: sortedHistories.isNotEmpty
//             ? _combineDateAndTime(sortedHistories.first.date, sortedHistories.first.time)
//             .subtract(const Duration(days: 30))
//             : null,
//         maximum: sortedHistories.isNotEmpty
//             ? _combineDateAndTime(sortedHistories.last.date, sortedHistories.last.time)
//             .add(const Duration(days: 30))
//             : null,
//         intervalType: DateTimeIntervalType.auto,
//         enableAutoIntervalOnZooming: true,
//         initialZoomFactor: 0.5,
//         initialZoomPosition: 0.5,
//       ),
//       primaryYAxis:  NumericAxis(
//         title: const AxisTitle(text: 'Power Consumption (Watts)'),
//         minimum: _findMinPower(sortedHistories)-50,
//         maximum: _findMaxPower(sortedHistories)+50,
//       ),
//       zoomPanBehavior: ZoomPanBehavior(
//         enablePinching: true,
//         zoomMode: ZoomMode.x, // Allows horizontal zooming
//         enablePanning: true,
//         enableDoubleTapZooming: true,
//         enableSelectionZooming: true,
//       ),
//       series: <CartesianSeries<dynamic, dynamic>>[
//         // Plot power1
//         LineSeries<ElectricityConsumptionHistory, DateTime>(
//           dataSource: sortedHistories, // Use sorted data
//           xValueMapper: (ElectricityConsumptionHistory history, _) =>
//               _combineDateAndTime(history.date, history.time),
//           yValueMapper: (ElectricityConsumptionHistory history, _) => history.power1,
//           name: 'Power Source 1',
//           dataLabelSettings: DataLabelSettings(
//             isVisible: true,
//             textStyle: TextStyle(color: Theme.of(context).colorScheme.tertiary),
//           ),
//           markerSettings: MarkerSettings(
//             isVisible: true,
//             color: Theme.of(context).colorScheme.tertiary,
//             shape: DataMarkerType.circle,
//             borderColor: Colors.white,
//             borderWidth: 1,
//             height: 10,
//             width: 10,
//           ),
//          // borderColor : Theme.of(context).colorScheme.primary, // Line color
//           //borderWidth: 2, // Line thickness
//         ),
//         // Plot power2
//         LineSeries<ElectricityConsumptionHistory, DateTime>(
//           dataSource: sortedHistories, // Use sorted data
//           xValueMapper: (ElectricityConsumptionHistory history, _) =>
//               _combineDateAndTime(history.date, history.time),
//           yValueMapper: (ElectricityConsumptionHistory history, _) => history.power2,
//           name: 'Power Source 2',
//           dataLabelSettings: DataLabelSettings(
//             isVisible: true,
//             textStyle: TextStyle(color: Theme.of(context).colorScheme.secondary),
//           ),
//           markerSettings: MarkerSettings(
//             isVisible: true,
//             color: Theme.of(context).colorScheme.secondary,
//             shape: DataMarkerType.diamond,
//             borderColor: Colors.white,
//             borderWidth: 1,
//             height: 10,
//             width: 10,
//           ),
//           //borderColor: Theme.of(context).colorScheme.secondary, // Line color
//           //borderWidth: 2, // Line thickness
//         ),
//       ],
//     );
//   }
//
//   // Helper function to combine date and time into a DateTime object
//   DateTime _combineDateAndTime(String date, String time) {
//     try {
//       // Parse the date and time strings into a DateTime object
//       return DateTime.parse('${_formatDate(date)} ${_formatTime(time)}');
//     } catch (e) {
//       // Handle parsing error, return current date-time if error occurs
//       if (kDebugMode) {
//         print('Error: time and date are not correct');
//       }
//       return DateTime.now();
//     }
//   }
//
//   // Function to sort the electricity consumption history data based on DateTime
//   List<ElectricityConsumptionHistory> _getSortedData(List<ElectricityConsumptionHistory> histories) {
//     histories.sort((a, b) {
//       DateTime dateTimeA = _combineDateAndTime(a.date, a.time);
//       DateTime dateTimeB = _combineDateAndTime(b.date, b.time);
//       return dateTimeA.compareTo(dateTimeB);
//     });
//     return histories;
//   }
//
//
//   // Helper function to find the minimum power value from both power1 and power2
//   double _findMinPower(List<ElectricityConsumptionHistory> histories) {
//     if (histories.isEmpty) return 0;
//     return histories
//         .map((history) => history.power1 < history.power2 ? history.power1 : history.power2)
//         .reduce((value, element) => value < element ? value : element)
//         .toDouble();
//   }
//
//   // Helper function to find the maximum power value from both power1 and power2
//   double _findMaxPower(List<ElectricityConsumptionHistory> histories) {
//     if (histories.isEmpty) return 0;
//     return histories
//         .map((history) => history.power1 > history.power2 ? history.power1 : history.power2)
//         .reduce((value, element) => value > element ? value : element)
//         .toDouble();
//   }
//
//   String _formatDate(String date) {
//     final parts = date.split('-');
//     final year = parts[0].padLeft(4, '0');
//     final month = parts[1].padLeft(2, '0');
//     final day = parts[2].padLeft(2, '0');
//     return '$year-$month-$day';
//   }
//
//   String _formatTime(String time) {
//     final parts = time.split(':');
//     final hours = parts[0].padLeft(2, '0');
//     final minutes = parts[1].padLeft(2, '0');
//     final seconds = parts.length > 2 ? parts[2].padLeft(2, '0') : '00'; // Default to '00' if seconds aren't provided
//     return '$hours:$minutes:$seconds';
//   }
// }


import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../../../Controllers/firebase_data_controller.dart';
import '../modals/electricity_consumption_history.dart'; // Import your ElectricityConsumptionHistory model

class ElectricityConsumptionChart extends StatelessWidget {

  const ElectricityConsumptionChart({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.find<FirebaseDataController>();
   return Obx(() {
     var devices = controller.user.value.devices;

     // List of all devices' power1 histories combined
     List<ElectricityConsumptionHistory> allDeviceHistories = [];

     // Iterate through each device and get the history
     for (var device in devices) {
       allDeviceHistories.addAll(device
           .deviceElectricityConsumptionHistories); // Assuming each device has a 'histories' field
     }

     final sortedHistories = _getSortedData(allDeviceHistories);

     return SfCartesianChart(
       primaryXAxis: DateTimeAxis(
         // Set the zoom range limits
         minimum: sortedHistories.isNotEmpty
             ? _combineDateAndTime(
             sortedHistories.first.date, sortedHistories.first.time)
             .subtract(const Duration(days: 7))
             : null,
         maximum: sortedHistories.isNotEmpty
             ? _combineDateAndTime(
             sortedHistories.last.date, sortedHistories.last.time)
             .add(const Duration(days: 7))
             : null,
         intervalType: DateTimeIntervalType.auto,
         enableAutoIntervalOnZooming: true,
         initialZoomFactor: 0.01,
         initialZoomPosition: 0.495,
       ),
       primaryYAxis: NumericAxis(
         title: const AxisTitle(text: 'Power Consumption (Watts)'),
         minimum: _findMinPower(sortedHistories) - 50,
         maximum: _findMaxPower(sortedHistories) + 50,
       ),
       zoomPanBehavior: ZoomPanBehavior(
         enablePinching: true,
         zoomMode: ZoomMode.x,
         // Allows horizontal zooming
         enablePanning: true,
         enableDoubleTapZooming: true,
         enableSelectionZooming: true,
       ),
       legend: const Legend(
         isVisible: true,
         position: LegendPosition.bottom,
         // Positioning the legend at the bottom
         overflowMode: LegendItemOverflowMode.wrap,
         // Wrap legend items
         textStyle: TextStyle(
           //color: Theme.of(context).colorScheme.onBackground, // Customize text style if needed
         ),
       ),
       series: <CartesianSeries<dynamic, dynamic>>[
         // Plot power1 for all devices
         for (var device in devices)
           LineSeries<ElectricityConsumptionHistory, DateTime>(
             dataSource: _getSortedData(
                 device.deviceElectricityConsumptionHistories),
             // Use sorted data for each device
             xValueMapper: (ElectricityConsumptionHistory history, _) =>
                 _combineDateAndTime(history.date, history.time),
             yValueMapper: (ElectricityConsumptionHistory history, _) =>
             history.power1,
             name: device.name,
             legendIconType: LegendIconType.diamond,
             //legendItemText: device.name,

             dataLabelSettings: DataLabelSettings(
               isVisible: true,
               textStyle: TextStyle(color: Theme
                   .of(context)
                   .colorScheme
                   .tertiary),
             ),
             markerSettings: MarkerSettings(
               isVisible: true,
               color: Theme
                   .of(context)
                   .colorScheme
                   .tertiary,
               shape: DataMarkerType.circle,
               borderColor: Colors.white,
               borderWidth: 1,
               height: 10,
               width: 10,
             ),
           ),
       ],
     );
   },);
  }

  // Helper function to combine date and time into a DateTime object
  DateTime _combineDateAndTime(String date, String time) {
    try {
      // Parse the date and time strings into a DateTime object
      return DateTime.parse('${_formatDate(date)} ${_formatTime(time)}');
    } catch (e) {
      // Handle parsing error, return current date-time if error occurs
      if (kDebugMode) {
        print('Error: time and date are not correct');
      }
      return DateTime.now();
    }
  }

  // Function to sort the electricity consumption history data based on DateTime
  List<ElectricityConsumptionHistory> _getSortedData(List<ElectricityConsumptionHistory> histories) {
    histories.sort((a, b) {
      DateTime dateTimeA = _combineDateAndTime(a.date, a.time);
      DateTime dateTimeB = _combineDateAndTime(b.date, b.time);
      return dateTimeA.compareTo(dateTimeB);
    });
    return histories;
  }

  // Helper function to find the minimum power value from power1 for all devices
  double _findMinPower(List<ElectricityConsumptionHistory> histories) {
    if (histories.isEmpty) return 0;
    return histories
        .map((history) => history.power1)
        .reduce((value, element) => value < element ? value : element)
        .toDouble();
  }

  // Helper function to find the maximum power value from power1 for all devices
  double _findMaxPower(List<ElectricityConsumptionHistory> histories) {
    if (histories.isEmpty) return 0;
    return histories
        .map((history) => history.power1)
        .reduce((value, element) => value > element ? value : element)
        .toDouble();
  }

  String _formatDate(String date) {
    final parts = date.split('-');
    final year = parts[0].padLeft(4, '0');
    final month = parts[1].padLeft(2, '0');
    final day = parts[2].padLeft(2, '0');
    return '$year-$month-$day';
  }

  String _formatTime(String time) {
    final parts = time.split(':');
    final hours = parts[0].padLeft(2, '0');
    final minutes = parts[1].padLeft(2, '0');
    final seconds = parts.length > 2 ? parts[2].padLeft(2, '0') : '00'; // Default to '00' if seconds aren't provided
    return '$hours:$minutes:$seconds';
  }
}
