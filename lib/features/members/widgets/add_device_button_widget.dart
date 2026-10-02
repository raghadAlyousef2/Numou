

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../Controllers/firebase_data_controller.dart';
import '../../../utiles/Widgets/alert_messages_dailog.dart';
import '../controllers/member_data_controller.dart';

class AddDeviceButtonWidget extends StatelessWidget {
  AddDeviceButtonWidget({super.key, required this.memberId});
 final String memberId;
  final MemberDataController memberDataController = Get.find<MemberDataController>();
  final FirebaseDataController firebaseDataController = Get.find<FirebaseDataController>();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(6.0),
      child: ElevatedButton(
        onPressed: () {
          if(firebaseDataController.user.value.devices.isNotEmpty){
          _addMemberDialog();}else{
          AlertMessagesDialog.errorMessageDialog('no device configure ');}
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
                          padding: const EdgeInsets.all(2),
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

                        String selectedDevice = memberDataController.selectedDevice.value;

                        // Validate email before proceeding

                          if (selectedDevice.isNotEmpty) {
                            Get.back();
                            memberDataController.addDevice(
                            memberId
                            ,selectedDevice);


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
