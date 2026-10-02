import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../../../Controllers/firebase_data_controller.dart';
import '../models/member_ship.dart';
class MemberShipDataController extends GetxController {
  var controller = Get.find<FirebaseDataController>();

  // Observable list for filtered members
  RxList<MemberShip> filteredMemberShips = <MemberShip>[].obs;

  // Text controller for search input
  final TextEditingController searchController = TextEditingController();
  final TextEditingController addShareCodeController = TextEditingController();

  var shareCodeError = ''.obs; // Reactive error message

  // Function to validate email format
  bool isValidShareCode(String shareCode) {
    // Regular expression for validating share codes
    // Must be between 4 and 20 characters long, containing only alphanumeric characters
    String shareCodePattern = r'^[a-zA-Z0-9]{4,20}$';
    RegExp regex = RegExp(shareCodePattern);
    return regex.hasMatch(shareCode);
  }


  @override
  void onInit() {
    super.onInit();

    searchController.addListener(() {
      filterMemberShips();
    });

    // Listen to changes in the member list from FirebaseDataController
    ever(controller.user, (_) {
      filterMemberShips(); // Reapply filtering when user data changes
    });
    filteredMemberShips.value=controller.user.value.memberShips;
  }

  // Filter members based on the search text
  void filterMemberShips() {
    String searchText = searchController.text.toLowerCase();
    filteredMemberShips.value = searchText.isEmpty?controller.user.value.memberShips: controller.user.value.memberShips.where((memberShip) {return memberShip.ownerName.toLowerCase().contains(searchText);}).toList();
  }

  // Function to add a member with selected device
  void addMemberShip(String shareCode) {
    controller.handleMembershipRequest(ownerShareCode: shareCode);
    //controller. addMemberToDevice(email,controller.user.value.devices.where((d)=>d.name==deviceName).first.deviceID);
  }
  void deleteMemberShip(String membershipId){
    controller.deleteMembership(membershipId: membershipId );
   // controller.deleteMemberFromDevice(email, deviceId);

  }


  // Function to update a member's device
  void updateMember(String email, String newDeviceName) {
    controller.user.update((user) {
      final member = user?.members.firstWhere((member) => member.email == email);
      if (member != null) {
        member.device = newDeviceName; // You can modify this to allow multiple devices
      }
    });
  }





  @override
  void onClose() {
    searchController.dispose(); // Dispose of controller when not needed
    super.onClose();
  }
}
