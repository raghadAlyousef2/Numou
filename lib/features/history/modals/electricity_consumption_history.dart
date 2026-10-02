class ElectricityConsumptionHistory {
  double power1; // Power consumption from source 1 (in watts)
  double power2; // Power consumption from source 2 (in watts)
  String date;   // Date when the consumption was recorded
  String time;   // Time when the consumption was recorded
  String id;     // Unique ID for the record (e.g., push ID)

  // Constructor
  ElectricityConsumptionHistory({
    required this.power1,
    required this.power2,
    required this.date,
    required this.time,
    required this.id,
  });

  // Factory method to create an ElectricityConsumptionHistory object from a JSON map
  factory ElectricityConsumptionHistory.fromJson(Map<dynamic, dynamic> json) {
    return ElectricityConsumptionHistory(
      id: json['id'] ?? '',
      power1: (json['power1'] ?? 0).toDouble(),
      power2: (json['power2'] ?? 0).toDouble(),
      date: json['date'] ?? '',
      time: json['time'] ?? '',
    );
  }

  // Method to convert an ElectricityConsumptionHistory object to a JSON map
  static Map<String, dynamic> toJson({
    required String myId,
    required double power1,
    required double power2,
    required String date,
    required String time,
  }) {
    return {
      'id': myId,
      'power1': power1,
      'power2': power2,
      'date': date,
      'time': time,
    };
  }
}
