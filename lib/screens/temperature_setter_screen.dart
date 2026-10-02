
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../Controllers/water_heater_controller.dart';
import '../Models/device.dart';
 // Import the controller

class TemperatureSetterScreen extends StatelessWidget {
  const TemperatureSetterScreen({required this.device,super.key});
  final Device device;
  @override
  Widget build(BuildContext context) {
    final controller=Get.find<WaterHeaterController>(tag: device.deviceID);
    return Scaffold(

      appBar: AppBar(
        title: const Text('Temperature Setter'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Set Temperature Limit',
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 500,
              child: RotatedBox(

                quarterTurns: 3,
                child: Obx(
                      () => Slider(
                        thumbColor: Colors.red,
                    activeColor: Theme.of(context).colorScheme.secondary,

                    value: controller.setTemperature.value,
                    min: -20.0,
                    max: 50.0,
                    divisions: 70,
                    label: '${controller.setTemperature.value.round()}°C',
                    onChanged: (double value) {
                      controller.updateTemperature(value);
                    },
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),
            Obx(
                  () => Text(
                '${controller.setTemperature.value.round()}°C',
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


