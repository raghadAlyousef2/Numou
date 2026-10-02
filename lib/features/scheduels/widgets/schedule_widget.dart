
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../Controllers/water_heater_controller.dart';
import '../models/schedule.dart';
class ScheduleWidget extends StatelessWidget {
  const ScheduleWidget({required this.controller,    required this.schedule,super.key});
  final Rx<Schedule> schedule;

  final WaterHeaterController controller ;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Dismissible(

      direction: DismissDirection.startToEnd,
         confirmDismiss: (direction){
        if(direction==DismissDirection.startToEnd){
          return _showDeleteConfirmationDialog();}
        return Future.value(false);
         },

      background: Container(
            padding: const EdgeInsets.all(20),  
        margin: const EdgeInsets.symmetric(vertical: 40),
        decoration: const BoxDecoration(
          color: Colors.red,
          
          borderRadius: BorderRadius.only(topLeft: Radius.circular(20),bottomLeft: Radius.circular(20)),
          
        ),
        child: const Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Icon(Icons.delete, color: Colors.white),
          ),
        ),
      ),
      key: ValueKey(schedule.value.id),
      child: Container(
        margin: EdgeInsets.only(bottom: size.height * 0.03),
        padding: EdgeInsets.symmetric(vertical: size.height * 0.02),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(size.width * 0.03),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              offset: const Offset(2, 2),
              blurRadius: 3,
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 0, 0, 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                contentPadding: const EdgeInsets.fromLTRB(25, 0, 10, 0),
                title: Obx(
                      ()=> Text(
                    schedule.value.getFormattedDate(),
                    style: TextStyle(
                      fontSize: size.width * 0.08,
                    ),
                  ),
                ),
                trailing: Obx(
                  ()=>  CupertinoSwitch(
                    value: schedule.value.isActive ,

                    onChanged:  (value) async {
                    await  controller.updateSchedule(schedule.value.id, schedule.value.time, schedule.value.daysOfWeek,!schedule.value.isActive);

                    },
                    activeTrackColor: Colors.blue,
                    inactiveTrackColor: Colors.grey,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: List.generate(7, (dayIndex) {
                    return Obx(
                        ()=> GestureDetector(
                        onTap: () {
                           controller.toggleDay(schedule.value.id, dayIndex);
                        },
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: size.width * 0.001),
                          padding: EdgeInsets.all(size.width * 0.002),
                          width: size.width * 0.09,
                          height: size.width * 0.08,
                          decoration:  BoxDecoration(
                            color:  schedule.value.daysOfWeek.contains(controller.getDayString(dayIndex))
                                ? Colors.blue
                                : Colors.grey[300], // Change text color according to selected day
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              controller.getDayAbbreviation(dayIndex),
                              style: TextStyle(
                                  fontSize: size.width * 0.03,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black//Todo change text color accoeding to selected day selectedDays[dayIndex] ? Colors.white : Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


 Future<bool> _showDeleteConfirmationDialog()  async{

   return await Get.dialog(

      AlertDialog(
        title: const Text('Confirm Deletion'),
        content: const Text('Are you sure you want to delete this item?'),
        actions: [
          TextButton(
            onPressed: () {
              Get.back(result: false);
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Get.dialog(
                const Center(child: CircularProgressIndicator()),
                barrierDismissible:
                false, // Prevent closing the dialog by tapping outside
              );

              await controller.deleteSchedule(schedule.value.id);
              Get.back(); // back from progress indicator
              Get.back(result: true);// back from deletion dialog
            },
            child: const Text('Delete'),
          ),
        ],
      ),
     barrierDismissible: false
    );



  }




}
