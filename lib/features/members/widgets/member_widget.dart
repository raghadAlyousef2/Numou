import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../Controllers/firebase_data_controller.dart';
import '../../../Controllers/water_heater_controller.dart';
import '../../../Models/device.dart';
import '../../../screens/water_heater_setting_screen.dart';
import '../../../utiles/Widgets/gray_scale_widget.dart';
import '../controllers/member_data_controller.dart';
import '../models/member.dart';
import 'add_device_button_widget.dart';


class MemberWidget extends StatelessWidget {
  const MemberWidget({
    super.key,
    required this.member,
    required this.colorScheme,
    required this.theme,
    required this.memberDataController,
  });

  final Member member;
  final ColorScheme colorScheme;
  final ThemeData theme;
  final MemberDataController memberDataController;

  @override
  Widget build(BuildContext context) {
    var fcontroller = Get.put(FirebaseDataController());
    return Dismissible(
        direction: DismissDirection.startToEnd,
        confirmDismiss: (direction) {
          if (direction == DismissDirection.startToEnd) {
            return _showDeleteConfirmationDialog();
          }
          return Future.value(false);
        },
        background: Container(
          padding: const EdgeInsets.all(10),
          margin: const EdgeInsets.symmetric(vertical: 10),
          decoration: const BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), bottomLeft: Radius.circular(20)),
          ),
          child: const Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Icon(Icons.delete, color: Colors.white),
            ),
          ),
        ),
        key: ValueKey(member.id),
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          // Adds spacing between list items
          decoration: BoxDecoration(
            color: colorScheme.surface,
            // Background color from theme
            border: Border.all(color: colorScheme.surfaceDim),
            // Border color from theme
            borderRadius: BorderRadius.circular(12.0),
            // Smooth rounded corners
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                // Subtle shadow effect
                spreadRadius: 1,
                blurRadius: 5,
                offset: const Offset(0, 3), // Offset of shadow
              ),
            ],
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 12.0, // Increased padding for better spacing
            ),
            title: Text(
              member.name,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: colorScheme.primary,
                // Use primary color for name
                fontWeight: FontWeight.bold,
                // Make the name bold
                fontSize: 18.0, // Larger font size for better readability
              ),
            ),
            subtitle: member.status == 'pending'
                ? const Text(
                    'Request Pending ',
                    style: TextStyle(color: Colors.red),
                  )
                : Text(
                    member.device.isNotEmpty
                        ? "Device: ${memberDataController.controller.user.value.devices.where((device) => device.deviceID == member.device).first.name}" // Display attached devices
                        : "No device assigned",
                    // Fallback message
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme
                          .secondary, // Use secondary color for the devices text
                    ),
                  ),
            trailing: member.status == 'pending'
                ? SizedBox(
                    width: 200,
                    child: Obx(
                      ()=> GrayscaleWidget(
                        isGrayscale:!fcontroller.isOnline.value ,
                        isAbsorb: !fcontroller.isOnline.value,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                memberDataController.approveMember(
                                    memberId: member.id);

                              },
                              child: const Text(
                                'Accept',
                                style: TextStyle(fontSize: 14, color: Colors.green),
                              ),

                            ),
                            ElevatedButton(
                                onPressed: () {
                                  memberDataController.deleteMember(member.id);
                                },
                                child: const Text(
                                  'Reject',
                                  style: TextStyle(fontSize: 14, color: Colors.red),
                                )),
                          ],
                        ),
                      ),
                    ),
                  )
                : member.device.isEmpty
                    ?   Obx(()=> GrayscaleWidget(
                  isAbsorb:!Get.find<FirebaseDataController>().isOnline.value,
                  isGrayscale: false,
                  child: AddDeviceButtonWidget(memberId: member.id),),)
                    : IconButton(
                        icon: Icon(
                          Icons.chevron_right,
                          color: colorScheme
                              .tertiary, // Use tertiary color for the icon
                        ),
                        onPressed: () {
                          Device device = memberDataController
                              .controller.user.value.devices
                              .where(
                                  (device) => device.deviceID == member.device)
                              .first;

                          Get.to(() => WaterHeaterSettingScreen(
                              controller: Get.put(
                                WaterHeaterController(
                                    controllerId: device.deviceID,
                                    device: device),
                                tag: device.deviceID,
                              ),
                              device: device));
                          // Handle the press (navigate or perform action)
                        },
                      ),
          ),
        ));
  }

  Future<bool> _showDeleteConfirmationDialog() async {
    return await Get.dialog(
        AlertDialog(
          title: const Text('Confirm Deletion'),
          content: const Text('Are you sure you want to delete this member?'),
          actions: [
            TextButton(
              onPressed: () {
                Get.back(result: false);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                Get.back(result: false);
                memberDataController.deleteMember(member.id);
                // await controller.deleteSchedule(schedule.value.id);

                // Get.back(result: true);// back from deletion dialog
              },
              child: const Text('Delete'),
            ),
          ],
        ),
        barrierDismissible: false);
  }
}
