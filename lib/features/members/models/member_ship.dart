class MemberShip {
  String id; // membership id
  String device;
  String ownerName; // Member's name
  String ownerShareCode;
  String status;
  // Constructor
  MemberShip({
    required this.id,
    required this.ownerName,

    // required this.attachedDevices,
    required this.device,
    required this.ownerShareCode,
    required this.status,
  });

  // Factory method to create a Member object from a JSON map
  factory MemberShip.fromJson(Map<dynamic, dynamic> json, String id) {
    // List<String> attachedDevicesList = [];
    // if (json['devices'] != null) {
    //   for (var device in json['devices'].values) {
    //     attachedDevicesList.add(device.toString()); // Adding each device to the list
    //   }
    // }
    return MemberShip(
      id: id, // Firebase key for the membership
      ownerName: json['ownerName'] ?? '',
      ownerShareCode: json['ownerShareCode'] ?? '',
      device: json['device']??'',
      status: json['status']??'',
    );
  }

  // Method to convert a Member object to a JSON map
   Map<String, dynamic> toJson() {
    return {

      //'devices': attachedDevices,
      'id':id,

      'device':device,
   'ownerShareCode':ownerShareCode,
      'ownerName':ownerName,
      'status':status
    };
  }
}
