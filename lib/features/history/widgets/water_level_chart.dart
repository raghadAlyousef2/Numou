import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../modals/water_level_history.dart';
class WaterLevelChart extends StatelessWidget {
 final  List<WaterLevelHistory> histories;
 const  WaterLevelChart({super.key, required this.histories});
  @override
  Widget build(BuildContext context) {
    final sortedHistories=getSortedData(histories);
    return SfCartesianChart(
      primaryXAxis: DateTimeAxis(
        // Set the zoom range limits
        minimum: sortedHistories.isNotEmpty
            ? combineDateAndTime(sortedHistories.first.date, sortedHistories.first.time).subtract(const Duration(days: 7))
            : null,
        maximum: sortedHistories.isNotEmpty
            ? combineDateAndTime(sortedHistories.last.date, sortedHistories.last.time).add(const Duration(days: 7))
            : null,
        intervalType: DateTimeIntervalType.auto,

        enableAutoIntervalOnZooming: true,
        initialZoomFactor: 0.001,
        initialZoomPosition: 0.4995,
       // initialVisibleMinimum: combineDateAndTime(sortedHistories.first.date, sortedHistories.first.time).subtract(const Duration(minutes: 1)),
//initialVisibleMaximum: combineDateAndTime(sortedHistories.last.date, sortedHistories.last.time).add(const Duration(days: 1)),

      ),
      primaryYAxis:  const NumericAxis(
        title: AxisTitle(text: 'Water Level (%Per)'),
        minimum: 0.0,
        maximum: 100.0,
      ),
      zoomPanBehavior: ZoomPanBehavior(
        enablePinching: true,
        zoomMode: ZoomMode.x, // Allows horizontal zooming
        enablePanning: true,
        enableDoubleTapZooming: true,
        enableSelectionZooming: true,
      ),
      series: <CartesianSeries<dynamic, dynamic>>[
        AreaSeries<WaterLevelHistory, DateTime>(
          dataSource: sortedHistories, // Use sorted data
          xValueMapper: (WaterLevelHistory history, _) =>
              combineDateAndTime(history.date, history.time),
          yValueMapper: (WaterLevelHistory history, _) => history.waterLevel,
          name: 'Water Level',
          dataLabelSettings:   DataLabelSettings(
            isVisible: true,
            textStyle: TextStyle(color: Theme.of(context).colorScheme.tertiary),
          ),
          markerSettings:  MarkerSettings(
            isVisible: true,
            color: Theme.of(context).colorScheme.tertiary,
            shape: DataMarkerType.circle,
            borderColor: Colors.white,
            borderWidth: 1,
            height: 15,
            width: 15
          ),
          // Apply gradient for shaded area
          gradient: LinearGradient(
            colors: <Color>[
              Colors.blue.withOpacity(0.5), // Gradient start
              Colors.blue.withOpacity(0.2), // Gradient end
            ],
            stops: const <double>[0.0, 1.0],
          ),
          borderColor: Theme.of(context).colorScheme.primary, // Line color
          borderWidth: 5, // Line thickness
        ),
      ],
    );
  }



  String formatDate(String date) {
    final parts = date.split('-');
    final year = parts[0].padLeft(4, '0');
    final month = parts[1].padLeft(2, '0');
    final day = parts[2].padLeft(2, '0');
    return '$year-$month-$day';
  }

  String formatTime(String time) {
    final parts = time.split(':');
    final hours = parts[0].padLeft(2, '0');
    final minutes = parts[1].padLeft(2, '0');
    final seconds = parts.length > 2 ? parts[2].padLeft(2, '0') : '00'; // Handle case where seconds may not be provided
    return '$hours:$minutes:$seconds';
  }



  // Helper function to combine date and time into a DateTime object
  DateTime combineDateAndTime(String date, String time) {
    try {
      // Parse the date and time strings into a DateTime object
     // print('$date ${time}');
      return DateTime.parse('${formatDate(date)} ${formatTime(time)}');
    } catch (e) {
      // Handle parsing error, you can return a default DateTime if needed
      if (kDebugMode) {
        print('error time date is not correct');
      }
      return DateTime.now();
    }
  }

  // Function to sort the water level history data based on DateTime
  List<WaterLevelHistory> getSortedData(List<WaterLevelHistory> histories) {


    // Sort the list based on combined DateTime
    histories.sort((a, b) {
      DateTime dateTimeA = combineDateAndTime(a.date, a.time);
      DateTime dateTimeB = combineDateAndTime(b.date, b.time);
      return dateTimeA.compareTo(dateTimeB);
    });

    return histories;
  }
}

