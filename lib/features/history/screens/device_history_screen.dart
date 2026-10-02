
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../Controllers/firebase_data_controller.dart';
import '../widgets/device_history_widget.dart';

class DeviceHistoryScreen extends StatelessWidget {
  const DeviceHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.find<FirebaseDataController>();
    final size = MediaQuery.of(context).size;

    return Padding(
        padding: const EdgeInsets.all(2.0),
        child: Obx(
          () => Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20),
              child: controller.user.value.devicesIds.isEmpty
                  ? const Center(
                      child: Text(
                        'No devices configured yet ',
                        style: TextStyle(fontSize: 20),
                      ),
                    )
                  : controller.user.value.devices.isNotEmpty
                      ? ListView.builder(
                          itemCount: controller.user.value.devices.length,
                          itemBuilder: (context, index) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 90),
                            child: DeviceHistoryWidget(
                                device: controller.user.value.devices[index]),
                          ))
                      : controller.isOnline.value==false?const Center(child: Text('NO Internet Check Connection'),):const Center(
                          child: SizedBox(
                              width: 30, child: CircularProgressIndicator()),
                        )),
        ));
  }
}
