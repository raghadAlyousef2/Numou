class Member {
  String id; // Member's unique ID (e.g., V8vcURf6DHfICrMWfxJ6ZAfKmJ72)
  String email; // Member's email
 // List<String> attachedDevices; // List of attached device IDs/names
  String device;
  String name; // Member's name
  String status;
  // Constructor
  Member({
    required this.id,
    required this.email,
   // required this.attachedDevices,
    required this.device,
    required this.name,
    required this.status,
  });

  // Factory method to create a Member object from a JSON map
  factory Member.fromJson(Map<dynamic, dynamic> json, String id) {
    // List<String> attachedDevicesList = [];
    // if (json['devices'] != null) {
    //   for (var device in json['devices'].values) {
    //     attachedDevicesList.add(device.toString()); // Adding each device to the list
    //   }
    // }
    return Member(
      id: id, // Firebase key for the member
      email: json['email'] ?? '',
      name: json['name'] ?? '',
      device: json['device']??'',
      status: json['status']??'pending',
    );
  }

  // Method to convert a Member object to a JSON map
   Map<String, dynamic> toJson() {
    return {
      'email': email,
      //'devices': attachedDevices,
      'device':device,
      'name': name,
      'status':status
    };
  }
}
