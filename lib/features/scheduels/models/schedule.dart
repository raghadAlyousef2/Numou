class Schedule {
  String id;
  String name; // Unique identifier for each schedule
  DateTime time; // To store the specific time (e.g., 11:34 PM)
  List<String> daysOfWeek; // To store the selected days of the week (e.g., Monday, Friday, Sunday)
  bool isActive;
  Schedule({
    required this.id,
    required this.name,
    required this.time,
    required this.daysOfWeek,
    required this.isActive,
  });

  // Function to convert the time and days of the week to a readable string
  String getFormattedDate() {
    String formattedTime = "${time.hour % 12 == 0 ? 12 : time.hour % 12}:${time.minute.toString().padLeft(2, '0')} ${time.hour >= 12 ? 'PM' : 'AM'}";
    //String formattedDays = daysOfWeek.join(', ');
    return formattedTime;
  }


  // Function to check if a given day is in the daysOfWeek list
  bool isDayIncluded(String inputDay) {
    // Create a mapping of short day names to full names
    Map<String, String> dayMapping = {
      'Mon': 'Monday',
      'Tue': 'Tuesday',
      'Wed': 'Wednesday',
      'Thu': 'Thursday',
      'Fri': 'Friday',
      'Sat': 'Saturday',
      'Sun': 'Sunday',
    };

    // Normalize the input to match with the list (either full day name or short version)
    String normalizedDay = dayMapping[inputDay] ?? inputDay;

    // Check if the normalized day exists in the daysOfWeek list
    return daysOfWeek.contains(normalizedDay);
  }




  // Convert Schedule object to a Firebase-friendly JSON format
  Map<String, dynamic> toJson() {
    return {
      'id':id,
      'isActive':isActive,
      'name': name,
      'time': {
        'hour': time.hour,
        'minute': time.minute,
      },
      'daysOfWeek': daysOfWeek,
    };
  }

  // Create Schedule object from Firebase JSON
  factory Schedule.fromJson(Map<dynamic, dynamic> json) {
    return Schedule(
      isActive: json['isActive']??false,
      id:json['id']??'',
      name: json['name']??'',
      time: DateTime(0, 0, 0, json['time']['hour']??0, json['time']['minute']??0),
      daysOfWeek: List<String>.from(json['daysOfWeek']??[]),
    );
  }






}
