import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../Controllers/firebase_data_controller.dart';
import '../widgets/electricity_consumption_chart_widget.dart';
class ElectricityConsumptionScreen extends StatelessWidget {
  const ElectricityConsumptionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.find<FirebaseDataController>();
    final size = MediaQuery.of(context).size;

    return Padding(
        padding: const EdgeInsets.all(0.0),
        child: Obx(
              () => Padding(
              padding:
              const EdgeInsets.symmetric(horizontal: 0.0, vertical: 0),
              child: controller.user.value.devicesIds.isEmpty
                  ? const Center(
                child: Text(
                  'No devices configured yet ',
                  style: TextStyle(fontSize: 20),
                ),
              )
                  : controller.user.value.devices.isNotEmpty
                  ? const ElectricityConsumptionChartWidget()

                  : const Center(
                child: SizedBox(
                    width: 30, child: CircularProgressIndicator()),
              )),
        ));
  }


}
