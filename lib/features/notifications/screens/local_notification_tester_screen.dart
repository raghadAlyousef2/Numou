import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';

import '../controllers/local_notification_controller.dart';

class LocalNotificationTesterScreen extends StatelessWidget {
  const LocalNotificationTesterScreen({super.key});

  @override
  Widget build(BuildContext context) {
  var controller= Get.find<LocalNotificationController>();
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => controller.showLocalNotification(
                  title: 'demo ',
                  body: 'this is demo of notification',
                  payload: 'this is payload of this notification '),
              child: const Row(
                children: [
                  Icon(Icons.notification_add),
                  Text('test instant notification feature')
                ],
              ),
            ),
            const SizedBox(height: 20,),
            ElevatedButton(
              onPressed: () => controller.setPeriodicLocalNotification(
                id: 2,
                repeatInterval: RepeatInterval.everyMinute,
                  title: 'perodic notifcation  ',
                  body: 'this is demo of perodic notifcation  notification',
                  payload: ''),
              child: const Row(
                children: [
                  Icon(Icons.notification_add_outlined),
                  Text('test periodic notification  feature')
                ],
              ),
            ),


            const SizedBox(height: 20,),
            ElevatedButton(
              onPressed: () => controller.setScheduleLocalNotification(
                repeatInterval: ScheduleRepeatInterval.daily,
                channelNumber: 5,
                 hour: 11,
                minute: 30,
                isPM: true,
                id: 3,
                title:'schedule notification ',
                body:'this is scheduled notificaiton ',
                payload: 'scheduled '
              ),
              child: const Row(
                children: [
                  Icon(Icons.notification_important),
                  Text('   schedule a notification')
                ],
              ),
            ),

            const SizedBox(height: 20,),
            ElevatedButton(
              onPressed: () => controller.cancelLocalNotification(
              id: 2),
              child: const Row(
                children: [
                  Icon(Icons.notification_important),
                  Text('cancel notificaiton of channel 1')
                ],
              ),
            ),
            const SizedBox(height: 20,),
            ElevatedButton(
              onPressed: () => controller.cancelAllLocalNotification(
                  ),
              child: const Row(
                children: [
                  Icon(Icons.notification_important),
                  Text('   cancel all notificaiton of channel 1')
                ],
              ),
            ),

          ],
        ),
      ),
    );
  }
}
