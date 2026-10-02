class DeviceHistory {
  String duration;
  String date;
  String time;
  String id;
  // Constructor
  DeviceHistory({
    required this.duration,
    required this.date,
    required this.time,
    required this.id,
  });

  // Factory method to create a DeviceHistory object from a JSON map
  factory DeviceHistory.fromJson(Map<dynamic, dynamic> json) {
    return DeviceHistory(
      id:json['id']??'',
      duration: json['duration'] ?? '',
      date: json['date'] ?? '',
      time: json['time'] ?? '',
    );
  }

  // Method to convert a DeviceHistory object to a JSON map
 static  Map<String, dynamic> toJson({required String myId,required String  duration,required String  date,required String  time}) {
    return {
      'id':myId,
      'duration': duration,
      'date': date,
      'time': time,
    };
  }
}
