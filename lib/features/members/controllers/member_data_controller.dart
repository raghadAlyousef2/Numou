import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../../../Controllers/firebase_data_controller.dart';
import '../models/member.dart';

class MemberDataController extends GetxController {
  var controller = Get.find<FirebaseDataController>();

  // Observable list for filtered members
  RxList<Member> filteredMembers = <Member>[].obs;

  // Text controller for search input
  final TextEditingController searchController = TextEditingController();
  final TextEditingController addEmailController = TextEditingController();


  var selectedDevice = ''.obs;
  var emailError = ''.obs; // Reactive error message

  // Function to validate email format
  bool isValidEmail(String email) {
    // Simple email regex for validation
    String emailPattern = r'^[^@]+@[^@]+\.[^@]+';
    RegExp regex = RegExp(emailPattern);
    return regex.hasMatch(email);
  }

  @override
  void onInit() {
    super.onInit();

    searchController.addListener(() {
      filterMembers();
    });

    // Listen to changes in the member list from FirebaseDataController
    ever(controller.user, (_) {
      filterMembers(); // Reapply filtering when user data changes
    });
    filteredMembers.value=controller.user.value.members;
  }

  // Filter members based on the search text
  void filterMembers() {
    String searchText = searchController.text.toLowerCase();
    filteredMembers.value = searchText.isEmpty?controller.user.value.members: controller.user.value.members.where((member) {return member.name.toLowerCase().contains(searchText);}).toList();
  }

  // Function to add a member with selected device
  void addMember(String email, String deviceName) {

   controller. addMemberToDevice(email,controller.user.value.devices.where((d)=>d.name==deviceName).first.deviceID);
  }
  void deleteMember(String memberId){
    controller.deleteMember(memberId: memberId);

  }
  //
  // // Function to delete a member
  // void deleteMember(String email) {
  //   controller.user.update((user) {
  //     user?.members.removeWhere((member) => member.email == email);
  //   });
  // }

  // Function to update a member's device
  void updateMember(String email, String newDeviceName) {
    controller.user.update((user) {
      final member = user?.members.firstWhere((member) => member.email == email);
      if (member != null) {
        member.device = newDeviceName; // You can modify this to allow multiple devices
      }
    });
  }
  void approveMember({required String memberId}){
     controller.acceptMembershipRequest( membershipId: memberId);
  }


  void addDevice(String memberId, String deviceName) {

    controller. addDeviceToMember(membershipId: memberId,deviceId:controller.user.value.devices.where((d)=>d.name==deviceName).first.deviceID);
  }

  @override
  void onClose() {
    searchController.dispose(); // Dispose of controller when not needed
    super.onClose();
  }
}
