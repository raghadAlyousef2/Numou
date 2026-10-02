import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../Controllers/firebase_data_controller.dart';
import '../../Controllers/water_heater_controller.dart';
import '../../Models/device.dart';
import '../../screens/water_heater_setting_screen.dart';
import 'gray_scale_widget.dart';


class WaterHeater extends StatelessWidget {
  WaterHeater(
      { required this.swipDirection, required this.device, required this.color, required this.textColor, super.key});

  final  fcontroller = Get.put(FirebaseDataController());
  final Color textColor;
  final Color color;
  final Device device;
  final String swipDirection;

  // bool _switchValue = false;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(
      WaterHeaterController(controllerId: device.deviceID, device: device),
      tag: device.deviceID,);
    //double screenWidth = MediaQuery.of(context).size.width;
    //double screenHeight = MediaQuery.of(context).size.height;
    return
      Dismissible(

          direction: fcontroller.user.value.isOwner == 'false'
              ? DismissDirection.none : swipDirection == 'right'
              ? DismissDirection.startToEnd
              : DismissDirection.endToStart,
          confirmDismiss: (direction) {
            if (direction == DismissDirection.startToEnd &&
                swipDirection == 'right' ||
                direction == DismissDirection.endToStart &&
                    swipDirection == 'left') {
              return fcontroller.isOnline.value?_showDeleteConfirmationDialog(controller):Future.value(false);
            }
            return Future.value(false);
          },

          background: Container(
            padding: const EdgeInsets.all(10),
            margin: const EdgeInsets.symmetric(vertical: 10),
            decoration: const BoxDecoration(
              color: Colors.red,

              borderRadius: BorderRadius.only(topLeft: Radius.circular(20),
                  bottomLeft: Radius.circular(20)),

            ),
            child: const Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Icon(Icons.delete, color: Colors.white),
              ),
            ),
          ),
          key: ValueKey(controller.device.deviceID),
          child:
          GestureDetector(
            onDoubleTap: () => Get.to(() => WaterHeaterSettingScreen(
                controller: controller, device: device)),
            child: Container(
              // width: screenWidth * 0.06,
              // height: screenHeight * 0.01,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(30),
                boxShadow: const [
                  BoxShadow(color: Colors.black87,
                      offset: Offset(2, 3),
                      blurRadius: 4)
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  fcontroller.user.value.isOwner=='true'?  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Obx(
                            () =>
                            GrayscaleWidget(
                              isGrayscale: false,
                              isAbsorb: !fcontroller.isOnline.value,
                              child:
                              IconButton(onPressed: () {
                                _showDeleteConfirmationDialog(controller);
                              }, icon: Icon(Icons.delete, color: Theme
                                  .of(context)
                                  .colorScheme
                                  .secondary,),),),),
                    ],
                  ):SizedBox(height: 16,),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 14.0),
                        child: Text(
                          device.name,
                          style: TextStyle(
                            color: textColor,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),


                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          //IconButton(onPressed: (){}, icon: const Icon(Id)),
                          Obx(
                                  () =>
                                  GrayscaleWidget(
                                      isGrayscale: false,
                                      isAbsorb: !fcontroller.isOnline.value,
                                      child:
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 12.0, vertical: 6),
                                        child: Obx(
                                              () =>
                                              CupertinoSwitch(
                                                value: fcontroller.user.value
                                                    .devices
                                                    .firstWhere((device) =>
                                                device.deviceID ==
                                                    controller.device.deviceID)
                                                    .switch1state == "ON"
                                                    ? true
                                                    : false,
                                                onChanged: (bool value) {
                                                  fcontroller.user.value.devices
                                                      .firstWhere((device) =>
                                                  device.deviceID ==
                                                      controller.device
                                                          .deviceID).toggle();
                                                  fcontroller.setDevice(
                                                      controller.device
                                                          .deviceID);
                                                  //  controller.toggleTimer();

                                                  // device.toggle();
                                                  //print(' switch state: before tongle ${device.switch1state } : ${device.switch2state}');

                                                  // print(' switch state: after tongle ${device.switch1state } : ${device.switch2state}');

                                                  //controller.toggleTimer();

                                                  //FirebaseDataController.instance.setDevice(device.deviceID);
                                                },
                                                activeTrackColor: Colors.yellow,
                                                inactiveTrackColor: Theme
                                                    .of(context)
                                                    .colorScheme
                                                    .surfaceDim,
                                              ),
                                        ),
                                      ))),

                        ],
                      ),

                    ],
                  ),
                ],
              ),
            ),));
  }

  Future<bool> _showDeleteConfirmationDialog(
      WaterHeaterController controller) async {
    return await Get.dialog(

        AlertDialog(
          title: const Text('Confirm Deletion'),
          content: const Text('Are you sure you want to delete this device?'),
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
                controller.deleteDevice();
                // memberDataController.deleteMember(member.email,member.attachedDevice);
                // await controller.deleteSchedule(schedule.value.id);

                // Get.back(result: true);// back from deletion dialog
              },
              child: const Text('Delete'),
            ),
          ],
        ),
        barrierDismissible: false
    );
  }

}
