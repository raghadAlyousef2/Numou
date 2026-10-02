
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../Controllers/firebase_data_controller.dart';
import '../controllers/member_data_controller.dart';

class AddMemberButtonWidget extends StatelessWidget {
  AddMemberButtonWidget({super.key});

  final MemberDataController memberDataController = Get.find<MemberDataController>();
  final FirebaseDataController firebaseDataController = Get.find<FirebaseDataController>();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(6.0),
      child: ElevatedButton(
        onPressed: () {
          _addMemberDialog();
        },
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.all(7),
          backgroundColor: const Color(0xFF0E6891),
        ),
        child: const Icon(Icons.add, color: Colors.white, size: 18),
      ),
    );
  }

  void _addMemberDialog() {
    // Set initial selectedDevice from the first device if available
    memberDataController.selectedDevice.value = firebaseDataController.user.value.devices.isNotEmpty
        ? firebaseDataController.user.value.devices.first.name
        : '';

    Get.dialog(
      Dialog(
        backgroundColor: const Color(0xFF0E6891),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Enter Member's Email",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: memberDataController.addEmailController,
                    decoration: InputDecoration(
                      hintText: 'Enter email',
                      hintStyle: const TextStyle(color: Color(0xFF828282)),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 12.0),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Color(0xFFC6C6C6)),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Color(0xFF828282)),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    onChanged: (value) {
                      // Clear the error message when user starts typing
                      memberDataController.emailError.value = '';
                    },
                  ),
                  // Display error message
                  Obx(() {
                    return memberDataController.emailError.value.isNotEmpty
                        ? Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        memberDataController.emailError.value,
                        style: const TextStyle(color: Colors.red, fontSize: 12),
                      ),
                    )
                        : const SizedBox.shrink();
                  }),
                  const SizedBox(height: 12),
                  const Text(
                    "Select Device",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Obx(() {
                    return DropdownButton<String>(
                      value: memberDataController.selectedDevice.value.isEmpty
                          ? null
                          : memberDataController.selectedDevice.value,
                      isExpanded: true,

                           iconEnabledColor: Colors.white70,

                      hint: const Text(
                        "Select a device",
                        style: TextStyle(color: Colors.white),
                      ),
                      dropdownColor: const Color(0xFF0E6891),
                      items: firebaseDataController.user.value.devices
                          .map((device) => DropdownMenuItem(
                        value: device.name,
                        child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(2),
                          decoration: BoxDecoration(
                             borderRadius: BorderRadius.circular(20),
                           // border: Border.all(color: Colors.white)
                          ),
                          child: Center(
                            child: Text(
                              device.name,
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ))
                          .toList(),
                      onChanged: (value) {
                        memberDataController.selectedDevice.value = value!;
                      },
                    );
                  }),
                  const SizedBox(height: 16),
                  Center(
                    child: TextButton(
                      onPressed: () {
                        String email = memberDataController.addEmailController.text.trim();
                        String selectedDevice = memberDataController.selectedDevice.value;

                        // Validate email before proceeding
                        if (email.isEmpty) {
                          memberDataController.emailError.value = 'Email cannot be empty';
                        } else if (!memberDataController.isValidEmail(email)) {
                          memberDataController.emailError.value = 'Invalid email format';
                        } else {
                          memberDataController.emailError.value = ''; // Clear error
                          if (selectedDevice.isNotEmpty) {
                            Get.back();
                            memberDataController.addMember(email, selectedDevice);

                          }
                        }
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: const Color(0xFFFBCD2F),
                        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 24),
                        minimumSize: const Size(double.infinity, 40),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      child: const Text(
                        'Add',
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: 16,
              right: 16,
              child: GestureDetector(
                onTap: () => Get.back(),
                child: const Icon(
                  Icons.close,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

}
