import 'package:flutter/material.dart';
import '../../../Models/device.dart';

class DeviceHistoryWidget extends StatelessWidget {
  DeviceHistoryWidget({
    super.key,
    required this.device,
  });

  Device device;

  @override
  Widget build(BuildContext context) {
    // Sort the deviceHistories by date and time before displaying them
    device.deviceHistories.sort((a, b) {
      // Combine date and time strings into a single DateTime object for comparison
      DateTime dateTimeA = _combineDateAndTime(a.date, a.time);
      DateTime dateTimeB = _combineDateAndTime(b.date, b.time);
      return dateTimeA.compareTo(dateTimeB); // Sort in ascending order
    });

    return Column(
      children: [
        Text(
          device.name,
          style: TextStyle(
            fontSize: 20.0,
            // Change the font size
            fontWeight: FontWeight.bold,
            // Make the text bold
            color: Theme.of(context).primaryColor,
            // Set text color
            letterSpacing: 1.5,
            // Add space between letters
            shadows: [
              Shadow(
                offset: const Offset(2.0, 2.0), // Shadow position
                blurRadius: 3.0, // Shadow blur effect
                color: Colors.black.withOpacity(0.3), // Shadow color
              ),
            ],
          ),
          textAlign: TextAlign.center, // Align text to center
        ),
        device.deviceHistories.isEmpty
            ? const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('No Record found'),
            )
            : Table(
                border: TableBorder.all(
                    color: Colors.black, width: 1), // Border around the table
                columnWidths: const {
                  0: FlexColumnWidth(2),
                  1: FlexColumnWidth(1.5),
                  2: FlexColumnWidth(1.5),
                },
                children: [
                  // Table header
                  const TableRow(
                    decoration: BoxDecoration(
                        color:
                            Color(0xFF1183B7)), // Blue background for headers
                    children: [
                      Padding(
                        padding: EdgeInsets.fromLTRB(5.0, 18, 10, 4),
                        child: Text(
                          textAlign: TextAlign.center,
                          'Date',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(15, 20, 10, 4),
                        child: Text(
                          'Time',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(5.0, 20, 0, 4),
                        child: Text(
                          'Duration',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  // Dynamic Table rows based on sorted data
                  for (var history in device.deviceHistories)
                    TableRow(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child:
                              Text(history.date.split('-').reversed.join('-')),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(convert24To12HourFormat(history.time)),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(history.duration),
                        ),
                      ],
                    ),
                ],
              ),
      ],
    );
  }

  // Method to combine date and time into a DateTime object for comparison
  DateTime _combineDateAndTime(String date, String time) {
    // Parse the date string (assuming it is in "YYYY-MM-DD" format)
    List<String> dateParts = date.split('-');
    int year = int.parse(dateParts[0]);
    int month = int.parse(dateParts[1]);
    int day = int.parse(dateParts[2]);

    // Parse the time string (assuming it is in "HH:MM:SS" format)
    List<String> timeParts = time.split(':');
    int hour = int.parse(timeParts[0]);
    int minute = int.parse(timeParts[1]);
    int second = int.parse(timeParts[2]);

    // Combine date and time into a single DateTime object
    return DateTime(year, month, day, hour, minute, second);
  }

  // Method to convert 24-hour time to 12-hour format with AM/PM
  String convert24To12HourFormat(String time24) {
    // Split the input string into hours and minutes
    List<String> parts = time24.split(':');
    int hour = int.parse(parts[0]);
    int minute = int.parse(parts[1]);

    // Determine whether it's AM or PM
    String period = hour >= 12 ? 'PM' : 'AM';

    // Convert hour from 24-hour format to 12-hour format
    hour = hour % 12;
    if (hour == 0) {
      hour = 12; // Midnight or Noon case
    }

    // Return the formatted time string
    return '${hour.toString()}:${minute.toString().padLeft(2, '0')} $period';
  }
}
