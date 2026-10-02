
import '../Controllers/firebase_data_controller.dart';
import '../features/members/models/member.dart';
import '../features/members/models/member_ship.dart';
import 'device.dart'; // Import Firebase package

class User {
  final String userId;
  final String name;
  final String email;
  String? profileImageUrl;
  final String isOwner;
   List<String> devicesIds;
  List<Device> devices = [];
  List<Member> members=[];
  List<MemberShip> memberShips=[];
  String shareCode;

  User({
    required this.userId,
    required this.name,
    required this.email,
    required this.devicesIds,
    required this.isOwner,
    required this.members,
    this.profileImageUrl,
    required this.shareCode,
    required this.memberShips
  });

  factory User.fromJson(Map<dynamic, dynamic> json,var userId) {
    List<String> d = [];
    if (json['devices'] != null) {
      for (Object? key in json['devices'].keys) {
        d.add(json['devices'][key]);
      }
    }

    final user = User(
      userId: userId,
      name: json['name'] ?? "",
      email: json['email'] ?? "",
      isOwner: json['isOwner']?? 'false',
      devicesIds: d,
      profileImageUrl: json['profileImageUrl'],
      members: json['members'] != null
          ? (json['members'].keys.map((key) {
        // Pass the key (ID) to the Member fromJson method
        return Member.fromJson(json['members'][key], key);
      }).toList().cast<Member>())
          : [],
      shareCode: json['shareCode']??'',
        memberShips: json['memberShips'] != null
    ? (json['memberShips'].keys.map((key) {
      // Pass the key (ID) to the Member fromJson method
      return MemberShip.fromJson(json['memberShips'][key], key);
    }).toList().cast<MemberShip>())
        : [],

    );

    //user.fetchDevicesData(); // Call fetchDevicesData method
    return user;
  }
  factory User.dummy() {
    return User(
      members: [],
      memberShips: [],
      userId: "",
      name: "",
      email: "",
      devicesIds: ['1'], isOwner: 'false',
      shareCode: ''

    );
  }
  void clearDevicesData() {
    devices = [];
  }
  Future<void> fetchDevicesData() async {
    List<String> updatedDevicesIds = []; // Temporary list to hold updated device IDs
    for (String deviceId in devicesIds) {
      final deviceData = await FirebaseDataController.instance.fetchDeviceData(deviceId);
      if (deviceData != null) {
       // print('device fount at $deviceId');
        devices.add(deviceData);
        updatedDevicesIds.add(deviceId); // Add the device ID to the updated list
      }else{
        print('device data is not fetched at deviceid $deviceId');
      }
    }
   devicesIds= updatedDevicesIds;
    // Return a new User object with the updated devicesIds list
    // return User(
    //   userId: userId,
    //   name: name,
    //   email: email,
    //   devices: devices,
    //   devicesIds: updatedDevicesIds, // Use the updated list
    // );
  }
}
