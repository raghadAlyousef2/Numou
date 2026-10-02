class WaterLevelHistory {
  int waterLevel; // Stores water level information
  String date;       // Date when the water level was recorded
  String time;       // Time when the water level was recorded
  String id;         // Unique ID for the record (e.g., push ID)

  // Constructor
  WaterLevelHistory({
    required this.waterLevel,
    required this.date,
    required this.time,
    required this.id,
  });

  // Factory method to create a WaterLevelHistory object from a JSON map
  factory WaterLevelHistory.fromJson(Map<dynamic, dynamic> json) {
    return WaterLevelHistory(
      id: json['id'] ?? '',
      waterLevel: json['waterLevel'] ?? '',
      date: json['date'] ?? '',
      time: json['time'] ?? '',
    );
  }

  // Method to convert a WaterLevelHistory object to a JSON map
  static Map<String, dynamic> toJson({
    required String myId,
    required int  waterLevel,
    required String date,
    required String time,
  }) {
    return {
      'id': myId,
      'waterLevel': waterLevel,
      'date': date,
      'time': time,
    };
  }
}
