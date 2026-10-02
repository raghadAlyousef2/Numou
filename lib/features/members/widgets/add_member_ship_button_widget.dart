
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../Controllers/firebase_data_controller.dart';
import '../controllers/member_ship_data_controller.dart';


class AddMemberShipButtonWidget extends StatelessWidget {
  AddMemberShipButtonWidget({super.key});

  final MemberShipDataController memberShipDataController = Get.find<MemberShipDataController>();
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
                    "Enter Share Code ",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: memberShipDataController.addShareCodeController,
                    decoration: InputDecoration(
                      hintText: 'Enter share code ',
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
                      memberShipDataController.shareCodeError.value = '';
                    },
                  ),
                  // Display error message
                  Obx(() {
                    return memberShipDataController.shareCodeError.value.isNotEmpty
                        ? Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        memberShipDataController.shareCodeError.value,
                        style: const TextStyle(color: Colors.red, fontSize: 12),
                      ),
                    )
                        : const SizedBox.shrink();
                  }),
                  const SizedBox(height: 12),

                  const SizedBox(height: 12),

                  const SizedBox(height: 16),
                  Center(
                    child: TextButton(
                      onPressed: () {
                        String shareCode = memberShipDataController.addShareCodeController.text.trim();


                        // Validate email before proceeding
                        if (shareCode.isEmpty) {
                          memberShipDataController.shareCodeError.value = 'Share code cannot be empty';
                        } else if (!memberShipDataController.isValidShareCode(shareCode)) {
                          memberShipDataController.shareCodeError.value = 'ShareCode must be min 4 character ';
                        } else {
                          memberShipDataController.shareCodeError.value = ''; // Clear error

                            //Get.back();
                            memberShipDataController.addMemberShip(shareCode);


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
              top: 20,
              right: 20,
              child: GestureDetector(
                onTap: () {
                  memberShipDataController.addShareCodeController.clear();
                  Get.back();

                  },
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
